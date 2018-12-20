//
//  CryptoUtil.swift
//  Qlink
//
//  Created by Jelly Foo on 2018/12/17.
//  Copyright © 2018 pan. All rights reserved.
//

import UIKit
import CryptoSwift
import Neoutils

public class CryptoUtil: NSObject {
    // NEO
    @objc static public func neoutilsign(dataHex:String, privateKey:String) -> String? {
        var error: NSError?
        let data = NeoutilsHexTobytes(dataHex)
        let signatureData = NeoutilsSign(data, privateKey, &error)
        let signatureHex = NeoutilsBytesToHex(signatureData)
        return signatureHex
    }
}
