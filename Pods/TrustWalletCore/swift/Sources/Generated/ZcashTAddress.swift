// Copyright © 2017-2019 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
//
// This is a GENERATED FILE, changes made here WILL BE LOST.
//

import Foundation

public final class ZcashTAddress: Address {

    public static func == (lhs: ZcashTAddress, rhs: ZcashTAddress) -> Bool {
        return TWZcashTAddressEqual(lhs.rawValue, rhs.rawValue)
    }

    public static func isValid(data: Data) -> Bool {
        let dataData = TWDataCreateWithNSData(data)
        defer {
            TWDataDelete(dataData)
        }
        return TWZcashTAddressIsValid(dataData)
    }

    public static func isValidString(string: String) -> Bool {
        let stringString = TWStringCreateWithNSString(string)
        defer {
            TWStringDelete(stringString)
        }
        return TWZcashTAddressIsValidString(stringString)
    }

    public var description: String {
        return TWStringNSString(TWZcashTAddressDescription(rawValue))
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
        guard let rawValue = TWZcashTAddressCreateWithString(stringString) else {
            return nil
        }
        self.rawValue = rawValue
    }

    public init?(data: Data) {
        let dataData = TWDataCreateWithNSData(data)
        defer {
            TWDataDelete(dataData)
        }
        guard let rawValue = TWZcashTAddressCreateWithData(dataData) else {
            return nil
        }
        self.rawValue = rawValue
    }

    public init?(publicKey: PublicKey, prefix: UInt8) {
        guard let rawValue = TWZcashTAddressCreateWithPublicKey(publicKey.rawValue, prefix) else {
            return nil
        }
        self.rawValue = rawValue
    }

    deinit {
        TWZcashTAddressDelete(rawValue)
    }

}
