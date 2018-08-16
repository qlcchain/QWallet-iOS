//
//  VPNDataUtil.m
//  Qlink
//
//  Created by 旷自辉 on 2018/8/16.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VPNDataUtil.h"

@implementation VPNDataUtil
+ (instancetype)shareInstance {
    static VPNDataUtil *shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
        shareObject.vpnDataDic = [[NSMutableDictionary alloc] init];
    });
    return shareObject;
}
@end
