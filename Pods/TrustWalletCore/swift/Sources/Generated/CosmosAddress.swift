// Copyright © 2017-2019 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
//
// This is a GENERATED FILE, changes made here WILL BE LOST.
//

import Foundation

public final class CosmosAddress: Address {

    public static func == (lhs: CosmosAddress, rhs: CosmosAddress) -> Bool {
        return TWCosmosAddressEqual(lhs.rawValue, rhs.rawValue)
    }

    public static func isValidString(string: String) -> Bool {
        let stringString = TWStringCreateWithNSString(string)
        defer {
            TWStringDelete(stringString)
        }
        return TWCosmosAddressIsValidString(stringString)
    }

    public var description: String {
        return TWStringNSString(TWCosmosAddressDescription(rawValue))
    }

    public var hrp: HRP {
        return HRP(rawValue: TWCosmosAddressHRP(rawValue).rawValue)!
    }

    public var keyHash: Data {
        return TWDataNSData(TWCosmosAddressKeyHash(rawValue))
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
        guard let rawValue = TWCosmosAddressCreateWithString(stringString) else {
            return nil
        }
        self.rawValue = rawValue
    }

    public init?(hrp: HRP, keyHash: Data) {
        let keyHashData = TWDataCreateWithNSData(keyHash)
        defer {
            TWDataDelete(keyHashData)
        }
        guard let rawValue = TWCosmosAddressCreateWithKeyHash(TWHRP(rawValue: hrp.rawValue), keyHashData) else {
            return nil
        }
        self.rawValue = rawValue
    }

    public init?(hrp: HRP, publicKey: PublicKey) {
        guard let rawValue = TWCosmosAddressCreateWithPublicKey(TWHRP(rawValue: hrp.rawValue), publicKey.rawValue) else {
            return nil
        }
        self.rawValue = rawValue
    }

    deinit {
        TWCosmosAddressDelete(rawValue)
    }

}
