//
//  QlinkNavViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2018/3/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "QlinkNavViewController.h"
//#import "VPNAddViewController.h"
#import "ProfileViewController.h"
#import "WalletDetailViewController.h"
#import "CreateNewWalletViewController.h"
#import "NewWalletViewController.h"
#import "UnlockWalletViewController.h"
#import "WalletCreateSuccessViewController.h"
#import "UIImage+Color.h"

@interface QlinkNavViewController ()

@end

@implementation QlinkNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    // 获取系统自带手势target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    self.delegate = self;
    
    [self.view addGestureRecognizer:pan];
     */
    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled = YES;
    self.navigationBar.translucent = NO;
    
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:MAIN_PURPLE_COLOR]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setShadowImage:[UIImage new]];
    // 去除返回按扭文字
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setBarTintColor:MAIN_PURPLE_COLOR];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:18.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    if ([viewController isKindOfClass:[ProfileViewController class]] || [viewController isKindOfClass:[WalletDetailViewController class]]) {
//        [viewController setHidesBottomBarWhenPushed:YES];
//    }
    if (self.viewControllers.count > 0) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    [super pushViewController:viewController animated:animated];
}

- (void) handleNavigationTransition:(UIPanGestureRecognizer *) gestureRecognizer
{
    
    [self gestureRecognizerShouldBegin:gestureRecognizer];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 禁止vc右滑返回
    NSArray *classArr = @[[UnlockWalletViewController class],[CreateNewWalletViewController class],[NewWalletViewController class],[WalletCreateSuccessViewController class]];
    __block BOOL contain = NO;
    [classArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Class class = obj;
        if([[self.viewControllers lastObject] isKindOfClass:class]) {
            contain = YES;
            *stop = YES;
        }
    }];
    if (contain) {
        return NO;
    }

    return self.viewControllers.count>1;
}

// 设置状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// 返回按钮设置
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//
//    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemAction)];
//
//    viewController.navigationItem.backBarButtonItem = backBarButtonItem;
//
//}

- (void)backBarButtonItemAction
{
    [self popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
