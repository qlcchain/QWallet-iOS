//
//  QlinkTabbarViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2018/3/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "QlinkTabbarViewController.h"
#import "WifiViewController.h"
#import "WalletViewController.h"
#import "VpnViewController.h"
#import "QlinkNavViewController.h"
#import "UIView+Gradient.h"
#import "NounView.h"
#import <Masonry/Masonry.h>
#import "WalletUtil.h"


#define tabbaritems 3

@interface QlinkTabbarViewController ()<UITabBarControllerDelegate>

@property (nonatomic , strong) NounView *nounView;

@end

@implementation QlinkTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置tintColor -> 统一设置tabBar的选中颜色
    // 越早设置越好，一般放到AppDelegate中
    // 或者：设置图片渲染模式、设置tabBar文字
//    [[UITabBar appearance] setTintColor:[UIColor clearColor]];
    [[UITabBar appearance] setBarTintColor:MAIN_PURPLE_COLOR];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
//    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    // 添加阴影
    self.tabBar.layer.shadowColor = SHADOW_COLOR.CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -5);
    self.tabBar.layer.shadowOpacity = 0.3;
    // 添加渐变背景
//    [self.tabBar addQGradient];
    self.delegate = self;
    
    [self addChildViewController:[[VpnViewController alloc] init] text:NSStringLocalizable(@"vpn") imageName:@"tab_vpn"];
    [self addChildViewController:[[WifiViewController alloc] init] text:NSStringLocalizable(@"wifi") imageName:@"tab_wifi"];
    [self addChildViewController:[[WalletViewController alloc] init] text:NSStringLocalizable(@"wallet") imageName:@"tab_wallet"];
    
}

- (void) addChildViewController:(UIViewController *) childController text:(NSString *) text imageName:(NSString *) imageName {
    // 设置item图片不渲染
    childController.tabBarItem.image = [[UIImage imageNamed:[imageName stringByAppendingString:@"_normal"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:[imageName stringByAppendingString:@"_highlight"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置标题的属性
    [childController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"VAGRoundedBT-Regular" size:10],NSForegroundColorAttributeName:[UIColor colorWithRed:115/255.0 green:48/255.0 blue:166/255.0 alpha:1.0]} forState:UIControlStateNormal];
    [childController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"VAGRoundedBT-Regular" size:10],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    
    // 设置item的标题
    childController.tabBarItem.title = text;
    childController.navigationItem.title = text;
    childController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
    
    QlinkNavViewController *nav = [[QlinkNavViewController alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];
}

#pragma mark - UITabBarControllerDelegate-
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    if ([((QlinkNavViewController *)viewController).topViewController isKindOfClass:[WalletViewController class]]){
//
//    }
//    return YES;
//}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex == 2) {
        if (AppD.checkPassLock) {
            [WalletUtil checkWalletPassAndPrivateKey:(WalletViewController *)(((QlinkNavViewController *)viewController).topViewController) TransitionFrom:CheckProcess_WALLET_TABBAR];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
