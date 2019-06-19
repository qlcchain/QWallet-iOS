//
//  Blake2.swift
//  libEd25519Blake2b
//
//  Created by Stone on 2018/9/4.
//

import Foundation
import TrezorCrytoEd25519

public struct Blake2b {

    public static func hash(outLength: Int, in: Bytes, key: Bytes? = nil) -> Bytes? {
        var out = Bytes(count: outLength)
        if let key = key {
            blake2b_Key_qlc(`in`, UInt32(`in`.count), key, key.count, &out, outLength)
        } else {
            blake2b_qlc(`in`, UInt32(`in`.count), &out, outLength)
        }
        return out
    }
}
