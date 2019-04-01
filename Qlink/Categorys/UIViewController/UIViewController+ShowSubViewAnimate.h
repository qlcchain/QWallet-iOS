//
//  UIViewController+ShowSubViewAnimate.h
//  WanAiProject
//
//  Created by Jelly Foo on 15/7/23.
//  Copyright (c) 2015年 WanAi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ShowSubViewAnimate)

- (void)showAnimateFromLeft:(UIView *)oneView;
- (void)showAnimateFromLeft:(UIView *)oneView Delay:(CGFloat)delay;
- (void)showAnimateFromBottom:(UIView *)oneView;
- (void)showAnimateFromBottom:(UIView *)oneView Delay:(CGFloat)delay;

@end
