//
//  SMSRpc.swift
//  qlc-ios-sdk
//
//  Created by Jelly Foo on 2019/5/15.
//  Copyright © 2019 Jelly Foo. All rights reserved.
//

import Foundation

public class SMSRpc {
    /**
     * Return blocks which the sender or receiver of block is the phone number
     * @param url
     * @param params string: phone number
     * @return
     * @throws QlcException
     * @throws IOException
     */
    public static func phoneBlocks(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "sms_phoneBlocks", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return blocks which message field is the hash
     * @param url
     * @param params string: message hash
     * @return
     * @throws QlcException
     * @throws IOException
     */
    public static func messageBlocks(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "sms_messageBlocks", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return hash for message
     * @param url
     * @param params string: message
     * @return
     * @throws QlcException
     * @throws IOException
     */
    public static func messageHash(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "sms_messageHash", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Store message and return message hash
     * @param url
     * @param params string: message
     * @return
     * @throws QlcException
     * @throws IOException
     */
    public static func messageStore(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "sms_messageStore", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
}
