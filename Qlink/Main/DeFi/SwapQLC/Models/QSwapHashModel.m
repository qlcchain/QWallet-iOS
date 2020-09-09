//
//  QSwapHashModel.m
//  Qlink
//
//  Created by 旷自辉 on 2020/8/20.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QSwapHashModel.h"
#import "KeyCUtil.h"
#import "QSwapHashModel.h"
#import <MJExtension/MJExtension.h>

#ifdef DEBUG
    static NSString *swapHashKey = @"swapHash_Key";
#else
    static NSString *swapHashKey = @"swapHash_main_Key";
#endif
@implementation QSwapHashModel

+ (void) deleteAllLocationHashs
{
    [KeyCUtil deleteWithKey:swapHashKey];
}
/// 获取本地所有的swap hash记录
+ (NSArray *) getLocalAllQSwapHashModels
{
    NSArray *swapHashs = [KeyCUtil getHashWithKey:swapHashKey]?:@[];
    NSMutableArray *resultArr = [NSMutableArray array];
    [swapHashs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QSwapHashModel *model = [QSwapHashModel getObjectWithKeyValues:obj];
        [resultArr addObject:model];
    }];
    return resultArr;
}

/// hash 是否存在
/// @param rhash 原文hash
+ (BOOL)isExitsWithHash:(NSString *) rhash
{
    if (!rhash) {
        return NO;
    }
    // 更新本地路由器
    NSArray *hashs = [KeyCUtil getHashWithKey:swapHashKey]?:@[];
    __block BOOL isExist = NO;
    [hashs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QSwapHashModel *model = [QSwapHashModel getObjectWithKeyValues:obj];
        if ([model.rHash isEqualToString:rhash]) {
            isExist = YES;
            *stop = YES;
        }
    }];
    return isExist;
}

/// 添加一条新的记录
/// @param hashM hash对象
+ (void)addSwapHashWithSwapHashModel:(QSwapHashModel *) hashM
{
    if (!hashM.rHash || [QSwapHashModel isExitsWithHash:hashM.rHash]) {
        return;
    }
    QSwapHashModel *hM = [[QSwapHashModel alloc] init];
    hM.rHash = hashM.rHash;
    hM.rOrigin = hashM.rOrigin;
    hM.txHash = hashM.txHash;
    hM.swaptxHash = hashM.swaptxHash;
    hM.state = hashM.state;
    hM.type = hashM.type;
    hM.amount = hashM.amount;
    hM.lockTime = hashM.lockTime;
    hM.fromAddress = hashM.fromAddress;
    hM.toAddress = hashM.toAddress;
    hM.privateKey = hashM.privateKey;
    hM.wrapperAddress = hashM.wrapperAddress;
    
    // 更新本地路由器
    NSArray *hashs = [KeyCUtil getHashWithKey:swapHashKey]?:@[];
    NSMutableArray *mutHashs = [NSMutableArray arrayWithArray:hashs];
    
    [mutHashs addObject:[hM mj_keyValues]];
    NSLog(@"新添加一个本地 hash");
    [KeyCUtil saveHashTokeychainWithArr:mutHashs key:swapHashKey];
   
}

/// 根据原文hash查询对象
/// @param rhash 原文hash
+ (QSwapHashModel *) checkSwapHashWithHash:(NSString *) rhash {
    if (!rhash) {
        return nil;
    }
    // 更新本地路由器
    NSArray *hashs = [KeyCUtil getHashWithKey:swapHashKey]?:@[];
    __block BOOL isExist = NO;
    __block NSInteger index = 0;
    [hashs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QSwapHashModel *model = [QSwapHashModel getObjectWithKeyValues:obj];
        if ([model.rHash isEqualToString:rhash]) {
            isExist = YES;
            index = idx;
            *stop = YES;
        }
    }];
    if (isExist) {
        return [QSwapHashModel getObjectWithKeyValues:[hashs objectAtIndex:index]];
    }
    return nil;
}
/// 根据原文hash删除对象
/// @param rHash 原文hash
+ (void) deleteSwapHashWithHash:(NSString *) rHash
{
    // 更新本地路由器
    NSArray *hashs = [KeyCUtil getHashWithKey:swapHashKey]?:@[];
    NSMutableArray *mutHashs = [NSMutableArray array];
    [hashs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QSwapHashModel *model = [QSwapHashModel getObjectWithKeyValues:obj];
        if (![model.rHash isEqualToString:rHash]) {
            [mutHashs addObject:[model mj_keyValues]];
        }
    }];
    [KeyCUtil saveHashTokeychainWithArr:mutHashs key:swapHashKey];
}

/// 更新本地hash状态
/// @param rHash 原文hash
/// @param state 状态
+ (void) updateSwapHashStateWithHash:(NSString *) rHash  withState:(NSInteger) state swapTxhash:(NSString *) swapTxhash
{
    // 更新本地hash状态
    NSArray *hashs = [KeyCUtil getHashWithKey:swapHashKey]?:@[];
    NSMutableArray *mutHashs = [NSMutableArray array];
    [hashs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QSwapHashModel *model = [QSwapHashModel getObjectWithKeyValues:obj];
        if ([model.rHash isEqualToString:rHash]) {
            model.state = state;
            if (swapTxhash && swapTxhash.length>0) {
                model.swaptxHash = swapTxhash;
            }
            
        }
        [mutHashs addObject:[model mj_keyValues]];
    }];
    [KeyCUtil saveHashTokeychainWithArr:mutHashs key:swapHashKey];
}
/// 更新本地hash状态
/// @param rHash 原文hash
/// @param state 状态
+ (void) updateSwapHashStateWithHash:(NSString *) rHash  withState:(NSInteger) state
{
    // 更新本地hash状态
    NSArray *hashs = [KeyCUtil getHashWithKey:swapHashKey]?:@[];
    NSMutableArray *mutHashs = [NSMutableArray array];
    [hashs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QSwapHashModel *model = [QSwapHashModel getObjectWithKeyValues:obj];
        if ([model.rHash isEqualToString:rHash]) {
            model.state = state;
        }
        [mutHashs addObject:[model mj_keyValues]];
    }];
    [KeyCUtil saveHashTokeychainWithArr:mutHashs key:swapHashKey];
}
@end
