//
//  WalletRpc.swift
//  qlc-ios-sdk
//
//  Created by Jelly Foo on 2019/5/15.
//  Copyright © 2019 Jelly Foo. All rights reserved.
//

import Foundation

public class WalletRpc {
    
    /**
     * Return balance for each token of the wallet
     * @param url
     * @param params string: master address of the wallet
     string: passphrase
     * @return balance of each token in the wallet
     * @throws QlcException
     * @throws IOException
     */
    public static func getBalances(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "wallet_getBalances", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Returns raw key (public key and private key) for a account
     * @param url
     * @param params string: account address
     string: passphrase
     * @return private key and public key for the address
     * @throws QlcException
     * @throws IOException
     */
    public static func getRawKey(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "wallet_getRawKey", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Generate new seed
     * @param url
     * @param params null
     * @return string: hex string for seed
     * @throws QlcException
     * @throws IOException
     */
    public static func newSeed(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "wallet_newSeed", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Create new wallet and Return the master address
     * @param url
     * @param params string: passphrase
     string: optional, hex string for seed, if not set, will create seed randomly
     * @return string : master address of the wallet
     * @throws QlcException
     * @throws IOException
     */
    public static func newWallet(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "wallet_newWallet", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    
    /**
     * Change wallet password
     * @param url
     * @param params string: master address of the wallet
     string: old passphrase
     string: new passphrase
     * @return null
     * @throws QlcException
     * @throws IOException
     */
    public static func changePassword(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "wallet_changePassword", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
}
