//
//  UtilRpc.swift
//  qlc-ios-sdk
//
//  Created by Jelly Foo on 2019/5/15.
//  Copyright © 2019 Jelly Foo. All rights reserved.
//

import Foundation

public class UtilRpc {
    
    /**
     * Decrypt the cryptograph string by passphrase
     * @param url
     * @param params string : cryptograph, encoded by base64
     string : passphrase
     * @return
     * @throws QlcException
     * @throws IOException
     */
    public static func decrypt(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "util_decrypt", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Encrypt encrypt raw data by passphrase
     * @param url
     * @param params string : cryptograph, encoded by base64
     string : passphrase
     * @return
     * @throws QlcException
     * @throws IOException
     */
    public static func encrypt(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "util_encrypt", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return balance by specific unit for raw value
     * @param url
     * @param params string: raw value
     string: unit
     string: optional, token name , if not set , default is QLC
     * @return
     * @throws QlcException
     * @throws IOException
     */
    public static func rawToBalance(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "util_rawToBalance", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return raw value for the balance by specific unit
     * @param url
     * @param params string: balance
     string: unit
     string: optional, token name , if not set , default is QLC
     * @return
     * @throws QlcException
     * @throws IOException
     */
    public static func balanceToRaw(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "util_balanceToRaw", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
}
