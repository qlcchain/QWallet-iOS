//
//  LocationMode.m
//  Qlink
//
//  Created by 旷自辉 on 2018/3/28.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "LocationMode.h"

@implementation LocationMode

+ (instancetype) getShareInstance
{
   __strong static LocationMode *shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
        shareObject.country = @"China";
    });
    return shareObject;
}

- (void)setCountry:(NSString *)country
{
    if ((country == nil || [country isEmptyString]) || [country isEqualToString:@"中国"]) {
        _country = @"China";
    } else {
        _country = country;
    }
}


@end
