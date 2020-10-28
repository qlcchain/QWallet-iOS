// Copyright © 2017-2019 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
//
// This is a GENERATED FILE, changes made here WILL BE LOST.
//

import Foundation

public final class AeternitySigner {

    public static func sign(input: TW_Aeternity_Proto_SigningInput) -> TW_Aeternity_Proto_SigningOutput {
        let inputData = TWDataCreateWithNSData(try! input.serializedData())
        defer {
            TWDataDelete(inputData)
        }
        let resultData = TWDataNSData(TWAeternitySignerSign(inputData))
        return try! TW_Aeternity_Proto_SigningOutput(serializedData: resultData)
    }

    let rawValue: OpaquePointer

    init(rawValue: OpaquePointer) {
        self.rawValue = rawValue
    }


}
