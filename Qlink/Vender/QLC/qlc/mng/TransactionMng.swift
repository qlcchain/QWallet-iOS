//
//  TransactionMng.swift
//  Qlink
//
//  Created by Jelly Foo on 2019/5/30.
//  Copyright © 2019 pan. All rights reserved.
//

import Foundation
import BigInt
import HandyJSON

public class TransactionMng {
    
    /**
     *
     * @Description Return send block by send parameter and private key
     * @param
     *     send parameter for the block
     *    from: send address for the transaction
     *    to: receive address for the transaction
     *    tokenName: token name
     *    amount: transaction amount
     *    sender: optional, sms sender
     *    receiver: optional, sms receiver
     *    message: optional, sms message hash
     *    string: private key
     * @return JSONObject send block
     * @throws QlcException
     * @throws IOException
     */
    public static func sendBlock(from:String, tokenName:String, to:String, amount: BigUInt, sender:String, receiver:String, message:String, privateKey: Bytes, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) throws {

        // token info
        var token: QLCToken? = nil
        try? QLCToken.getTokenByTokenName(tokenName: tokenName, successHandler: { (response) in
            if response != nil {
                token = response as? QLCToken
                
                // send address token info
                var tokenMeta : QLCTokenMeta? = nil
                try? TokenMetaMng.getTokenMeta(tokenHash: token!.tokenId!, address: from, successHandler: { (response) in
                    if response != nil {
                        tokenMeta = response as? QLCTokenMeta
                        if tokenMeta!.balance! < amount {
                            print(QLCConstants.EXCEPTION_MSG_1000, "(balance:",String(tokenMeta!.balance!) ,", need:",String(amount),")")
                            failureHandler(nil, nil)
                            return
                        }

                        // previous block info
                        var previousBlock : QLCStateBlock?
                        try? LedgerMng.blocksInfo(blockHash: tokenMeta!.header!.hex2Bytes, successHandler: { (response) in
                            if response != nil {
                                previousBlock = response as? QLCStateBlock
                                
                                // create send block
                                TransactionMng.fillSendBlock(token: token!, from: from, tokenMeta: tokenMeta!, amount: amount, to: to, sender: sender, receiver: receiver, message: message, previousBlock: previousBlock!, privateKey: privateKey, resultHandler: { (dic) in
                                    successHandler(dic)
                                })
                                
                            } else {
                                failureHandler(nil, nil)
                            }
                                
                        }, failureHandler: { (error, message) in
                            print("getBlockInfoByHash = ",message ?? "")
                            failureHandler(error, message)
                        })
                    } else {
                        failureHandler(nil, nil)
                    }
                }, failureHandler: { (error, message) in
                    print("getTokenMeta = ",message ?? "")
                    failureHandler(error, message)
                })
            } else {
                failureHandler(nil, nil)
            }
        })  { (error, message) in
            print("getTokenByTokenName = ",message ?? "")
            failureHandler(error, message)
        }
    }
    
