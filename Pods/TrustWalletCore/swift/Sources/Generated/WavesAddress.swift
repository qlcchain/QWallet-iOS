// Copyright © 2017-2019 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
//
// This is a GENERATED FILE, changes made here WILL BE LOST.
//

import Foundation

public final class WavesAddress: Address {

    public static func == (lhs: WavesAddress, rhs: WavesAddress) -> Bool {
        return TWWavesAddressEqual(lhs.rawValue, rhs.rawValue)
    }

    public static func isValidString(string: String) -> Bool {
        let stringString = TWStringCreateWithNSString(string)
        defer {
            TWStringDelete(stringString)
        }
        return TWWavesAddressIsValidString(stringString)
    }

    public var description: String {
        return TWStringNSString(TWWavesAddressDescription(rawValue))
    }

    public var keyHash: Data {
        return TWDataNSData(TWWavesAddressKeyHash(rawValue))
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
        guard let rawValue = TWWavesAddressCreateWithString(stringString) else {
            return nil
        }
        self.rawValue = rawValue
    }

    public init(publicKey: PublicKey) {
        rawValue = TWWavesAddressCreateWithPublicKey(publicKey.rawValue)
    }

    deinit {
        TWWavesAddressDelete(rawValue)
    }

}
