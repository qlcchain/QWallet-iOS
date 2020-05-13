//
//  TrustWalletManage.swift
//  TestTrust
//
//  Created by Jelly Foo on 2018/5/30.
//  Copyright © 2018年 qlink. All rights reserved.
//

import UIKit
import TrustCore
import TrustKeystore
import BigInt
import RealmSwift
import Result

public class WalletModel : NSObject {
    @objc public var name: String = ""
    @objc public var balance: String = ""
    @objc public var address: String = ""
    @objc public var isWatch: Bool = false
    @objc public var symbol : String = ""
}

public class TrustWalletManage: NSObject {
    
    var keystore: Keystore
    let coin: Coin = .ethereum
    private let shortFormatter = EtherNumberFormatter.short
    
    public static let swiftSharedInstance = TrustWalletManage()
    //在oc中这样写才能被调用
    @objc public class func sharedInstance() -> TrustWalletManage
    {
        return TrustWalletManage.swiftSharedInstance
    }
    
    //    init(keystore: Keystore) {
    //        self.keystore = keystore
    //    }
    
    override public init() {
        
        var config = Realm.Configuration()
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("ETHTest.realm")
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm(configuration: config)
        
//        let sharedMigration = SharedMigrationInitializer()
//        sharedMigration.perform()
//        let realm = try! Realm(configuration: sharedMigration.config)
        let walletStorage = WalletStorage(realm: realm)
        self.keystore = EtherKeystore(storage: walletStorage)
        //        self.keystore = EtherKeystore.shared
    }
    
    @objc public func createInstantWallet( _ export : @escaping (([String]?, String?) -> Void) ) {
        let password = PasswordGenerator.generateRandom()
        keystore.createAccount(with: password) { result in
            switch result {
            case .success(let account):
                print("****ETH_LOG****create account success:\(account)")
//                self.markAsMainWallet(for: account)
                let address = self.keystore.wallets.last?.currentAccount.address.description
                self.keystore.exportMnemonic(wallet: account) { mnemonicResult in
                    switch mnemonicResult {
                    case .success(let words):
                        print("****ETH_LOG****exportMnemonic success:\(words)")
                        export(words, address)
                    case .failure(let error):
                        print("****ETH_LOG****exportMnemonic fail:\(error)")
                        export(nil, address)
                    }
                }
            case .failure(let error):
                print("****ETH_LOG****create account fail:\(error)")
                export(nil, nil)
            }
        }
    }
    
    @objc public func importWallet(keystoreInput:String?,privateKeyInput:String?,addressInput:String?,mnemonicInput:String?,password:String?,_ importResult : @escaping ((Bool, String?) -> Void)) {
        var words : [String]? = nil
        var type : ImportSelectionType = .privateKey
        if (keystoreInput != nil) {
            type = .keystore
        } else if (privateKeyInput != nil) {
            type = .privateKey
        } else if (addressInput != nil) {
            type = .address
        } else if (mnemonicInput != nil) {
            type = .mnemonic
            words = mnemonicInput!.components(separatedBy: " ").map { $0.trimmed.lowercased() }
        }
        let importType: ImportType = {
            switch type {
            case .keystore:
                return .keystore(string: keystoreInput!, password: password!)
            case .privateKey:
                return .privateKey(privateKey: privateKeyInput!)
            case .mnemonic:
                return .mnemonic(words: words!, password: password!, derivationPath: coin.derivationPath(at: 0))
            case .address:
                let address = EthereumAddress(string: addressInput!)! // EthereumAddress validated by form view.
                return .address(address: address)
            }
        }()
        
        keystore.importWallet(type: importType, coin: coin) { result in
            switch result {
            case .success(let account):
                print("****ETH_LOG****import account success:\(account)")
                let address = account.currentAccount.address.description
                importResult(true, address)
            case .failure(let error):
                print("****ETH_LOG****import account fail",error)
                importResult(false, nil)
            }
        }
    }
    
    @objc public func importWallet(privateKeyInput:String?,addressInput:String?,isWatch:Bool,_ importResult : @escaping ((Bool, String?) -> Void)) {
        var type : ImportSelectionType = .privateKey
        if isWatch == true {
            type = .address
        } else {
            type = .privateKey
        }
        let importType: ImportType = {
            if type == .privateKey {
                return .privateKey(privateKey: privateKeyInput!)
            } else {
                let address = EthereumAddress(string: addressInput!)! // EthereumAddress validated by form view.
                return .address(address: address)
            }
        }()
        
        keystore.importWallet(type: importType, coin: coin) { result in
            switch result {
            case .success(let account):
                print("****ETH_LOG****import account success:\(account)")
                let address = account.currentAccount.address.description
                importResult(true, address)
            case .failure(let error):
                print("****ETH_LOG****import account fail",error)
                importResult(false, nil)
            }
        }
    }
    
