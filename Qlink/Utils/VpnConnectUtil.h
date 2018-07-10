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

- (instancetype)initWithVpn:(VPNInfo *)vpnInfo;
- (void)checkConnect;
//- (void)connectAction;

@end
