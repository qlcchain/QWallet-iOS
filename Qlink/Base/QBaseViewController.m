//
//  QBaseViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "QBaseViewController.h"
//#import "QlinkNavViewController.h"
#import "QNavigationController.h"
#import "GlobalConstants.h"

@interface QBaseViewController ()

@end

@implementation QBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBarHidden = YES;
    if ([self.view.backgroundColor isEqual:MAIN_WHITE_COLOR]) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}
    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBarHidden = NO;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 13.0, *)) {
//        self.view.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
//    self.view.backgroundColor = [UIColor RandomColor];
//    self.view.backgroundColor = MAIN_BLUE_COLOR;
//    self.view.theme_backgroundColor = globalBackgroundColorPicker;
    self.navigationController.navigationBarHidden = !showRightNavBarItem;
    
    // 设置右边按钮
    if (showRightNavBarItem) {
        self.rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightNavBtn.frame = CGRectMake(0, 0, 60, 30);
        
        self.rightNavBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [self.rightNavBtn setShowsTouchWhenHighlighted:YES];
        [self.rightNavBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightNavBtn setTitle:@"" forState:UIControlStateNormal];
        [self.rightNavBtn addTarget:self action:@selector(rightNavBarItemPressed) forControlEvents:UIControlEventTouchUpInside];
        self.rightNavBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightNavBtn];
    }
    
    [self refreshContent];
}

- (void) initVariables
{
    showRightNavBarItem = NO;
    showNavigationBar = YES;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initVariables];
    }
    return self;
}

- (id)initWithShowCustomNavigationBar:(BOOL)_showNavigationBar
{
    self = [super init];
    if (self) {
        showNavigationBar = _showNavigationBar;
        showRightNavBarItem = NO;
    }
    return self;
    
}
- (void)leftNavBarItemPressedWithPop:(BOOL)isPop
{
    if (!isPop)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightNavBarItemPressed
{
    
}

- (void)presentModalVC:(UIViewController *)VC animated:(BOOL)animated
{
//    QlinkNavViewController *navController = [[QlinkNavViewController alloc] initWithRootViewController:VC] ;
    QNavigationController *navController = [[QNavigationController alloc] initWithRootViewController:VC];
    if([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
        [self presentViewController:navController animated:animated completion:nil];
    }
}
// 移除指定vs
- (void) moveNavgationViewController:(UIViewController *) vs
{
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[vs class]]) {
            [marr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = marr;
}
// 移除前二个vs
- (void) moveNavgationBackViewController
{
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    if (marr.count > 1) {
        [marr removeObjectAtIndex:marr.count-2];
        if (marr.count > 1) {
             [marr removeObjectAtIndex:marr.count-2];
        }
        self.navigationController.viewControllers = marr;
    }
   
}
// 移除上一个vs
- (void) moveNavgationBackOneViewController
{
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    if (marr.count > 1) {
        [marr removeObjectAtIndex:marr.count-2];
        self.navigationController.viewControllers = marr;
    }
}

/**
 检查连接状态 并显示msg提示
 */
- (void) showUserConnectStatus
{
    [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"p2p_connect_status")];
}

#pragma mark - 子类继承刷新子view
- (void)refreshContent {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