    @objc public func importWallet() {
        //        let validatedError = keystoreRow?.section?.form?.validate()
        //        guard let errors = validatedError, errors.isEmpty else { return }
        //        let validatedAdressError = addressRow?.section?.form?.validate()
        //        guard let addressErrors = validatedAdressError, addressErrors.isEmpty else { return }
        
        let keystoreInput = "{\"version\":3,\"id\":\"1a464fe8-b97f-4f47-ba43-ba11847447e8\",\"crypto\":{\"ciphertext\":\"55db45f95baa7ac08e0345f5488ba0ca4fb11ea0e91e7b9198ec736577aeb3d1\",\"cipherparams\":{\"iv\":\"ac7096897ca79119409c78ce3b7f1f38\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"r\":8,\"p\":6,\"n\":4096,\"dklen\":32,\"salt\":\"5e47464718c002c05acd7cbd1c2a74407b159aa78f539e9ce0674fdf20b3b725\"},\"mac\":\"bdfce9e2250986cf98324b17fb5e04a71afb196e316ab97cc31b7cb55f560026\",\"cipher\":\"aes-128-ctr\"},\"type\":\"private-key\",\"address\":\"14758245C6E5F450e9fBED333F0d9C36AcE3Bc76\"}"
        let privateKeyInput = "4f2723cb79e172f6cb3cd6275c35ee5baa3db45111dfccccbebbe6c4294fc690"
        let password = "123456"
        let addressInput = ""
        let mnemonicInput = ""
        let words = mnemonicInput.components(separatedBy: " ").map { $0.trimmed.lowercased() }
        
        //        let type = ImportSelectionType(title: segmentRow?.value)
        //        let type : ImportSelectionType = .keystore
        let type : ImportSelectionType = .privateKey
        let importType: ImportType = {
            switch type {
            case .keystore:
                return .keystore(string: keystoreInput, password: password)
            case .privateKey:
                return .privateKey(privateKey: privateKeyInput)
            case .mnemonic:
                return .mnemonic(words: words, password: password, derivationPath: coin.derivationPath(at: 0))
            case .address:
                let address = EthereumAddress(string: addressInput)! // EthereumAddress validated by form view.
                return .address(address: address)
            }
        }()
        
        keystore.importWallet(type: importType, coin: coin) { result in
            switch result {
            case .success(let account):
                print("****ETH_LOG****import account success:\(account)")
            case .failure(let error):
                print("****ETH_LOG****import account fail",error)
            }
        }
    }
    
