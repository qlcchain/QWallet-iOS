//
//  Account.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/25/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import Neoutils
import Security

public class Wallet {
    public var wif: String
    public var publicKey: Data
    public var privateKey: Data
    public var address: String
    public var hashedSignature: Data

    lazy var publicKeyString: String = {
        return publicKey.fullHexString
    }()

    lazy var privateKeyString: String = {
        return privateKey.fullHexString
    }()

    public init?(wif: String) {
        var error: NSError?
        guard let wallet = NeoutilsGenerateFromWIF(wif, &error) else { return nil }
        self.wif = wif
        self.publicKey = wallet.publicKey()
        self.privateKey = wallet.privateKey()
        self.address = wallet.address()
        self.hashedSignature = wallet.hashedSignature()
    }

    public init?(privateKey: String) {
        var error: NSError?
        guard let wallet = NeoutilsGenerateFromPrivateKey(privateKey, &error) else { return nil }
        self.wif = wallet.wif()
        self.publicKey = wallet.publicKey()
        self.privateKey = privateKey.dataWithHexString()
        self.address = wallet.address()
        self.hashedSignature = wallet.hashedSignature()
    }
    
    public init?(wallet: NeoutilsWallet) {
        self.wif = wallet.wif()
        self.publicKey = wallet.publicKey()
        self.privateKey = wallet.privateKey()
        self.address = wallet.address()
        self.hashedSignature = wallet.hashedSignature()
    }

