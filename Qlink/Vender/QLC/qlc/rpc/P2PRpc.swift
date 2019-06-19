//
//  P2PRpc.swift
//  qlc-ios-sdk
//
//  Created by Jelly Foo on 2019/5/15.
//  Copyright © 2019 Jelly Foo. All rights reserved.
//

import Foundation

public class P2PRpc {
    /**
     * Return online representative accounts that have voted recently
     * @param url
     * @param params null
     * @return
     * @throws QlcException
     * @throws IOException
     */
    public static func onlineRepresentatives(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "net_onlineRepresentatives", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
}
