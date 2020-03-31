//
//  EntrustOrderListModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "EntrustOrderListModel.h"
#import "OTCUtil.h"
#import "NSString+RemoveZero.h"

@implementation EntrustOrderListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

- (NSString *)showNickName {
    return [OTCUtil getShowNickName:_nickname];
}

- (NSString *)unitPrice_str {
    return [NSString doubleToString:_unitPrice];
}


- (NSString *)totalAmount_str {
    return [NSString doubleToString:_totalAmount];
}


- (NSString *)lockingAmount_str {
    return [NSString doubleToString:_lockingAmount];
}

- (NSString *)completeAmount_str {
    return [NSString doubleToString:_completeAmount];
}

@end
