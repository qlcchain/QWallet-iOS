//
//  Token.swift
//  Qlink
//
//  Created by Jelly Foo on 2019/5/30.
//  Copyright © 2019 pan. All rights reserved.
//

import Foundation
import BigInt
import HandyJSON

public class QLCToken:HandyJSON {
    
    public var tokenId:String?
    
    public var tokenName:String?
    
    public var tokenSymbol:String?
    
    public var totalSupply:BigUInt?
    
    public var decimals:Int?
    
    public var owner:String?
    
    public var pledgeAmount:BigUInt?
    
    public var withdrawTime:Int?
    
    required public init() {}
    
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            totalSupply <-- TransformOf<BigUInt, String>(fromJSON: { (rawString) -> BigUInt? in
                return BigUInt(rawString ?? "0")
            }, toJSON: { (bigUInt) -> String? in
                return String(bigUInt ?? BigUInt(0))
            })
        
        mapper <<<
            pledgeAmount <-- TransformOf<BigUInt, String>(fromJSON: { (rawString) -> BigUInt? in
                return BigUInt(rawString ?? "0")
            }, toJSON: { (bigUInt) -> String? in
                return String(bigUInt ?? BigUInt(0))
            })
    }
    
    public static func getTokenByTokenName(tokenName:String, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) throws {
        LedgerRpc.tokenInfoByName(token: tokenName, successHandler: { (response) in
            if response != nil {
                let dic = response as! Dictionary<String, Any>
                let token = QLCToken.deserialize(from: dic)
                successHandler(token)
            } else {
                successHandler(nil)
            }
        }) { (error, message) in
            failureHandler(error, message)
        }
    }
    
}
