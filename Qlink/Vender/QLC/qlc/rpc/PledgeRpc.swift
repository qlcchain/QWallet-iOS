//
//  PledgeRpc.swift
//  qlc-ios-sdk
//
//  Created by Jelly Foo on 2019/5/15.
//  Copyright © 2019 Jelly Foo. All rights reserved.
//

import Foundation

public class PledgeRpc {
    /**
     * Return pledge data by pledge parameters ，if there are multiple identical pledge in the query result, it will be returned in time order
     * @param url
     * @param params pledgeParams: pledge parameters
     *               beneficial：beneficial account
     *               amount：amount of pledge
     *               pType：type of pledge
     * @return
     * @throws QlcException
     * @throws IOException
     */
    public static func searchPledgeInfo(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "pledge_searchPledgeInfo", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    
    /**
     * Return all pledge info
     * @param url
     * @param params pledgeParams: no
     * @return
     * @throws QlcException
     * @throws IOException
     */
    public static func pledge_searchAllPledgeInfo(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "pledge_searchAllPledgeInfo", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
}
