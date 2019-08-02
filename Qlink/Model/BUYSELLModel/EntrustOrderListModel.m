//
//  EntrustOrderListModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "EntrustOrderListModel.h"
#import "OTCUtil.h"

@implementation EntrustOrderListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

- (NSString *)showNickName {
    return [OTCUtil getShowNickName:_nickname];
}

@end
