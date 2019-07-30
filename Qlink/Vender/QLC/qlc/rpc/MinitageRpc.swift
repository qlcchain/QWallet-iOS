//
//  MinitageRpc.swift
//  qlc-ios-sdk
//
//  Created by Jelly Foo on 2019/5/15.
//  Copyright © 2019 Jelly Foo. All rights reserved.
//

import Foundation

public class MinitageRpc {
    
    /**
     * Return mintage data by mintage parameters
     * @param url
     * @param params mintageParams: mintage parameters
     * @return
     * @throws QlcException
     * @throws IOException
     */
    public static func getMintageData(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "mintage_getMintageData", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return contract send block by mintage parameters
     * @param url
     * @param params mintageParams: mintage parameters
     * @return
     * @throws QlcException
     * @throws IOException
     */
    public static func getMintageBlock(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "mintage_getMintageBlock", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return contract reward block by contract send block
     * @param url
     * @param params block: contract send block
     * @return
     * @throws QlcException
     * @throws IOException
     */
    public static func getRewardBlock(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "mintage_getRewardBlock", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
}
