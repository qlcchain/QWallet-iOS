// Copyright © 2017-2019 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
//
// This is a GENERATED FILE, changes made here WILL BE LOST.
//

import Foundation

public final class EOSSigner {

    public static func sign(input: TW_EOS_Proto_SigningInput) -> TW_Proto_Result {
        let inputData = TWDataCreateWithNSData(try! input.serializedData())
        defer {
            TWDataDelete(inputData)
        }
        let resultData = TWDataNSData(TWEOSSignerSign(inputData))
        return try! TW_Proto_Result(serializedData: resultData)
    }

    let rawValue: OpaquePointer

    init(rawValue: OpaquePointer) {
        self.rawValue = rawValue
    }


}
