//
//  NSString+Trim.m
//  PNRouter
//
//  Created by 旷自辉 on 2019/3/27.
//  Copyright © 2019 旷自辉. All rights reserved.
//

#import "NSString+Trim.h"

@implementation NSString (Trim)

+ (NSString *)trim:(NSString *)val trimCharacterSet:(NSCharacterSet *)characterSet {
    NSString *returnVal = @"";
    if (val) {
        returnVal = [val stringByTrimmingCharactersInSet:characterSet]?:@"";
    }
    return returnVal;
}
 + (NSString *)trimWhitespace:(NSString *)val {
    return [self trim:val trimCharacterSet:[NSCharacterSet whitespaceCharacterSet]]; //去掉前后空格
}
+ (NSString *)trimNewline:(NSString *)val {
    return [self trim:val trimCharacterSet:[NSCharacterSet newlineCharacterSet]]; //去掉前后回车符
 }
 + (NSString *)trimWhitespaceAndNewline:(NSString *)val {
    return [self trim:val trimCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去掉前后空格和回车符
}

- (NSString *)trim_whitespace {
    NSString *returnVal = @"";
    if (self) {
        returnVal = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]?:@"";
    }
    return returnVal;
}

- (NSString *)trimAndLowercase {
    NSString *returnVal = @"";
    if (self) {
        returnVal = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]?:@"";
    }
    return [returnVal lowercaseString]?:@"";
}

@end
