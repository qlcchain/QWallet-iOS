//
//  KeyChatUtil.m
//  PNRouter
//
//  Created by 旷自辉 on 2018/9/12.
//  Copyright © 2018年 旷自辉. All rights reserved.
//

#import "KeyCUtil.h"
#import "Qlink-Swift.h"
#import <MJExtension/MJExtension.h>

@implementation KeyCUtil
// 检查key是否存在
+ (BOOL) isExitKey:(NSString *) key
{
    return [KeychainUtil isExistKeyWithKeyName:key];
}
// 删除指定key
+ (BOOL) deleteWithKey:(NSString *) key
{
    return [KeychainUtil removeKeyWithKeyName:key];
}
// 删除所有Key
+ (BOOL) deleteAllKey
{
    return [KeychainUtil removeAllKey];
}
// 写入nsstring到key
+ (BOOL) saveStringToKeyWithString:(NSString *)vaule key:(NSString *) key
{
    return [KeychainUtil saveValueToKeyWithKeyName:key keyValue:vaule];
}
// 写入data到key
+ (BOOL) saveDataToKeyWithData:(NSData *)data key:(NSString *) key
{
    return [KeychainUtil saveDataKeyAndDataWithKeyName:key keyValue:data];
}
// 得到对应key的nsstirng
+ (NSString *) getKeyValueWithKey:(NSString *) key
{
    return [KeychainUtil getKeyValueWithKeyName:key];
}
// 得到对应key的data
+ (NSData *) getKeyDataWithKey:(NSString *) key
{
    return [KeychainUtil getKeyDataValueWithKeyName:key];
}
// 写入router
+ (BOOL) saveHashTokeychainWithValue:(NSDictionary *)value key:(NSString *) key
{
    NSString *modeJosn = [KeychainUtil getKeyValueWithKeyName:key];
    NSMutableArray *modeArr = nil;
    if (modeJosn) {
        NSArray *arr = [modeJosn mj_JSONObject];
        modeArr = [NSMutableArray arrayWithArray:arr];
        [modeArr addObject:value];
    } else {
        modeArr = [NSMutableArray arrayWithObjects:value, nil];
    }
    NSString *json = [modeArr mj_JSONString];
   return [KeyCUtil saveStringToKeyWithString:json key:key];
}

+ (NSArray *) getHashWithKey:(NSString *) key
{
     NSString *modeJosn = [KeychainUtil getKeyValueWithKeyName:key];
    if (modeJosn) {
        return [modeJosn mj_JSONObject];
    } else {
        return @[];
    }
}

+ (BOOL) saveHashTokeychainWithArr:(NSArray *)arr key:(NSString *)key {
    NSString *json = [arr mj_JSONString];
    return [KeyCUtil saveStringToKeyWithString:json key:key];
}

@end
