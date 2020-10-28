// Copyright © 2017-2019 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
//
// This is a GENERATED FILE, changes made here WILL BE LOST.
//

import Foundation

public final class IoTeXAddress: Address {

    public static func == (lhs: IoTeXAddress, rhs: IoTeXAddress) -> Bool {
        return TWIoTeXAddressEqual(lhs.rawValue, rhs.rawValue)
    }

    public static func isValidString(string: String) -> Bool {
        let stringString = TWStringCreateWithNSString(string)
        defer {
            TWStringDelete(stringString)
        }
        return TWIoTeXAddressIsValidString(stringString)
    }

    public var description: String {
        return TWStringNSString(TWIoTeXAddressDescription(rawValue))
    }

    public var keyHash: Data {
        return TWDataNSData(TWIoTeXAddressKeyHash(rawValue))
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
        guard let rawValue = TWIoTeXAddressCreateWithString(stringString) else {
            return nil
        }
        self.rawValue = rawValue
    }

    public init?(keyHash: Data) {
        let keyHashData = TWDataCreateWithNSData(keyHash)
        defer {
            TWDataDelete(keyHashData)
        }
        guard let rawValue = TWIoTeXAddressCreateWithKeyHash(keyHashData) else {
            return nil
        }
        self.rawValue = rawValue
    }

    public init(publicKey: PublicKey) {
        rawValue = TWIoTeXAddressCreateWithPublicKey(publicKey.rawValue)
    }

    deinit {
        TWIoTeXAddressDelete(rawValue)
    }

}
