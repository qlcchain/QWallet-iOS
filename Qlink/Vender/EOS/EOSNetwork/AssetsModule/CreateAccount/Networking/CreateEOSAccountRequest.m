//
//  CreateEOSAccountRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CreateEOSAccountRequest.h"
#import "RequestUrlConstant.h"
#import <eosFramework/AppConstant.h>

@implementation CreateEOSAccountRequest

//-(NSString *)requestUrlPath{
//    return [NSString stringWithFormat:@"%@/user/add_new_eos", REQUEST_BASEURL];
//}
-(NSString *)requestUrlPath{
    return @"/user/add_new_eos";
}

-(id)parameters{
    
    return @{
             @"uid" : VALIDATE_STRING(self.uid),
             @"eosAccountName" : VALIDATE_STRING(self.eosAccountName),
             @"activeKey" : VALIDATE_STRING(self.activeKey),
             @"ownerKey" : VALIDATE_STRING(self.ownerKey)
             
             };
}
@end
