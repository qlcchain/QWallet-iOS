// Copyright © 2017-2019 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
//
// This is a GENERATED FILE, changes made here WILL BE LOST.
//

import Foundation

public final class EthereumAbiFunction {

    let rawValue: OpaquePointer

    init(rawValue: OpaquePointer) {
        self.rawValue = rawValue
    }

    public init?(name: String) {
        let nameString = TWStringCreateWithNSString(name)
        defer {
            TWStringDelete(nameString)
        }
        guard let rawValue = TWEthereumAbiFunctionCreateWithString(nameString) else {
            return nil
        }
        self.rawValue = rawValue
    }

    deinit {
        TWEthereumAbiFunctionDelete(rawValue)
    }

    public func getType() -> String {
        return TWStringNSString(TWEthereumAbiFunctionGetType(rawValue))
    }

    public func addParamUInt8(val: UInt8, isOutput: Bool) -> Int32 {
        return TWEthereumAbiFunctionAddParamUInt8(rawValue, val, isOutput)
    }

    public func addParamUInt16(val: UInt16, isOutput: Bool) -> Int32 {
        return TWEthereumAbiFunctionAddParamUInt16(rawValue, val, isOutput)
    }

    public func addParamUInt32(val: UInt32, isOutput: Bool) -> Int32 {
        return TWEthereumAbiFunctionAddParamUInt32(rawValue, val, isOutput)
    }

    public func addParamUInt64(val: UInt64, isOutput: Bool) -> Int32 {
        return TWEthereumAbiFunctionAddParamUInt64(rawValue, val, isOutput)
    }

    public func addParamUInt256(val: Data, isOutput: Bool) -> Int32 {
        let valData = TWDataCreateWithNSData(val)
        defer {
            TWDataDelete(valData)
        }
        return TWEthereumAbiFunctionAddParamUInt256(rawValue, valData, isOutput)
    }

    public func addParamUIntN(bits: Int32, val: Data, isOutput: Bool) -> Int32 {
        let valData = TWDataCreateWithNSData(val)
        defer {
            TWDataDelete(valData)
        }
        return TWEthereumAbiFunctionAddParamUIntN(rawValue, Int32(bits), valData, isOutput)
    }

    public func addParamInt8(val: Int8, isOutput: Bool) -> Int32 {
        return TWEthereumAbiFunctionAddParamInt8(rawValue, val, isOutput)
    }

    public func addParamInt16(val: Int16, isOutput: Bool) -> Int32 {
        return TWEthereumAbiFunctionAddParamInt16(rawValue, val, isOutput)
    }

    public func addParamInt32(val: Int32, isOutput: Bool) -> Int32 {
        return TWEthereumAbiFunctionAddParamInt32(rawValue, val, isOutput)
    }

    public func addParamInt64(val: Int64, isOutput: Bool) -> Int32 {
        return TWEthereumAbiFunctionAddParamInt64(rawValue, val, isOutput)
    }

    public func addParamInt256(val: Data, isOutput: Bool) -> Int32 {
        let valData = TWDataCreateWithNSData(val)
        defer {
            TWDataDelete(valData)
        }
        return TWEthereumAbiFunctionAddParamInt256(rawValue, valData, isOutput)
    }

    public func addParamIntN(bits: Int32, val: Data, isOutput: Bool) -> Int32 {
        let valData = TWDataCreateWithNSData(val)
        defer {
            TWDataDelete(valData)
        }
        return TWEthereumAbiFunctionAddParamIntN(rawValue, Int32(bits), valData, isOutput)
    }

    public func addParamBool(val: Bool, isOutput: Bool) -> Int32 {
        return TWEthereumAbiFunctionAddParamBool(rawValue, val, isOutput)
    }

    public func addParamString(val: String, isOutput: Bool) -> Int32 {
        let valString = TWStringCreateWithNSString(val)
        defer {
            TWStringDelete(valString)
        }
        return TWEthereumAbiFunctionAddParamString(rawValue, valString, isOutput)
    }

    public func addParamAddress(val: Data, isOutput: Bool) -> Int32 {
        let valData = TWDataCreateWithNSData(val)
        defer {
            TWDataDelete(valData)
        }
        return TWEthereumAbiFunctionAddParamAddress(rawValue, valData, isOutput)
    }

    public func addParamBytes(val: Data, isOutput: Bool) -> Int32 {
        let valData = TWDataCreateWithNSData(val)
        defer {
            TWDataDelete(valData)
        }
        return TWEthereumAbiFunctionAddParamBytes(rawValue, valData, isOutput)
    }

    public func addParamBytesFix(count_in: Int, val: Data, isOutput: Bool) -> Int32 {
        let valData = TWDataCreateWithNSData(val)
        defer {
            TWDataDelete(valData)
        }
        return TWEthereumAbiFunctionAddParamBytesFix(rawValue, count_in, valData, isOutput)
    }

    public func addParamArray(isOutput: Bool) -> Int32 {
        return TWEthereumAbiFunctionAddParamArray(rawValue, isOutput)
    }

    public func getParamUInt8(idx: Int32, isOutput: Bool) -> UInt8 {
        return TWEthereumAbiFunctionGetParamUInt8(rawValue, Int32(idx), isOutput)
    }

    public func getParamUInt64(idx: Int32, isOutput: Bool) -> UInt64 {
        return TWEthereumAbiFunctionGetParamUInt64(rawValue, Int32(idx), isOutput)
    }

