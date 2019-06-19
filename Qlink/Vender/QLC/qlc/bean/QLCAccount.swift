//
//  QLCAccount.swift
//  Qlink
//
//  Created by Jelly Foo on 2019/5/30.
//  Copyright © 2019 pan. All rights reserved.
//

import Foundation
import BigInt
import HandyJSON

public class QLCAccount : HandyJSON {
    
    public var account:String?                            // the account address
    
    public var coinBalance:BigUInt?                    // balance of main token of the account (default is QLC)
    
    public var vote:BigUInt?
    
    public var network:BigUInt?
    
    public var storage:BigUInt?
    
    public var oracle:BigUInt?
    
    public var representative:String?                    // representative address of the account
    
    public var tokens:Array<QLCTokenMeta>?
    
    required public init() {}
    
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            coinBalance <-- TransformOf<BigUInt, String>(fromJSON: { (rawString) -> BigUInt? in
                return BigUInt(rawString ?? "0")
            }, toJSON: { (bigUInt) -> String? in
                return String(bigUInt ?? BigUInt(0))
            })
        
        mapper <<<
            vote <-- TransformOf<BigUInt, String>(fromJSON: { (rawString) -> BigUInt? in
                return BigUInt(rawString ?? "0")
            }, toJSON: { (bigUInt) -> String? in
                return String(bigUInt ?? BigUInt(0))
            })
        
        mapper <<<
            network <-- TransformOf<BigUInt, String>(fromJSON: { (rawString) -> BigUInt? in
                return BigUInt(rawString ?? "0")
            }, toJSON: { (bigUInt) -> String? in
                return String(bigUInt ?? BigUInt(0))
            })
        
        mapper <<<
            storage <-- TransformOf<BigUInt, String>(fromJSON: { (rawString) -> BigUInt? in
                return BigUInt(rawString ?? "0")
            }, toJSON: { (bigUInt) -> String? in
                return String(bigUInt ?? BigUInt(0))
            })
        
        mapper <<<
            oracle <-- TransformOf<BigUInt, String>(fromJSON: { (rawString) -> BigUInt? in
                return BigUInt(rawString ?? "0")
            }, toJSON: { (bigUInt) -> String? in
                return String(bigUInt ?? BigUInt(0))
            })
    }
    
}
