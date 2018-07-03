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
#import "WalletUtil.h"
#import "DDLogUtil.h"
#import <Bugly/Bugly.h>
#import <BGFMDB/BGFMDB.h>
#import "VPNFileInputView.h"
#import "QlinkNavViewController.h"
#import "VPNFileUtil.h"
#import "OLImage.h"
#import "NotifactionView.h"
#import "ChatUtil.h"
#import "VPNOperationUtil.h"
#import <BGFMDB/BGDB.h>
#import "SystemUtil.h"
#import "TransferUtil.h"
#import "MiPushSDK.h"
#import "NSBundle+Language.h"
#import "DBManageUtil.h"
#import "GuidePageViewController.h"

@interface AppDelegate () <MiPushSDKDelegate, UNUserNotificationCenterDelegate, UIApplicationDelegate> {
    UIBackgroundTaskIdentifier backTaskI;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _checkPassLock = YES; // 处理tabbar连续点击的bug
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   // [WalletUtil removeAllKey];

    // 配置DDLog
    [self configDDLog];
    // 配置app语言
    [self configAppLanguage];
    // 配置主网钱包 0-测试网。1- 主网
    [self configServerNetwork];
    // 开启VPN连接扣费
    [TransferUtil startVPNConnectTran];
    // 初始化当前钱包
    [WalletUtil getCurrentWalletInfo];
    // 初始化data文件
    [ToxManage readKeychainToLibary];
    // 初始化vpn文件
    [VPNFileUtil keychainVPNFileToLibray];
    // 初始化手势默认为开启·
    [self configTouch];
    // 配置状态栏
    [self configStatusBar];
    // 配置IQKeyboardManager
    [self keyboardManagerConfig];
    // 配置Bugly
    [self configBugly];
    // 配置项目崩溃捕获
    [self configExceptionHandler];
    // 配置FMDB
    [self configureFMDB];
    // 发送json请求
    [ToxManage sendReqeuestToxJson];
    // 创建p2pid
    [self configToxP2PNetwork];
    // 获取用户信息
    [self fetchUserInfo];
    // 注册本地通知
    [self setUserNotifationSettings:application];
    // 配置群聊
    [self configChat];
    // 配置小米推送
    [self configPush];
    // Root
//    [self setTabbarRoot];
    // 是否需要显示引导页
    [self checkGuidenPage];

    [self.window makeKeyAndVisible];
    
    // 点击推送打开app
    [self handleLaunchWithPush:launchOptions];
    
//    [VPNFileUtil removeVPNFile];
    
    return YES;
}

// 是否需要显示引导页
- (void) checkGuidenPage
{
    NSString *version = [HWUserdefault getStringWithKey:VERSION_KEY];
    if (![[NSStringUtil getNotNullValue:version] isEqualToString:APP_Version]) {
        [HWUserdefault insertString:APP_Version withkey:VERSION_KEY];
        GuidePageViewController *pageVC = [[GuidePageViewController alloc] init];
        self.window.rootViewController = pageVC;
    } else {
        [self addLaunchAnimation];
    }
}

#pragma mark - 配置Bugly
- (void)configBugly {
    [Bugly startWithAppId:Bugly_AppID];
}
#pragma mark - 配置手势 默认开启
- (void) configTouch {
    NSString *touchStatu = [HWUserdefault getStringWithKey:TOUCH_SWITCH_KEY];
    if ([[NSStringUtil getNotNullValue:touchStatu] isEmptyString]) {
        [HWUserdefault insertString:@"1" withkey:TOUCH_SWITCH_KEY];
    }
}
#pragma mark -// 配置主网钱包 0-测试网。1- 主网
- (void) configServerNetwork {
    NSString *serverNetwork = [HWUserdefault getStringWithKey:SERVER_NETWORK];
    if ([[NSStringUtil getNotNullValue:serverNetwork] isEmptyString]) {
        [HWUserdefault insertString:@"0" withkey:SERVER_NETWORK];
    }
}
#pragma mark - 配置App语言
- (void) configAppLanguage {
    NSString *languages = [[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGES];
    if (languages && ![languages isEqualToString:@""]) {
        [NSBundle setLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGES]];
    }
}
#pragma mark - 配置DDLog
- (void)configDDLog {
    //开启DDLog 颜色
//    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
//    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:DDLogFlagVerbose];
    
    //配置DDLog
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
//    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7; // 7
    [DDLog addLogger:fileLogger];
    
    //针对单个文件配置DDLog打印级别，尚未测试
    //    [DDLog setLevel:DDLogLevelAll forClass:nil];
    
//    DDLogVerbose(@"Verbose");
//    DDLogDebug(@"Debug");
//    DDLogInfo(@"Info");
//    DDLogWarn(@"Warn");
//    DDLogError(@"Error");
    
    [DDLogUtil getDDLog];
}

