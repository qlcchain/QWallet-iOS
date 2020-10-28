// Copyright © 2017-2019 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
//
// This is a GENERATED FILE, changes made here WILL BE LOST.
//

import Foundation

public final class ZilliqaAddress: Address {

    public static func == (lhs: ZilliqaAddress, rhs: ZilliqaAddress) -> Bool {
        return TWZilliqaAddressEqual(lhs.rawValue, rhs.rawValue)
    }

    public static func isValidString(string: String) -> Bool {
        let stringString = TWStringCreateWithNSString(string)
        defer {
            TWStringDelete(stringString)
        }
        return TWZilliqaAddressIsValidString(stringString)
    }

    public var description: String {
        return TWStringNSString(TWZilliqaAddressDescription(rawValue))
    }

    public var keyHash: String {
        return TWStringNSString(TWZilliqaAddressKeyHash(rawValue))
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
        guard let rawValue = TWZilliqaAddressCreateWithString(stringString) else {
            return nil
        }
        self.rawValue = rawValue
    }

    public init?(keyHash: Data) {
        let keyHashData = TWDataCreateWithNSData(keyHash)
        defer {
            TWDataDelete(keyHashData)
        }
        guard let rawValue = TWZilliqaAddressCreateWithKeyHash(keyHashData) else {
            return nil
        }
        self.rawValue = rawValue
    }

    public init(publicKey: PublicKey) {
        rawValue = TWZilliqaAddressCreateWithPublicKey(publicKey.rawValue)
    }

    deinit {
        TWZilliqaAddressDelete(rawValue)
    }

}
