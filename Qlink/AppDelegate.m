//
//  AppDelegate.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "AppDelegate.h"
#import "QlinkTabbarViewController.h"
#import "Qlink-Swift.h"
#import "LaunchViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "NEOWalletUtil.h"
#import <BGFMDB/BGFMDB.h>
//#import "VPNFileInputView.h"
#import "QNavigationController.h"
//#import "VPNFileUtil.h"
#import "OLImage.h"
#import "NotifactionView.h"
//#import "VPNOperationUtil.h"
#import "SystemUtil.h"
#import "WalletTransferUtil.h"
#import "NEOTransferUtil.h"
//#import "MiPushSDK.h"
#import "LoginSetPWViewController.h"
#import "LoginInputPWViewController.h"
#import "WalletCommonModel.h"
//#import "RunInBackground.h"
#import "AppDelegate+AppService.h"
#import "NSString+HexStr.h"
#import "EOSSignUtil.h"
#import "ReportUtil.h"
#import <ETHFramework/ETHFramework.h>
#import "LoginViewController.h"
#import "UserModel.h"
#import "FingerprintVerificationUtil.h"
#import "NSDate+Category.h"
#import "UserUtil.h"
#import "QLogHelper.h"
#import "ClaimQGASTipView.h"
#import "NSString+Base64.h"
#import "JPUSHService.h"
#import "JPushTagHelper.h"

@interface AppDelegate () </*MiPushSDKDelegate,*/ UNUserNotificationCenterDelegate, UIApplicationDelegate> {
//    BOOL isBackendRun;
}

//@property (nonatomic, strong) LocationTracker * locationTracker;
@property (nonatomic, strong) NSTimer* locationUpdateTimer;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:@"_UIConstraintBasedLayoutLogUnsatisfiable"]; //隐藏 constraint log
    
//    [UserModel deleteOneAccount];
//    [NEOWalletUtil deleteAllWallet];
//    [LoginPWModel deleteLoginPW];
//    [WalletCommonModel deleteAllWallet];
//    [UserModel cleanAllUser];
    
    [KeychainUtil resetKeyService]; // 先重置keyservice  以后1掉
    
    _checkPassLock = YES; // 处理tabbar连续点击的bug
    kAppD.needFingerprintVerification = YES; // 打开app允许弹出指纹验证
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
   // 配置Firebase
    [self configFirebase];
    // 配置DDLog
    [self configDDLog];
    // 配置app语言
    [self configAppLanguage];
    // 删除手机VPN配置
//    [SystemUtil deleteVPNConfig];
    // 将连接状态置为NO
//    [NeoTransferUtil updateUserDefaultVPNListCurrentVPNConnectStatus];
    // 开启VPN连接扣费
//    [NeoTransferUtil startVPNConnectTran];
    // 开启VPN上传服务器
//    [VPNFileUtil startVPNSendServerTimer];
//    // 初始化当前钱包
//    [NEOWalletUtil getCurrentWalletInfo];
    // 初始化data文件
//    [ToxManage readKeychainToLibary];
    // 初始化vpn文件
//    [VPNFileUtil keychainVPNFileToLibray];
    // 初始化手势默认为开启
    [self configTouch];
    // 配置状态栏
    [self configStatusBar];
    // 配置IQKeyboardManager
    [self keyboardManagerConfig];
    // 配置Bugly
    [self configBugly];
    // 配置FMDB
    [self configureFMDB];
    // 发送json请求
//    [ToxManage sendReqeuestToxJson];
    // 创建p2pid
    [self configToxP2PNetwork];
    // 获取用户信息
    [self fetchUserInfo];
    // 注册本地通知
    [self setUserNotifationSettings:application];
    // 配置群聊
    [self configChat];
//    // 配置小米推送
//    [self configPush];
    // 配置JPush
    [self configJPush:launchOptions];
    // Root
//    [self setTabbarRoot];
    // 是否需要显示引导页
    [self checkGuidenPage];
    // 后台定位常驻
//    [self getBackgroudLocation];

    [self.window makeKeyAndVisible];
    
    // 点击推送打开app
    [self handleLaunchWithPush:launchOptions];
    