    public init?() {
        let byteCount: Int = 32
        var keyData = Data(count: byteCount)
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, byteCount, $0)
        }

        if result != errSecSuccess {
            fatalError()
        }

        var error: NSError?
        guard let wallet = NeoutilsGenerateFromPrivateKey(keyData.fullHexString, &error) else { return nil }
        self.wif = wallet.wif()
        self.publicKey = wallet.publicKey()
        self.privateKey = keyData
        self.address = wallet.address()
        self.hashedSignature = wallet.hashedSignature()
    }

    func createSharedSecret(publicKey: Data) -> Data? {
        var error: NSError?
        guard let wallet = NeoutilsGenerateFromPrivateKey(self.privateKey.fullHexString, &error) else {return nil}
        return wallet.computeSharedSecret(publicKey)
    }

    func encryptString(key: Data, text: String) -> String {
        return NeoutilsEncrypt(key, text)
    }

    func decryptString(key: Data, text: String) -> String? {
        return NeoutilsDecrypt(key, text)
    }

    /*
     * Every asset has a list of transaction ouputs representing the total balance
     * For example your total NEO could be represented as a list [tx1, tx2, tx3]
     * and each element contains an individual amount. So your total balance would
     * be represented as SUM([tx1.amount, tx2.amount, tx3.amount]) In order to make
     * a new transaction we will need to find which inputs are necessary in order to
     * satisfy the condition that SUM(Inputs) >= amountToSend
     *
     * We will attempt to get rid of the the smallest inputs first. So we will sort
     * the list of unspents in ascending order, and then keep a running sum until we
     * meet the condition SUM(Inputs) >= amountToSend. If the SUM(Inputs) == amountToSend 
     * then we will have one transaction output since no change needs to be returned
     * to the sender. If Sum(Inputs) > amountToSend then we will need two transaction
     * outputs, one that sends the amountToSend to the reciever and one that sends
     * Sum(Inputs) - amountToSend back to the sender, thereby returning the change.
     *
     * Input Payload Structure (where each Transaction Input is 34 bytes ). Let n be the
     * number of input transactions necessary | Inputs.count | Tx1 | Tx2 |....| Txn |
     *
     *
     *                             * Input Data Detailed View *
     * |    1 byte    |         32 bytes         |       2 bytes     | 34 * (n - 2) | 34 bytes |
     * | Inputs.count | TransactionId (Reversed) | Transaction Index | ............ |   Txn    |
     *
     *
     *
     *                                               * Final Payload *
     * | 3 bytes  |    1 + (n * 34) bytes     | 1 byte | 32 bytes |     16 bytes (Int64)     |       32 bytes        |
     * | 0x800000 | Input Data Detailed Above |  0x02  |  assetID | toSendAmount * 100000000 | reciever address Hash |
     *
     *
     * |                    16 bytes (Int64)                    |       32 bytes      |  3 bytes |
     * | (totalAmount * 100000000) - (toSendAmount * 100000000) | sender address Hash | 0x014140 |
     *
     *
     * |    32 bytes    |      34 bytes        |
     * | Signature Data | NeoSigned public key |
     *
     * NEED TO DOUBLE CHECK THE BYTE COUNT HERE
     */
    public func getInputsNecessaryToSendNeo(amount: Double, assets: Assets?) ->
        (totalAmount: Decimal?, inputCount: UInt8?, payload: Data?, error: Error?) {

        var sortedUnspents = [UTXO]()
        var neededForTransaction = [UTXO]()
        sortedUnspents = assets!.getSortedNEOUTXOs()
        if sortedUnspents.reduce(0, {$0 + $1.value}) < Decimal(amount) {
            return (nil, nil, nil, NSError())
        }

        var runningAmount: Decimal = 0.0
        var index = 0
        var count: UInt8 = 0
        //Assume we always have enough balance to do this, prevent the check for bal
        while runningAmount < Decimal(amount) {
            neededForTransaction.append(sortedUnspents[index])
            runningAmount += sortedUnspents[index].value
            index += 1
            count += 1
        }
        var inputData = [UInt8]()
        for x in 0..<neededForTransaction.count {
            let data = neededForTransaction[x].txid.dataWithHexString()
            let reversedBytes = data.bytes.reversed()
            inputData += reversedBytes + toByteArray(UInt16(neededForTransaction[x].index))
        }

        return (runningAmount, count, Data(bytes: inputData), nil)
    }

    public func getInputsNecessaryToSendGas(amount: Double, assets: Assets?, fee: Double = 0.0) ->
        (totalAmount: Decimal?, inputCount: UInt8?, payload: Data?, error: Error?) {

        //asset less sending
        if assets == nil {
            let inputData = [UInt8]()
            return (0, 0, Data(bytes: inputData), nil)
        }

        var sortedUnspents = [UTXO]()
        var neededForTransaction = [UTXO]()
        sortedUnspents = assets!.getSortedGASUTXOs()
        var amountDecimal: Decimal = Decimal(amount)
        var amountDecimalRounded: Decimal = Decimal()
        NSDecimalRound(&amountDecimalRounded, &amountDecimal, 8, .down)
            
        var feeDecimal: Decimal = Decimal(fee)
        var feeDecimalRounded: Decimal = Decimal()
        NSDecimalRound(&feeDecimalRounded, &feeDecimal, 8, .down)
            
        if sortedUnspents.reduce(0, {$0 + $1.value}) < amountDecimalRounded {
            return (nil, nil, nil, NSError())
        }

        var runningAmount: Decimal = 0.0
        var index = 0
        var count: UInt8 = 0
        //Assume we always have enough balance to do this, prevent the check for bal
        while runningAmount < amountDecimalRounded + feeDecimalRounded {
            neededForTransaction.append(sortedUnspents[index])
            runningAmount += sortedUnspents[index].value
            index += 1
            count += 1
        }
        var inputData = [UInt8]()
        for x in 0..<neededForTransaction.count {
            let data = neededForTransaction[x].txid.dataWithHexString()
            let reversedBytes = data.bytes.reversed()
            inputData += reversedBytes + toByteArray(UInt16(neededForTransaction[x].index))
        }

        return (runningAmount, count, Data(bytes: inputData), nil)
    }

    func getAttributesPayload(attributes: [TransactionAttritbute]?) -> [UInt8] {
        var numberOfAttributes: UInt8 = 0x00
        var attributesPayload: [UInt8] = []
        if attributes != nil {
            for attribute in attributes! where attribute.data != nil {
                attributesPayload += attribute.data!
                numberOfAttributes += 1
            }
        }
        return  [numberOfAttributes] + attributesPayload
    }

    func getOuputDataPayload(asset: AssetId, with inputData: Data, runningAmount: Decimal,
                             toSendAmount: Double, toScriptHash: String, fee: Double = 0.0) -> (payload: Data, outputCount: UInt8) {
        var toSendAmountDecimal: Decimal = Decimal(toSendAmount)
        var toSendAmountDecimalRounded: Decimal = Decimal()
        NSDecimalRound(&toSendAmountDecimalRounded, &toSendAmountDecimal, 8, .down)
        
        var feeDecimal: Decimal = Decimal(fee)
        var feeDecimalRounded: Decimal = Decimal()
        NSDecimalRound(&feeDecimalRounded, &feeDecimal, 8, .down)
        
        let needsTwoOutputTransactions =
            (runningAmount != (toSendAmountDecimalRounded + feeDecimalRounded)) && toSendAmount > 0

        var outputCount: UInt8
        var payload: [UInt8] = []
        if runningAmount == Decimal(0) && fee == 0.0 {
            return (Data(bytes: payload), 0)
        }

        if needsTwoOutputTransactions {
            //Transaction To Reciever
            outputCount = 2
            payload += asset.rawValue.dataWithHexString().bytes.reversed()
            let amountToSend = toSendAmount * pow(10, 8)
            let amountToSendRounded = round(amountToSend)
            let amountToSendInMemory = UInt64(amountToSendRounded)
            payload += toByteArray(amountToSendInMemory)

            //reciever addressHash
            payload += toScriptHash.dataWithHexString()

            //Transaction To Sender
            payload += asset.rawValue.dataWithHexString().bytes.reversed()
            let runningAmountRounded = round(NSDecimalNumber(decimal: runningAmount * pow(10, 8)).doubleValue)
            let feeRounded = round(fee * pow(10, 8))
            let amountToGetBack = runningAmountRounded - amountToSendRounded - feeRounded
            let amountToGetBackInMemory = UInt64(amountToGetBack)

            payload += toByteArray(amountToGetBackInMemory)
            payload += hashedSignature.bytes

            //we just paying fee and want to return everything back to ourselves
        } else if toSendAmount == 0.0 {
            outputCount = 1
            payload += asset.rawValue.dataWithHexString().bytes.reversed()
            let runningAmountRounded = round(NSDecimalNumber(decimal: runningAmount * pow(10, 8)).doubleValue)
            let feeRounded = round(fee * pow(10, 8))
            let amountToGetBack = runningAmountRounded - feeRounded
            let amountToGetBackInMemory = UInt64(amountToGetBack)
            
            payload += toByteArray(amountToGetBackInMemory)
            payload += hashedSignature.bytes
        } else {
            outputCount = 1
            payload += asset.rawValue.dataWithHexString().bytes.reversed()
            let amountToSend = toSendAmount * pow(10, 8)
            let amountToSendRounded = round(amountToSend)
            let amountToSendInMemory = UInt64(amountToSendRounded)
            
            payload += toByteArray(amountToSendInMemory)
            payload += toScriptHash.dataWithHexString()
        }
        return (Data(bytes: payload), outputCount)
    }

    func concatenatePayloadData(txData: Data, signatureData: Data) -> Data {
        var payload = txData.bytes + [0x01]               // signature number
        payload += [0x41]                                 // signature struct length
        payload += [0x40]                                 // signature data length
        payload += signatureData.bytes                    // signature
        payload += [0x23]                                 // contract data length
        payload += [0x21] + self.publicKey.bytes + [0xac] // NeoSigned publicKey
        return Data(bytes: payload)
    }

    func generateSendTransactionPayload(asset: AssetId, amount: Double, toAddress: String, assets: Assets, attributes: [TransactionAttritbute]? = nil, fee: Double = 0.0) -> (Data, Data) {
        var error: NSError?

        var mainInputData: (totalAmount: Decimal?, inputCount: UInt8?, payload: Data?, error: Error?)
        var mainOutputData: (payload: Data, outputCount: UInt8)
        var optionalFeeInputData: (totalAmount: Decimal?, inputCount: UInt8?, payload: Data?, error: Error?)? = nil
        if asset == AssetId.gasAssetId {
            mainInputData = getInputsNecessaryToSendGas(amount: amount, assets: assets, fee: fee)
            mainOutputData = getOuputDataPayload(asset: asset, with: mainInputData.payload!,
                                                 runningAmount: mainInputData.totalAmount!,
                                                 toSendAmount: amount, toScriptHash: toAddress.hashFromAddress(), fee: fee)

        } else {
            mainInputData = getInputsNecessaryToSendNeo(amount: amount, assets: assets)
            mainOutputData = getOuputDataPayload(asset: asset, with: mainInputData.payload!,
                                                 runningAmount: mainInputData.totalAmount!,
                                                 toSendAmount: amount, toScriptHash: toAddress.hashFromAddress(), fee: 0)
            if fee > 0.0 {
                optionalFeeInputData = getInputsNecessaryToSendGas(amount: 0.00000001, assets: assets, fee: fee)
            }
        }

        var optionalFeeOutputData: (payload: Data, outputCount: UInt8)? = nil
        if optionalFeeInputData != nil {
            optionalFeeOutputData = getOuputDataPayload(asset: AssetId.gasAssetId, with: (optionalFeeInputData?.payload!)!,
                                                            runningAmount: (optionalFeeInputData?.totalAmount!)!,
                                                            toSendAmount: 0.00000001, toScriptHash: self.address.hashFromAddress(), fee: fee)
        }

        let sendPayloadPrefix: [UInt8] = [0x80, 0x00]
        let attributesPayload = getAttributesPayload(attributes: attributes)

        let totalInputCount = (mainInputData.inputCount!) + (optionalFeeInputData?.inputCount ?? 0)
        let finalInputPayload = Data(bytes: (mainInputData.payload!).bytes + (optionalFeeInputData?.payload ?? Data()).bytes)

        let totalOutputCount = (mainOutputData.outputCount) + (optionalFeeOutputData?.outputCount ?? 0)
        let finalOutputPayload = Data(bytes: (mainOutputData.payload).bytes + (optionalFeeOutputData?.payload ?? Data()).bytes)

        var rawTransaction = sendPayloadPrefix + attributesPayload
        rawTransaction += [totalInputCount] + finalInputPayload.bytes +
            [totalOutputCount] + finalOutputPayload.bytes

        let rawTransactionData = Data(bytes: rawTransaction)

        let signatureData = NeoutilsSign(rawTransactionData, privateKey.fullHexString, &error)
        let finalPayload = concatenatePayloadData(txData: rawTransactionData, signatureData: signatureData!)
        return (rawTransactionData, finalPayload)

    }

    func unsignedPayloadToTransactionId(_ unsignedPayload: Data) -> String {
        let unsignedPayloadString = unsignedPayload.fullHexString
        let firstHash = unsignedPayloadString.dataWithHexString().sha256.fullHexString
        let reversed: [UInt8] = firstHash.dataWithHexString().sha256.bytes.reversed()
        return reversed.fullHexString
    }

