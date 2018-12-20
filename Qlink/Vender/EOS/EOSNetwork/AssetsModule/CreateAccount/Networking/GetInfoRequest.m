//
//  CreateAccountRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/19.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "GetInfoRequest.h"
#import <eosFramework/AppConstant.h>

@implementation GetInfoRequest


-(NSString *)requestUrlPath{
    return @"/get_info";
}

-(id)parameters{
    return @{
             };
}
@end
