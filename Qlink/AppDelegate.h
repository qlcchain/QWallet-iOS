//
//  AppDelegate.h
//  Qlink
//
//  Created by Jelly Foo on 2018/3/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "LoginPWModel.h"

@class MainTabBarViewController,NEOAddressInfoModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL checkPassLock;
@property (nonatomic) BOOL needFingerprintVerification;
//@property (nonatomic) BOOL openShowPresentLogin;
@property (nonatomic) BOOL pushToOrderList;
//@property (nonatomic, strong) QlinkTabbarViewController *qtabbarC;
@property (nonatomic, strong) MainTabBarViewController *mtabbarC;

- (void)addLaunchAnimation;
//- (void)setRootLogin;
- (void)setRootTabbar;
- (void)presentLoginNew;
- (void)presentFingerprintVerify:(LoginPWCompleteBlock)completeBlock;
//- (void)jumpToWallet;
//- (void)jumpToOTC;
//- (void)jumpToTopup;
//- (void)jumpToDailyEarnings;
//- (void)jumpToOTCTradeOrderDetail;
- (void)logout;

@end