    @objc public func send(fromAddress:String,contractAddress:String,toAddress:String,name:String,symbol:String,amount:String,gasLimit:Int,gasPrice:Int,memo:String?,decimals:Int,value:String,isCoin:Bool,_ sendComplete : @escaping ((Bool, String?) -> Void)) {
//        let walletInfo : WalletInfo = self.keystore.wallets[0]
        var walletInfo : WalletInfo? = nil
        for tempWalletInfo in self.keystore.wallets {
            if fromAddress == tempWalletInfo.currentAccount.address.description {
                walletInfo = tempWalletInfo
                break
            }
        }
        if walletInfo == nil {
            print("****ETH_LOG****找不到钱包")
            return
        }
        let config: Config = .current
        let migration = MigrationInitializer(account: walletInfo!)
        migration.perform()
        let sharedMigration = SharedMigrationInitializer()
        sharedMigration.perform()
        let realm = self.realm(for: migration.config)
        let sharedRealm = self.realm(for: sharedMigration.config)
        let session = WalletSession(
            account: walletInfo!,
            realm: realm,
            sharedRealm: sharedRealm,
            config: config
        )
        session.transactionsStorage.removeTransactions(for: [.failed, .unknown])
        
        let fullFormatter = EtherNumberFormatter.full
        let gasPriceBig = fullFormatter.number(from: String(Int(gasPrice)), units: UnitConfiguration.gasPriceUnit) ?? BigInt()
        let gasLimitBig = BigInt(String(Int(gasLimit)), radix: 10) ?? BigInt()
        
        let data = Data()
//        if let dataString = memo {
//            data = Data(hex: dataString.drop0x)
//        } else {
//            data = Data()
//        }
        
        let nonceBig = BigInt("0") ?? 0
        let configuration = TransactionConfiguration(
            gasPrice: gasPriceBig,
            gasLimit: gasLimitBig,
            data: data,
            nonce: nonceBig
        )
        
        var type: TokenObjectType = .ERC20
        if isCoin == true {
            type = .coin
        }
        
        let token = TokenObject(
            contract: contractAddress,
            name: name,
            coin: .ethereum,
            type: type,
            symbol: symbol, decimals: decimals, value: value, isCustom: false, isDisabled: false)
        
        let transfer: Transfer = {
            let server = token.coin.server
            switch token.type {
            case .coin:
                return Transfer(server: server, type: .ether(token, destination: .none))
            case .ERC20:
                return Transfer(server: server, type: .token(token))
            }
        }()
        
        print("拿到transfer")
        
//        let balance = Balance(value: transfer.type.token.valueBigInt)
        let chainState: ChainState = ChainState(server: transfer.server)
        chainState.fetch()
//        let viewModel: SendViewModel = SendViewModel(transfer: transfer, config: session.config, chainState: chainState, storage: session.tokensStorage, balance: balance)
        
        let addressString = toAddress
        guard let address = EthereumAddress(string: addressString) else {
            print("****ETH_LOG****拿不到address")
            return
        }
        let amountString = amount
        let parsedValue : BigInt? = {
            switch transfer.type {
            case .ether, .dapp:
                return EtherNumberFormatter.full.number(from: amountString, units: .ether)
            case .token(let token):
                return EtherNumberFormatter.full.number(from: amountString, decimals: token.decimals)
            }
        }()
        print("****ETH_LOG****拿到parsedValue")
        guard let value = parsedValue else {
            print("****ETH_LOG****拿不到parsedValue")
            return
        }
        let transaction = UnconfirmedTransaction(
            transfer: transfer,
            value: value,
            to: address,
            data: configuration.data,
            gasLimit: configuration.gasLimit,
            gasPrice: configuration.gasPrice,
//            nonce: configuration.nonce
            nonce: .none
        )
        print("****ETH_LOG****拿到transaction")
        switch session.account.type {
        case .privateKey, .hd:
            let first = session.account.accounts.filter { $0.coin == token.coin }.first
            guard let account = first else {
                print("****ETH_LOG****拿不到account")
                return
            }
            
            let configurator = TransactionConfigurator(
                session: session,
                account: account,
                transaction: transaction,
                server: transfer.server,
                chainState: ChainState(server: transfer.server)
            )
            
            
            
            let transaction1 = configurator.signTransaction
            let server = transfer.server
            let sendTransactionCoordinator : SendTransactionCoordinator = SendTransactionCoordinator(session: session, keystore: keystore, confirmType: .signThenSend, server: server)
            print("****ETH_LOG****开始sendTransaction")
            sendTransactionCoordinator.send(transaction: transaction1) { result in
                print("****ETH_LOG****转账结果:",result)
                switch result {
                case .success(let complete) :
                    print("****ETH_LOG****send success:\(complete)")
//                    ConfirmResult
                    var txId = ""
                    switch complete {
                    case .signedTransaction(let sentTransaction):
                        txId = sentTransaction.id
                    case .sentTransaction(let sentTransaction):
                        txId = sentTransaction.id
                    }
                    sendComplete(true, txId)
                case .failure(let error) :
                    print("****ETH_LOG****send fail:\(error)")
                    sendComplete(false, nil)
                }
            }
            
        case .address:
            sendComplete(false, nil)
        }
    }
    
