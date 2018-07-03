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
    private static let KeyService : String = "network.o3.neo.wallet"
   static func isExistWalletPass() -> Bool {
        return isExistKey(keyName: KeychainUtil.WalletPassKey)
    }
    
   static func saveWalletPass(keyValue value:String) -> Bool {
    
        return saveValueToKey(keyName: value, keyValue: KeychainUtil.WalletPassKey)
    }
    
    // 清除指定key
   static func removeKey(keyName key:String) -> Bool {
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
   static func removeAllKey() -> Bool {
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
    
    
   static func isExistKey(keyName key:String) -> Bool {
        
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
    
    static func getKeyValue(keyName key:String) -> String {
        
        let keychain = Keychain(service:KeychainUtil.KeyService)
        do {
            //save pirivate key to keychain
            let keyValue  = try keychain
                .get(key)
            if keyValue == nil {
                return ""
            }
            return keyValue!
        } catch _ {
            return ""
        }
    }
    
    static func getKeyDataValue(keyName key:String) -> Data? {
        
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
    
   static func saveValueToKey(keyName key:String, keyValue value:String) -> Bool {
        
        let keychain = Keychain(service: KeychainUtil.KeyService)
        do {
            //save pirivate key to keychain
            try keychain
                .accessibility(.whenPasscodeSetThisDeviceOnly)
                .set(value, key: key)
        } catch _ {
            return false
        }
        
        return true
    }
    
    static func saveDataKeyAndData(keyName key:String, keyValue value:Data) -> Bool {
        
        let keychain = Keychain(service: KeychainUtil.KeyService)
        do {
            //save pirivate key to keychain
            try keychain
                .accessibility(.whenPasscodeSetThisDeviceOnly)
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
    
}
