//
//  UIView+Gradient.h
//  Qlink
//
//  Created by Jelly Foo on 2018/3/23.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Gradient)

- (void)addQGradient;
- (void)addQGradientWithStart:(UIColor *)startColor end:(UIColor *)endColor;
- (void)addHorizontalQGradientWithStart:(UIColor *)startColor end:(UIColor *)endColor frame:(CGRect)frame;
- (void)addVerticalQGradientWithStart:(UIColor *)startColor end:(UIColor *)endColor frame:(CGRect)frame;

@end