    @objc public func send() {
        
        //        let keystore = EtherKeystore.shared
        //        let wallet : Wallet = keystore.recentlyUsedWallet ?? keystore.wallets.first!
        let walletInfo : WalletInfo = self.keystore.wallets[0]
        
        let config: Config = .current
        
        let migration = MigrationInitializer(account: walletInfo)
        migration.perform()
        
        let sharedMigration = SharedMigrationInitializer()
        sharedMigration.perform()
        
        let realm = self.realm(for: migration.config)
        let sharedRealm = self.realm(for: sharedMigration.config)
        
        let session = WalletSession(
            account: walletInfo,
            realm: realm,
            sharedRealm: sharedRealm,
            config: config
        )
        session.transactionsStorage.removeTransactions(for: [.failed, .unknown])
        
        //        let tokensStorage = TokensDataStore(realm: realm, config: config)
        //        let balanceCoordinator =  TokensBalanceService()
        //        let trustNetwork = TrustNetwork(provider: TrustProviderFactory.makeProvider(), balanceService: balanceCoordinator, account: wallet, config: config)
        //        let balance =  BalanceCoordinator(account: wallet, config: config, storage: tokensStorage)
        //        let transactionsStorage = TransactionsStorage(
        //            realm: realm,
        //            account: wallet
        //        )
        //        let nonceProvider = GetNonceProvider(storage: transactionsStorage)
        //        let session = WalletSession(
        //            account: wallet,
        //            config: config,
        //            balanceCoordinator: balance,
        //            nonceProvider: nonceProvider
        //        )
        //        transactionsStorage.removeTransactions(for: [.failed, .unknown])
        
        //        let transferType: TransferType = .ether(destination: .none)
        //        let transferType: TransferType = .token( TokenObject(contract: "0xe41d2489571d322189246dafa5ebde1f4699f498", name: "0x project", symbol: "ZRX", decimals: 6, value: "30000000", isCustom: true, isDisabled: false))
        
        //        let transferType: TransferType = .token( TokenObject(contract: "0xB8c77482e45F1F44dE1745F52C74426C631bDD52", name: "BNB", symbol: "BNB", decimals: 18, value: "420000000000000000", isCustom: false, isDisabled: false))
        
        //        let transferType: TransferType = .token( TokenObject(contract: "0x14758245C6E5F450e9fBED333F0d9C36AcE3Bc76", name: "0x project", symbol: "ZRX", decimals: 6, value: "3", isCustom: true, isDisabled: false))
        // BNB
        //        TokenObject {
        //            contract = 0xB8c77482e45F1F44dE1745F52C74426C631bDD52;
        //            name = BNB;
        //            symbol = BNB;
        //            decimals = 18;
        //            value = 420000000000000000;
        //            isCustom = 0;
        //            isDisabled = 0;
        //            balance = 0;
        //        }
        
        let token = TokenObject(
            contract: "0x14758245C6E5F450e9fBED333F0d9C36AcE3Bc76",
            name: "YYC",
            coin: .ethereum,
            type: .coin,
            symbol: "YYC", decimals: 18, value: "20", isCustom: false, isDisabled: false)
        
        let transfer: Transfer = {
            let server = token.coin.server
            switch token.type {
            case .coin:
                return Transfer(server: server, type: .ether(token, destination: .none))
            case .ERC20:
                return Transfer(server: server, type: .token(token))
            }
        }()
        
        let data = Data()
//        let testData:String? = "0x1234567890"
//        if let dataString = testData {
//            data = Data(hex: dataString.drop0x)
//        } else {
//            data = Data()
//        }
        let balance = Balance(value: transfer.type.token.valueBigInt)
        let chainState: ChainState = ChainState(server: transfer.server)
        chainState.fetch()
        let viewModel: SendViewModel = SendViewModel(transfer: transfer, config: session.config, chainState: chainState, storage: session.tokensStorage, balance: balance)
        
        let addressString = "0x14758245C6E5F450e9fBED333F0d9C36AcE3Bc76"
        let amountString = "0.001"
        guard let address = EthereumAddress(string: addressString) else {
            return
        }
        let parsedValue: BigInt? = {
            switch transfer.type {
            case .ether, .dapp:
                return EtherNumberFormatter.full.number(from: amountString, units: .ether)
            case .token(let token):
                return EtherNumberFormatter.full.number(from: amountString, decimals: token.decimals)
            }
        }()
        guard let value = parsedValue else {
            return
        }
        let transaction = UnconfirmedTransaction(
            transfer: transfer,
            value: value,
            to: address,
            data: data,
            gasLimit: .none,
            gasPrice: viewModel.gasPrice,
            nonce: .none
        )
        
        switch session.account.type {
        case .privateKey, .hd:
            let first = session.account.accounts.filter { $0.coin == token.coin }.first
            guard let account = first else { return }
            
            let configurator = TransactionConfigurator(
                session: session,
                account: account,
                transaction: transaction,
                server: transfer.server,
                chainState: ChainState(server: transfer.server)
            )
            
            let transaction1 = configurator.signTransaction
            let server = transfer.server
            let sendTransactionCoordinator : SendTransactionCoordinator = SendTransactionCoordinator(session: session, keystore: keystore, confirmType: .signThenSend, server: server)
            sendTransactionCoordinator.send(transaction: transaction1) { result in
                //                guard let `self` = self else { return }
                //                self.didCompleted?(result)
                print(result)
            }
            
        case .address: break
            //nav.displayError(error: InCoordinatorError.onlyWatchAccount)
        }
        
        
        //            let sendTransactionCoordinator : SendTransactionCoordinator = SendTransactionCoordinator(session: session, keystore: keystore, confirmType: .signThenSend)
        
        
        //            break
        //        case (.request(let token), _):
        //            break
        //        case (.send, .address):
        //            // This case should be returning an error inCoordinator. Improve this logic into single piece.
        //            break
        //        }
        
    }
    
