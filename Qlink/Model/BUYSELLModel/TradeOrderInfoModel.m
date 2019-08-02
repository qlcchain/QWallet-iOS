//
//  TradeOrderInfoModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/18.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TradeOrderInfoModel.h"
#import "OTCUtil.h"

@implementation TradeOrderInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

- (NSString *)showNickName {
    return [OTCUtil getShowNickName:_nickname];
}

@end
