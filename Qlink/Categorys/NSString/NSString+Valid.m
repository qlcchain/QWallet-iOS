//
//  NSString+Valid.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/16.
//  Copyright © 2018 pan. All rights reserved.
//

#import "NSString+Valid.h"

@implementation NSString (Valid)

- (BOOL)containChinese {
    BOOL isContain = NO;
    NSInteger alength = [self length];
    for (int i = 0; i<alength; i++) {
        char commitChar = [self characterAtIndex:i];
        NSString *temp = [self substringWithRange:NSMakeRange(i,1)];
        const char *u8Temp = [temp UTF8String];
        if (3==strlen(u8Temp)){
            NSLog(@"字符串中含有中文");
            isContain = YES;
        }
    }
    return isContain;
}

- (BOOL)containUppercase {
    BOOL isContain = NO;
    NSInteger alength = [self length];
    for (int i = 0; i<alength; i++) {
        char commitChar = [self characterAtIndex:i];
        NSString *temp = [self substringWithRange:NSMakeRange(i,1)];
        const char *u8Temp = [temp UTF8String];
        if((commitChar>64)&&(commitChar<91)){
            NSLog(@"字符串中含有大写英文字母");
            isContain = YES;
        }
    }
    return isContain;
}

- (BOOL)containLowercase {
    BOOL isContain = NO;
    NSInteger alength = [self length];
    for (int i = 0; i<alength; i++) {
        char commitChar = [self characterAtIndex:i];
        NSString *temp = [self substringWithRange:NSMakeRange(i,1)];
        const char *u8Temp = [temp UTF8String];
        if((commitChar>96)&&(commitChar<123)){
            NSLog(@"字符串中含有小写英文字母");
            isContain = YES;
        }
    }
    return isContain;
}

- (BOOL)containDigital {
    BOOL isContain = NO;
    NSInteger alength = [self length];
    for (int i = 0; i<alength; i++) {
        char commitChar = [self characterAtIndex:i];
        NSString *temp = [self substringWithRange:NSMakeRange(i,1)];
        const char *u8Temp = [temp UTF8String];
        if((commitChar>47)&&(commitChar<58)){
            NSLog(@"字符串中含有数字");
            isContain = YES;
        }
    }
    return isContain;
}

@end
