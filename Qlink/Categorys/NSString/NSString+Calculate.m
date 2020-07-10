//
//  NSString+Calculate.m
//  Qlink
//
//  Created by 旷自辉 on 2020/7/9.
//  Copyright © 2020 pan. All rights reserved.
//

#import "NSString+Calculate.h"

@implementation NSString (Calculate)

+(NSString *)countNumAndChangeformat:(NSString *)num

{
//整数
    NSString* str11;
//小数点之后的数字
    NSString* str22;
    if ([num containsString:@"."]) {
        NSArray* array = [num componentsSeparatedByString:@"."];

        str11 = array[0];

        str22 = array[1];

    }else{
        str11 = num;
    }

    int count = 0;
    long long int a = str11.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:str11];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    if ([num containsString:@"."]) {

//包含小数点
//返回的数字
        NSString* str33;
        if (str22.length>0) {
//小数点后面有数字
            str33 = [NSString stringWithFormat:@"%@.%@",newstring,str22];
        }else{
            //没有数字
            str33 = [NSString stringWithFormat:@"%@",newstring];
        }
        return str33;
        
    }else{
        //不包含小数点

        return newstring;
    }
}


@end
