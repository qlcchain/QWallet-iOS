//
//  UIView+PopAnimate.m
//  Qlink
//
//  Created by Jelly Foo on 2020/4/2.
//  Copyright © 2020 pan. All rights reserved.
//

#import "UIView+PopAnimate.h"

@implementation UIView (PopAnimate)

- (void)showPopAnimate {
//    __weak typeof(view) weakView = view;
    __weak typeof(self) weakSelf = self;
    self.layer.transform = CATransform3DMakeScale(0, 0, 1);
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.layer.transform = CATransform3DIdentity;
    } completion:nil];
}

@end