    private static func fillSendBlock(token:QLCToken, from:String, tokenMeta:QLCTokenMeta, amount: BigUInt, to: String, sender: String, receiver: String, message: String, previousBlock: QLCStateBlock, privateKey:Bytes, resultHandler: @escaping ((Dictionary<String, Any>?) -> Void)) {
        let block = QLCStateBlock.factory(type: QLCConstants.BLOCK_TYPE_SEND, token: token.tokenId ?? "", address: from, balance: BigUInt(tokenMeta.balance!-amount), previous: tokenMeta.header ?? "", link: QLCUtil.addressToPublicKey(address: to), timestamp: Int64(Date().timeIntervalSince1970), representative: tokenMeta.representative ?? "")
        
        if !sender.isEmpty {
            block.sender = sender
        }
        if !receiver.isEmpty {
            block.receiver = receiver
        }
        if !message.isEmpty {
            block.message = message
        } else {
            block.message = QLCConstants.ZERO_HASH
        }
        block.vote = previousBlock.vote == nil ? BigUInt(0) : previousBlock.vote
        block.network = previousBlock.network == nil ? BigUInt(0) : previousBlock.network
        block.storage = previousBlock.storage == nil ? BigUInt(0) : previousBlock.storage
        block.oracle = previousBlock.oracle == nil ? BigUInt(0) : previousBlock.oracle
        block.povHeight = previousBlock.povHeight == nil ? 0 : previousBlock.povHeight
        if previousBlock.extra != nil && !previousBlock.extra!.isEmpty {
            block.extra = previousBlock.extra
        } else {
            block.extra = QLCConstants.ZERO_HASH
        }
        
        // block hash
        let hash = BlockMng.getHash(block: block)
//        let hashHex = hash.toHexString()
        if hash.count == 0 {
            print(QLCConstants.EXCEPTION_BLOCK_MSG_2000)
            resultHandler(nil)
//            return nil
        }

        if (privateKey.count == 64 || privateKey.count == 128) {
            // send address info
            let sendAddress = QLCAddress.factory(address: from, publicKey: QLCUtil.addressToPublicKey(address: from), privateKey: privateKey.toHexString())
            
            // set signature
            let priKey = sendAddress.privateKey!.replacingOccurrences(of: sendAddress.publicKey!, with: "")
            let pubKey = sendAddress.publicKey!
            let signature = QLCUtil.sign(message: hash.toHexString(), secretKey: priKey, publicKey: pubKey)
            let signCheck : Bool = QLCUtil.signOpen(message: hash.toHexString(), publicKey: pubKey, signature: signature)
            if !signCheck {
                print(QLCConstants.EXCEPTION_MSG_1005)
                resultHandler(nil)
//                return nil
            }
            block.signature = signature

            // set work
            WorkUtil.generateWorkOfOperation(hash: BlockMng.getRoot(block: block) ?? "") { (work) in
                block.work = work
                resultHandler(block.toJSON())
            }
//            let work = WorkUtil.generateWorkOfSingle(hash: BlockMng.getRoot(block: block) ?? "", startWork: 0, offsetWork: 1)
//            block.work = work
        }
        
//        return block.toJSON()
    }
    
