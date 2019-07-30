//
//  Helper.swift
//  qlc-ios-sdk
//
//  Created by Jelly Foo on 2019/5/14.
//  Copyright © 2019 Jelly Foo. All rights reserved.
//

import Foundation

public class Helper {
    
    public static func getSeed() -> String {
        let uuid : String = UUID().uuidString.replacingOccurrences(of: "-", with: "")
//        let data : Data = uuid.data(using: String.Encoding.utf8) ?? ""
        let data = Data(hex: uuid)
        let seed : String = data.toHexString()
        return seed
    }
    
    public static func reverse(v: Bytes) -> Bytes {
        var result = Bytes(count: v.count)
        for (index, _) in v.enumerated() {
            result[index] = v[v.count-index-1];
        }
        return result;
    }
    
}

extension Data {
    public init(hex: String) {
        self.init(bytes: Array<UInt8>(hex: hex))
    }
    public var bytes_qlc: Array<UInt8> {
        return Array(self)
    }
    public func toHexString() -> String {
        return bytes_qlc.toHexString()
    }
}

extension Array {
    public init(reserveCapacity: Int) {
        self = Array<Element>()
        self.reserveCapacity(reserveCapacity)
    }
    
    var slice: ArraySlice<Element> {
        return self[self.startIndex ..< self.endIndex]
    }
}

extension Array where Element == UInt8 {
    public init(hex: String) {
        self.init(reserveCapacity: hex.unicodeScalars.lazy.underestimatedCount)
        var buffer: UInt8?
        var skip = hex.hasPrefix("0x") ? 2 : 0
        for char in hex.unicodeScalars.lazy {
            guard skip == 0 else {
                skip -= 1
                continue
            }
            guard char.value >= 48 && char.value <= 102 else {
                removeAll()
                return
            }
            let v: UInt8
            let c: UInt8 = UInt8(char.value)
            switch c {
            case let c where c <= 57:
                v = c - 48
            case let c where c >= 65 && c <= 70:
                v = c - 55
            case let c where c >= 97:
                v = c - 87
            default:
                removeAll()
                return
            }
            if let b = buffer {
                append(b << 4 | v)
                buffer = nil
            } else {
                buffer = v
            }
        }
        if let b = buffer {
            append(b)
        }
    }
    
    public func toHexString() -> String {
        return `lazy`.reduce("") {
            var s = String($1, radix: 16)
            if s.count == 1 {
                s = "0" + s
            }
            return $0 + s
        }
    }
}


//public typealias Bytes = Array<UInt8>
//
//public extension Bytes {
//    var bytes2Hex: String {
//        var hexResult : String = String()
//        for ten in self {
//            let hex = String(ten,radix:16)
//            hexResult.append(hex)
//        }
//        return hexResult
//    }
//
//    var bytes2Binary: String {
//        var binaryResult : String = String()
//        for ten in self {
//            let binary = String(ten,radix:2)
//            binaryResult.append(binary)
//        }
//        return binaryResult
//    }
//}
//
//extension Array where Element == UInt8 {
//    init (count bytes: Int) {
//        self.init(repeating: 0, count: bytes)
//    }
//}
//
//public extension String {
//    var hex2Bytes: Bytes {
//
//        if self.unicodeScalars.lazy.underestimatedCount % 2 != 0 {
//            return []
//        }
//
//        var bytes = Bytes()
//        bytes.reserveCapacity(self.unicodeScalars.lazy.underestimatedCount / 2)
//
//        var buffer: UInt8?
//        var skip = self.hasPrefix("0x") ? 2 : 0
//        for char in self.unicodeScalars.lazy {
//            guard skip == 0 else {
//                skip -= 1
//                continue
//            }
//            guard char.value >= 48 && char.value <= 102 else {
//                return []
//            }
//            let v: UInt8
//            let c: UInt8 = UInt8(char.value)
//            switch c {
//            case let c where c <= 57:
//                v = c - 48
//            case let c where c >= 65 && c <= 70:
//                v = c - 55
//            case let c where c >= 97:
//                v = c - 87
//            default:
//                return []
//            }
//            if let b = buffer {
//                bytes.append(b << 4 | v)
//                buffer = nil
//            } else {
//                buffer = v
//            }
//        }
//        if let b = buffer {
//            bytes.append(b)
//        }
//
//        return bytes
//    }
//
//    var hex2Binary : String {
//        var resultBinary: String = ""
//        let byte = self.hex2Bytes
//        resultBinary = byte.bytes2Binary
//        return resultBinary
//    }
//}

public extension Dictionary {
    var JSONString : String {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try! JSONSerialization.data(withJSONObject: self, options: []) as NSData?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
}
