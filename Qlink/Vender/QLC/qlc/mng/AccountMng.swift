//
//  AccountMng.swift
//  qlc-ios-sdk
//
//  Created by Jelly Foo on 2019/5/14.
//  Copyright © 2019 Jelly Foo. All rights reserved.
//

import Foundation
//import TrezorCryptoEd25519WithBlake2b
//import TrezorCrypto

public final class AccountMng {
    
    public static let privateKeyLength = 64
    public static let publicKeyLength = 64
//    public static let signatureLength = 64
    
    public static var ACCOUNT_ALPHABET : Array = "13456789abcdefghijkmnopqrstuwxyz".map ({ String($0) })
    
    public static var NUMBER_CHAR_MAP = Dictionary<String, String>()
    
    public static var CHAR_NUMBER_MAP = Dictionary<String, String>()
    
    // init the NUMBER_CHAR_MAP and CHAR_NUMBER_MAP
//    private static func intMap() {
//        for i in 0..<ACCOUNT_ALPHABET.count {
//            var num : String = String(i, radix:2) // 十进制转二进制
//            while (num.count < 5) { // Not enough 5 digits, add 0
//                num = "0" + num
//            }
//            NUMBER_CHAR_MAP.updateValue(ACCOUNT_ALPHABET[i], forKey: num)
//            CHAR_NUMBER_MAP.updateValue(num, forKey: ACCOUNT_ALPHABET[i])
//        }
//    }
 
    
}





