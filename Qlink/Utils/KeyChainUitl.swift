//
//  KeyChainUitl.swift
//  Qlink
//
//  Created by 旷自辉 on 2018/4/3.
//  Copyright © 2018年 pan. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainUtil: NSObject {
    
    // 获取和存储密码
    private static let WalletPassKey : String = "walletPassKey"
    private static let OldKeyService : String = "network.o3.neo.wallet"
    private static let KeyService : String = "com.qlink.winq.keyservice"
    
   @objc public static func isExistWalletPass() -> Bool {
        return isExistKey(keyName: KeychainUtil.WalletPassKey)
    }
    
   @objc public static func saveWalletPass(keyValue value:String) -> Bool {
    
        return saveValueToKey(keyName: value, keyValue: KeychainUtil.WalletPassKey)
    }
    
    // 清除指定key
    @objc public static func removeKey(keyName key:String) -> Bool {
        let keychain = Keychain(service:KeychainUtil.KeyService)
        do {
            //save pirivate key to keychain
            try keychain
                 .remove(key)
        } catch _ {
            return false
        }
        
        return true
    }
    
    // 清除所有key
   @objc public static func removeAllKey() -> Bool {
        let keychain = Keychain(service:KeychainUtil.KeyService)
        do {
            //save pirivate key to keychain
            try keychain
                .removeAll()
        } catch _ {
            return false
        }
        
        return true
    }
    
    
   @objc public static func isExistKey(keyName key:String) -> Bool {
        
        let keychain = Keychain(service:KeychainUtil.KeyService)
        do {
            //save pirivate key to keychain
            let keyValue : String = try keychain
                .get(key)!
            if keyValue.isEmpty {
                return false
            }
        } catch _ {
            return false
        }
        
        return true
        
    }
    
    @objc public static func getKeyValue(keyName key:String) -> String {
        
        let keychain = Keychain(service:KeychainUtil.KeyService)
        do {
            //save pirivate key to keychain
            let keyValue  = try keychain
                .getString(key)
            if keyValue == nil {
                return ""
            }
            return keyValue!
        } catch _ {
            return ""
        }
    }
    
    @objc public static func getKeyDataValue(keyName key:String) -> Data? {
        
        let keychain = Keychain(service:KeychainUtil.KeyService)
        do {
            //save pirivate key to keychain
            let keyValue :Data? = (try keychain
                .getData(key))
            return keyValue
        } catch _ {
            return nil
        }
    }
    
   @objc public static func saveValueToKey(keyName key:String, keyValue value:String) -> Bool {
        
        let keychain = Keychain(service: KeychainUtil.KeyService)
        do {
            //save pirivate key to keychain
            try keychain
                .accessibility(.whenUnlockedThisDeviceOnly)
                .set(value, key: key)
        } catch _ {
            return false
        }
        
        return true
    }
    
    @objc public static func saveDataKeyAndData(keyName key:String, keyValue value:Data) -> Bool {
        
        let keychain = Keychain(service: KeychainUtil.KeyService)
        do {
            //save pirivate key to keychain
            try keychain
                .accessibility(.whenUnlockedThisDeviceOnly)
                .set(value, key: key)
        } catch _ {
            return false
        }
        return true
    }
    
    // 获取和存储密码
    private static let WalletPrivateKey : String = "walletPrivateKey"
    static func isExistWalletPrivate() -> Bool {
        return isExistKey(keyName: KeychainUtil.WalletPrivateKey)
    }
    
    static func saveWalletPrivate(keyValue value:String) -> Bool {
        return saveValueToKey(keyName: value, keyValue: KeychainUtil.WalletPrivateKey)
    }
    
    // 将旧的KeyService替换掉
    @objc static public func resetKeyService() {
        let oldKeychain = Keychain(service:KeychainUtil.OldKeyService)
        for (_, oldKey) in oldKeychain.allKeys().enumerated() {
            do {
                print("keychain: key=",oldKey)
                let keyValueString = try oldKeychain
                    .getString(oldKey)
                if keyValueString != nil {
                    print("keychain: 存在字符串 Value=",keyValueString!)
                    let success = self.saveValueToKey(keyName: oldKey, keyValue: keyValueString!)
                    if success {
                        print("保存string成功")
                    } else {
                        print("保存string失败")
                    }
                }
            } catch _ {
                do {
                    let keyValueData = try oldKeychain.getData(oldKey)
                    if keyValueData != nil {
                        print("keychain: 存在Data Value=",keyValueData!)
                        let success = self.saveDataKeyAndData(keyName: oldKey, keyValue: keyValueData!)
                        if success {
                            print("保存data成功")
                        } else {
                            print("保存data失败")
                        }
                    }
                } catch _ {
                }
            }
        }
        
        // 移除所有old
        do {
            try oldKeychain.removeAll()
        } catch _ {
        }
    }
    
    @objc static public func showKeyChain(keyservice:String) {
        let keychain = Keychain(service:keyservice)
        for (_, key) in keychain.allKeys().enumerated() {
            do {
                print("keychain: key=",key)
                let keyValueString = try keychain
                    .getString(key)
                if keyValueString != nil {
                    print("keychain: 存在字符串 Value=",keyValueString!)
                }
            } catch _ {
            }
        }
    }
}
