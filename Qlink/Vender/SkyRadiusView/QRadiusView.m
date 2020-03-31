//
//  SkyRadiusView.m
//  SkyRadiusView
//
//  Created by skytoup on 15/8/11.
//  Copyright (c) 2015年 skytoup. All rights reserved.
//

#import "QRadiusView.h"

@interface QRadiusView ()
//@property (strong, nonatomic) UIColor *bgColor;
@end

@implementation QRadiusView

//- (void)setBackgroundColor:(UIColor *)backgroundColor {
//    [super setBackgroundColor:[UIColor clearColor]];
//    _bgColor = backgroundColor;
//}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
//    [path moveToPoint:CGPointMake(0.f, 0.f)];
    [path moveToPoint:CGPointMake(self.frame.size.width, 0.f)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(30, self.frame.size.height)];
    [path addQuadCurveToPoint:CGPointMake(0.f, 0.f) controlPoint:CGPointMake(4.f,28.f)];
//    [path addCurveToPoint:CGPointMake(0.f, 0.f) controlPoint1:CGPointMake(6.f,14.f) controlPoint2:CGPointMake(22.f,26.f)];
    
    [path closePath];
                                     
     CAShapeLayer *shapLayer = [CAShapeLayer layer];
     shapLayer.path = path.CGPath;
     self.layer.mask = shapLayer;
    
//    UIBezierPath *p = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(_bottomLeftRadius?UIRectCornerBottomLeft:0)|(_bottomRightRadius?UIRectCornerBottomRight:0)|(_topLeftRadius?UIRectCornerTopLeft:0)|(_topRightRadius?UIRectCornerTopRight:0) cornerRadii:CGSizeMake(_cornerRadius, 0.f)];
//    CGContextRef c = UIGraphicsGetCurrentContext();
//    CGContextAddPath(c, p.CGPath);
//    CGContextClosePath(c);
//    CGContextClip(c);
//    CGContextAddRect(c, rect);
//    CGContextSetFillColorWithColor(c, _bgColor.CGColor);
//    CGContextFillPath(c);
}

@end