#pragma mark - 获取用户信息
- (void)fetchUserInfo {
    [UserManage fetchUserInfo];
}

#pragma mark - 设置IQKeyboardManager
- (void) keyboardManagerConfig {
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:15]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}

#pragma mark - 配置项目崩溃捕获
- (void) configExceptionHandler
{
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

#pragma mark - 创建p2pid
- (void) configToxP2PNetwork {
    // 初始化实列。并创建c回调
    [ToxManage shareMange];
    // 创建p2p连接网络
    [ToxManage createdP2PNetwork];
}

#pragma mark - 添加启动页动画
- (void)addLaunchAnimation {
    LaunchViewController *vc = [[LaunchViewController alloc] init];
    self.window.rootViewController = vc;
    NSTimeInterval timeI = [LaunchViewController getGifDuration];
    [self performSelector:@selector(setTabbarRoot) withObject:nil afterDelay:timeI];
}

#pragma mark - 初始化Tabbar
- (void)setTabbarRoot {
    _tabbarC = [[QlinkTabbarViewController alloc] init];
    self.window.rootViewController = _tabbarC;
}

#pragma mark - 配置状态栏
- (void)configStatusBar {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - 配置群聊
- (void)configChat {
    [ChatUtil shareInstance];
}

#pragma mark - 配置小米推送
- (void)configPush {
    [MiPushSDK registerMiPush:self];
}

#pragma mark - 配置FMDB
- (void) configureFMDB
{
    /**
     想测试更多功能,打开注释掉的代码即可.
     */
    bg_setDebug(YES);//打开调试模式,打印输出调试信息.
    
    /**
     如果频繁操作数据库时,建议进行此设置(即在操作过程不关闭数据库);
     */
    bg_setDisableCloseDB(YES);
    
    /**
     自定义数据库名称，否则默认为BGFMDB
     */
    bg_setSqliteName(@"Qlink_DataBase");
    // 判断表名是否存在
    if (![[BGDB shareManager] bg_isExistWithTableName:VPNREGISTER_TABNAME]) {
         [VPNOperationUtil keyChainDataToDB];
    }
    [DBManageUtil updateDBversion];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    @weakify_self
    backTaskI = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(){
        // 程序在10分钟内未被系统关闭或者强制关闭，则程序会调用此代码块，可以在这里做一些保存或者清理工作
//        [SystemUtil configureAPPTerminate];
//        [weakSelf endBackTask];
    }];
}

- (void)endBackTask {
    [[UIApplication sharedApplication] endBackgroundTask:backTaskI];
    backTaskI = UIBackgroundTaskInvalid;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [SystemUtil configureAPPTerminate];
}

#pragma mark - UIApplicationDelegate
- (void)application:(UIApplication *)app
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 注册APNS成功, 注册deviceToken
    [MiPushSDK bindDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)app
didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    // 注册APNS失败
    // 自行处理
}

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
- (void) showNotificationAlertViewWtihDic:(NSDictionary *) userInfo
{
    NotifactionView *notiView = [NotifactionView loadNotifactionView];
   
    notiView.lblTtile.text = [userInfo objectForKey:@"title"];
    notiView.lblSubTitle.text =[userInfo objectForKey:@"body"];
    [notiView show];
}

#pragma mark - 收到推送
- ( void )application:( UIApplication *)application didReceiveRemoteNotification:( NSDictionary *)userInfo
{
    [ MiPushSDK handleReceiveRemoteNotification :userInfo];
    // 使用此方法后，所有消息会进行去重，然后通过miPushReceiveNotification:回调返回给App
}

