//
//  WalletManage.swift
//  Qlink
//
//  Created by 旷自辉 on 2018/5/9.
//  Copyright © 2018年 pan. All rights reserved.
//

import UIKit
import Foundation
//import NEOFramework
//import NeoSwift

class NEOWalletManage : NSObject {
    //-MARK: 单例:方法3
//    static var shareInstance3 : WalletManage {
//        struct MyStatic {
//            static var instance : WalletManage = WalletManage()
//        }
//        return MyStatic.instance;
//    }
    static let swiftSharedInstance = NEOWalletManage()
    //在oc中这样写才能被调用
    @objc open class func sharedInstance() -> NEOWalletManage
    {
        return NEOWalletManage.swiftSharedInstance
    }
    
    var account:Wallet?
    var transactionCompleted:Bool?
    //定义block
    //typealias fucBlock = (_ flag : Bool) ->()
    typealias fucBlock = (_ hex : String) ->()
    //定义Neo兑换返回block
    typealias neoTranQlcBlock = (_ hex : String) ->()
    //定义QLC交易返回block
    typealias tranQlcBlock = (_ hex : String) ->()
    //创建block变量
    //var blockproerty:fucBlock!
    
    /// 创建钱包
    ///
    /// - Returns: 创建钱包是否成功
    @objc open func createWallet() -> Bool {
        account = Wallet()
        if (account != nil) {
            return true;
        }
        return false;
    }
    
    /// 根据privatekey 找回钱包
    ///
    /// - Parameter privatekey: 私钥
    /// - Returns: 钱包
    @objc open func getWalletWithPrivatekey(privatekey:String) -> Bool {
        
        if privatekey.count == 52 {
           return self.getWalletWithPrivateWif(wif: privatekey)
        } else {
            account = Wallet(privateKey:privatekey)
            if (account != nil) {
                return true;
            }
            return false;
        }
    }
    /// 根据private wif 找回钱包
    ///
    /// - Parameter privatekey: 私钥
    /// - Returns: 钱包
    @objc open func getWalletWithPrivateWif(wif:String) -> Bool {
        account = Wallet(wif: wif)
        if (account != nil) {
            return true;
        }
        return false;
    }
    
    
    
    @objc open func getTXWithAddress(isQLC:Bool, address:String, tokeHash:String, qlc:String , mainNet: Bool, remarkStr: String?, fee: Double, completeBlock:@escaping fucBlock) -> () {
        //print(account?.wif as Any);
        var decimal = 0
        if isQLC {
            decimal = 8
        }
        
        let amountFormatter = NumberFormatter()
        amountFormatter.minimumFractionDigits = 0
        amountFormatter.maximumFractionDigits = decimal
        amountFormatter.numberStyle = .decimal
        
        var amount = amountFormatter.number(from:(qlc))
        if (amount == nil) {
            amount = NSNumber.init(value: 0);
        }
        let amountDouble: Double = (amount?.doubleValue)!
        let assetName = "Qlink Token"
        if isQLC {
//            self.sendNEP5Token(tokenHash: tokeHash, assetName:assetName,amount:amountDouble, toAddress: address,completeBlock: completeBlock)
            self.sendNEP5Token(assetHash: tokeHash, decimals: decimal, assetName: assetName, amount: amountDouble, toAddress: address, mainNet: mainNet, remarkStr: remarkStr, fee: fee, completeBlock: completeBlock)
        }
    }

//    @objc open func sendNEP5Token(tokenHash: String, assetName: String, amount: Double, toAddress: String , completeBlock:@escaping fucBlock) {
//
//        DispatchQueue.main.async {
//            if let bestNode = NEONetworkMonitor.autoSelectBestNode() {
//                UserDefaultsManager.seed = bestNode
//                UserDefaultsManager.useDefaultSeed = false
//            }
//            #if TESTNET
//            UserDefaultsManager.seed = "http://seed2.neo.org:20332"
//            UserDefaultsManager.useDefaultSeed = false
//            UserDefaultsManager.network = .test
//            Authenticated.account?.neoClient = NeoClient(network: .test)
//            #endif
//
//            self.account?.sendNep5Token(tokenContractHash: tokenHash, amount: amount, toAddress: toAddress, completion: { (txHex, error, txId) in
//                completeBlock(txHex ?? "", txId ?? "")
//            })
//        }
//    }
    
