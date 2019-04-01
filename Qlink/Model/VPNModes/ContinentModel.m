//
//  ContinentModel.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "ContinentModel.h"

@implementation CountryModel
+ (NSDictionary *) mj_replacedKeyFromPropertyName
{
    return @{@"countryCode" : @"ISOcountryCode"};
}
@end

@implementation ContinentModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"country":@"CountryModel"};
}

@end
