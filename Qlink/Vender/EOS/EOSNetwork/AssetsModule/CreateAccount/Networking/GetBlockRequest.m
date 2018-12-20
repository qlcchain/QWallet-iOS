//
//  CreateAccountRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/19.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "GetBlockRequest.h"
#import <eosFramework/AppConstant.h>

@implementation GetBlockRequest


-(NSString *)requestUrlPath{
    return @"/get_block";
}

-(id)parameters{
    return @{
             @"block_num_or_id" : VALIDATE_STRING(self.block_num_or_id),
             };
}
@end
