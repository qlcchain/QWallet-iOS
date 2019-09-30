//
//  QLCUtil.swift
//  qlc-ios-sdk
//
//  Created by Jelly Foo on 2019/5/23.
//  Copyright © 2019 Jelly Foo. All rights reserved.
//

import UIKit
import TrezorCrytoEd25519
//import HandyJSON
//import BigInt
//import libsodium

public class QLCUtil: NSObject {
    
    private static let signatureLength = 64
    private static let addressCodeArray : String  = "13456789abcdefghijkmnopqrstuwxyz"
    private static var addressCodeCharArray: Array<String> {
        return  addressCodeArray.map { String($0) }
    }
    
    // sign
    @objc public static func sign(message: String, secretKey: String, publicKey: String) -> String {
        let messageB : Bytes = message.hex2Bytes
        let secretKeyB : Bytes = secretKey.hex2Bytes
        let publicKeyB : Bytes = publicKey.hex2Bytes
        var signature = Bytes(count: signatureLength)
        ed25519_sign_qlc(messageB, Int(messageB.count), secretKeyB, publicKeyB, &signature)
        let signHex : String = signature.toHexString()
        return signHex
    }
    
    // check sign
    @objc public static func signOpen(message: String, publicKey: String, signature: String) -> Bool {
        let messageB : Bytes = message.hex2Bytes
        let signatureB : Bytes = signature.hex2Bytes
        let publicKeyB : Bytes = publicKey.hex2Bytes
        return ed25519_sign_open_qlc(messageB, Int(messageB.count), publicKeyB, signatureB) == 0
    }
    
    // seed
    @objc public static func generateSeed() -> String {
        let seed = RandomString.getRandomStringOfLength(length: 64)
//        let seed = RandomString.sharedInstance.getRandomStringOfLength(length: 64)
        return seed
    }
    
    // seed
    @objc public static func isValidSeed(seed:String) -> Bool {
        return seed.count == 64
    }
    
    // privatekey
    @objc public static func seedToPrivateKey(seed:String, index:UInt8) -> String {
        var privateKeySource = Bytes()
        let seedB = seed.hex2Bytes
        privateKeySource.append(contentsOf: seedB)
        let indexB = Bytes(arrayLiteral: 0x00,0x00,0x00,index)
        privateKeySource.append(contentsOf: indexB)
        let hashB = Blake2b.hash(outLength: 32, in: privateKeySource) ?? Bytes()
        let privateKey = hashB.toHexString()
//        print("privateKey = " + privateKey)
        return privateKey
    }
    
    // publickey
    @objc public static func privateKeyToPublicKey(privateKey:String) -> String {
        var public_key_b = Bytes(count: 32)
        let private_key_b = privateKey.hex2Bytes
        ed25519_publickey_qlc(private_key_b, &public_key_b)
        let publicKey = public_key_b.toHexString()
        return publicKey
    }
    
    // address
    @objc public static func publicKeyToAddress(publicKey:String) -> String {
        let encodedAddress = QLCUtil.encode(hex_data: publicKey)
    
        var source = Bytes()
        let bytePublic = publicKey.hex2Bytes
        source.append(contentsOf: bytePublic)
        let check = Blake2b.hash(outLength: 5, in: source)!
        let checkReverse = QLCUtil.reverse(bytes: check)
        let checkReverseStr = checkReverse.toHexString()
    
        var resultAddress = String()
        resultAddress.insert(contentsOf: "qlc_", at: resultAddress.startIndex)
        resultAddress.append(encodedAddress)
        let check_str = QLCUtil.encode(hex_data: checkReverseStr)
        resultAddress.append(check_str)
    
        return resultAddress
    
    }
    
    // publickey
    @objc public static func addressToPublicKey(address: String) -> String {
//        let addressB : Bytes = address.hex2Bytes
        var str:String = String(address.split(separator: "_")[1])
        let data = str.slice(from: 0, to: 52)
        let pubkey = decodeAddressCharacters(data: data)
        
        var source = Bytes()
        let data_b = pubkey.hex2Bytes
        source.append(contentsOf: data_b)
        let check = Blake2b.hash(outLength: 5, in: source)!
        let checkReverse = QLCUtil.reverse(bytes: check)
        let checkReverseStr = checkReverse.toHexString()
     
        // left pad byte array with zeros
        var pk = String(data_b.toHexString())
        while pk.count < 64 {
            pk.insert(contentsOf: "0", at: pk.startIndex)
        }
        
        return pk
    }
    
