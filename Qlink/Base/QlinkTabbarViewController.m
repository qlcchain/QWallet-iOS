//
//  QlinkTabbarViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2018/3/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "QlinkTabbarViewController.h"
//#import "WifiViewController.h"
#import "MarketsViewController.h"
//#import "SettingsViewController.h"
#import "MyViewController.h"
//#import "WalletViewController.h"
#import "WalletsViewController.h"
//#import "VpnViewController.h"
//#import "VPNViewController.h"
#import "FinanceViewController.h"
#import "HomeBuySellViewController.h"
//#import "QlinkNavViewController.h"
#import "QNavigationController.h"
#import "UIView+Gradient.h"
//#import "NounView.h"
#import <Masonry/Masonry.h>
#import "NEOWalletUtil.h"
#import "GlobalConstants.h"
#import "UIColor+Random.h"
#import "TopupViewController.h"

//static NSInteger const tabbaritems = 3;

@interface QlinkTabbarViewController ()<UITabBarControllerDelegate>

//@property (nonatomic , strong) NounView *nounView;

@end

@implementation QlinkTabbarViewController

#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeNoti:) name:kLanguageChangeNoti object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserve];
    
    [UITabBar appearance].translucent = NO;
    
    // 设置tintColor -> 统一设置tabBar的选中颜色
    // 越早设置越好，一般放到AppDelegate中
    // 或者：设置图片渲染模式、设置tabBar文字
//    [[UITabBar appearance] setTintColor:UIColorFromRGB(0xfefefe)];
    [[UITabBar appearance] setBarTintColor:MAIN_WHITE_COLOR];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
//    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundColor:MAIN_WHITE_COLOR];
    // 添加阴影
    self.tabBar.layer.shadowColor = UIColorFromRGB(0xdddddd).CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -5);
    self.tabBar.layer.shadowOpacity = 0.3;
    // 添加渐变背景
//    [self.tabBar addQGradient];
    self.delegate = self;
    
    _walletsVC = [[WalletsViewController alloc] init];
    _topupVC = [[TopupViewController alloc] init];
    [self addChildViewController:_topupVC text:kLang(@"top_up") imageName:@"topup"];
//    [self addChildViewController:[[FinanceViewController alloc] init] text:@"Finance" imageName:@"finance"];
    [self addChildViewController:[[HomeBuySellViewController alloc] init] text:kLang(@"finance") imageName:@"finance"];
//    [self addChildViewController:[[MarketsViewController alloc] init] text:@"Markets" imageName:@"markets"];
    [self addChildViewController:_walletsVC text:kLang(@"wallet") imageName:@"wallet"];
    [self addChildViewController:[[MyViewController alloc] init] text:kLang(@"me") imageName:@"settings"];
}

- (void) addChildViewController:(UIViewController *) childController text:(NSString *) text imageName:(NSString *) imageName {
    // 设置item图片不渲染
    childController.tabBarItem.image = [[UIImage imageNamed:[imageName stringByAppendingString:@"_n"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:[imageName stringByAppendingString:@"_h"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置标题的属性
    [childController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x676767)} forState:UIControlStateNormal]; //[UIFont fontWithName:@"VAGRoundedBT-Regular" size:12]
    [childController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor mainColor]} forState:UIControlStateSelected];
    
    // 设置item的标题
    childController.tabBarItem.title = text;
    childController.navigationItem.title = text;
    childController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
    
//    QlinkNavViewController *nav = [[QlinkNavViewController alloc] initWithRootViewController:childController];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:childController];
    
    [self addChildViewController:nav];
}

#pragma mark - UITabBarControllerDelegate-
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UIViewController *topVC = ((QNavigationController *)viewController).topViewController;
    if ([topVC isKindOfClass:[WalletsViewController class]]){
        if (kAppD.needFingerprintVerification) {
            [kAppD presentFingerprintVerify:^{
                kAppD.tabbarC.selectedIndex = TabbarIndexWallet;
            }];
            return NO;
        }
    }
//    if ([topVC isKindOfClass:[MyViewController class]]){
//        if (kAppD.allowPresentLogin) {
//            [kAppD presentLogin:^{
//                kAppD.tabbarC.selectedIndex = TabbarIndexMy;
//            }];
//            return NO;
//        }
//    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    if (tabBarController.selectedIndex == 1) {
//        if (kAppD.checkPassLock) {
//            [WalletUtil checkWalletPassAndPrivateKey:(WalletViewController *)(((QlinkNavViewController *)viewController).topViewController) TransitionFrom:CheckProcess_WALLET_TABBAR];
//        }
//    }
}

#pragma mark - Noti
- (void)languageChangeNoti:(NSNotification *)noti {
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == TabbarIndexTopup) {
            obj.title = kLang(@"top_up");
        } else if (idx == TabbarIndexFinance) {
            obj.title = kLang(@"finance");
        } else if (idx == TabbarIndexWallet) {
            obj.title = kLang(@"wallet");
        } else if (idx == TabbarIndexMy) {
            obj.title = kLang(@"me");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
