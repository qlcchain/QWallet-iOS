//
//  LedgerRpc.swift
//  qlc-ios-sdk
//
//  Created by Jelly Foo on 2019/5/15.
//  Copyright © 2019 Jelly Foo. All rights reserved.
//

import Foundation
import APIKit

public class QLCLedgerRpc : NSObject {
    /**
     * Return number of blocks for a specific account
     * @param url
     * @param params string : the account address
     * @return
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func accountBlocksCount(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_accountBlocksCount", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return blocks for the account, include each token of the account and order of blocks is forward from the last one
     * @param url
     * @param params string : the account address, int: number of blocks to return, int: optional , offset, index of block where to start, default is 0
     * @return
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  accountHistoryTopn(address : String,baseUrl:String, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let request = AccountHistoryTopn(
            address: address
        )
        let client : QlcClient = QlcClient()
        client.call(request,baseUrl:baseUrl, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return account detail info, include each token in the account
     * @param url
     * @param params string : the account address
     * @return
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  accountInfo(address : String,baseUrl:String, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let request = AccountInfo(
            address: address
        )
        let client : QlcClient = QlcClient()
        client.call(request,baseUrl:baseUrl, successHandler: successHandler, failureHandler: failureHandler)
        
    }
    
    /**
     * Return the representative address for account
     * @param url
     * @param params string : the account address
     * @return
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  accountRepresentative(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_accountRepresentative", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return the vote weight for account
     * @param url
     * @param params string :  the vote weight for the account (if account not found, return error)
     * @return
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  accountVotingWeight(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_accountVotingWeight", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    
    /**
     * Return account list of chain
     * @param url
     * @param params int: number of accounts to return
     int: optional , offset, index of account where to start, default is 0
     * @return []address: addresses list of accounts
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  accounts(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_accounts", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Returns balance and pending (amount that has not yet been received) for each account
     * @param url
     * @param params []string: addresses list
     * @return balance and pending amount of each token for each account
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  accountsBalance(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_accountsBalance", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return pairs of token name and block hash (representing the head block ) of each token for each account
     * @param url
     * @param params []string: addresses list
     * @return token name and block hash for each account
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  accountsFrontiers(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_accountsFrontiers", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return pending info for accounts
     * @param url
     * @param params []string: addresses list for accounts
     int: get the maximum number of pending for each account, if set -1, return all pending
     * @return pending info for each token of each account, means:
     tokenName : token name
     type : token type
     source : sender account of transaction
     amount : amount of transaction
     hash : hash of send block
     timestamp: timestamp
     * @throws QlcException
     * @throws IOException
     */
//    @objc public static func  accountsPending(addressArr: Array<String>, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
    @objc public static func  accountsPending(addressArr: Array<String>,baseUrl:String, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let request = AccountsPending(
            addressArr: addressArr
//            address: address
        )
        let client : QlcClient = QlcClient()
        client.call(request,baseUrl:baseUrl, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return total number of accounts of chain
     * @param url
     * @param params
     * @return: total number of accounts
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  accountsCount(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_accountsCount", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return the account that the block belong to
     * @param url
     * @param params string: block hash
     * @return: string: the account address (if block not found, return error)
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  blockAccount(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_blockAccount", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    
    /**
     * Return hash for the block
     * @param url
     * @param params block: block info
     * @return: string: block hash
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  blockHash(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_blockHash", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    
    /**
     * Return blocks list of chain
     * @param url
     * @param params int: number of blocks to return
     int: optional, offset, index of block where to start, default is 0
     * @return: []block: blocks list
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  blocks(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_blocks", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return the number of blocks (include smartcontrant block) and unchecked blocks of chain
     * @param url
     * @param params int: number of blocks to return
     int: optional, offset, index of block where to start, default is 0
     * @return: number of blocks, means:
     count: int, number of blocks , include smartcontrant block
     unchecked: int, number of unchecked blocks
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  blocksCount(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_blocksCount", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Report number of blocks by type of chain
     * @param url
     * @param params
     * @return: number of blocks for each type
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  blocksCountByType(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_blocksCountByType", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return blocks info for blocks hash
     * @param url
     * @param params []string: blocks hash
     * @return: []block: blocks info
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  blocksInfo(hashArr : Array<String>,baseUrl:String, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let request = BlocksInfo(
            hashArr: hashArr
        )
        let client : QlcClient = QlcClient()
        client.call(request,baseUrl:baseUrl, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    
    /**
     * Accept a specific block hash and return a consecutive blocks hash list， starting with this block, and traverse forward to the maximum number
     * @param url
     * @param params string : block hash to start at
     int: get the maximum number of blocks, if set n to -1, will list blocks to open block
     * @return: []string: block hash list (if block not found, return error)
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  chain(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_chain", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return a list of pairs of delegator and it's balance for a specific representative account
     * @param url
     * @param params string: representative account address
     * @return: each delegator and it's balance
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  delegators(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_delegators", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return number of delegators for a specific representative account
     * @param url
     * @param params string: representative account address
     * @return: int: number of delegators for the account
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  delegatorsCount(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_delegatorsCount", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return send block by send parameter and private key
     * @param url
     * @param params send parameter for the block
     from: send address for the transaction
     to: receive address for the transaction
     tokenName: token name
     amount: transaction amount
     sender: optional, sms sender
     receiver: optional, sms receiver
     message: optional, sms message hash
     string: private key
     * @return: block: send block
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  generateSendBlock(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_generateSendBlock", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return receive block by send block and private key
     * @param url
     * @param params block: send block
     string: private key
     * @return: block: receive block
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  generateReceiveBlock(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_generateReceiveBlock", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    
    /**
     * Return change block by account and private key
     * @param url
     * @param params string: account address
     string: new representative account
     string: private key
     * @return: block: change block
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  generateChangeBlock(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_generateChangeBlock", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Check block base info, update chain info for the block, and broadcast block
     * @param url
     * @param params block: block
     * @return: string: hash of the block
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  process(dic : Dictionary<String, Any>,baseUrl:String, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let request = Process(
            dic: dic
        )
        let client : QlcClient = QlcClient()
        client.call(request,baseUrl:baseUrl, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return pairs of representative and its voting weight
     * @param url
     * @param params bool , optional, if not set or set false, will return representatives randomly, if set true, will sorting represetntative balance in descending order
     * @return: each representative and its voting weight
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  representatives(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_representatives", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return tokens of the chain
     * @param url
     * @param params
     * @return: []token: the tokens info
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  tokens(baseUrl:String,successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let request = Tokens()
        let client : QlcClient = QlcClient()
        client.call(request,baseUrl:baseUrl, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return token info by token id
     * @param url
     * @param params string: token id
     * @return: token: token info
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func  tokenInfoById(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_tokens", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return token info by token name
     * @param url
     * @param params string: token name
     * @return: token: token info
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func tokenInfoByName(token : String,baseUrl:String, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let request = TokenInfoByName(
            token: token
        )
        let client : QlcClient = QlcClient()
//        let callbackQueue : CallbackQueue? = isMainQueue ? .main : nil
        client.call(request,baseUrl:baseUrl, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    /**
     * Return the number of blocks (not include smartcontrant block) and unchecked blocks of chain
     * @param url
     * @param params
     * @return: count: int, number of blocks , not include smartcontrant block
     unchecked: int, number of unchecked blocks
     * @throws QlcException
     * @throws IOException
     */
    @objc public static func transactionsCount(url : String?, params : [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let client : QlcClient = QlcClient()
        //client.call(method: "ledger_transactionsCount", params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    @objc public static func rewards_getReceiveRewardBlock(hashHex: String,baseUrl:String, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let request = GetReceiveRewardBlock(hashHex: hashHex)
        let client : QlcClient = QlcClient()
        client.call(request,baseUrl:baseUrl, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    @objc public static func pov_getFittestHeader(baseUrl:String, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let request = GetFittestHeader()
        let client : QlcClient = QlcClient()
        client.call(request,baseUrl:baseUrl, successHandler: successHandler, failureHandler: failureHandler)
    }
}