    // address
    @objc public static func isValidAddress(address:String) -> Bool {
        let parts : Array<Substring> = address.split(separator: "_")
        if parts.count != 2 {
            return false
        }
        if parts[0] != "qlc" {
            return false
        }
        if parts[1].count != 60 {
            return false
        }
        checkCharacters:
        for i in 0..<parts[1].count {
            var str = String(parts[1].lowercased())
            let letter = str.slice(from: i, length: 1)
            for j in 0..<addressCodeCharArray.count {
                if (addressCodeCharArray[j] == letter) {
                    continue checkCharacters
                }
            }
            return false
        }
//        efbeb3ba0457574f4ad578367192da3b651d1c6de6c0a4b912c33b75fb38516136c20e9cd3
//        9ce6f608ebb5de240aaf850fd9247eeece06b3c7e4d17810277ea3c90c7a6bf3271bef51f
        let shortBytes = decodeAddressCharactersOf74(data: String(parts[1])).hex2Bytes
        var bytes = Bytes(count: 37) // total:37
        // Restore leading null bytes
        let range = Range<Int>(NSMakeRange(37 - shortBytes.count, shortBytes.count))!
        bytes.replaceSubrange(range, with: shortBytes)
//        System.arraycopy(shortBytes, 0, bytes, bytes.length - shortBytes.length, shortBytes.length);
        var source = Bytes()
        source.append(contentsOf: bytes[0...31])
        let check = Blake2b.hash(outLength: 5, in: source)!
        for i in 0..<check.count {
            if (check[i] != bytes[bytes.count - 1 - i]) {
                return false
            }
        }
        return true
    }
    
    // Mnemonic
    @objc public static func seedToMnemonic(seed:String) -> String {
        let entropy = Data(hex: seed)
        let mnemonic = Mnemonic.generator(entropy: entropy)
        return mnemonic
    }
    
    // Mnemonic
    @objc public static func mnemonicToSeed(mnemonic:String) -> String {
        let entropy = Mnemonic.mnemonicsToEntropy(mnemonic)
        let seed = (entropy ?? Data()).dataToHexString()
        print(seed)
        return seed
    }
    
    // Mnemonic
    @objc public static func isValidMnemonic(mnemonic:String) -> Bool {
        let arr = mnemonic.components(separatedBy: " ")
        if (arr.count == 24) {
            return true
        }
        return false
    }
    
