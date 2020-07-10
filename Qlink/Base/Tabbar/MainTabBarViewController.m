//
//  MainTabBarViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/4/2.
//  Copyright © 2020 pan. All rights reserved.
//

#import "MainTabBarViewController.h"
//#import "WifiViewController.h"
//#import "MarketsViewController.h"
//#import "SettingsViewController.h"
#import "MyViewController.h"
//#import "WalletViewController.h"
#import "WalletsViewController.h"
//#import "VpnViewController.h"
//#import "VPNViewController.h"
//#import "FinanceViewController.h"
#import "HomeBuySellViewController.h"
//#import "QlinkNavViewController.h"
#import "QNavigationController.h"
#import "UIView+Gradient.h"
//#import "NounView.h"
#import <Masonry/Masonry.h>
#import "NEOWalletUtil.h"
#import "GlobalConstants.h"
#import "UIColor+Random.h"
//#import "Topup3ViewController.h"
#import "Topup4ViewController.h"
#import "DeFiHomeViewController.h"

@interface MainTabBarViewController () <UITabBarControllerDelegate,CYLTabBarControllerDelegate>
{
    NSInteger firstCount; // 记录第一次图标不动画
}
@end

@implementation MainTabBarViewController

//- (instancetype)init {
//   if (!(self = [super init])) {
//       return nil;
//   }
//   /**
//    * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
//    * 等效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
//    * 更推荐后一种做法。
//    */
//   UIEdgeInsets imageInsets = UIEdgeInsetsZero;//UIEdgeInsetsMake(4.5, 0, -4.5, 0);
//   UIOffset titlePositionAdjustment = UIOffsetMake(0, -3.5);
//   CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers tabBarItemsAttributes:self.tabBarItemsAttributesForController imageInsets:imageInsets titlePositionAdjustment:titlePositionAdjustment context:nil];
//   [self customizeTabBarAppearance:tabBarController];
//    self.delegate = self;
//   self.navigationController.navigationBar.hidden = YES;
//   return (self = (MainTabBarViewController *)tabBarController);
//}

- (instancetype)initWithContext:(NSString *)context {
    /**
     * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
     * 等 效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
     * 更推荐后一种做法。
     */
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;//UIEdgeInsetsMake(4.5, 0, -4.5, 0);
    UIOffset titlePositionAdjustment = UIOffsetMake(0, -3.5);
    if (self = [super initWithViewControllers:[self viewControllersForTabBar]
                        tabBarItemsAttributes:[self tabBarItemsAttributesForTabBar]
                                  imageInsets:imageInsets
                      titlePositionAdjustment:titlePositionAdjustment
                                      context:context
                ]) {
        [self customizeTabBarAppearance];
        self.delegate = self;
        self.navigationController.navigationBar.hidden = YES;
        
        [[UITabBar appearance] setBarTintColor:MAIN_WHITE_COLOR];
        [[UITabBar appearance] setShadowImage:[UIImage new]];
        [[UITabBar appearance] setBackgroundColor:MAIN_WHITE_COLOR];
        
        // 添加阴影
        self.tabBar.layer.shadowColor = UIColorFromRGB(0xdddddd).CGColor;
        self.tabBar.layer.shadowOffset = CGSizeMake(0, -5);
        self.tabBar.layer.shadowOpacity = 0.3;
        
    }
    return self;
}

