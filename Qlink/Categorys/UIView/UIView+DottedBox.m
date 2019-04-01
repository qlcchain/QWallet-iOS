//
//  UIView+DottedBox.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/8.
//  Copyright © 2018 pan. All rights reserved.
//

#import "UIView+DottedBox.h"

@implementation UIView (DottedBox)

- (void)addDottedBox:(UIColor *)strokeColor fillColor:(UIColor *)fillColor cornerRadius:(CGFloat)cornerRadius lineWidth:(CGFloat)lineWidth {
    CAShapeLayer *border = [CAShapeLayer layer];
    //虚线的颜色
    border.strokeColor = strokeColor.CGColor;
    //填充的颜色
    border.fillColor = fillColor.CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
    
    //设置路径
    border.path = path.CGPath;
    border.frame = self.bounds;
    //虚线的宽度
    border.lineWidth = lineWidth;
    //设置线条的样式
    //    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@4, @2];
    
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    
    [self.layer addSublayer:border];
}

@end