//    [VPNFileUtil removeVPNFile];
//    [WorkUtil generateWorkOfOperationWithHash:@"642206314f534b29ad297d82440a5f9f210e30ca5ced805a587ca402de927342" handler:^(NSString * _Nonnull result) {
//    }];
    
//    [WorkUtil generateWorkOfOperationRandomWithHash:@"642206314f534b29ad297d82440a5f9f210e30ca5ced805a587ca402de927342" handler:^(NSString * _Nonnull result) {
//    }];
    
    return YES;
}

#pragma mark - 添加启动页动画
- (void)addLaunchAnimation {    
//    LaunchViewController *vc = [[LaunchViewController alloc] init];
//    self.window.rootViewController = vc;
//    NSTimeInterval timeI = [LaunchViewController getGifDuration];
//    [self performSelector:@selector(configRootAndBackground) withObject:nil afterDelay:timeI];
    
    [self configRootAndBackground];
}

- (void)configRootAndBackground {
    [self setRootTabbar];
    // 获取主地址
    [[WalletTransferUtil getShareObject] startFetchServerMainAddress];
}

#pragma mark - 初始化Tabbar
- (void)setRootTabbar {
    [WalletCommonModel walletInit]; // 钱包初始化
    [UserUtil updateUserInfo];
    
    _tabbarC = [[QlinkTabbarViewController alloc] init];
    self.window.rootViewController = _tabbarC;
    [self jumpToWallet];
    
    [SystemUtil checkAPPUpdate]; // 检查app更新
}

- (void)jumpToWallet {
    if (kAppD.needFingerprintVerification) {
        [kAppD presentFingerprintVerify:^{
            kAppD.tabbarC.selectedIndex = TabbarIndexWallet;
        }];
    } else {
        kAppD.tabbarC.selectedIndex = TabbarIndexWallet;
    }
}

- (void)jumpToOTC {
    kAppD.tabbarC.selectedIndex = TabbarIndexFinance;
}

#pragma mark - Login
//- (void)setRootLoginNew {
//    LoginViewController *vc = [[LoginViewController alloc] init];
//    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
//    self.window.rootViewController = nav;
//}

- (void)presentLoginNew {
    LoginViewController *vc = [[LoginViewController alloc] init];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    __weak typeof(vc) weakvc = vc;
    [_tabbarC.selectedViewController presentViewController:nav animated:YES completion:^{
        if ([UserModel haveAccountInLocal]) {
            [weakvc showLastLoginAccount];
        }
    }];
//    self.window.rootViewController = nav;
}

- (void)logout {
    if (![UserModel haveLoginAccount]) {
        return;
    }
    UserModel *userM = [UserModel fetchUserOfLogin];
    userM.isLogin = @(NO);
    [UserModel storeUserByID:userM];
    
    [JPushTagHelper cleanTags]; // 清除tag
    
    [[NSNotificationCenter defaultCenter] postNotificationName:User_Logout_Success_Noti object:nil];
}

//- (void)setRootLogin {
//    BOOL isExist = [LoginPWModel isExistLoginPW];
//    UIViewController *vc = nil;
//    if (isExist) {
//        vc = [[LoginInputPWViewController alloc] init];
//    } else {
//        vc = [[LoginSetPWViewController alloc] init];
//    }
//    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
//    self.window.rootViewController = nav;
//}

- (void)presentFingerprintVerify:(LoginPWCompleteBlock)completeBlock {
//    kWeakSelf(self);
    if ([ConfigUtil getLocalTouch]) {
        [FingerprintVerificationUtil show:^(BOOL success) {
            if (success) {
                kAppD.needFingerprintVerification = NO; // 设置已经输入过密码
                if (completeBlock) {
                    completeBlock();
                }
            }
        }];
    } else {
        if (completeBlock) {
            completeBlock();
        }
    }
    
//    BOOL isExist = [LoginPWModel isExistLoginPW];
//    UIViewController *vc = nil;
//    if (isExist) {
//        vc = [[LoginInputPWViewController alloc] init];
//        [((LoginInputPWViewController *)vc) configCompleteBlock:completeBlock];
//    } else {
//        vc = [[LoginSetPWViewController alloc] init];
//        [((LoginSetPWViewController *)vc) configCompleteBlock:completeBlock];
//    }
//    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
//    [[self getCurrentVC] presentViewController:nav animated:YES completion:^{}];
}

