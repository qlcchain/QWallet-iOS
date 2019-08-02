//
//  TradeOrderListModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/17.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TradeOrderListModel.h"
#import "OTCUtil.h"

@implementation TradeOrderListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

- (NSString *)showNickName {
    return [OTCUtil getShowNickName:_nickname];
}

@end