//    public func sendAssetTransaction(network: Network, seedURL: String, asset: AssetId, amount: Double, toAddress: String, attributes: [TransactionAttritbute]? = nil, fee: Double = 0.0, completion: @escaping(String?, Error?) -> Void) {
    public func sendAssetTransaction(assetHash: String, asset: AssetId, amount: Double, toAddress: String, mainNet: Bool, remarkStr: String?, network: NeoNetwork, fee: Double = 0.0, completion: @escaping(String?, Error?) -> Void) {
        
        var customAttributes: [TransactionAttritbute] = []
        let remarkInput = remarkStr ?? NEO_Transfer_Remark
        let remark = String(format: "%@%@", remarkInput,Date().timeIntervalSince1970.description)
//        let remark = String(format: "O3X%@", Date().timeIntervalSince1970.description)
        customAttributes.append(TransactionAttritbute(script: self.address.hashFromAddress()))
        customAttributes.append(TransactionAttritbute(remark: remark))
        
        O3APIClient(network: network).getUTXO(for: self.address) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let assets):
                let payload = self.generateSendTransactionPayload(asset: asset, amount: amount, toAddress: toAddress, assets: assets, attributes: customAttributes, fee: fee)
                let txid = self.unsignedPayloadToTransactionId(payload.0)
                let txHex = payload.1.fullHexString
                completion(txHex,nil)
