//
//  TokenMate.swift
//  Qlink
//
//  Created by Jelly Foo on 2019/5/30.
//  Copyright © 2019 pan. All rights reserved.
//

import Foundation
import BigInt

public class QLCTokenMeta {
    
    public var type:String?                    // token hash
    
    public var header:String?                    // the latest block hash for the token chain
    
    public var representative:String?            // representative address
    
    public var open:String?                    // the open block hash for the token chain
    
    public var balance:BigInt?                // balance for the token
    
    public var account:String?                  // account that token belong to
    
    public var modified:Int?                // timestamp
    
    public var blockCount:Int?                // total block number for the token chain
    
    public var tokenName:String?                // the token name
    
    public var pending:String?                    // pending amount
}
