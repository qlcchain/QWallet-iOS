//
//  QLCBlock.swift
//  Qlink
//
//  Created by Jelly Foo on 2019/5/30.
//  Copyright © 2019 pan. All rights reserved.
//

import Foundation
import HandyJSON

public class QLCBlock : HandyJSON {
    public enum QLCType {
        case State,Send,Receive,Change,Open,ContractReward,ContractSend,ContractRefund,ContractError,SmartContract,Invalid
        public static func getIndex(type:String) -> Int {
                switch (type.lowercased()) {
                    case "state":
                        return 0
                    case "send":
                        return 1
                    case "receive":
                        return 2
                    case "change":
                        return 3
                    case "open":
                        return 4
                    case "contractreward":
                        return 5
                    case "contractsend":
                        return 6
                    case "contractrefund":
                        return 7
                    case "contracterror":
                        return 8
                    case "smartcontract":
                        return 9
                    default:
                        return 10
            }
        }
    }
    
    required public init() {}
}
