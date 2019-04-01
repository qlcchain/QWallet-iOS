//
//  VPNDataUtil.m
//  Qlink
//
//  Created by 旷自辉 on 2018/8/16.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VPNDataUtil.h"
#import "MD5Util.h"
#import "NSString+Base64.h"

@implementation VPNDataUtil

+ (instancetype)shareInstance {
    static VPNDataUtil *shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
        shareObject.vpnDataDic = [[NSMutableDictionary alloc] init];
        shareObject.sendVpnFileListRspArr = [[NSMutableArray alloc] init];
        shareObject.sendVpnFileNewRspArr = [[NSMutableArray alloc] init];
    });
    return shareObject;
}

- (BOOL)handleVpnFileListRsp:(NSDictionary *)inputDic {
    __block BOOL isExist = NO;
    [self.sendVpnFileListRspArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *tempDic = obj;
        if ([inputDic isEqualToDictionary:tempDic]) {
            isExist = YES;
            *stop = YES;
        }
    }];
    if (!isExist) { // 不存在则添加
        [self.sendVpnFileListRspArr addObject:inputDic];
    }
    
    // {“msgid”:111, “msglen”:20000, “msg”:”xxxxxx”, “more”:1, “offset”:1000, ”md5”:”xxxxxxxxxx” }
    NSMutableString *allMsgStr = [NSMutableString string];
    __block NSInteger strLength = 0;
    __block NSString *md5Str = @"";
    [self.sendVpnFileListRspArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        [allMsgStr appendString:dic[@"msg"]];
        strLength = [dic[@"msglen"] integerValue];
        md5Str = dic[@"md5"];
    }];
    
    if (allMsgStr.length >= strLength) { // 如果接收的所有消息长度大于等于总消息长度  可以拼接
        // 先排序
        [self.sendVpnFileListRspArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSDictionary *dic1 = obj1;
            NSInteger offset1 = [dic1[@"offset"] integerValue];
            NSDictionary *dic2 = obj2;
            NSInteger offset2 = [dic2[@"offset"] integerValue];
            return offset1>offset2;
        }];
        
        // 拼接
        NSMutableString *resultStr = [NSMutableString string];
        [self.sendVpnFileListRspArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            NSString *tempMsg = dic[@"msg"];
            [resultStr appendString:tempMsg];
        }];
        
        NSString *resultMd5 = [MD5Util md5:resultStr];
        if ([resultMd5 isEqualToString:md5Str]) { // 验证md5
            self.sendVpnFileListRspMsg = resultStr;
            return YES;
        } else {
        }
    } else {
    }
    
    return NO;
}

- (BOOL)handleVpnFileNewRsp:(NSDictionary *)inputDic {
    __block BOOL isExist = NO;
    [self.sendVpnFileNewRspArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *tempDic = obj;
        if ([inputDic isEqualToDictionary:tempDic]) {
            isExist = YES;
            *stop = YES;
        }
    }];
    if (!isExist) { // 不存在则添加
        [self.sendVpnFileNewRspArr addObject:inputDic];
    }
    
    // {“msgid”:111, “msglen”:20000, “msg”:”xxxxxx”, “more”:1, “offset”:1000, ”md5”:”xxxxxxxxxx” }
    NSMutableString *allMsgStr = [NSMutableString string];
    __block NSInteger strLength = 0;
    __block NSString *md5Str = @"";
    [self.sendVpnFileNewRspArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        [allMsgStr appendString:dic[@"msg"]];
        strLength = [dic[@"msglen"] integerValue];
        md5Str = dic[@"md5"];
    }];
    
    if (allMsgStr.length >= strLength) { // 如果接收的所有消息长度大于等于总消息长度  可以拼接
        // 先排序
        [self.sendVpnFileNewRspArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSDictionary *dic1 = obj1;
            NSInteger offset1 = [dic1[@"offset"] integerValue];
            NSDictionary *dic2 = obj2;
            NSInteger offset2 = [dic2[@"offset"] integerValue];
            return offset1>offset2;
        }];
        
        // 拼接
        NSMutableString *resultStr = [NSMutableString string];
        [self.sendVpnFileNewRspArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            NSString *tempMsg = dic[@"msg"];
            [resultStr appendString:tempMsg];
        }];
        
        NSString *resultMd5 = [MD5Util md5:resultStr];
        if ([resultMd5 isEqualToString:md5Str]) { // 验证md5
            self.sendVpnFileNewRspMsg = [resultStr base64DecodedString];
            return YES;
        } else {
        }
    } else {
    }
    
    return NO;
}

@end