    @objc open func sendNEOTranQLCWithAddress( address:String, tokeHash:String, qlc:String, mainNet: Bool, remarkStr: String?, completeBlock:@escaping fucBlock) -> () {
        print(account?.wif as Any)
        
        let decimal = 0
        let amountFormatter = NumberFormatter()
        amountFormatter.minimumFractionDigits = 0
        amountFormatter.maximumFractionDigits = decimal
        amountFormatter.numberStyle = .decimal
        
        let amount = amountFormatter.number(from:(qlc))
       
        self.sendNativeAsset(assetHash:tokeHash, assetId: AssetId(rawValue: AssetId.neoAssetId.rawValue)!, assetName: "NEO", amount: amount!.doubleValue, toAddress: address, mainNet: mainNet, remarkStr: remarkStr, completeBlock: completeBlock);
//        self.sendNativeAsset(asset:AssetId(rawValue: AssetId.neoAssetId.rawValue)!, assetName: "NEO", amount: amount!.doubleValue, toAddress: address,completeBlock: completeBlock)
    }
    
//    func sendNativeAsset(asset: AssetId, assetName: String, amount: Double, toAddress: String , completeBlock:@escaping neoTranQlcBlock) {
//        DispatchQueue.main.async {
//            self.account?.sendAssetTransaction(asset:asset, amount: amount, toAddress: toAddress, completion: { (completed, _) in
//
//                //self.transactionCompleted = completed ?? nil
//                completeBlock(completed!)
//
//            })
//
//        }
//    }
    
    @objc open func getWalletAddress() -> String {
        return (NEOWalletManage.swiftSharedInstance.account?.address)!;
    }
    
    @objc open func getWalletWif() -> String {
        return (NEOWalletManage.swiftSharedInstance.account?.wif)!;
    }
    
    @objc open func getWalletPrivateKey() -> String {
        let pkey:Data = (NEOWalletManage.swiftSharedInstance.account?.privateKey)!;
        let privatekeys:[String] = dataToHexStringArrayWithData(data: pkey as NSData)
        var result = ""
        for valueStr in privatekeys {
            result.append(valueStr)
        }
        return result;
    }
    
    @objc open func getWalletPublicKey() -> String {
        let pkey:Data = (NEOWalletManage.swiftSharedInstance.account?.publicKey)!;
        let privatekeys:[String] = dataToHexStringArrayWithData(data: pkey as NSData)
        var result = ""
        for valueStr in privatekeys {
            result.append(valueStr)
        }
        return result;
    }
    
    @objc open func haveDefaultWallet() -> Bool {
        if account != nil {
            return true
        }
        return false;
    }
    
    @objc static public func configO3Network(isMain: Bool) ->() {
        // 设置O3网络
//        if isMain {
//            UserDefaultsManager.network = .main
//        } else {
//            UserDefaultsManager.network = .test
//        }
        //  UserDefaultsManager.seed = "http://seed2.neo.org:20332" //self.tableNodes[indexPath.row].URL
        UserDefaultsManager.useDefaultSeed = false
    }
    
    // 初始化当前Account 信息   网络切换配置
    @objc open func configureAccount(mainNet:Bool) -> Bool {
//        return account?.configureWalletNetwork(mianNet: mainNet) ?? false
        return true
    }
    
    @objc open func validateNEOAddress(address:String) -> Bool {
        var validate : Bool = false
        validate = NEOValidator.validateNEOAddress(address)
        return validate
    }

    
    // data 转 stirng[]
    @objc open func dataToHexStringArrayWithData(data: NSData) -> [String] {
        
        let byteArray:[Int] = DataToIntWithData(data: data)
        
        var byteStrings: [String] = []
        
        for (_,value) in byteArray.enumerated() {
            
            byteStrings.append(ToHex(tmpid: value))
            
        }
        
        return byteStrings
        
    }
    
    // Data -> 10
    
    @objc open func DataToIntWithData(data: NSData) -> [Int] {
        
        var byteArray:[Int] = []
        
        for i in 0..<data.length {
            
            var temp:Int = 0
            
            data.getBytes(&temp, range: NSRange(location: i,length:1 ))
            
            byteArray.append(temp)
            
        }
        
        return byteArray
        
    }
    // 10 -> 16
    
    @objc open func ToHex(tmpid: Int) -> String {
        
        let leftInt: Int  = tmpid / 16
        
        let rightInt: Int = tmpid % 16
        
        var leftIndex: String = ""
        
        var rightIndex: String = ""
        
        let numberArray = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"]
        
        for i in 0..<numberArray.count {
            
            if i == leftInt {
                
                leftIndex = numberArray[i]
                
            }
            
            if i == rightInt {
                
                rightIndex = numberArray[i]
                
            }
            
        }
        
        return "\(leftIndex)\(rightIndex)"
        
    }
    
    // New Interface
    