    /**
     *
     * @Description Return receive block by send block and private key
     * @param sendBlock
     * @param privateKey
     * @throws QlcException
     * @throws IOException
     * @return JSONObject
     */
    public static func receiveBlock(sendBlock:QLCStateBlock, privateKey:Bytes, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) throws {

        // the block hash
        let sendBlockHash:Bytes = BlockMng.getHash(block: sendBlock)

        // is send block
        if (QLCConstants.BLOCK_TYPE_SEND != sendBlock.type ?? "") {
            print(QLCConstants.EXCEPTION_BLOCK_MSG_2002 + ", block hash[" + sendBlockHash.toHexString() + "]")
            failureHandler(nil, nil)
            return
        }

        // Does the send block exist
        var tempBlock:QLCStateBlock?
        try? LedgerMng.blocksInfo(blockHash: sendBlockHash, successHandler: { (response) in
            if response != nil {
                tempBlock = response as? QLCStateBlock
                if (tempBlock == nil) {
//                throw new QlcException(Constants.EXCEPTION_BLOCK_CODE_2003, Constants.EXCEPTION_BLOCK_MSG_2003 + ", block hash[" + Helper.byteToHexString(sendBlockHash) + "]");
                    print(QLCConstants.EXCEPTION_BLOCK_MSG_2003 + ", block hash[" + sendBlockHash.toHexString() + "]")
                    failureHandler(nil, nil)
                    return
                }
                
                // check private key and link
                let priKey = privateKey.toHexString()
                let pubKey = QLCUtil.privateKeyToPublicKey(privateKey: priKey)
                if pubKey != sendBlock.link {
                    print(QLCConstants.EXCEPTION_BLOCK_MSG_2004)
                    failureHandler(nil, nil)
                    return
                }
                let receiveAddress = QLCUtil.publicKeyToAddress(publicKey: sendBlock.link ?? "")
                
                // pending info
                var info: QLCPendingInfo?
                var pending: QLCPending?
                try? LedgerMng.accountsPending(address: receiveAddress, successHandler: { (response) in
                    if response != nil {
                        pending = (response as! QLCPending)
                        let itemList = pending?.infoList
                        if itemList != nil && itemList!.count > 0 {
                            var tempInfo:QLCPendingInfo?
                            for item in itemList! {
                                tempInfo = item
                                if tempInfo?.Hash == sendBlockHash.toHexString() {
                                    info = tempInfo
                                    break
                                }
                                tempInfo = nil
                            }
                        }
                        
                        if info == nil {
                            print(QLCConstants.EXCEPTION_BLOCK_MSG_2005)
                            failureHandler(nil, nil)
                            return
                        }
                        
                        // has token meta
                        var tokenMeta:QLCTokenMeta?
                        try? TokenMetaMng.getTokenMeta(tokenHash: sendBlock.token!, address: receiveAddress, successHandler: { (response) in
                            if response != nil {
                                tokenMeta = (response as! QLCTokenMeta)
                                var has = false
                                if tokenMeta != nil {
                                    has = true
                                }
                                
                                // previous block info
                                var previousBlock : QLCStateBlock?
                                try? LedgerMng.blocksInfo(blockHash: tokenMeta!.header!.hex2Bytes, successHandler: { (response) in
                                    if response != nil {
                                        previousBlock = response as? QLCStateBlock
                                        
                                        // create receiver block
                                        TransactionMng.fillReceiveBlock(has: has, receiveAddress: receiveAddress, tokenMeta: tokenMeta!, info: info!, previousBlock: previousBlock!, sendBlockHash: sendBlockHash, sendBlock: sendBlock, privateKey: privateKey, resultHandler: { (dic) in
                                            successHandler(dic)
                                        });
                                    } else {
                                        failureHandler(nil, nil)
                                    }
                                    
                                }, failureHandler: { (error, message) in
                                    print("getBlockInfoByHash = ",message ?? "")
                                    failureHandler(error, message)
                                })
                            } else {
                                failureHandler(nil, nil)
                            }
                        }, failureHandler: { (error, message) in
                            print("getTokenMeta = ",message ?? "")
                            failureHandler(error, message)
                        })
                    } else {
                        failureHandler(nil, nil)
                    }
                }, failureHandler: { (error, message) in
                    print("getAccountPending = ",message ?? "")
                    failureHandler(error, message)
                })
            }
        }) { (error, message) in
            print("getBlockInfoByHash = ",message ?? "")
            failureHandler(error, message)
        }
    }
    
