//
//  NSString+HexStr.h
//  Qlink
//
//  Created by Jelly Foo on 2018/3/26.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HexStr)

+ (NSString *)cutString:(NSString *)str;
+ (NSString *)transToStr:(NSData *)data;
//字符串补零操作
+ (NSString *)addZero:(NSString *)str withLength:(int)length;
// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString;
//普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string;
//10进制转16进制
+(NSString *)ToHex:(long long int)tmpid;
//将16进制的字符串转换成NSData
+ (NSMutableData *)convertHexStrToData:(NSString *)str;
+ (NSString *)convertDataToHexStr:(NSData *)data;
+(NSString *) parseByteArray2HexString:(Byte[]) bytes;

@end