// iOS10新加入的回调方法
// 应用在前台收到通知
- (void) userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)) {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [MiPushSDK handleReceiveRemoteNotification:userInfo];
    }
    
    if ([notification.request.trigger isKindOfClass:[UNTimeIntervalNotificationTrigger class]]) {
        NSDictionary *dic = notification.request.content.userInfo;
        [self showNotificationAlertViewWtihDic:dic];
    }
    
    //    completionHandler(UNNotificationPresentationOptionAlert);
}

// 点击通知进入应用
- (void) userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)) {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [MiPushSDK handleReceiveRemoteNotification:userInfo];
    }
    completionHandler();
}

#pragma mark - MiPushSDKDelegate
- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data {
    // 请求成功
    // 可在此获取regId
    DDLogDebug(@"小米推送请求方法 selector = %@ data = %@",selector,data);
    if ([selector isEqualToString:@"bindDeviceToken:"]) {
        DDLogDebug(@"regid = %@", data[@"regid"]);
    }
}

- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data {
    // 请求失败
    DDLogDebug(@"小米推送失败方法  selector = %@  error = %i  data = %@",selector,error,data);
}


#pragma mark -第三方app传输文件回调
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
{

    return YES;
}

#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
//    NSString *fileURL = url.absoluteString;
//    NSArray *array = [fileURL componentsSeparatedByString:@"."];
//    NSString *fileName = [array lastObject];
//    if(array && [fileName isEqualToString:@"ovpn"]) {
//        array = [fileURL componentsSeparatedByString:@"/"];
//        NSString *vpnFileName = [array lastObject];
//
//        [self performSelector:@selector(showVPNFileView:) withObject:url afterDelay:4.0];
//
//        VPNFileInputView *fileView = [VPNFileInputView loadVPNFileInputView];
//        fileView.lblMsg.text =@"Save as the current file name ?";
//        fileView.txtFileName.text = [vpnFileName stringByReplacingOccurrencesOfString:@".ovpn" withString:@""];
//        fileView.vpnURL = url;
//       // UIWindow *win = [UIApplication sharedApplication].keyWindow;
//        [fileView showVPNFileInputView:_window];
//    }
    
    if ([_window.rootViewController isKindOfClass:[QlinkTabbarViewController class]]) {
        [self performSelector:@selector(showVPNFileView:) withObject:url afterDelay:.5f];
    } else {
        NSTimeInterval timeI = [LaunchViewController getGifDuration];
        [self performSelector:@selector(showVPNFileView:) withObject:url afterDelay:timeI + 0.2f];
    }
    
    return YES;
}
#endif
- (void) showVPNFileView:(NSURL *) url
{
    NSString *fileURL = url.absoluteString;
    NSArray *array = [fileURL componentsSeparatedByString:@"."];
    NSString *fileName = [array lastObject];
    if(array && [fileName isEqualToString:@"ovpn"]) {
        array = [fileURL componentsSeparatedByString:@"/"];
        NSString *vpnFileName = [[array lastObject] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        VPNFileInputView *fileView = [VPNFileInputView loadVPNFileInputView];
        fileView.lblMsg.text =@"Save as the current file name ?";
        fileView.txtFileName.text = [vpnFileName stringByReplacingOccurrencesOfString:@".ovpn" withString:@""];
        fileView.vpnURL = url;
         UIWindow *win = [UIApplication sharedApplication].keyWindow;
        [fileView showVPNFileInputView:win];
    }
}

#pragma mark - 点击推送启动app
- (void)handleLaunchWithPush:(NSDictionary *)launchOptions {
    // 处理点击通知打开app的逻辑
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo){//推送信息
        NSString *messageId = [userInfo objectForKey:@"_id_"];
        if (messageId!=nil) {
            [MiPushSDK openAppNotify:messageId];
        }
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"gg" message:[NSString stringWithFormat:@"%@", userInfo] preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *act = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//        [alert addAction:act];
//        [nav presentViewController:alert animated:YES completion:nil];
    }
}

/**
 *  获取异常崩溃信息   上传data 到keychain
 */
void UncaughtExceptionHandler(NSException *exception) {
    
    [SystemUtil configureAPPTerminate];
    //    NSArray *callStack = [exception callStackSymbols];
    //    NSString *reason = [exception reason];
    //    NSString *name = [exception name];
    //    NSString *content = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    //    DDLogDebug(@"%@",content);
}

@end


