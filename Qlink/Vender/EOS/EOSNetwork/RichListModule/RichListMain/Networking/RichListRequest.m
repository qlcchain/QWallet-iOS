//
//  RichListRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/26.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "RichListRequest.h"
#import "RequestUrlConstant.h"
#import <eosFramework/AppConstant.h>

@implementation RichListRequest

- (NSString *)requestUrlPath{
     return [NSString stringWithFormat:@"%@/follow_list", REQUEST_PERSONAL_BASEURL];
}

-(id)parameters{
    return @{@"uid" : VALIDATE_STRING(self.uid)};
}

@end
