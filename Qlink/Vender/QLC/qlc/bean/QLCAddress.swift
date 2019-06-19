//
//  QLCAddress.swift
//  Qlink
//
//  Created by Jelly Foo on 2019/5/30.
//  Copyright © 2019 pan. All rights reserved.
//

import Foundation
import HandyJSON

public class QLCAddress : HandyJSON {
    
    public var address:String?
    
    public var publicKey:String?
    
    public var privateKey:String?
    
    required public init() {}
    
    public static func factory(address:String, publicKey:String, privateKey:String) -> QLCAddress {
        let addressM:QLCAddress = QLCAddress()
        addressM.address = address
        addressM.publicKey = publicKey
        addressM.privateKey = privateKey
        
        return addressM
    }
}
