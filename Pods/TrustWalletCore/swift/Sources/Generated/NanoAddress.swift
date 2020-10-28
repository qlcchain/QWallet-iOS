// Copyright © 2017-2019 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
//
// This is a GENERATED FILE, changes made here WILL BE LOST.
//

import Foundation

public final class NanoAddress: Address {

    public static func == (lhs: NanoAddress, rhs: NanoAddress) -> Bool {
        return TWNanoAddressEqual(lhs.rawValue, rhs.rawValue)
    }

    public static func isValidString(string: String) -> Bool {
        let stringString = TWStringCreateWithNSString(string)
        defer {
            TWStringDelete(stringString)
        }
        return TWNanoAddressIsValidString(stringString)
    }

    public var description: String {
        return TWStringNSString(TWNanoAddressDescription(rawValue))
    }

    public var keyHash: Data {
        return TWDataNSData(TWNanoAddressKeyHash(rawValue))
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
        guard let rawValue = TWNanoAddressCreateWithString(stringString) else {
            return nil
        }
        self.rawValue = rawValue
    }

    public init(publicKey: PublicKey) {
        rawValue = TWNanoAddressCreateWithPublicKey(publicKey.rawValue)
    }

    deinit {
        TWNanoAddressDelete(rawValue)
    }

}