    private static func fillReceiveBlock(has:Bool,receiveAddress:String,tokenMeta:QLCTokenMeta,info:QLCPendingInfo,previousBlock:QLCStateBlock,sendBlockHash:Bytes,sendBlock:QLCStateBlock, privateKey:Bytes, resultHandler: @escaping ((Dictionary<String, Any>?) -> Void)) {
        // create receive block
        let receiveBlock = QLCStateBlock()
        if (has) {
            // previous block info
            receiveBlock.type = QLCConstants.BLOCK_TYPE_RECEIVE
            receiveBlock.address = receiveAddress
            receiveBlock.balance = BigUInt(tokenMeta.balance!+info.amount!)
            receiveBlock.vote = previousBlock.vote
            receiveBlock.network = previousBlock.network
            receiveBlock.storage = previousBlock.storage
            receiveBlock.oracle = previousBlock.oracle
            receiveBlock.previous = tokenMeta.header
            receiveBlock.link = sendBlockHash.toHexString()
            receiveBlock.representative = tokenMeta.representative
            receiveBlock.token = tokenMeta.type
            receiveBlock.extra = QLCConstants.ZERO_HASH
            receiveBlock.timestamp = Int64(Date().timeIntervalSince1970)
        } else {
            receiveBlock.type = QLCConstants.BLOCK_TYPE_OPEN
            receiveBlock.address = receiveAddress
            receiveBlock.balance = info.amount
            receiveBlock.vote = QLCConstants.ZERO_BIG_INTEGER
            receiveBlock.network = QLCConstants.ZERO_BIG_INTEGER
            receiveBlock.storage = QLCConstants.ZERO_BIG_INTEGER
            receiveBlock.oracle = QLCConstants.ZERO_BIG_INTEGER
            receiveBlock.previous = QLCConstants.ZERO_HASH
            receiveBlock.link = sendBlockHash.toHexString()
            receiveBlock.representative = sendBlock.representative
            receiveBlock.token = sendBlock.token
            receiveBlock.extra = QLCConstants.ZERO_HASH
            receiveBlock.timestamp = Int64(Date().timeIntervalSince1970)
        }
        if sendBlock.message == nil || sendBlock.message!.isEmpty {
            receiveBlock.message = QLCConstants.ZERO_HASH
        } else {
            receiveBlock.message = sendBlock.message
        }
        receiveBlock.povHeight = QLCConstants.ZERO_LONG
        
        if (privateKey.count == 64 || privateKey.count == 128) {
            
            // check private key and link
            let priKey = privateKey.toHexString()
            let pubKey = QLCUtil.privateKeyToPublicKey(privateKey: priKey)
            if pubKey != sendBlock.link {
                print(QLCConstants.EXCEPTION_BLOCK_MSG_2004)
                resultHandler(nil)
            }
            
            // set signature
            let receiveBlockHash = BlockMng.getHash(block: receiveBlock)
            let signature = QLCUtil.sign(message: receiveBlockHash.toHexString(), secretKey: priKey, publicKey: pubKey)
            let signCheck : Bool = QLCUtil.signOpen(message: receiveBlockHash.toHexString(), publicKey: pubKey, signature: signature)
            if !signCheck {
                print(QLCConstants.EXCEPTION_MSG_1005)
                resultHandler(nil)
            }
            receiveBlock.signature = signature
            
            // set work
            WorkUtil.generateWorkOfOperation(hash: BlockMng.getRoot(block: receiveBlock) ?? "") { (work) in
                receiveBlock.work = work
                resultHandler(receiveBlock.toJSON())
            }
        }
        
//        return receiveBlock.toJSON()
        
    }
    
    /**
     *
     * @Description Return change block by account and private key
     * @param address:account address
     * @param representative:new representative account
     * @param chainTokenHash:chian token hash
     * @param privateKey:private key ,if not set ,will return block without signature and work
     * @return
     * @return JSONObject
     * @throws IOException
     * @throws QlcException
     */
    public static func changeBlock(address:String, representative:String, chainTokenHash:String, privateKey:Bytes, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) throws {
    
        // check representative
        var representativeInfo : QLCAccount?
        try? TokenMetaMng.getAccountMeta(address: representative, successHandler: { (response) in
            if response != nil {
                representativeInfo = (response as! QLCAccount)
                
                // check address
                var addressInfo: QLCAccount?
                try? TokenMetaMng.getAccountMeta(address: address, successHandler: { (response) in
                    if response != nil {
                        addressInfo = (response as! QLCAccount)
                        
                        // account has chain token
                        var tokenMeta:QLCTokenMeta?
                        let tokens = addressInfo!.tokens
                        for item in tokens ?? [] {
                            tokenMeta = item
                            if chainTokenHash == tokenMeta!.type {
                                break
                            }
                            tokenMeta = nil
                        }
                        
                        if tokenMeta == nil {
                            print(QLCConstants.EXCEPTION_BLOCK_MSG_2008 + ", address:[" + address + "]")
                            failureHandler(nil, nil)
                            return
                        }
                        
                        // previous block info
                        var previousBlock:QLCStateBlock?
                        try? LedgerMng.blocksInfo(blockHash: tokenMeta!.header!.hex2Bytes, successHandler: { (response) in
                            if response != nil {
                                previousBlock = response as? QLCStateBlock
                                
                                // create change block
                                TransactionMng.fillChangeBlock(address: address, tokenMeta: tokenMeta!, previousBlock: previousBlock!, representative: representative, privateKey: privateKey, resultHandler: { (dic) in
                                    successHandler(dic)
                                });
                            } else {
                                print(QLCConstants.EXCEPTION_BLOCK_MSG_2009)
                                failureHandler(nil, nil)
                            }
                            
                        }, failureHandler: { (error, message) in
                            print("getBlockInfoByHash = ",error!.localizedDescription)
                            failureHandler(nil, nil)
                        })
                    } else {
                        print(QLCConstants.EXCEPTION_BLOCK_MSG_2007 + ", address:[" + address + "]")
                        failureHandler(nil, nil)
                    }
                }, failureHandler: { (error, message) in
                    print("getAccountMeta = ",error!.localizedDescription)
                    failureHandler(error, message)
                })
            } else {
                print(QLCConstants.EXCEPTION_BLOCK_MSG_2006 + "[" + representative + "]")
                failureHandler(nil, nil)
            }
        }, failureHandler: { (error, message) in
            print("getAccountMeta = ",message)
            failureHandler(error, message)
        })
    }

