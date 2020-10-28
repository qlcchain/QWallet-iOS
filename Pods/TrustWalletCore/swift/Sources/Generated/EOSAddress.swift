// Copyright © 2017-2019 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
//
// This is a GENERATED FILE, changes made here WILL BE LOST.
//

import Foundation

public final class EOSAddress: Address {

    public static func == (lhs: EOSAddress, rhs: EOSAddress) -> Bool {
        return TWEOSAddressEqual(lhs.rawValue, rhs.rawValue)
    }

    public static func isValidString(string: String) -> Bool {
        let stringString = TWStringCreateWithNSString(string)
        defer {
            TWStringDelete(stringString)
        }
        return TWEOSAddressIsValidString(stringString)
    }

    public var description: String {
        return TWStringNSString(TWEOSAddressDescription(rawValue))
    }

    let rawValue: OpaquePointer

    init(rawValue: OpaquePointer) {
        self.rawValue = rawValue
    }

    public init?(string: String) {
        let stringString = TWStringCreateWithNSString(string)
        defer {
            TWStringDelete(stringString)
        }
        guard let rawValue = TWEOSAddressCreateWithString(stringString) else {
            return nil
        }
        self.rawValue = rawValue
    }

    public init(publicKey: PublicKey, type: EOSKeyType) {
        rawValue = TWEOSAddressCreateWithPublicKey(publicKey.rawValue, TWEOSKeyType(rawValue: type.rawValue))
    }

    public init?(keyHash: Data, type: EOSKeyType) {
        let keyHashData = TWDataCreateWithNSData(keyHash)
        defer {
            TWDataDelete(keyHashData)
        }
        guard let rawValue = TWEOSAddressCreateWithKeyHash(keyHashData, TWEOSKeyType(rawValue: type.rawValue)) else {
            return nil
        }
        self.rawValue = rawValue
    }

    deinit {
        TWEOSAddressDelete(rawValue)
    }

}
