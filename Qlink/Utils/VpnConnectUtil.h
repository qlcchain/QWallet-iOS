//
//  VpnConnectUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2018/7/10.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VPNInfo;

@interface VpnConnectUtil : NSObject

@property (nonatomic, strong) VPNInfo *vpnInfo;

+ (instancetype)shareInstance;
//- (instancetype)initWithVpn:(VPNInfo *)vpnInfo;
- (void)checkConnect;
//- (void)connectAction;

@end
