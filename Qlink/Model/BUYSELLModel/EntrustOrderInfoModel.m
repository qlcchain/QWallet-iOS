//
//  EntrustOrderInfoModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/16.
//  Copyright © 2019 pan. All rights reserved.
//

#import "EntrustOrderInfoModel.h"
#import "NSString+RemoveZero.h"

@implementation EntrustOrderInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
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
