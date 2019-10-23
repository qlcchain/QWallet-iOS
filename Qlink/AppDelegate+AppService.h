//
//  AppDelegate+AppService.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/29.
//  Copyright © 2018 pan. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (AppService)

- (void)configFirebase;
- (void)configDDLog;
- (void)configAppLanguage;
- (void)configTouch;
- (void)configStatusBar;
- (void)keyboardManagerConfig;
- (void)configBugly;
- (void)configureFMDB;
- (void)configToxP2PNetwork;
- (void)fetchUserInfo;
- (void)configChat;
- (void)checkGuidenPage;
- (void)configJPush:(NSDictionary *)launchOptions;

/**
 当前顶层控制器
 */
- (UIViewController *)getCurrentVC;
- (UIViewController *)getCurrentUIVC;

@end

NS_ASSUME_NONNULL_END
