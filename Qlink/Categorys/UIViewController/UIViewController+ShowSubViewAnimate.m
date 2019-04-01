//
//  UIViewController+ShowSubViewAnimate.m
//  WanAiProject
//
//  Created by Jelly Foo on 15/7/23.
//  Copyright (c) 2015年 WanAi. All rights reserved.
//

#import "UIViewController+ShowSubViewAnimate.h"
#import "UIView+Frame.h"

@implementation UIViewController (ShowSubViewAnimate)

- (void)showAnimateFromLeft:(UIView *)oneView Delay:(CGFloat)delay {
    CGFloat oneViewX = oneView.left;
    oneView.frame = CGRectMake(-oneView.width, oneView.top, oneView.width, oneView.height);
    [UIView animateWithDuration:1.0 delay:delay usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        oneView.frame = CGRectMake(oneViewX,  oneView.top, oneView.width, oneView.height);
    } completion:^(BOOL finished) {
    }];
}

- (void)showAnimateFromLeft:(UIView *)oneView {
    [self showAnimateFromLeft:oneView Delay:0.1];
}

- (void)showAnimateFromBottom:(UIView *)oneView Delay:(CGFloat)delay {
    CGFloat oneViewTop = oneView.top;
    oneView.frame = CGRectMake(oneView.left, [UIScreen mainScreen].bounds.size.height, oneView.width, oneView.height);
    [UIView animateWithDuration:1.0 delay:delay usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        oneView.frame = CGRectMake(oneView.left, oneViewTop, oneView.width, oneView.height);
    } completion:^(BOOL finished) {
    }];
}

- (void)showAnimateFromBottom:(UIView *)oneView {
    [self showAnimateFromBottom:oneView Delay:0.1];
}

@end
