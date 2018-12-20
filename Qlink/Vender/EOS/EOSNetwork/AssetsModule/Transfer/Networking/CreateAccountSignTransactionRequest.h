//
//  GetRequiredPublicKeyRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/3/21.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BaseHttpsNetworkRequest.h"
#import "BaseNetworkRequest.h"

@interface CreateAccountSignTransactionRequest : BaseNetworkRequest

@property(nonatomic, copy) NSString *ref_block_prefix;
@property(nonatomic, copy) NSString *ref_block_num;
@property(nonatomic, copy) NSString *expiration;

@property(nonatomic, copy) NSString *sender;
@property(nonatomic , copy) NSString *permission;

@property(nonatomic, copy) NSString *newaccount_data;
@property(nonatomic, copy) NSString *newaccount_account;
@property(nonatomic , copy) NSString *newaccount_name;

@property(nonatomic, copy) NSString *buyram_data;
@property(nonatomic, copy) NSString *buyram_account;
@property(nonatomic , copy) NSString *buyram_name;

@property(nonatomic, copy) NSString *stake_data;
@property(nonatomic, copy) NSString *stake_account;
@property(nonatomic , copy) NSString *stake_name;


@property(nonatomic, strong) NSArray *available_keys;



@end