    @objc public static func requestServerWork(workHash:String,resultHandler: @escaping ((String) -> Void)) {
//        let workHash = "0a3b1fdaa5d4edd885cfb40ac0e83d29996a7be843e410d6038fbba4bb862ca1"
        let url = "http://pow1.qlcchain.org/work"+"?root=\(workHash)"
        print("远程算work："+url)
        let urlRequest = URLRequest(url: URL(string: url)!)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            var work = ""
            if let _ = error {
                print("远程算work失败："+error.debugDescription)
            } else if let responseString = String(data: data!, encoding: .utf8) {
                print("远程算work成功："+responseString)
                work = responseString
            } else {
                print("远程算work失败1："+error.debugDescription)
            }
            resultHandler(work)
        }.resume()
    }
    
    // sign and work
    @objc public static func signAndWork(dic : NSDictionary, publicKey: String, privateKey: String,resultHandler: @escaping ((Dictionary<String, Any>?) -> Void)) {
        let block:QLCStateBlock = QLCStateBlock.deserialize(from: dic) ?? QLCStateBlock()
        // set signature
        let blockHash = BlockMng.getHash(block: block)
        let signature = QLCUtil.sign(message: blockHash.toHexString(), secretKey: privateKey, publicKey: publicKey)
        let signCheck : Bool = QLCUtil.signOpen(message: blockHash.toHexString(), publicKey: publicKey, signature: signature)
        if !signCheck {
            print(QLCConstants.EXCEPTION_MSG_1005)
            resultHandler(nil)
        }
        block.signature = signature
        
        // set work
        let workHash = BlockMng.getRoot(block: block) ?? ""
//        WorkUtil.generateWorkOfOperationRandom(hash: workHash) { (work,isTimeOut) in
//            if isTimeOut == true {
        
        QLCUtil.requestServerWork(workHash: workHash) { (work) in
            block.work = work
            resultHandler(block.toJSON())
        }
//        print("http://pow1.qlcchain.org/work params=\(params)")
//        let params = ["root":workHash]
//        RequestService.testRequest(withBaseURLStr8: "http://pow1.qlcchain.org/work", params: params, httpMethod: HttpMethodGet, userInfo: nil, requestManagerType: QRequestManagerTypeHTTP, successBlock: { (task, response) in
//            block.work = (response as! String?) ?? ""
//            resultHandler(block.toJSON())
//        }, failedBlock: { (task, error) in
//            block.work = ""
//            resultHandler(block.toJSON())
//        })
//            } else {
//                block.work = work
//                resultHandler(block.toJSON())
//            }
//        }
    }
    
    // Send
    @objc public static func sendAsset(from:String, tokenName:String, to:String, amount:UInt, sender: String?, receiver:String?, message:String?, privateKey:String,isMainNetwork:Bool, workInLocal:Bool, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let privateKeyB = privateKey.hex2Bytes
        let amountB = BigUInt(amount)
        try? TransactionMng.sendBlock(from: from, tokenName: tokenName, to: to, amount: amountB, sender: sender ?? "", receiver: receiver ?? "", message: message ?? "", privateKeyB: privateKeyB,isMainNetwork:isMainNetwork, workInLocal: workInLocal, successHandler: { (response) in
            if response != nil {
                let dic = response as! Dictionary<String, Any>
                try? LedgerMng.process(dic: dic,isMainNetwork:isMainNetwork, successHandler: { (response) in
                    if response != nil {
                        successHandler(response)
                    } else {
                        failureHandler(nil, nil)
                    }
                }) { (error, message) in
                    failureHandler(error, message)
                }
            } else {
                failureHandler(nil, nil)
            }
        }) { (error, message) in
            failureHandler(error, message)
        }
    }
    
    // Receive
    @objc public static func receive_accountsPending(address:String,isMainNetwork:Bool, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        // pending info
        var pending: QLCPending?
        try? LedgerMng.accountsPending(address: address,isMainNetwork:isMainNetwork, successHandler: { (response) in
            if response != nil {
                pending = (response as! QLCPending)
                let itemList = pending?.infoList
                if itemList != nil && itemList!.count > 0 {
                    successHandler(itemList!.toJSON())
                } else {
                    successHandler(nil)
                }
            } else {
                failureHandler(nil, nil)
            }
        }, failureHandler: { (error, message) in
            print("getAccountPending = ",message ?? "")
            failureHandler(error, message)
        })
    }
    
    // Receive
    @objc public static func receive_blocksInfo(blockHash:String, receiveAddress:String ,privateKey:String,isMainNetwork:Bool, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let blockHashB = blockHash.hex2Bytes
        try? LedgerMng.blocksInfo(blockHash: blockHashB,isMainNetwork:isMainNetwork, successHandler: { (response) in
            if response != nil {
                let tempBlock:QLCStateBlock = response as! QLCStateBlock
                let privateKeyB = privateKey.hex2Bytes
                try? TransactionMng.receiveBlock(sendBlock: tempBlock, receiveAddress: receiveAddress, privateKeyB: privateKeyB,isMainNetwork:isMainNetwork, successHandler: { (response) in
                    if response != nil {
                        let dic = response as! Dictionary<String, Any>
                        try? LedgerMng.process(dic: dic,isMainNetwork:isMainNetwork, successHandler: { (response) in
                            if response != nil {
                                successHandler(response)
                            } else {
                                failureHandler(nil, nil)
                            }
                        }) { (error, message) in
                            failureHandler(error, message)
                        }
                    } else {
                        failureHandler(nil, nil)
                    }
                }, failureHandler: { (error, message) in
                    failureHandler(error, message)
                })
            } else {
                print(QLCConstants.EXCEPTION_BLOCK_MSG_2003 + ", block hash[" + blockHashB.toHexString() + "]")
                failureHandler(nil, nil)
            }
        }) { (error, message) in
            print("getBlockInfoByHash = ",message ?? "")
            failureHandler(error, message)
        }
        
    }

    private static func decodeAddressCharacters(data: String) -> String {
        var muStr = String()
        for (i,_) in data.enumerated() {
            var dataMu = String(data)
            let dataSub:String = dataMu.slice(from: i, to: i+1)
            let index:Int = addressCodeArray.positionOfSubstring(dataSub)
            var binaryStr = String((0x20 | index), radix: 2)
            let binarySub = binaryStr.slice(from: 1, to: binaryStr.count)
            muStr.append(binarySub)
        }
        var result = String(BigInt(muStr, radix: 2)!, radix: 16)
        
        return result
    }
    
    private static func decodeAddressCharactersOf74(data: String) -> String {
        var muStr = String()
        for (i,_) in data.enumerated() {
            var dataMu = String(data)
            let dataSub:String = dataMu.slice(from: i, to: i+1)
            let index:Int = addressCodeArray.positionOfSubstring(dataSub)
            var binaryStr = String((0x20 | index), radix: 2)
            let binarySub = binaryStr.slice(from: 1, to: binaryStr.count)
            muStr.append(binarySub)
        }
        var result = String(BigInt(muStr, radix: 2)!, radix: 16)
        if result.count < 74 { // 不足74位前面加0 （自己理解）
            var temp = String()
            for _ in 0..<74-result.count {
                temp.append("0")
            }
            temp.append(result)
            result = temp
        }
        
        return result
    }
    
    private static func encode(hex_data:String) -> String {
        var bits = String()
        let dataBinary = String(BigInt(hex_data, radix: 16)!,radix:2)
        bits.insert(contentsOf: dataBinary, at: bits.startIndex)
        while bits.count < hex_data.count*4 {
            bits.insert(contentsOf: "0", at: bits.startIndex)
        }

        var data = String()
        data.insert(contentsOf: bits, at: data.startIndex)
        while data.count % 5 != 0 {
            data.insert(contentsOf: "0", at: data.startIndex)
        }
    
        var output = String()
        let slice = data.count / 5
        for this_slice in 0..<slice {
            var dataMu = String(data)
            let dataSub = dataMu.slice(from: this_slice * 5, to:this_slice * 5 + 5)
            let subInt = Int(BigInt(dataSub, radix: 2)!)
            let appendStr : String = addressCodeCharArray[subInt]
            output.append(appendStr)
        }

        return output
    }
    
    public static func reverse(bytes:Bytes) -> Bytes {
        var bytesArr = Bytes(bytes)
        var i = 0
        var j = bytes.count - 1
        var temp : UInt8
        while j > i {
            temp = bytesArr[j]
            bytesArr[j] = bytesArr[i]
            bytesArr[i] = temp
            j = j - 1
            i = i + 1
        }
        return bytesArr
    }
    
    @objc public static func getRandomStringOfLength(length: Int) -> String {
        return RandomString.getRandomStringOfLength(length: length)
    }

}


/// 随机字符串生成
public class RandomString:NSObject {
//    let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static let characters = "0123456789abcdef"
    
    /**
     生成随机字符串,
     - parameter length: 生成的字符串的长度
     - returns: 随机生成的字符串
     */
    static func getRandomStringOfLength(length: Int) -> String {
        var ranStr = ""
        for _ in 0..<length {
            let index = Int(arc4random_uniform(UInt32(characters.count)))
            var charactersMu = String(characters)
            let character = charactersMu.slice(from: index, length: 1)
            ranStr.append(character)
        }
        return ranStr
    }
//    static let sharedInstance = RandomString()
}
