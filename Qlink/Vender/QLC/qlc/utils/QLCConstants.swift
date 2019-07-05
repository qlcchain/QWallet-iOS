//
//  QLCConstants.swift
//  Qlink
//
//  Created by Jelly Foo on 2019/5/30.
//  Copyright © 2019 pan. All rights reserved.
//

import Foundation
import BigInt

public class QLCConstants {
    
    // basic node
    public static let URL:String = "http://192.168.1.122:19735"
    
    // exception code
    public static let EXCEPTION_CODE_1000:Int = 1000
    public static let EXCEPTION_MSG_1000:String = "Not enought balance"
    
    public static let EXCEPTION_CODE_1001:Int = 1001
    public static let EXCEPTION_MSG_1001:String = "Seed can`t be empty"
    
    public static let EXCEPTION_CODE_1002:Int = 1002
    public static let EXCEPTION_MSG_1002:String = "Public key can`t be empty"
    
    public static let EXCEPTION_CODE_1003:Int = 1003
    public static let EXCEPTION_MSG_1003:String = "Address can`t be empty"
    
    public static let EXCEPTION_CODE_1004:Int = 1004
    public static let EXCEPTION_MSG_1004:String = "Address format error"
    
    public static let EXCEPTION_CODE_1005:Int = 1005
    public static let EXCEPTION_MSG_1005:String = "Signature verification failed"
    
    public static let EXCEPTION_CODE_1006:Int = 1006;
    public static let EXCEPTION_MSG_1006:String = "Seed generation not supported";
    
    public static let EXCEPTION_CODE_1007:Int = 1007;
    public static let EXCEPTION_MSG_1007:String = "Mnemonics can`t be empty";
    
    
    public static let EXCEPTION_BLOCK_CODE_2000:Int = 2000
    public static let EXCEPTION_BLOCK_MSG_2000:String = "Parameter error for send block"
    
    public static let EXCEPTION_BLOCK_CODE_2001:Int = 2001
    public static let EXCEPTION_BLOCK_MSG_2001:String = "Parameter error for receive block"
    
    public static let EXCEPTION_BLOCK_CODE_2002:Int = 2002
    public static let EXCEPTION_BLOCK_MSG_2002:String = "The block is not send block"
    
    public static let EXCEPTION_BLOCK_CODE_2003:Int = 2003
    public static let EXCEPTION_BLOCK_MSG_2003:String = "Send block does not exist"
    
    public static let EXCEPTION_BLOCK_CODE_2004:Int = 2004
    public static let EXCEPTION_BLOCK_MSG_2004:String = "receive address is mismatch private key"
    
    public static let EXCEPTION_BLOCK_CODE_2005:Int = 2005
    public static let EXCEPTION_BLOCK_MSG_2005:String = "Pending not found"
    
    public static let EXCEPTION_BLOCK_CODE_2006:Int = 2006
    public static let EXCEPTION_BLOCK_MSG_2006:String = "Invalid representative"
    
    public static let EXCEPTION_BLOCK_CODE_2007:Int = 2007
    public static let EXCEPTION_BLOCK_MSG_2007:String = "Account is not exist"
    
    public static let EXCEPTION_BLOCK_CODE_2008:Int = 2008
    public static let EXCEPTION_BLOCK_MSG_2008:String = "Account has no chain token"
    
    public static let EXCEPTION_BLOCK_CODE_2009:Int = 2009
    public static let EXCEPTION_BLOCK_MSG_2009:String = "Token header block not found"
    
    public static let EXCEPTION_BLOCK_CODE_2010:Int = 2010
    public static let EXCEPTION_BLOCK_MSG_2010:String = "Parameter error for change block"
    
    // system code
    public static let EXCEPTION_SYS_CODE_3000:Int = 3000
    public static let EXCEPTION_SYS_MSG_3000:String = "Need initialize qlc client"
    
    // block type
    public static let BLOCK_TYPE_OPEN:String = "Open"
    public static let BLOCK_TYPE_SEND:String = "Send"
    public static let BLOCK_TYPE_RECEIVE:String = "Receive"
    public static let BLOCK_TYPE_CHANGE:String = "Change"
    public static let BLOCK_TYPE_CONTRACTSEND:String = "ContractSend"
    public static let BLOCK_TYPE_CONTRACTREWARD:String = "ContractReward"
    
    // block parameter default value
    public static let ZERO_HASH:String = "0000000000000000000000000000000000000000000000000000000000000000"
    public static let ZERO_BIG_INTEGER:BigUInt = BigUInt(0)
    public static let ZERO_LONG:Int64 = 0
    
    // link type
    public static let LINNK_TYPE_AIRDORP:String = "d614bb9d5e20ad063316ce091148e77c99136c6194d55c7ecc7ffa9620dbcaeb"
    
}
