//
//  GetRequiredPublicKeyRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/3/21.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "CreateAccountGetRequiredPublicKeyRequest.h"
#import <eosFramework/AppConstant.h>

@implementation CreateAccountGetRequiredPublicKeyRequest

-(NSString *)requestUrlPath{
    return @"/get_required_keys";
}

-(NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    NSMutableDictionary *transacDic = [NSMutableDictionary dictionary];
    [transacDic setObject:VALIDATE_STRING(self.ref_block_prefix) forKey:@"ref_block_prefix"];
    [transacDic setObject:VALIDATE_STRING(self.ref_block_num) forKey:@"ref_block_num"];
    [transacDic setObject:VALIDATE_STRING(self.expiration) forKey:@"expiration"];

    [transacDic setObject:@[] forKey:@"context_free_data"];
    [transacDic setObject:@[] forKey:@"transaction_extensions"];

//    [transacDic setObject:@[] forKey:@"signatures"];
//    [transacDic setObject:@[] forKey:@"context_free_actions"];
//    [transacDic setObject:@0 forKey:@"delay_sec"];
//    [transacDic setObject:@0 forKey:@"max_kcpu_usage"];
//    [transacDic setObject:@0 forKey:@"max_net_usage_words"];

    NSMutableDictionary *authorizationDict = [NSMutableDictionary dictionary];
    [authorizationDict setObject:VALIDATE_STRING(self.sender) forKey:@"actor"];
    [authorizationDict setObject:IsStrEmpty(self.permission) ? @"active" :self.permission forKey:@"permission"];

    // newaccount
    NSMutableDictionary *newaccount_actionDict = [NSMutableDictionary dictionary];
    [newaccount_actionDict setObject:VALIDATE_STRING(self.newaccount_account) forKey:@"account"];
    [newaccount_actionDict setObject:self.newaccount_name forKey:@"name"];
    [newaccount_actionDict setObject:VALIDATE_STRING(self.newaccount_data) forKey:@"data"];
    [newaccount_actionDict setObject:@[authorizationDict] forKey:@"authorization"];

    // buyram
    NSMutableDictionary *buyram_actionDict = [NSMutableDictionary dictionary];
    [buyram_actionDict setObject:VALIDATE_STRING(self.buyram_account) forKey:@"account"];
    [buyram_actionDict setObject:self.buyram_name forKey:@"name"];
    [buyram_actionDict setObject:VALIDATE_STRING(self.buyram_data) forKey:@"data"];
    [buyram_actionDict setObject:@[authorizationDict] forKey:@"authorization"];

    // stake
    NSMutableDictionary *stake_actionDict = [NSMutableDictionary dictionary];
    [stake_actionDict setObject:VALIDATE_STRING(self.stake_account) forKey:@"account"];
    [stake_actionDict setObject:self.stake_name forKey:@"name"];
    [stake_actionDict setObject:VALIDATE_STRING(self.stake_data) forKey:@"data"];
    [stake_actionDict setObject:@[authorizationDict] forKey:@"authorization"];

    [transacDic setObject:@[newaccount_actionDict,buyram_actionDict,stake_actionDict] forKey:@"actions"];

    [params setObject:transacDic forKey:@"transaction"];

    NSMutableArray *available_keysArr = [NSMutableArray array];
    for (NSString *publicKey in self.available_keys) {
        if ([publicKey hasPrefix:@"EOS"]) {
            [available_keysArr addObject: publicKey];
        }
    }
    [params setObject:VALIDATE_ARRAY(available_keysArr) forKey:@"available_keys"];

    return params;
}


@end

