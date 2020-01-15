//
//  GroupBuyListModel.m
//  Qlink
//
//  Created by Jelly Foo on 2020/1/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import "GroupBuyListModel.h"

@implementation GroupBuyListItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end

@implementation GroupBuyListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

+ (NSDictionary *) mj_objectClassInArray
{
    return @{@"items" : @"GroupBuyListItemModel"};
}

@end