    func sendNEP5Token(assetHash: String, decimals: Int, assetName: String, amount: Double, toAddress: String, mainNet: Bool, remarkStr: String?, fee: Double, completeBlock:@escaping fucBlock) {
        
        DispatchQueue.main.async {
            let network = Network.main
            var node = AppState.bestSeedNodeURL
            if let bestNode = NEONetworkMonitor.autoSelectBestNode(network: network) {
                node = bestNode
                UserDefaultsManager.seed = node
                UserDefaultsManager.useDefaultSeed = false
                AppState.bestSeedNodeURL = bestNode
            }
//            if let bestNode = NEONetworkMonitor.autoSelectBestNode() {
//                UserDefaultsManager.seed = node
//                UserDefaultsManager.useDefaultSeed = false
//            }
            #if TESTNET
            UserDefaultsManager.seed = "http://seed2.neo.org:20332"
            UserDefaultsManager.useDefaultSeed = false
            UserDefaultsManager.network = .test
            Authenticated.account?.neoClient = NeoClient(network: .test)
            #endif
        
            self.account?.sendNep5Token(tokenContractHash: assetHash, amount: amount, toAddress: toAddress, mainNet: mainNet, remarkStr: remarkStr, decimals: decimals, fee: fee, network: network, completion: { (txHex, error) in
                print("--------neo tx error:" + "\(String(describing: error))")
                if txHex != nil {
                    print(txHex!)
                }
                completeBlock(txHex ?? "")
            })
        }
    }
    
    func sendNativeAsset(assetHash: String, assetId: AssetId, assetName: String, amount: Double, toAddress: String, mainNet: Bool, remarkStr: String?, completeBlock:@escaping fucBlock) {
        DispatchQueue.main.async {
            let network = Network.main
            var node = AppState.bestSeedNodeURL
            if let bestNode = NEONetworkMonitor.autoSelectBestNode(network: network) {
                node = bestNode
                UserDefaultsManager.seed = node
                UserDefaultsManager.useDefaultSeed = false
                AppState.bestSeedNodeURL = bestNode
            }
//            if let bestNode = NEONetworkMonitor.autoSelectBestNode() {
//                UserDefaultsManager.seed = bestNode
//                UserDefaultsManager.useDefaultSeed = false
//            }
            #if TESTNET
            UserDefaultsManager.seed = "http://seed2.neo.org:20332"
            UserDefaultsManager.useDefaultSeed = false
            UserDefaultsManager.network = .test
            Authenticated.account?.neoClient = NeoClient(network: .test)
            #endif
            
            self.account?.sendAssetTransaction(assetHash: assetHash, asset: assetId, amount: amount, toAddress: toAddress, mainNet: mainNet, remarkStr: remarkStr, network: network, completion: { (txHex, error) in
                print("--------neo tx error:" + "\(String(describing: error))")
                if txHex != nil {
                    print(txHex!)
                }
                completeBlock(txHex ?? "")
            })
        }
    }
    
    @objc open func getNEOTX(assetHash: String, decimals: Int, assetName: String, amount: String, toAddress: String, assetType: Int, mainNet: Bool, remarkStr: String?, fee: Double, completeBlock:@escaping fucBlock) {
        
//        let assetId: String! = self.selectedAsset!.assetID!
//        let assetName: String! = self.selectedAsset?.name!
        let amountFormatter = NumberFormatter()
        amountFormatter.minimumFractionDigits = 0
//        amountFormatter.maximumFractionDigits = self.selectedAsset!.decimal
        amountFormatter.maximumFractionDigits = decimals
        amountFormatter.numberStyle = .decimal
        
        var amount = amountFormatter.number(from:(amount))
        if (amount == nil) {
            amount = NSNumber.init(value: 0);
        }
        let amountDouble: Double = (amount?.doubleValue)!
        
        if assetType == 0 { // NEO\GAS
            var assetId = AssetId(rawValue: AssetId.neoAssetId.rawValue)!
            if assetName == "GAS" {
                assetId = AssetId(rawValue: AssetId.gasAssetId.rawValue)!
            }
            self.sendNativeAsset(assetHash: assetHash, assetId: assetId, assetName: assetName, amount: amountDouble, toAddress: toAddress, mainNet: mainNet, remarkStr: remarkStr) { txHex in
                completeBlock(txHex)
            }
        } else if assetType == 1 { // token
            self.sendNEP5Token(assetHash: assetHash, decimals: decimals, assetName: assetName, amount: amountDouble, toAddress: toAddress, mainNet: mainNet, remarkStr: remarkStr, fee: fee) { txHex in
                completeBlock(txHex)
            }
        }
    }
}
