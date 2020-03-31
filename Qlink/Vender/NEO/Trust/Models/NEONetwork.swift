//
//  NEONetwork.swift
//  NeoSwift
//
//  Created by Apisit Toompakdee on 10/21/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

struct Nodes: Codable {
    let neo: ChainNetwork
    let ontology: ChainNetwork

    enum CodingKeys: String, CodingKey {
        case neo
        case ontology
    }
}

struct ChainNetwork: Codable {
    let blockCount: Int
    let best: String
    let nodes: [String]

    enum CodingKeys: String, CodingKey {
        case blockCount
        case best
        case nodes
    }
}