//#pragma mark - 配置小米推送
//- (void)configPush {
//    [MiPushSDK registerMiPush:self];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    _allowPresentLogin = YES; // 打开app允许弹出输入密码
    NSLog(@"backgroundTimeRemaining=%@",@(application.backgroundTimeRemaining));
    NSLog(@"applicationState=%@",@(application.applicationState));
    
    NSInteger seconds = [NSDate getTimestampFromDate:[NSDate date]] ;
    [HWUserdefault insertObj:@(seconds) withkey:In_Background_Time];
    
//    isBackendRun = YES;
//    [[RunInBackground sharedBg] startRunInbackGround];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
    [JPUSHService setBadge:0];
    
    // 进入后台大于5分钟需要开启指纹验证
    NSInteger seconds = [[HWUserdefault getObjectWithKey:In_Background_Time] integerValue];
    if (seconds == 0) {
        return;
    }
    NSDate *backDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSInteger minues = [backDate minutesAfterDate:[NSDate date]];
    if (labs(minues) >= 5) {
        [HWUserdefault insertObj:@(0) withkey:In_Background_Time];
        kAppD.needFingerprintVerification = YES;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
//    if (isBackendRun){
//        [[RunInBackground sharedBg] stopAudioPlay];
//        isBackendRun = NO;
//    }
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [SystemUtil configureAPPTerminate];
}

#pragma mark - Backgroud Location
//- (void)getBackgroudLocation {
//    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
//        DDLogDebug(@"UIBackgroundRefreshStatusDenied");
//    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
//        DDLogDebug(@"UIBackgroundRefreshStatusRestricted");
//    } else{
//        _locationTracker = [[LocationTracker alloc] init];
//        [_locationTracker startLocationTracking];
//
//        //Send the best location to server every 60 seconds
//        //You may adjust the time interval depends on the need of your app.
//        NSTimeInterval time = 60.0;
//        __weak typeof(_locationTracker) weakLocationTracker = _locationTracker;
//        _locationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:time repeats:YES block:^(NSTimer * _Nonnull timer) {
//            NSLog(@"updateLocation");
//            [weakLocationTracker updateLocationToServer];
//        }];
//    }
//}

#pragma mark - UIApplicationDelegate
//- (void)application:(UIApplication *)app
//didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    // 注册APNS成功, 注册deviceToken
//    [MiPushSDK bindDeviceToken:deviceToken];
//}
//
//- (void)application:(UIApplication *)app
//didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
//    // 注册APNS失败
//    // 自行处理
//}

#pragma mark - 注册本地通知
- (void) setUserNotifationSettings:(UIApplication *) application
{
   // if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *userCenter = [UNUserNotificationCenter currentNotificationCenter];
         userCenter.delegate = self;
         UNAuthorizationOptions options = UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert;
        //iOS 10 使用以下方法注册，才能得到授权
        [userCenter requestAuthorizationWithOptions:options
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
              if (granted) { // 用户允许
                  
              } else {  // 用户不允许
                  
              }
          }];

//    } else {
//        // Fallback on earlier versions
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
//        [application registerUserNotificationSettings:settings];
//    }
}

//// ios 8 ~ ios 10 之前回调
//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    // app 在前台时显示提示
//    if (application.applicationState == UIApplicationStateActive) {
//        NSDictionary *dic = notification.userInfo;
//        [self showNotificationAlertViewWtihDic:dic];
//    }
//}

//// 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
//- (void) userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)) {
//
//}

//// 这个方法是在后台或者程序被杀死的时候，点击通知栏调用的，在前台的时候不会被调用
//- (void) userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
//
//}

/**
 前台显示通知
 */
- (void) showNotificationAlertViewWtihDic:(NSDictionary *) userInfo {
    NotifactionView *notiView = [NotifactionView loadNotifactionView];
    notiView.lblTtile.text = [userInfo objectForKey:@"title"];
    notiView.lblSubTitle.text =[userInfo objectForKey:@"body"];
    [notiView show];
}