    private static func fillChangeBlock(address:String,tokenMeta:QLCTokenMeta,previousBlock:QLCStateBlock,representative:String, privateKey:Bytes, resultHandler: @escaping ((Dictionary<String, Any>?) -> Void)){
        // create change block
        let changeBlock : QLCStateBlock = QLCStateBlock()
        changeBlock.type = QLCConstants.BLOCK_TYPE_CHANGE
        changeBlock.address = address
        changeBlock.balance = tokenMeta.balance
        changeBlock.vote = previousBlock.vote
        changeBlock.network = previousBlock.network
        changeBlock.storage = previousBlock.storage
        changeBlock.oracle = previousBlock.oracle
        changeBlock.previous = tokenMeta.header
        changeBlock.link = QLCConstants.ZERO_HASH
        changeBlock.representative = representative
        changeBlock.token = tokenMeta.type
        changeBlock.extra = QLCConstants.ZERO_HASH
        changeBlock.timestamp = Int64(Date().timeIntervalSince1970)
        changeBlock.message = QLCConstants.ZERO_HASH
        changeBlock.povHeight = QLCConstants.ZERO_LONG
        
        if (privateKey.count == 64 || privateKey.count == 128) {
            
            // check private key and link
            let priKey = privateKey.toHexString()
            let pubKey = QLCUtil.privateKeyToPublicKey(privateKey: priKey)
            if address != QLCUtil.publicKeyToAddress(publicKey: pubKey) {
//            throw new QlcException(Constants.EXCEPTION_BLOCK_CODE_2004, Constants.EXCEPTION_BLOCK_MSG_2004);
                print(QLCConstants.EXCEPTION_BLOCK_MSG_2004)
                resultHandler(nil)
            }
            
            // set signature
            let changeBlockHash = BlockMng.getHash(block: changeBlock)
            let signature = QLCUtil.sign(message: changeBlockHash.toHexString(), secretKey: priKey, publicKey: pubKey)
            let signCheck : Bool = QLCUtil.signOpen(message: changeBlockHash.toHexString(), publicKey: pubKey, signature: signature)
            if !signCheck {
                print(QLCConstants.EXCEPTION_MSG_1005)
                resultHandler(nil)
            }
            changeBlock.signature = signature
            
            // set work
            WorkUtil.generateWorkOfOperation(hash: BlockMng.getRoot(block: changeBlock) ?? "") { (work) in
                changeBlock.work = work
                resultHandler(changeBlock.toJSON())
            }
            
        }
        
//        return changeBlock.toJSON()
    }
}
