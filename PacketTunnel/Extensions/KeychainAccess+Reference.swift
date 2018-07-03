//
//  KeychainAccess+Reference.swift
//  PacketTunnel
//
//  Created by 周荣水 on 2017/12/6.
//  Copyright © 2017年 周荣水. All rights reserved.
//

import Foundation
import KeychainAccess

extension Keychain {
    
    public func get(ref: Data) throws -> String? {
        guard let data = try getData(ref: ref) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    public func getData(ref: Data) throws -> Data? {
        let query: [String: Any] = [
        
            String(kSecClass): itemClass.rawValue,
            String(kSecReturnData): kCFBooleanTrue,
            String(kSecValuePersistentRef): ref as CFData
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        switch status {
        case errSecSuccess:
            guard let data = result as? Data else {
                throw Status.unexpectedError
            }
            return data
        case errSecItemNotFound:
            return nil
        default:
            throw Status(status: status)
        }
    }
}