- (NSArray *)viewControllersForTabBar {
    _walletsVC = [[WalletsViewController alloc] init];
    QNavigationController *walletsNav = [[QNavigationController alloc] initWithRootViewController:_walletsVC];
//    [_walletsVC cyl_setHideNavigationBarSeparator:YES];
    
    _topupVC = [[Topup4ViewController alloc] init];
    QNavigationController *topupNav = [[QNavigationController alloc] initWithRootViewController:_topupVC];
//    [_topupVC cyl_setHideNavigationBarSeparator:YES];
    
//    _defiVC = [DeFiHomeViewController new];
//    QNavigationController *defiNav = [[QNavigationController alloc] initWithRootViewController:_defiVC];
    
    _homeBuySellVC = [[HomeBuySellViewController alloc] init];
    QNavigationController *otcNav = [[QNavigationController alloc] initWithRootViewController:_homeBuySellVC];
//    [_homeBuySellVC cyl_setHideNavigationBarSeparator:YES];
    
    MyViewController *myVC = [[MyViewController alloc] init];
    QNavigationController *myNav = [[QNavigationController alloc] initWithRootViewController:myVC];
//    [myVC cyl_setHideNavigationBarSeparator:YES];
    
    
//    [self addChildViewController:_topupVC text:kLang(@"top_up") imageName:@"topup"];
////    [self addChildViewController:[[FinanceViewController alloc] init] text:@"Finance" imageName:@"finance"];
//    [self addChildViewController:_homeBuySellVC text:kLang(@"finance") imageName:@"finance"];
////    [self addChildViewController:[[MarketsViewController alloc] init] text:@"Markets" imageName:@"markets"];
//    [self addChildViewController:_walletsVC text:kLang(@"wallet") imageName:@"wallet"];
//    [self addChildViewController:[[MyViewController alloc] init] text:kLang(@"me") imageName:@"settings"];
    
//   CYLHomeViewController *firstViewController = [[CYLHomeViewController alloc] init];
//   UIViewController *firstNavigationController = [[CYLBaseNavigationController alloc]
//                                                  initWithRootViewController:firstViewController];
//   [firstViewController cyl_setHideNavigationBarSeparator:YES];
//   CYLSameCityViewController *secondViewController = [[CYLSameCityViewController alloc] init];
//   UIViewController *secondNavigationController = [[CYLBaseNavigationController alloc]
//                                                   initWithRootViewController:secondViewController];
//   [secondViewController cyl_setHideNavigationBarSeparator:YES];
   NSArray *viewControllers = @[topupNav,otcNav,walletsNav,myNav];
   return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForTabBar {
//    [self addChildViewController:_topupVC text:kLang(@"top_up") imageName:@"topup"];
////    [self addChildViewController:[[FinanceViewController alloc] init] text:@"Finance" imageName:@"finance"];
//    [self addChildViewController:_homeBuySellVC text:kLang(@"finance") imageName:@"finance"];
////    [self addChildViewController:[[MarketsViewController alloc] init] text:@"Markets" imageName:@"markets"];
//    [self addChildViewController:_walletsVC text:kLang(@"wallet") imageName:@"wallet"];
//    [self addChildViewController:[[MyViewController alloc] init] text:kLang(@"me") imageName:@"settings"];
    
   NSDictionary *topupTabBarItemsAttributes = @{
                                                CYLTabBarItemTitle : kLang(@"top_up"),
                                                CYLTabBarItemImage : @"topup_n",  /* NSString and UIImage are supported*/
                                                CYLTabBarItemSelectedImage : @"topup_h",  /* NSString and UIImage are supported*/
                                                };
   NSDictionary *otcTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : kLang(@"finance"),
                                                 CYLTabBarItemImage : @"finance_n",
                                                 CYLTabBarItemSelectedImage : @"finance_h",
                                                 };
//    NSDictionary *defiTabBarItemsAttributes = @{
//                                                CYLTabBarItemTitle : kLang(@"defi"),
//                                                CYLTabBarItemImage : @"defi_n",
//                                                CYLTabBarItemSelectedImage : @"defi_h",
//                                                };
    NSDictionary *walletsTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : kLang(@"wallet"),
                                                  CYLTabBarItemImage : @"wallet_n",
                                                  CYLTabBarItemSelectedImage : @"wallet_h",
                                                  };
    NSDictionary *myTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : kLang(@"me"),
                                                  CYLTabBarItemImage : @"settings_n",
                                                  CYLTabBarItemSelectedImage : @"settings_h",
                                                  };
   

   NSArray *tabBarItemsAttributes = @[
                                      topupTabBarItemsAttributes,
                                      otcTabBarItemsAttributes,
//                                      defiTabBarItemsAttributes,
                                      walletsTabBarItemsAttributes,
                                      myTabBarItemsAttributes,
                                      ];
   return tabBarItemsAttributes;
}


#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeNoti:) name:kLanguageChangeNoti object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addObserve];
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
//    [self becomeFirstResponder];
    [self customizeInterface];
}


