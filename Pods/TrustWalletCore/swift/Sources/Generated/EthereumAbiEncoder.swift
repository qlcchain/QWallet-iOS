// Copyright © 2017-2019 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
//
// This is a GENERATED FILE, changes made here WILL BE LOST.
//

import Foundation

public final class EthereumAbiEncoder {

    public static func buildFunction(name: String) -> EthereumAbiFunction? {
        let nameString = TWStringCreateWithNSString(name)
        defer {
            TWStringDelete(nameString)
        }
        guard let value = TWEthereumAbiEncoderBuildFunction(nameString) else {
            return nil
        }
        return EthereumAbiFunction(rawValue: value)
    }

    public static func deleteFunction(func_in: EthereumAbiFunction) -> Void {
        return TWEthereumAbiEncoderDeleteFunction(func_in.rawValue)
    }

    public static func encode(func_in: EthereumAbiFunction) -> Data {
        return TWDataNSData(TWEthereumAbiEncoderEncode(func_in.rawValue))
    }

    public static func decodeOutput(func_in: EthereumAbiFunction, encoded: Data) -> Bool {
        let encodedData = TWDataCreateWithNSData(encoded)
        defer {
            TWDataDelete(encodedData)
        }
        return TWEthereumAbiEncoderDecodeOutput(func_in.rawValue, encodedData)
    }

    let rawValue: OpaquePointer

    init(rawValue: OpaquePointer) {
        self.rawValue = rawValue
    }


}