    @objc public func delete(address:String,_ deleteComplete : @escaping ((Bool) -> Void)) {
        for walletInfo in self.keystore.wallets {
            if address == walletInfo.currentAccount.address.description {
                self.keystore.delete(wallet: walletInfo) { result in
                    print(result)
                    switch result {
                    case .success(let complete) :
                        print("****ETH_LOG****delete success:\(complete)")
                        deleteComplete(true)
                    case .failure(let error) :
                        print("****ETH_LOG****delete fail:\(error)")
                        deleteComplete(false)
                    }
                    
//                    deleteComplete(true)
                }
                break
            }
        }
    }
    
    @objc public func getAllWalletModel() -> [WalletModel] {
        var modelArr = [WalletModel]()
        for walletInfo in self.keystore.wallets {
            let model = WalletModel()
            model.name = walletInfo.info.name
            model.symbol = walletInfo.coin!.server.symbol
            if !walletInfo.info.balance.isEmpty, let server = walletInfo.coin?.server {
                model.balance = WalletInfo.format(value: shortFormatter.string(from: BigInt(walletInfo.info.balance) ?? BigInt(), decimals: server.decimals), server: server)
            } else {
                model.balance = WalletInfo.format(value: "0.0", server: .main)
            }
            model.address = walletInfo.currentAccount.address.description
            model.isWatch = walletInfo.isWatch
            modelArr.append(model)
        }
        return modelArr
    }
    
    @objc public func isHavaWallet() -> Bool {
        return self.keystore.hasWallets
    }
    
    @objc public func isValidAddress(address:String) -> Bool {
        var valid = false
        if CryptoAddressValidator.isValidAddress(address) {
            valid = true
        }
        return valid
    }
    
    @objc public func getAddress() -> String {
        let walletInfo : WalletInfo = self.keystore.wallets[0]
        return walletInfo.currentAccount.address.description
    }
    
    @objc public func walletIsExist(address:String) -> Bool {
        var isExist : Bool = false
        for walletInfo in self.keystore.wallets {
            if address == walletInfo.currentAccount.address.description {
                isExist = true
            }
        }
        return isExist
    }
    
    @objc public func exportKeystore(address:String,newPassword:String,_ export : @escaping ((String?) -> Void)) {
        for walletInfo in self.keystore.wallets {
            if address == walletInfo.currentAccount.address.description {
                let currentPassword = self.keystore.getPassword(for: walletInfo.currentAccount.wallet!)
                self.keystore.export(account: walletInfo.currentAccount, password: currentPassword ?? newPassword, newPassword: newPassword) { result in
                    switch result {
                    case .success(let value):
                        print("****ETH_LOG****exportKeystore success:\(value)")
                        export(value)
                    case .failure(let error):
                        print("****ETH_LOG****exportKeystore fail:\(error)")
                        export(nil)
                    }
                }
                break
            }
        }
    }
    
    @objc public func exportMnemonic(address:String,_ export : @escaping (([String]?) -> Void)) {
        for walletInfo in self.keystore.wallets {
            if address == walletInfo.currentAccount.address.description {
                self.keystore.exportMnemonic(wallet: walletInfo.currentAccount.wallet!) { result in
                    switch result {
                    case .success(let words):
                        print("****ETH_LOG****exportMnemonic success:\(words)")
                        export(words)
                    case .failure(let error):
                        print("****ETH_LOG****exportMnemonic fail:\(error)")
                        export(nil)
                    }
                }
            }
        }
    }
    
//    @objc public func exportPrivateKeyTest() {
//        for (idx,walletInfo) in self.keystore.wallets.enumerated() {
//            print("\(idx)","*****walletInfo = ",walletInfo)
//            print("\(idx)","*****currentAccount = ",walletInfo.currentAccount)
//            print("\(idx)","*****derivationPath = ",walletInfo.currentAccount.derivationPath)
//            print("\(idx)","*****wallet = ",walletInfo.currentAccount.wallet ?? "")
//            print("\(idx)","*****address = ",walletInfo.currentAccount.address.description)
//            self.keystore.exportPrivateKey(account: walletInfo.currentAccount) { result in
//                switch result {
//                case .success(let privateKey):
//                    print("\(idx)","exportPrivateKey success:\(privateKey.hexString)")
//                    print("\(idx)","*****privateKey = ",privateKey.hexString)
//                case .failure(let error):
//                    print("\(idx)","exportPrivateKey fail:\(error)")
//                }
//            }
//        }
//    }
    
