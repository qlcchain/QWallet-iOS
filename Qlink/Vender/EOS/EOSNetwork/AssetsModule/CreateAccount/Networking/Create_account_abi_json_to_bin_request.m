//
//  Buy_ram_abi_json_to_bin_request.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/22.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Create_account_abi_json_to_bin_request.h"
#import <eosFramework/AppConstant.h>

@implementation Create_account_abi_json_to_bin_request
-(NSString *)requestUrlPath{
    return @"/abi_json_to_bin";
}

-(NSDictionary *)parameters{
    // 交易JSON序列化
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: VALIDATE_STRING(self.code) forKey:@"code"];
    [params setObject:VALIDATE_STRING(self.action) forKey:@"action"];
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [args setObject:VALIDATE_STRING(self.creator) forKey:@"creator"];
    [args setObject:VALIDATE_STRING(self.name) forKey:@"name"];
    
    NSMutableDictionary *owner = [NSMutableDictionary dictionary];
    [owner setObject:@1 forKey:@"threshold"];
    [owner setObject:@[@{@"key":VALIDATE_STRING(self.ownerPublicKey),@"weight":@1}] forKey:@"keys"];
    [owner setObject:@[] forKey:@"accounts"];
    [owner setObject:@[] forKey:@"waits"];
    [args setObject:owner forKey:@"owner"];
    
    NSMutableDictionary *active = [NSMutableDictionary dictionary];
    [active setObject:@1 forKey:@"threshold"];
    [active setObject:@[@{@"key":VALIDATE_STRING(self.activePublicKey),@"weight":@1}] forKey:@"keys"];
    [active setObject:@[] forKey:@"accounts"];
    [active setObject:@[] forKey:@"waits"];
    [args setObject:active forKey:@"active"];
    
    [params setObject:args forKey:@"args"];
    return params;
}

//{
//    "code": "eosio",
//    "action": "newaccount",
//    "args": {
//        "creator": "testnetyy111",
//        "name": "testnetyy222",
//        "owner": {
//            "threshold": 1,
//            "keys": [
//                     {
//                         "key": "EOS7L9pb38iiqvnrsgzPVqxHnxHmxxeX6bCNbGkehh1hCScEc3ya2",
//                         "weight": 1
//                     }
//                     ],
//            "accounts": [],
//            "waits": []
//        },
//        "active": {
//            "threshold": 1,
//            "keys": [
//                     {
//                         "key": "EOS7eZtj6yzESob8Y3vjYwBnM25uZ3HnQa922FmcR3MZuozdiRCEj",
//                         "weight": 1
//                     }
//                     ],
//            "accounts": [],
//            "waits": []
//        }
//    }
//}

@end
