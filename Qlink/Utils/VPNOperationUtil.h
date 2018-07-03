//
//  VPNDataUtil.h
//  Qlink
//
//  Created by 旷自辉 on 2018/5/4.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNMode.h"

typedef enum : NSUInteger {
    registerConnect,
    normalConnect,
} VPNConnectOperationType;

@interface VPNOperationUtil : NSObject

@property (nonatomic) VPNConnectOperationType operationType;

+ (instancetype) shareInstance;

// 将vpn资产表存入keychain
+ (void) saveArrayToKeyChain;
// 将keychain中的资产导入资产表中
+ (void) keyChainDataToDB;

@end
