//
//  SystemUtil.h
//  Qlink
//
//  Created by 旷自辉 on 2018/4/11.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemUtil : NSObject

+ (NSString *) uuidString;
// 得到时间戳
+ (NSString *) getTimeInterval;

/**
 app退出时。配置
 */
+ (void) configureAPPTerminate;
//+ (void)deleteVPNConfig;
+ (void)checkAPPUpdate;
+ (void)requestLogout:(void (^)(void))completeBlock;
+ (void)requestBind_jpush;

@end
