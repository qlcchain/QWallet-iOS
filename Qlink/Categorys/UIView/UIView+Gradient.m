//
//  UIView+Gradient.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/23.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "UIView+Gradient.h"

@implementation UIView (Gradient)

- (void)addQGradient {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    UIColor *startC = [UIColor colorWithRed:73/255.0 green:0 blue:116/255.0 alpha:1];
    UIColor *endC = [UIColor colorWithRed:40/255.0 green:0 blue:102/255.0 alpha:1];
    gradientLayer.colors = @[(__bridge id)startC.CGColor, (__bridge id)endC.CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = self.bounds;
//    [self.layer addSublayer:gradientLayer];
    [self.layer insertSublayer:gradientLayer atIndex:0];
}


@end