/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance {
    // Customize UITabBar height
    // 自定义 TabBar 高度
    // tabBarController.tabBarHeight = CYL_IS_IPHONE_X ? 65 : 40;
    
//    [self rootWindow].backgroundColor = [UIColor cyl_systemBackgroundColor];
    [self rootWindow].backgroundColor = MAIN_WHITE_COLOR;
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
//    normalAttrs[NSForegroundColorAttributeName] = [UIColor cyl_systemGrayColor];
    normalAttrs[NSForegroundColorAttributeName] = UIColorFromRGB(0x676767);
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
//    selectedAttrs[NSForegroundColorAttributeName] = [UIColor cyl_labelColor];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor mainColor];
    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
    // [self customizeTabBarSelectionIndicatorImage];
    
    // update TabBar when TabBarItem width did update
    // If your app need support UIDeviceOrientationLandscapeLeft or UIDeviceOrientationLandscapeRight，
    // remove the comment '//'
    // 如果你的App需要支持横竖屏，请使用该方法移除注释 '//'
//     [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    
    // set background color
    // 设置 TabBar 背景
    // 半透明
//    [UITabBar appearance].translucent = YES;
    // [UITabBar appearance].barTintColor = [UIColor cyl_systemBackgroundColor];
    // [[UITabBar appearance] setBackgroundColor:[UIColor cyl_systemBackgroundColor]];
    
    
    //     [[UITabBar appearance] setBackgroundImage:[[self class] imageWithColor:[UIColor whiteColor] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, tabBarController.tabBarHeight ?: (CYL_IS_IPHONE_X ? 65 : 40))]];
    //    [[UITabBar appearance] setUnselectedItemTintColor:[UIColor systemGrayColor]];
    
    //Three way to deal with shadow 三种阴影处理方式：
    // NO.3, without shadow : use -[[CYLTabBarController hideTabBarShadowImageView] in CYLMainRootViewController.m
    // NO.2，using Image
    // set the bar shadow image
    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
//    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
//    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"TabBar_Bg_Shadow"]];
    // NO.1，using layer to add shadow. note:recommended. 推荐该方式，可以给PlusButton突出的部分也添加上阴影
//    tabBarController.tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
//    tabBarController.tabBar.layer.shadowRadius = 15.0;
//    tabBarController.tabBar.layer.shadowOpacity = 0.2;
//    tabBarController.tabBar.layer.shadowOffset = CGSizeMake(0, 3);
//    tabBarController.tabBar.layer.masksToBounds = NO;
//    tabBarController.tabBar.clipsToBounds = NO;
}

- (void)customizeInterface {
    //设置导航栏
    //    [self setUpNavigationBarAppearance];
        [self hideTabBarShadowImageView];
    //#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    //    if (@available(iOS 13.0, *)) {
    //        tabBarController.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    //    }
    //#endif
    //添加小红点
    //添加提示动画，引导用户点击
//    [self setViewDidLayoutSubViewsBlockInvokeOnce:YES block:^(CYLTabBarController *tabBarController) {
//        NSUInteger delaySeconds = 1.5;
//        dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC));
//        dispatch_after(when, dispatch_get_main_queue(), ^{
//            @try {
//                UIViewController *viewController0 = tabBarController.viewControllers[0];
//                // UIControl *tab0 = viewController0.cyl_tabButton;
//                // [tab0 cyl_showBadge];
//                [viewController0 cyl_setBadgeBackgroundColor:RANDOM_COLOR];
//                [viewController0 cyl_setBadgeCenterOffset:CGPointMake(-5, 3)];
//                //                [viewController0 cyl_setBadgeRadius:11/2];
//                //以上对Badge的参数设置，需要在 cyl_showBadgeValue 调用之前执行。
//                [viewController0 cyl_showBadge];
//
//                //                [tabBarController.viewControllers[1] cyl_setBadgeMargin:5];
//                //                [tabBarController.viewControllers[2] cyl_setBadgeMargin:5];
//                //                [tabBarController.viewControllers[3] cyl_setBadgeMargin:5];
//                //                [tabBarController.viewControllers[4] cyl_setBadgeMargin:5];
//                [tabBarController.viewControllers[1] cyl_setBadgeBackgroundColor:RANDOM_COLOR];
//                [tabBarController.viewControllers[1] cyl_showBadgeValue:@"" animationType:CYLBadgeAnimationTypeScale];
//                [tabBarController.viewControllers[2] cyl_showBadgeValue:@"" animationType:CYLBadgeAnimationTypeShake];
//
//                NSString *testBadgeString = @"100";
//                //                [tabBarController.viewControllers[3] cyl_setBadgeMargin:-5];
//                //                CGSize size = [testBadgeString sizeWithAttributes:
//                //                               @{NSFontAttributeName:
//                //                                     tabBarController.viewControllers[3].cyl_badgeFont}];
//                //                float labelHeight = ceilf(size.height);
//                //                [tabBarController.viewControllers[3] cyl_setBadgeCornerRadius:(labelHeight+ tabBarController.viewControllers[3].cyl_badgeMargin)/2];
//                [tabBarController.viewControllers[3] cyl_showBadgeValue:testBadgeString animationType:CYLBadgeAnimationTypeBounce];
//
//                [tabBarController.viewControllers[4] cyl_showBadgeValue:@"NEW" animationType:CYLBadgeAnimationTypeBreathe];
//            } @catch (NSException *exception) {}
//
//            //添加仿淘宝tabbar，第一个tab选中后有图标覆盖
//            if (self.selectedIndex != 0) {
//                return;
//            }
//            // tabBarController.selectedIndex = 1;
//        });
//    }];
}


