//
//  NSString+RandomStr.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/5.
//  Copyright © 2019 pan. All rights reserved.
//

#import "NSString+RandomStr.h"

@implementation NSString (RandomStr)

+ (NSString *)randomOf32 {
    static int kNumber = 32;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
