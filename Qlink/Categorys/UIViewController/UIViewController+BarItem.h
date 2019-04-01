//
//  UINavigationController+BarItem.h
//  LoveDaBai
//
//  Created by Jelly Foo on 15/12/7.
//  Copyright © 2015年 life. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BarItem)

/**
 *  此方法用于webview
 */
- (void)setLeftFirstItemWithFirstImage:(UIImage *)leftFirstImage LeftFirstItemWithFirstTitle:(NSString *)leftFirstTitle LeftFirstTarget:(id)leftFirstTarget LeftFirstSel:(SEL)leftFirstSel LeftSecondItemWithSecondImage:(UIImage *)leftSecondImage LeftSecondItemWithSecondTitle:(NSString *)leftSecondTitle LeftSecondTarget:(id)leftSecondTarget LeftSecondSel:(SEL)leftSecondSel;

- (UIButton *)setLeftItemWithImage:(UIImage *)leftImage LeftItemWithTitle:(NSString *)leftTitle LeftTitleColor:(UIColor *)leftColor LeftTarget:(id)leftTarget LeftSel:(SEL)leftSel;
- (UIButton *)setRightItemWithImage:(UIImage *)rightImage RightItemWithTitle:(NSString *)rightTitle RightTitleColor:(UIColor *)rightColor RightTarget:(id)rightTarget RightSel:(SEL)rightSel;
- (UIButton *)setRightItemWithImage:(UIImage *)rightImage RightItemWithTitle:(NSString *)rightTitle RightTarget:(id)rightTarget RightSel:(SEL)rightSel;
- (UIButton *)setRightItemWithTitle:(NSString *)rightTitle TitleColor:(UIColor *)titleColor RightTarget:(id)rightTarget RightSel:(SEL)rightSel;

@end
