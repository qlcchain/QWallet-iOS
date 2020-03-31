//
//  BuybackBurnModel.m
//  Qlink
//
//  Created by Jelly Foo on 2020/2/28.
//  Copyright © 2020 pan. All rights reserved.
//

#import "BuybackBurnModel.h"
#import "NSString+RemoveZero.h"

@implementation BuybackBurnModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id", @"DescriptionEn":@"descriptionEn", @"Description":@"description"};
}

- (NSString *)unitPrice_str {
    return [NSString doubleToString:_unitPrice];
}

@end
