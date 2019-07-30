//
//  BlockMng.swift
//  Qlink
//
//  Created by Jelly Foo on 2019/5/30.
//  Copyright © 2019 pan. All rights reserved.
//

import Foundation
import BigInt

public class BlockMng {
    
    /**
     *
     * @Description get block root
     * @param block
     * @throws QlcException
     * @return String
     */
    public static func getRoot(block:QLCStateBlock) -> String? {
        if block.type == QLCConstants.BLOCK_TYPE_OPEN  {
            return QLCUtil.addressToPublicKey(address: block.address ?? "")
        } else {
            return block.previous
        }
    }
    
    /**
     *
     * @Description get block hash
     * @param block
     * @throws QlcException
     * @return byte[]:block hash
     */
    public static func getHash(block:QLCStateBlock) -> Bytes {
        var source : Bytes = Bytes()
        
        let type = QLCBlock.QLCType.getIndex(type: block.type ?? "").toBytes_Big
        source.append(contentsOf: [type.last!])
 
        let token = (block.token ?? "").hex2Bytes
        source.append(contentsOf: token)

        let addressB = QLCUtil.addressToPublicKey(address: block.address ?? "").hex2Bytes
        source.append(contentsOf: addressB)

        let balance:BigUInt = block.balance ?? BigUInt(0)
        let balanceB = [UInt8](balance.serialize())
        source.append(contentsOf: balanceB)

        let vote:BigUInt = block.vote ?? BigUInt(0)
        source.append(contentsOf: [UInt8](vote.serialize()))

        let network:BigUInt = block.network ?? BigUInt(0)
        source.append(contentsOf: [UInt8](network.serialize()))

        let storage:BigUInt = block.storage ?? BigUInt(0)
        source.append(contentsOf: [UInt8](storage.serialize()))

        let oracle:BigUInt = block.oracle ?? BigUInt(0)
        source.append(contentsOf: [UInt8](oracle.serialize()))

        let previousB = (block.previous ?? "").hex2Bytes
        source.append(contentsOf: previousB)

        let linkB = (block.link ?? "").hex2Bytes
        source.append(contentsOf: linkB)

        //TODO:未检验
//        var sender = Data()
//        if (block.sender != nil) {
//            sender = Data(base64Encoded: block.sender!, options: Data.Base64DecodingOptions(rawValue: 0)) ?? Data()
//        }
//        let senderB = sender.bytes
        let senderB = (block.sender ?? "").bytes
        source.append(contentsOf: senderB)

        //TODO:未检验
//        var receiver = Data()
//        if (block.receiver != nil) {
//            receiver = Data(base64Encoded: block.receiver!, options: Data.Base64DecodingOptions(rawValue: 0)) ?? Data()
//        }
//        let receiverB = receiver.bytes
        let receiverB = (block.receiver ?? "").bytes
        source.append(contentsOf: receiverB)

        let messageB = (block.message ?? "").hex2Bytes
        source.append(contentsOf: messageB)
        
        var data = Data()
        if (block.data != nil) {
            data = Data(base64Encoded: block.data!, options: Data.Base64DecodingOptions(rawValue: 0)) ?? Data()
        }
        let dataB = data.bytes
        source.append(contentsOf: dataB)

        let timestamp = (block.timestamp ?? 0).toBytes_Big
        source.append(contentsOf: timestamp)

        let povHeight = (block.povHeight ?? 0).toBytes_Big
        source.append(contentsOf: povHeight)

        let extra = (block.extra ?? "").hex2Bytes
        source.append(contentsOf: extra)

        let representativeB = QLCUtil.addressToPublicKey(address: (block.representative ?? "")).hex2Bytes
        source.append(contentsOf: representativeB)

        let hashB = Blake2b.hash(outLength: 32, in: source) ?? Bytes()
//        let hashString = hashB.toHexString()
        return hashB
    }
    
}
