//
//  QLCStateBlock.swift
//  Qlink
//
//  Created by Jelly Foo on 2019/5/30.
//  Copyright © 2019 pan. All rights reserved.
//

import Foundation
import BigInt
import HandyJSON

public class QLCStateBlock : HandyJSON {
    
    public var type:String?
    
    public var token:String?
    
    public var address:String?
    
    public var balance:BigUInt?
    
    public var vote:BigUInt?
    
    public var network:BigUInt?
    
    public var storage:BigUInt?
    
    public var oracle:BigUInt?
    
    public var previous:String?
    
    public var link:String?
    
    public var sender:String?
    
    public var receiver:String?
    
    public var message:String?
    
    public var data:String?
    
    public var povHeight:Int64?
    
    public var quota:Int?
    
    public var timestamp:Int64?
    
    public var extra:String?
    
    public var representative:String?
    
    public var work:String?
    
    public var signature:String?
    
    public var tokenName:String?
    
    public var amount:BigUInt?
    
    public var hash:String?
    
    required public init() {}
    
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            balance <-- TransformOf<BigUInt, String>(fromJSON: { (rawString) -> BigUInt? in
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
        
        mapper <<<
            amount <-- TransformOf<BigUInt, String>(fromJSON: { (rawString) -> BigUInt? in
                return BigUInt(rawString ?? "0")
            }, toJSON: { (bigUInt) -> String? in
                return String(bigUInt ?? BigUInt(0))
            })
    }
    
    public static func factory(type:String, token:String,address:String,balance:BigUInt,previous:String,link:String,timestamp:Int64,representative:String) -> QLCStateBlock {
        let stateB:QLCStateBlock = QLCStateBlock()
        stateB.type = type
        stateB.token = token
        stateB.address = address
        stateB.balance = balance
        stateB.previous = previous
        stateB.link = link
        stateB.timestamp = timestamp
        stateB.representative = representative
        
        return stateB
    }
}