#pragma mark - 收到推送
//- ( void )application:( UIApplication *)application didReceiveRemoteNotification:( NSDictionary *)userInfo
//{
//    [ MiPushSDK handleReceiveRemoteNotification :userInfo];
//    // 使用此方法后，所有消息会进行去重，然后通过miPushReceiveNotification:回调返回给App
//}
//
//// iOS10新加入的回调方法
//// 应用在前台收到通知
//- (void) userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)) {
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [MiPushSDK handleReceiveRemoteNotification:userInfo];
//    }
//
//    if ([notification.request.trigger isKindOfClass:[UNTimeIntervalNotificationTrigger class]]) {
//        NSDictionary *dic = notification.request.content.userInfo;
//        [self showNotificationAlertViewWtihDic:dic];
//    }
//
//    //    completionHandler(UNNotificationPresentationOptionAlert);
//}
//
//// 点击通知进入应用
//- (void) userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)) {
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [MiPushSDK handleReceiveRemoteNotification:userInfo];
//    }
//    completionHandler();
//}
//
//#pragma mark - MiPushSDKDelegate
//- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data {
//    // 请求成功
//    // 可在此获取regId
//    DDLogDebug(@"小米推送请求方法 selector = %@ data = %@",selector,data);
//    if ([selector isEqualToString:@"bindDeviceToken:"]) {
//        DDLogDebug(@"regid = %@", data[@"regid"]);
//    }
//}
//
//- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data {
//    // 请求失败
//    DDLogDebug(@"小米推送失败方法  selector = %@  error = %i  data = %@",selector,error,data);
//}


#pragma mark - 第三方app传输文件回调
//#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
//{
//
//    return YES;
//}
//
//#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
//    if ([_window.rootViewController isKindOfClass:[QlinkTabbarViewController class]]) {
//        [self performSelector:@selector(showVPNFileView:) withObject:url afterDelay:.5f];
//    } else {
//        NSTimeInterval timeI = [LaunchViewController getGifDuration];
//        [self performSelector:@selector(showVPNFileView:) withObject:url afterDelay:timeI + 0.2f];
//    }
    
    // H5微信支付的回调
    if ([url.scheme isEqualToString:Weixin_Pay_Url_Scheme]) {
        NSLog(@"********走微信支付回调 %@",url);
        [[NSNotificationCenter defaultCenter] postNotificationName:Weixin_Pay_Back_Noti object:nil];
    }
    
    return YES;
}
//#endif

- (void) showVPNFileView:(NSURL *) url {
    NSString *fileURL = url.absoluteString;
    NSArray *array = [fileURL componentsSeparatedByString:@"."];
    NSString *fileName = [array lastObject];
    if(array && [fileName isEqualToString:@"ovpn"]) {
        array = [fileURL componentsSeparatedByString:@"/"];
        NSString *vpnFileName = [[array lastObject] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        VPNFileInputView *fileView = [VPNFileInputView loadVPNFileInputView];
//        fileView.lblMsg.text = NSStringLocalizable(@"save_ovpn");
//        fileView.txtFileName.text = [vpnFileName stringByReplacingOccurrencesOfString:@".ovpn" withString:@""];
//        fileView.vpnURL = url;
//         UIWindow *win = [UIApplication sharedApplication].keyWindow;
//        [fileView showVPNFileInputView:win];
    }
}

#pragma mark - 点击推送启动app
- (void)handleLaunchWithPush:(NSDictionary *)launchOptions {
    // 处理点击通知打开app的逻辑
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo){//推送信息
//        NSString *messageId = [userInfo objectForKey:@"_id_"];
//        if (messageId!=nil) {
//            [MiPushSDK openAppNotify:messageId];
//        }
    }
}

///**
// *  获取异常崩溃信息   上传data 到keychain
// */
//void UncaughtExceptionHandler(NSException *exception) {
//    [SystemUtil configureAPPTerminate];
//    //    NSArray *callStack = [exception callStackSymbols];
//    //    NSString *reason = [exception reason];
//    //    NSString *name = [exception name];
//    //    NSString *content = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
//    //    DDLogDebug(@"%@",content);
//}

@end


