//
//  LedgerMng.swift
//  Qlink
//
//  Created by Jelly Foo on 2019/5/30.
//  Copyright © 2019 pan. All rights reserved.
//

import Foundation

public class LedgerMng {
    
    /**
     *
     * @Description Return block info by block hash
     * @param blockHash:block hash
     * @throws QlcException
     * @throws IOException
     * @return StateBlock
     */
    public static func blocksInfo(blockHash:Bytes, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) throws {
        let hashArr = [blockHash.toHexString()]
        LedgerRpc.blocksInfo(hashArr: hashArr, successHandler: { (response) in
            if response != nil {
                let dic = (response as! Array<Dictionary<String, Any>>)[0]
                let stateBlock = QLCStateBlock.deserialize(from: dic)
                successHandler(stateBlock)
            } else {
                successHandler(nil)
            }
        }) { (error, message) in
            failureHandler(error, message)
        }
    }
    
    /**
     *
     * @Description Return pending info for account
     * @param address:account
     * @throws QlcException
     * @throws IOException
     * @return Pending
     */
    public static func accountsPending(address:String, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) throws {
        
        let addressArr = [address]
        LedgerRpc.accountsPending(addressArr: addressArr, successHandler: { (response) in
            if response != nil {
                let dic: Dictionary<String, Any?> = response as! Dictionary<String, Any?>
                if dic.count <= 0 {
                    failureHandler(nil, nil)
                    return
                }
                let infoArray : Array<Dictionary<String, Any>?>? = (dic[address] as! Array<Dictionary<String, Any>?>)
                if infoArray == nil {
                    failureHandler(nil, nil)
                    return
                }
                let pending = QLCPending()
                pending.address = address
                var infoList = Array<QLCPendingInfo>()
                if infoArray!.count > 0 {
                    var info: QLCPendingInfo?
                    for item in infoArray! {
                        info = QLCPendingInfo.deserialize(from: item)
                        infoList.append(info!)
                        info = nil
                    }
                    pending.infoList = infoList
                }
                
                successHandler(pending)
            } else {
                successHandler(nil)
            }
        }) { (error, message) in
            failureHandler(error, message)
        }
    }
    
    // process
    public static func process(dic:Dictionary<String, Any>, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) throws {
        LedgerRpc.process(dic: dic, successHandler: { (response) in
            if response != nil {
                let result:String = response as! String
                successHandler(result)
            } else {
                successHandler(nil)
            }
        }) { (error, message) in
            failureHandler(error, message)
        }
    }
}