    public func getParamUInt256(idx: Int32, isOutput: Bool) -> Data {
        return TWDataNSData(TWEthereumAbiFunctionGetParamUInt256(rawValue, Int32(idx), isOutput))
    }

    public func getParamBool(idx: Int32, isOutput: Bool) -> Bool {
        return TWEthereumAbiFunctionGetParamBool(rawValue, Int32(idx), isOutput)
    }

    public func getParamString(idx: Int32, isOutput: Bool) -> String {
        return TWStringNSString(TWEthereumAbiFunctionGetParamString(rawValue, Int32(idx), isOutput))
    }

    public func getParamAddress(idx: Int32, isOutput: Bool) -> Data {
        return TWDataNSData(TWEthereumAbiFunctionGetParamAddress(rawValue, Int32(idx), isOutput))
    }

    public func addInArrayParamUInt8(arrayIdx: Int32, val: UInt8) -> Int32 {
        return TWEthereumAbiFunctionAddInArrayParamUInt8(rawValue, Int32(arrayIdx), val)
    }

    public func addInArrayParamUInt16(arrayIdx: Int32, val: UInt16) -> Int32 {
        return TWEthereumAbiFunctionAddInArrayParamUInt16(rawValue, Int32(arrayIdx), val)
    }

    public func addInArrayParamUInt32(arrayIdx: Int32, val: UInt32) -> Int32 {
        return TWEthereumAbiFunctionAddInArrayParamUInt32(rawValue, Int32(arrayIdx), val)
    }

    public func addInArrayParamUInt64(arrayIdx: Int32, val: UInt64) -> Int32 {
        return TWEthereumAbiFunctionAddInArrayParamUInt64(rawValue, Int32(arrayIdx), val)
    }

    public func addInArrayParamUInt256(arrayIdx: Int32, val: Data) -> Int32 {
        let valData = TWDataCreateWithNSData(val)
        defer {
            TWDataDelete(valData)
        }
        return TWEthereumAbiFunctionAddInArrayParamUInt256(rawValue, Int32(arrayIdx), valData)
    }

    public func addInArrayParamUIntN(arrayIdx: Int32, bits: Int32, val: Data) -> Int32 {
        let valData = TWDataCreateWithNSData(val)
        defer {
            TWDataDelete(valData)
        }
        return TWEthereumAbiFunctionAddInArrayParamUIntN(rawValue, Int32(arrayIdx), Int32(bits), valData)
    }

    public func addInArrayParamInt8(arrayIdx: Int32, val: Int8) -> Int32 {
        return TWEthereumAbiFunctionAddInArrayParamInt8(rawValue, Int32(arrayIdx), val)
    }

    public func addInArrayParamInt16(arrayIdx: Int32, val: Int16) -> Int32 {
        return TWEthereumAbiFunctionAddInArrayParamInt16(rawValue, Int32(arrayIdx), val)
    }

    public func addInArrayParamInt32(arrayIdx: Int32, val: Int32) -> Int32 {
        return TWEthereumAbiFunctionAddInArrayParamInt32(rawValue, Int32(arrayIdx), val)
    }

    public func addInArrayParamInt64(arrayIdx: Int32, val: Int64) -> Int32 {
        return TWEthereumAbiFunctionAddInArrayParamInt64(rawValue, Int32(arrayIdx), val)
    }

    public func addInArrayParamInt256(arrayIdx: Int32, val: Data) -> Int32 {
        let valData = TWDataCreateWithNSData(val)
        defer {
            TWDataDelete(valData)
        }
        return TWEthereumAbiFunctionAddInArrayParamInt256(rawValue, Int32(arrayIdx), valData)
    }

    public func addInArrayParamIntN(arrayIdx: Int32, bits: Int32, val: Data) -> Int32 {
        let valData = TWDataCreateWithNSData(val)
        defer {
            TWDataDelete(valData)
        }
        return TWEthereumAbiFunctionAddInArrayParamIntN(rawValue, Int32(arrayIdx), Int32(bits), valData)
    }

    public func addInArrayParamBool(arrayIdx: Int32, val: Bool) -> Int32 {
        return TWEthereumAbiFunctionAddInArrayParamBool(rawValue, Int32(arrayIdx), val)
    }

    public func addInArrayParamString(arrayIdx: Int32, val: String) -> Int32 {
        let valString = TWStringCreateWithNSString(val)
        defer {
            TWStringDelete(valString)
        }
        return TWEthereumAbiFunctionAddInArrayParamString(rawValue, Int32(arrayIdx), valString)
    }

    public func addInArrayParamAddress(arrayIdx: Int32, val: Data) -> Int32 {
        let valData = TWDataCreateWithNSData(val)
        defer {
            TWDataDelete(valData)
        }
        return TWEthereumAbiFunctionAddInArrayParamAddress(rawValue, Int32(arrayIdx), valData)
    }

    public func addInArrayParamBytes(arrayIdx: Int32, val: Data) -> Int32 {
        let valData = TWDataCreateWithNSData(val)
        defer {
            TWDataDelete(valData)
        }
        return TWEthereumAbiFunctionAddInArrayParamBytes(rawValue, Int32(arrayIdx), valData)
    }

    public func addInArrayParamBytesFix(arrayIdx: Int32, count_in: Int, val: Data) -> Int32 {
        let valData = TWDataCreateWithNSData(val)
        defer {
            TWDataDelete(valData)
        }
        return TWEthereumAbiFunctionAddInArrayParamBytesFix(rawValue, Int32(arrayIdx), count_in, valData)
    }

}