#pragma mark - delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    BOOL should = YES;
//    [self updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController shouldSelect:should];
//    UIControl *selectedTabButton = [viewController.tabBarItem cyl_tabButton];
//    if (selectedTabButton.selected) {
//        @try {
//            [[[self class] cyl_topmostViewController] performSelector:@selector(refresh)];
//        } @catch (NSException *exception) {
//            NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), exception.reason);
//        }
//    }
//    return should;
    
    UIViewController *topVC = ((QNavigationController *)viewController).topViewController;
    if ([topVC isKindOfClass:[WalletsViewController class]]){
        if (kAppD.needFingerprintVerification) {
            [kAppD presentFingerprintVerify:^{
                kAppD.mtabbarC.selectedIndex = MainTabbarIndexWallet;
            }];
            return NO;
        }
    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    UIView *animationView;
    //    NSLog(@"🔴类名与方法名：%@（在第%@行），描述：control : %@ ,tabBarChildViewControllerIndex: %@, tabBarItemVisibleIndex : %@", @(__PRETTY_FUNCTION__), @(__LINE__), control, @(control.cyl_tabBarChildViewControllerIndex), @(control.cyl_tabBarItemVisibleIndex));
    if ([control cyl_isTabButton]) {
        if (firstCount == 0) {
            firstCount = 1;
            //return;
        }
//        //更改红标状态
//        if ([self.selectedViewController cyl_isShowBadge]) {
//            [self.selectedViewController cyl_clearBadge];
//        } else {
//            [self.selectedViewController cyl_showBadge];
//        }
        animationView = [control cyl_tabImageView];
    }
    
    UIButton *button = CYLExternPlusButton;
    BOOL isPlusButton = [control cyl_isPlusButton];
    // 即使 PlusButton 也添加了点击事件，点击 PlusButton 后也会触发该代理方法。
    if (isPlusButton) {
        animationView = button.imageView;
    }
    
    [self addScaleAnimationOnView:animationView repeatCount:1];
    // [self addRotateAnimationOnView:animationView];//暂时不推荐用旋转方式，badge也会旋转。
    
    //添加仿淘宝tabbar，第一个tab选中后有图标覆盖
    if ([control cyl_isTabButton]|| [control cyl_isPlusButton]) {
        //        BOOL shouldSelectedCoverShow = (self.selectedIndex == 0);
        //        [self setSelectedCoverShow:shouldSelectedCoverShow];
    }
}


//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

//旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
    // 针对旋转动画，需要将旋转轴向屏幕外侧平移，最大图片宽度的一半
    // 否则背景与按钮图片处于同一层次，当按钮图片旋转时，转轴就在背景图上，动画时会有一部分在背景图之下。
    // 动画结束后复位
    animationView.layer.zPosition = 65.f / 2;
    [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
        } completion:nil];
    });
}

#pragma mark - Noti
- (void)languageChangeNoti:(NSNotification *)noti {
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == MainTabbarIndexTopup) {
            obj.title = kLang(@"top_up");
        } else if (idx == MainTabbarIndexFinance) {
            obj.title = kLang(@"finance");
        } else if (idx == MainTabbarIndexWallet) {
            obj.title = kLang(@"wallet");
        } else if (idx == MainTabbarIndexMy) {
            obj.title = kLang(@"me");
        } else if (idx == MainTabbarIndexDefi) {
           obj.title = kLang(@"defi");
       }
    }];
}

@end
