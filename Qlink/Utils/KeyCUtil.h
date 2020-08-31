//
//  KeyChatUtil.h
//  PNRouter
//
//  Created by 旷自辉 on 2018/9/12.
//  Copyright © 2018年 旷自辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyCUtil : NSObject
// 检查key是否存在
+ (BOOL) isExitKey:(NSString *) key;
// 删除指定key
+ (BOOL) deleteWithKey:(NSString *) key;
// 删除所有Key
+ (BOOL) deleteAllKey;
// 写入nsstring到key
+ (BOOL) saveStringToKeyWithString:(NSString *)vaule key:(NSString *) key;
// 写入data到key
+ (BOOL) saveDataToKeyWithData:(NSData *)data key:(NSString *) key;
// 得到对应key的nsstirng
+ (NSString *) getKeyValueWithKey:(NSString *) key;
// 得到对应key的data
+ (NSData *) getKeyDataWithKey:(NSString *) key;
// 写入router
+ (BOOL) saveHashTokeychainWithValue:(NSDictionary *)value key:(NSString *) key;
+ (NSArray *) getHashWithKey:(NSString *) key;
+ (BOOL) saveHashTokeychainWithArr:(NSArray *)arr key:(NSString *)key;
@end
