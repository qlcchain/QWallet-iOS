// Copyright © 2017-2019 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
//
// This is a GENERATED FILE, changes made here WILL BE LOST.
//

import Foundation

public struct PKCS8 {

    public static func encodeED25519PrivateKey(PrivateKey: Data) -> Data? {
        let PrivateKeyData = TWDataCreateWithNSData(PrivateKey)
        defer {
            TWDataDelete(PrivateKeyData)
        }
        guard let result = TWPKCS8EncodeED25519PrivateKey(PrivateKeyData) else {
            return nil
        }
        return TWDataNSData(result)
    }

    public static func decodeED25519PrivateKey(data: Data) -> Data? {
        let dataData = TWDataCreateWithNSData(data)
        defer {
            TWDataDelete(dataData)
        }
        guard let result = TWPKCS8DecodeED25519PrivateKey(dataData) else {
            return nil
        }
        return TWDataNSData(result)
    }

    var rawValue: TWPKCS8

    init(rawValue: TWPKCS8) {
        self.rawValue = rawValue
    }


}
