//
//  TokenMateRpc.swift
//  qlc-ios-sdk
//
//  Created by Jelly Foo on 2019/5/15.
//  Copyright © 2019 Jelly Foo. All rights reserved.
//

import Foundation

public class TokenMateRpc {
    
    /*
    // return tokenmeta info by account and token hash
    public static TokenMate getTokenMate(String tokenHash, String address) {
    JSONArray params = new JSONArray();
    params.add(address);
    
    QlcClient client = new QlcClient(Constants.URL);
    JSONObject json = client.call("ledger_accountInfo", params: params, successHandler: successHandler, failureHandler: failureHandler)
    if (json.containsKey("result")) {
    
    json = json.getJSONObject("result");
    
    Account bean = new Gson().fromJson(json.toJSONString(), Account.class);
    List<TokenMate> tokens = bean.getTokens();
    if (tokens!=null && tokens.size()>0) {
    TokenMate token = null;
    for (int i=0; i<tokens.size(); i++) {
    token = tokens.get(i);
    if (token.getType().equals(tokenHash))
    return token;
    
    token = null;
    }
    }
    }
    
    return null;
    }
 */
    
}