    @objc public func exportPrivateKey(address:String,_ export : @escaping ((String?) -> Void)) {
        for walletInfo in self.keystore.wallets {
            if address == walletInfo.currentAccount.address.description {
                self.keystore.exportPrivateKey(account: walletInfo.currentAccount) { result in
                    switch result {
                    case .success(let privateKey):
                        print("****ETH_LOG****exportPrivateKey success:\(privateKey.hexString)")
                        export(privateKey.hexString)
                    case .failure(let error):
                        print("****ETH_LOG****exportPrivateKey fail:\(error)")
                        export(nil)
                    }
                }
                break
            }
        }
    }
    
    @objc public func exportPublicKey(address:String,_ export : @escaping ((String?) -> Void)) {
        for walletInfo in self.keystore.wallets {
            if address == walletInfo.currentAccount.address.description {
                self.keystore.exportPublicKey(account: walletInfo.currentAccount) { result in
                    switch result {
                    case .success(let publicKey):
                        print("****ETH_LOG****exportPublicKey success:\(publicKey)")
                        export(publicKey.hexString)
                    case .failure(let error):
                        print("****ETH_LOG****exportPublicKey fail:\(error)")
                        export(nil)
                    }
                }
                break
            }
        }
    }
    
    @objc public func switchWallet(address : String) {
        var account : WalletInfo? = nil
        for walletInfo in self.keystore.wallets {
            if address == walletInfo.currentAccount.address.description {
                account = walletInfo
                break
            }
        }
        if account == nil {
            print("****ETH_LOG****ETH切换钱包失败account=nil address=\(address)")
            return
        }
        let migration = MigrationInitializer(account: account!)
        migration.perform()
        
        let sharedMigration = SharedMigrationInitializer()
        sharedMigration.perform()
        
        let realm = self.realm(for: migration.config)
        let sharedRealm = self.realm(for: sharedMigration.config)
        
        let config: Config = .current
        
        let session = WalletSession(
            account: account!,
            realm: realm,
            sharedRealm: sharedRealm,
            config: config
        )
        session.transactionsStorage.removeTransactions(for: [.failed, .unknown])
        
        // Create coins based on supported networks
        let coins = Config.current.servers
        if let wallet = account!.currentWallet, account!.accounts.count < coins.count, account!.mainWallet {
            let derivationPaths = coins.map { $0.derivationPath(at: 0) }
            let _ = self.keystore.addAccount(to: wallet, derivationPaths: derivationPaths)
        }
    
        self.keystore.recentlyUsedWallet = account!
    }
    
    @objc public func signMessage(data:Data,address:String) -> Array<Any>? {
        var useAccount : Account? = nil
        for walletInfo in self.keystore.wallets {
            if address == walletInfo.currentAccount.address.description {
                useAccount = walletInfo.currentAccount
                break
            }
        }
        if useAccount == nil {
            return nil
        }
        let result: Result<Array<Any>, KeystoreError> = keystore.signData(data, account: useAccount!)
//        let result: Result<Data, KeystoreError> = keystore.signMessage(data, for: useAccount!)
        switch result {
        case .success(let data):
            return data
        case .failure( _):
            return nil
        }
    }
    
    private func realm(for config: Realm.Configuration) -> Realm {
        return try! Realm(configuration: config)
    }
    
    
    private func markAsMainWallet(for account: Wallet) {
        let type = WalletType.hd(account)
        let wallet = WalletInfo(type: type, info: keystore.storage.get(for: type))
        markAsMainWallet(for: wallet)
    }
    
    private func markAsMainWallet(for wallet: WalletInfo) {
        let initialName = "R.string.localizable.mainWallet()"
        keystore.store(object: wallet.info, fields: [
            .name(initialName),
            .mainWallet(true),
            ])
    }
    
}
