//
//  WalletManage.swift
//  Qlink
//
//  Created by 旷自辉 on 2018/5/9.
//  Copyright © 2018年 pan. All rights reserved.
//

import UIKit
import Foundation



class WalletManage: NSObject {
    
    var account:Account?
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
    
    //-MARK: 单例:方法3
    static var shareInstance3:WalletManage{
        struct MyStatic {
            static var instance:WalletManage = WalletManage()
        }
        return MyStatic.instance;
    }
    
    /// 创建钱包
    ///
    /// - Returns: 创建钱包是否成功
    func createWallet() -> Bool {
        account = Account()
        if (account != nil) {
            return true;
        }
        return false;
    }
    
    /// 根据privatekey 找回钱包
    ///
    /// - Parameter privatekey: 私钥
    /// - Returns: 钱包
    func getWalletWithPrivatekey(privatekey:String) -> Bool {
        
        if privatekey.count == 52 {
           return self.getWalletWithPrivateWif(wif: privatekey)
        } else {
            account = Account(privateKey:privatekey)
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
    func getWalletWithPrivateWif(wif:String) -> Bool {
        account = Account(wif: wif)
        if (account != nil) {
            return true;
        }
        return false;
    }
    
    
    
    func sendQLCWithAddress(isQLC:Bool, address:String, tokeHash:String, qlc:String , completeBlock:@escaping fucBlock) -> () {
        print(account?.wif as Any);
        
        var decimal = 0
        if isQLC {
            decimal = 8
        }
        
        let amountFormatter = NumberFormatter()
        amountFormatter.minimumFractionDigits = 0
        amountFormatter.maximumFractionDigits = decimal
        amountFormatter.numberStyle = .decimal
        
        let amount = amountFormatter.number(from:(qlc))
        
        if isQLC {
            self.sendNEP5Token(tokenHash: tokeHash, assetName: "Qlink Token", amount: amount!.doubleValue, toAddress: address,completeBlock: completeBlock)
        }
    }
    
    func sendNEP5Token(tokenHash: String, assetName: String, amount: Double, toAddress: String , completeBlock:@escaping fucBlock) {
        
        DispatchQueue.main.async {
          
            self.account?.sendNep5Token(tokenContractHash: tokenHash, amount: amount, toAddress: toAddress, completion: { (completed, _) in
                
                //self.transactionCompleted = completed ?? false
                 //    completeBlock(self.transactionCompleted!)
                completeBlock(completed ?? "")
   
                })
        }
    }
    
    func sendNEOTranQLCWithAddress( address:String, tokeHash:String, qlc:String , completeBlock:@escaping neoTranQlcBlock) -> () {
        print(account?.wif as Any);
        
        let decimal = 0
        let amountFormatter = NumberFormatter()
        amountFormatter.minimumFractionDigits = 0
        amountFormatter.maximumFractionDigits = decimal
        amountFormatter.numberStyle = .decimal
        
        let amount = amountFormatter.number(from:(qlc))
       
        self.sendNativeAsset(asset:AssetId(rawValue: AssetId.neoAssetId.rawValue)!, assetName: "NEO", amount: amount!.doubleValue, toAddress: address,completeBlock: completeBlock)
        
    }
    
    func sendNativeAsset(asset: AssetId, assetName: String, amount: Double, toAddress: String , completeBlock:@escaping neoTranQlcBlock) {
        
        DispatchQueue.main.async {
            self.account?.sendAssetTransaction(asset:asset, amount: amount, toAddress: toAddress, completion: { (completed, _) in
                
                //self.transactionCompleted = completed ?? nil
                completeBlock(completed!)
                
            })
            
        }
    }
   
    
    
    func getWalletAddress() -> String {
        return (WalletManage.shareInstance3.account?.address)!;
    }
    func getWalletWif() -> String {
        return (WalletManage.shareInstance3.account?.wif)!;
    }
    func getWalletPrivateKey() -> String {
        let pkey:Data = (WalletManage.shareInstance3.account?.privateKey)!;
        let privatekeys:[String] = dataToHexStringArrayWithData(data: pkey as NSData)
        var result = ""
        for valueStr in privatekeys {
            result.append(valueStr)
        }
        return result;
    }
    
    func getWalletPublicKey() -> String {
        let pkey:Data = (WalletManage.shareInstance3.account?.publicKey)!;
        let privatekeys:[String] = dataToHexStringArrayWithData(data: pkey as NSData)
        var result = ""
        for valueStr in privatekeys {
            result.append(valueStr)
        }
        return result;
    }
    
    static func configO3Network(isMain: Bool) ->()
    {
        // 设置O3网络
        if isMain {
            UserDefaultsManager.network = .main
        } else {
            UserDefaultsManager.network = .test
        }
      //  UserDefaultsManager.seed = "http://seed2.neo.org:20332" //self.tableNodes[indexPath.row].URL
        UserDefaultsManager.useDefaultSeed = false
    }
    
    // 初始化当前Account 信息   网络切换配置
    func configureAccount(mainNet:Bool) -> () {
        account?.configureWalletInfo(isMain: mainNet)
    }
    

    
    // data 转 stirng[]
    func dataToHexStringArrayWithData(data: NSData) -> [String] {
        
        let byteArray:[Int] = DataToIntWithData(data: data)
        
        var byteStrings: [String] = []
        
        for (_,value) in byteArray.enumerated() {
            
            byteStrings.append(ToHex(tmpid: value))
            
        }
        
        return byteStrings
        
    }
    
    // Data -> 10
    
    func DataToIntWithData(data: NSData) -> [Int] {
        
        var byteArray:[Int] = []
        
        for i in 0..<data.length {
            
            var temp:Int = 0
            
            data.getBytes(&temp, range: NSRange(location: i,length:1 ))
            
            byteArray.append(temp)
            
        }
        
        return byteArray
        
    }
    // 10 -> 16
    
    func ToHex(tmpid: Int) -> String {
        
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
}
