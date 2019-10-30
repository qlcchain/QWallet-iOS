//
//  ContractState.swift
//  O3
//
//  Created by Andrei Terentiev on 2/14/19.
//  Copyright © 2019 O3 Labs Inc. All rights reserved.
//

import Foundation

public struct ContractState: Codable {
    var version: Int
    var hash: String
    var script: String
    var parameters: [String]
    var returntype: String
    var name: String
    var code_version: String
    var author: String
    var email: String
    var description: String
    var properties: Properties
    
    public struct Properties: Codable {
        var storage: Bool
        var dynamic_invoke: Bool
    }
}
