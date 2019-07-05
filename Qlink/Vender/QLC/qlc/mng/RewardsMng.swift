//
//  RewardsMng.swift
//  Qlink
//
//  Created by Jelly Foo on 2019/7/4.
//  Copyright © 2019 pan. All rights reserved.
//

import Foundation

public class RewardsMng {
    /**
     *
     * returns airdrop contract reward block by contract send block hash
     * @param client:qlc client
     * @param blockHash send block hash
     * @throws IOException io exception
     * @return StateBlock:contract reward block
     */
    public static func getReceiveRewardBlock(hashHex:String?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) throws {
    
        if (hashHex == nil) {
            failureHandler(nil, nil)
            return
        }
        
        LedgerRpc.rewards_getReceiveRewardBlock(hashHex: hashHex!, successHandler: { (response) in
            let dic : Dictionary<String, Any?> = response as! Dictionary<String, Any?>
            if (dic["result"] != nil) {
                let result:Dictionary<String, Any?> = dic["result"] as! Dictionary<String, Any?>
                let block : QLCStateBlock = QLCStateBlock.deserialize(from: result as [String : Any])!
                successHandler(block)
            }
        }) { (error, message) in
            failureHandler(error, message)
        }
    }
}
