//
//  DBManageUtil.h
//  Qlink
//
//  Created by 旷自辉 on 2018/6/15.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VPNInfo;

@interface DBManageUtil : NSObject

+ (void) updateDBversion;
+ (VPNInfo *)getVpnInfo:(NSString *)vpnName;

@end
