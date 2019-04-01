//
//  QBaseViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/3/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBaseViewController : UIViewController
{
    BOOL showRightNavBarItem;
    BOOL showNavigationBar;
}

@property (nonatomic,strong) UIButton *rightNavBtn;

- (id)initWithShowCustomNavigationBar:(BOOL)_showNavigationBar;
- (void)leftNavBarItemPressedWithPop:(BOOL) isPop;
- (void)rightNavBarItemPressed;
- (void)presentModalVC:(UIViewController *)VC animated:(BOOL)animated;
- (void) moveNavgationViewController:(UIViewController *) vs;
- (void)refreshContent;
// 移除上二个vs
- (void) moveNavgationBackViewController;
// 移除上一个vs
- (void) moveNavgationBackOneViewController;
// 检查自己当前
- (void) showUserConnectStatus;
@end
