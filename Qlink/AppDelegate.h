//
//  AppDelegate.h
//  Qlink
//
//  Created by Jelly Foo on 2018/3/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "BalanceInfo.h"


@class QlinkTabbarViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BalanceInfo *balanceInfo;
@property (nonatomic , assign) BOOL checkPassLock;

@property (nonatomic, strong) QlinkTabbarViewController *tabbarC;
- (void) addLaunchAnimation;
@end

