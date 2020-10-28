// Copyright © 2017-2019 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
//
// This is a GENERATED FILE, changes made here WILL BE LOST.
//

import Foundation

public final class NULSAddress: Address {

    public static func == (lhs: NULSAddress, rhs: NULSAddress) -> Bool {
        return TWNULSAddressEqual(lhs.rawValue, rhs.rawValue)
    }

    public static func isValidString(string: String) -> Bool {
        let stringString = TWStringCreateWithNSString(string)
        defer {
            TWStringDelete(stringString)
        }
        return TWNULSAddressIsValidString(stringString)
    }

    public var description: String {
        return TWStringNSString(TWNULSAddressDescription(rawValue))
    }

    public var keyHash: Data {
        return TWDataNSData(TWNULSAddressKeyHash(rawValue))
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
        guard let rawValue = TWNULSAddressCreateWithString(stringString) else {
            return nil
        }
        self.rawValue = rawValue
    }

    public init(publicKey: PublicKey) {
        rawValue = TWNULSAddressCreateWithPublicKey(publicKey.rawValue)
    }

    deinit {
        TWNULSAddressDelete(rawValue)
    }

}