//                NeoClient(seed: seedURL).sendRawTransaction(with: payload.1) { (result) in
//                    switch result {
//                    case .failure(let error):
//                        completion(nil, error)
//                    case .success(let response):
//                        if response {
//                            completion(txid, nil)
//                        } else {
//                            completion(nil, nil)
//                        }
//                    }
//                }
            }
        }
    }

    func generateClaimInputData(claims: Claimable) -> Data {
        var payload: [UInt8] = [0x02] // Claim Transaction Type
        payload += [0x00]    // Version
        //let claimsCount = UInt8(claims.claims.count)
        let claimsCount = UInt8(claims.claims.count)
        payload += [claimsCount]

        for claim in claims.claims {
            payload += claim.txid.dataWithHexString().bytes.reversed()
            payload += toByteArray(claim.index)
        }

        let amountDecimal = claims.gas * pow(10, 8)
        let amountInt = UInt64(round(NSDecimalNumber(decimal: amountDecimal).doubleValue))

        var attributes: [TransactionAttritbute] = []
        let remark = String(format: "O3XCLAIM")
        attributes.append(TransactionAttritbute(remark: remark))

        var numberOfAttributes: UInt8 = 0x00
        var attributesPayload: [UInt8] = []

        for attribute in attributes where attribute.data != nil {
            attributesPayload += attribute.data!
            numberOfAttributes += 1
        }

        payload += [numberOfAttributes]
        payload += attributesPayload
        payload += [0x00] // Inputs
        payload += [0x01] // Output Count
        payload += AssetId.gasAssetId.rawValue.dataWithHexString().bytes.reversed()
        payload += toByteArray(amountInt)
        payload += hashedSignature.bytes
        #if DEBUG
        print(payload.fullHexString)
        #endif
        return Data(bytes: payload)
    }

    func generateClaimTransactionPayload(claims: Claimable) -> Data {
        var error: NSError?
        let rawClaim = generateClaimInputData(claims: claims)
        let signatureData = NeoutilsSign(rawClaim, privateKey.fullHexString, &error)
        let finalPayload = concatenatePayloadData(txData: rawClaim, signatureData: signatureData!)
        return finalPayload
    }

    public func claimGas(network: NeoNetwork, seedURL: String, completion: @escaping(Bool?, Error?) -> Void) {
        O3APIClient(network: network).getClaims(address: self.address) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let claims):
                let claimData = self.generateClaimTransactionPayload(claims: claims)
                print(claimData.fullHexString)
                NeoClient(seed: seedURL).sendRawTransaction(with: claimData) { (result) in
                    switch result {
                    case .failure(let error):
                        completion(nil, error)
                    case .success(let response):
                        completion(response, nil)
                    }
                }
            }
        }
    }
    
    private func generateGenericInvokeTransactionPayload(assets: Assets? = nil, script: String, attributes: [TransactionAttritbute]?, invokeRequest: dAppProtocol.InvokeRequest) -> (String, Data) {
        var error: NSError?
        var gasAmount = 0.0
        var neoAmount = 0.0
        
        //everything will always be in the format where double is period
        if let attachedGas = invokeRequest.attachedAssets?.gas {
            gasAmount = Double(attachedGas)!
        }
        
        if let attachedNeo = invokeRequest.attachedAssets?.neo {
            neoAmount = Double(attachedNeo)!
        }
    
        let gasInputData = getInputsNecessaryToSendGas(amount: gasAmount, assets: assets, fee: Double(invokeRequest.fee) ?? 0)
        
        var neoInputData: (totalAmount: Decimal?, inputCount: UInt8?, payload: Data?, error: Error?)? = nil
        if neoAmount > 0 {
            neoInputData = getInputsNecessaryToSendNeo(amount: neoAmount, assets: assets)
        }
        
        var neoOutputData: (payload: Data, outputCount: UInt8)?
        if neoInputData != nil {
            neoOutputData = getOuputDataPayload(asset: AssetId.neoAssetId, with: neoInputData!.payload!,
                                                     runningAmount: neoInputData!.totalAmount!,
                                                     toSendAmount: neoAmount, toScriptHash: invokeRequest.scriptHash, fee: Double(invokeRequest.fee) ?? 0)
        }
        
        var gasOutputData: (payload: Data, outputCount: UInt8)?
        if gasInputData.payload != nil {
            gasOutputData = getOuputDataPayload(asset: AssetId.gasAssetId, with: gasInputData.payload!, runningAmount: gasInputData.totalAmount!,
                                                    toSendAmount: gasAmount, toScriptHash: invokeRequest.scriptHash, fee: Double(invokeRequest.fee) ?? 0)
        }
        
        let totalInputCount = (neoInputData?.inputCount ?? 0) + (gasInputData.inputCount ?? 0)
        let finalInputPayload = (neoInputData?.payload ?? Data()) + (gasInputData.payload ?? Data())
        
        let finalOutputCount = (neoOutputData?.outputCount ?? 0) + (gasOutputData?.outputCount ?? 0)
        let finalOutputPayload = (neoOutputData?.payload ?? Data()) + (gasOutputData?.payload ?? Data())
        
        let payloadPrefix = [0xd1, 0x00] + script.dataWithHexString().bytes
        let attributesPayload = getAttributesPayload(attributes: attributes)
        var rawTransaction = payloadPrefix + attributesPayload
        rawTransaction += [totalInputCount] + finalInputPayload.bytes +
            [finalOutputCount] + finalOutputPayload.bytes
        print("payloadPrefix.fullHexString:  "+payloadPrefix.fullHexString)
        print("attributesPayload.fullHexString:  "+attributesPayload.fullHexString)
        print("[totalInputCount].fullHexString:  "+[totalInputCount].fullHexString)
        print("finalInputPayload.bytes.fullHexString:  "+finalInputPayload.bytes.fullHexString)
        print("[finalOutputCount].fullHexString:  "+[finalOutputCount].fullHexString)
        print("finalOutputPayload.bytes.fullHexString:  "+finalOutputPayload.bytes.fullHexString)
        
        print("rawTransaction.fullHexString:  "+rawTransaction.fullHexString)
        let rawTransactionData = Data(bytes: rawTransaction)
        print("rawTransactionData.fullHexString:  "+rawTransactionData.fullHexString)
        let signatureData = NeoutilsSign(rawTransactionData, privateKey.fullHexString, &error)
        print("signatureData.fullHexString:  "+signatureData!.fullHexString)
        let finalPayload = concatenatePayloadData(txData: rawTransactionData, signatureData: signatureData!)
        print("finalPayload.fullHexString:  "+finalPayload.fullHexString)
        //hash unsigned tx to get txid
        let txid = self.unsignedPayloadToTransactionId(rawTransactionData)
        return (txid, finalPayload)
    }
    

    private func buildNEP5TransferScript(scriptHash: String, decimals: Int, fromAddress: String,
                                         toAddress: String, amount: Double) -> [UInt8] {

        let amountToSend = Int(amount * pow(10, Double(decimals)))
        let fromAddressHash = fromAddress.hashFromAddress()
        let toAddressHash = toAddress.hashFromAddress()
        let scriptBuilder = ScriptBuilder()
        scriptBuilder.pushContractInvoke(scriptHash: scriptHash, operation: "transfer",
                                         args: [amountToSend, toAddressHash, fromAddressHash])
        let script = scriptBuilder.rawBytes
        return [UInt8(script.count)] + script
    }
    
    enum InvokeError: Error {
        case invokeFailed
    }
    
    public func invokeContract(network: NeoNetwork, seedURL: String?,
                               invokeRequest: dAppProtocol.InvokeRequest, remarkStr: String?, completion: @escaping(String?, Error?) -> Void) {

        var customAttributes: [TransactionAttritbute] = []
        let remarkInput = remarkStr ?? NEO_Transfer_Remark
        let remark = String(format: "%@%@", remarkInput,Date().timeIntervalSince1970.description)
        customAttributes.append(TransactionAttritbute(script: self.address.hashFromAddress()))
        customAttributes.append(TransactionAttritbute(remark: remark))
        
        let scriptBuilder = ScriptBuilder()
        scriptBuilder.pushTypedContractInvoke(scriptHash: invokeRequest.scriptHash, operation: invokeRequest.operation, args: invokeRequest.args ?? [])
        let script = scriptBuilder.rawBytes
        let scriptBytes = [UInt8(script.count)] + script
        print("scriptBytes.fullHexString:  "+scriptBytes.fullHexString)
        
        if Double(invokeRequest.fee) == 0.0 && invokeRequest.attachedAssets?.neo == nil && invokeRequest.attachedAssets?.gas == nil {
            let payload = self.generateGenericInvokeTransactionPayload(assets: nil, script: scriptBytes.fullHexString, attributes: customAttributes, invokeRequest: invokeRequest)
            
//            payload.1 += invokeRequest.scriptHash.dataWithHexString().bytes
            let txID = payload.0
            let test = payload.1.fullHexString
            print("test = \(test)")
            let payloadHex = payload.1 + invokeRequest.scriptHash.dataWithHexString().bytes
            let txHex = payloadHex.fullHexString
            print("txHex = \(txHex)")
            completion(txHex,nil)
//            NeoClient(seed: seedURL).sendRawTransaction(with: payload.1) { (result) in
//                switch result {
//                case .failure(let error):
//                    completion(nil, error)
//                case .success(let response):
//                    if response == true {
//                        completion(txID, nil)
//                    } else {
//                        completion(nil, InvokeError.invokeFailed)
//                    }
//                }
//            }
        } else {
            O3APIClient(network: network).getUTXO(for: self.address) { result in
                switch result {
                case .failure(let error):
                    completion(nil, error)
                case .success(let assets):
                    let payload = self.generateGenericInvokeTransactionPayload(assets: assets, script: scriptBytes.fullHexString, attributes: customAttributes, invokeRequest: invokeRequest)
//                    payload.1 += invokeRequest.scriptHash.dataWithHexString().bytes
                    let txID = payload.0
                    let payloadHex = payload.1 + invokeRequest.scriptHash.dataWithHexString().bytes
                    let txHex = payloadHex.fullHexString
                    completion(txHex,nil)
//                    NeoClient(seed: seedURL).sendRawTransaction(with: payload.1) { (result) in
//                        switch result {
//                        case .failure(let error):
//                            completion(nil, error)
//                        case .success(let response):
//                            if response == true {
//                                completion(txID, nil)
//                            } else {
//                                completion(nil, InvokeError.invokeFailed)
//                            }
//                        }
//                    }
                }
            }
        }
    }
    
