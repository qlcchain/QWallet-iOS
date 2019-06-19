//
//  TokenMate.swift
//  Qlink
//
//  Created by Jelly Foo on 2019/5/30.
//  Copyright © 2019 pan. All rights reserved.
//

import Foundation
import BigInt
import HandyJSON

public class QLCTokenMeta : HandyJSON {
    
    public var type:String?                    // token hash
    
    public var header:String?                    // the latest block hash for the token chain
    
    public var representative:String?            // representative address
    
    public var open:String?                    // the open block hash for the token chain
    
    public var balance:BigUInt?                // balance for the token
    
    public var account:String?                  // account that token belong to
    
    public var modified:Int?                // timestamp
    
    public var blockCount:Int?                // total block number for the token chain
    
    public var tokenName:String?                // the token name
    
    public var pending:String?                    // pending amount
    
    required public init() {}
    
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            balance <-- TransformOf<BigUInt, String>(fromJSON: { (rawString) -> BigUInt? in
                return BigUInt(rawString ?? "0")
            }, toJSON: { (bigUInt) -> String? in
                return String(bigUInt ?? BigUInt(0))
            })
    }
    
}
