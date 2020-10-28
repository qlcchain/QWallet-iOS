// Copyright © 2017-2019 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
//
// This is a GENERATED FILE, changes made here WILL BE LOST.
//

import Foundation

public struct X509 {

    public static func encodeED25519PublicKey(publicKey: Data) -> Data? {
        let publicKeyData = TWDataCreateWithNSData(publicKey)
        defer {
            TWDataDelete(publicKeyData)
        }
        guard let result = TWX509EncodeED25519PublicKey(publicKeyData) else {
            return nil
        }
        return TWDataNSData(result)
    }

    public static func decodeED25519PublicKey(data: Data) -> Data? {
        let dataData = TWDataCreateWithNSData(data)
        defer {
            TWDataDelete(dataData)
        }
        guard let result = TWX509DecodeED25519PublicKey(dataData) else {
            return nil
        }
        return TWDataNSData(result)
    }

    var rawValue: TWX509

    init(rawValue: TWX509) {
        self.rawValue = rawValue
    }


}