//    public func sendNep5Token(network: Network, seedURL: String, tokenContractHash: String, decimals: Int, amount: Double, toAddress: String, attributes: [TransactionAttritbute]? = nil, fee: Double = 0.0, completion: @escaping(String?, Error?) -> Void) {
    public func sendNep5Token(tokenContractHash: String, amount: Double, toAddress: String, mainNet: Bool, attributes: [TransactionAttritbute]? = nil, remarkStr: String?, decimals: Int, fee: Double = 0.0, network: NeoNetwork, completion: @escaping(String?, Error?) -> Void) {
        print("sendNep5Token action")
    
        let amountToSend = Int(amount * pow(10, Double(decimals)))
        let args:[dAppProtocol.Arg] = [dAppProtocol.Arg(type: "address", value: self.address),
                                       dAppProtocol.Arg(type: "address", value: toAddress),
                                       dAppProtocol.Arg(type: "integer", value: String(amountToSend))]
        
        
        let invokeRequest = dAppProtocol.InvokeRequest(operation: "transfer", scriptHash: tokenContractHash, assetIntentOverrides: nil,
                                                       attachedAssets: nil, triggerContractVerification: false, fee: String(fee),
                                                       args: args, network: network.rawValue)
        invokeContract(network: network, seedURL: nil, invokeRequest: invokeRequest, remarkStr: remarkStr) { (hex, err) in
            completion(hex,err)
        }
    }
}
