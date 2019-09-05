//
//  OTCUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2019/8/1.
//  Copyright © 2019 pan. All rights reserved.
//

#import "OTCUtil.h"
#import "NSString+RegexCategory.h"
#import "NSString+EmptyUtil.h"

@implementation OTCUtil

+ (NSString *)getShowNickName:(NSString *)_nickname {
    if (![_nickname isEmptyString]) {
        NSString *result = @"";
        if ([_nickname isEmailAddress]) {
            if (_nickname.length <= 3) {
                result = _nickname;
            } else {
                result = [NSString stringWithFormat:@"%@...",[_nickname substringWithRange:NSMakeRange(0, 3)]];
            }
        } else {
            result = _nickname;
        }
        
        return result;
    } else {
        return @"";
    }
}

@end
