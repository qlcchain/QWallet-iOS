//
//  QLCPending.swift
//  Qlink
//
//  Created by Jelly Foo on 2019/5/30.
//  Copyright © 2019 pan. All rights reserved.
//

import Foundation
import BigInt
import HandyJSON

public class QLCPendingInfo : HandyJSON {
    
    public var source:String?
    
    public var amount:BigUInt?
    
    public var type:String?
    
    public var tokenName:String?
    
    public var Hash:String?
    
    public var timestamp:Int64?
    
    public var account:String?
    
    required public init() {}
    
    public func mapping(mapper: HelpingMapper) {
        // specify 'cat_id' field in json map to 'id' property in object
        mapper <<<
            self.Hash <-- "hash"
        
        mapper <<<
            amount <-- TransformOf<BigUInt, String>(fromJSON: { (rawString) -> BigUInt? in
                return BigUInt(rawString ?? "0")
            }, toJSON: { (bigUInt) -> String? in
                return String(bigUInt ?? BigUInt(0))
            })
    }
    
}

public class QLCPending : HandyJSON {
    
    public var address:String?
    
    public var infoList:Array<QLCPendingInfo>?
    
    required public init() {}
    
}
