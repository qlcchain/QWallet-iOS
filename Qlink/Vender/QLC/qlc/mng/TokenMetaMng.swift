//
//  TokenMetaMng.swift
//  Qlink
//
//  Created by Jelly Foo on 2019/5/30.
//  Copyright © 2019 pan. All rights reserved.
//

import Foundation

public class TokenMetaMng {
    
    // return token meta info by account and token hash
    public static func getTokenMeta(tokenHash:String, address:String, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) throws {
        LedgerRpc.accountInfo(address: address, successHandler: { (response) in
            if response != nil {
                let dic = response as! Dictionary<String, Any>
                let account = QLCAccount.deserialize(from: dic)
                let tokens = account?.tokens
                if (tokens != nil && tokens!.count > 0) {
                    var token : QLCTokenMeta? = nil
                    for item in tokens! {
                        if item.type == tokenHash {
                            token = item
                            break
                        }
                    }
                    successHandler(token)
                } else {
                    successHandler(nil)
                }
            } else {
                successHandler(nil)
            }
        }) { (error, message) in
            failureHandler(error, message)
        }
    }
    
    // return account info by address
    public static func getAccountMeta(address:String, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) throws {
        LedgerRpc.accountInfo(address: address, successHandler: { (response) in
            if response != nil {
                let dic = response as! Dictionary<String, Any>
                let account = QLCAccount.deserialize(from: dic)
                successHandler(account)
            } else {
                successHandler(nil)
            }
        }) { (error, message) in
            failureHandler(error, message)
        }
    }
}
