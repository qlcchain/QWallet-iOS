//
//  GroupBuyListModel.m
//  Qlink
//
//  Created by Jelly Foo on 2020/1/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import "GroupBuyListModel.h"
#import "NSString+RemoveZero.h"

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

- (NSString *)deductionTokenAmount_str {
    return [NSString doubleToString:_deductionTokenAmount];
}

- (NSString *)payTokenAmount_str {
    return [NSString doubleToString:_payTokenAmount];
}

@end
