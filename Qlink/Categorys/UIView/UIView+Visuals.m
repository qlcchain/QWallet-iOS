//
//  UIView+Visuals.m
//
//  Created by Heiko Dreyer on 25.05.11.
//  Copyright 2011 boxedfolder.com. All rights reserved.
//

#import "UIView+Visuals.h"

// Degree -> Rad
#define degToRad(x) (M_PI * (x) / 180.0)

@implementation UIView (Visuals)

/*
周边加阴影，并且同时圆角
*/
- (void)addShadowWithOpacity:(float)shadowOpacity
                 shadowColor:(UIColor *)shadowColor
                shadowOffset:(CGSize)shadowOffset
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOffset = shadowOffset;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowRadius = shadowRadius;
    
    return;
    
    //////// shadow /////////
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = self.layer.frame;
    
    shadowLayer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
    shadowLayer.shadowOffset = shadowOffset;//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    shadowLayer.shadowOpacity = shadowOpacity;//0.8;//阴影透明度，默认0
    shadowLayer.shadowRadius = shadowRadius;//8;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;
    
    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    
    //设置阴影路径
    shadowLayer.shadowPath = path.CGPath;
    
    //////// cornerRadius /////////
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [self.superview.layer insertSublayer:shadowLayer below:self.layer];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)cornerRadius: (CGFloat)radius strokeSize: (CGFloat)size color: (UIColor *)color
{
    self.layer.cornerRadius = radius;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = size;
}

-(void)cornerRadius: (CGFloat)radius
{
    self.layer.cornerRadius = radius;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    CGRect rect = self.bounds;
    
    // Create the path
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the view's layer
    self.layer.mask = maskLayer;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)shadowWithColor: (UIColor *)color 
                offset: (CGSize)offset 
               opacity: (CGFloat)opacity 
                radius: (CGFloat)radius
{
    self.clipsToBounds = NO;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)removeFromSuperviewWithFadeDuration: (NSTimeInterval)duration
{
    [UIView beginAnimations: nil context: NULL];
	[UIView setAnimationBeginsFromCurrentState: YES];
	[UIView setAnimationDuration: duration];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDidStopSelector: @selector(removeFromSuperview)];
    self.alpha = 0.0;
	[UIView commitAnimations];	
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)addSubview: (UIView *)subview withTransition: (UIViewAnimationTransition)transition duration: (NSTimeInterval)duration
{
	[UIView beginAnimations: nil context: NULL];
	[UIView setAnimationDuration: duration];
	[UIView setAnimationTransition: transition forView: self cache: YES];
	[self addSubview: subview];
	[UIView commitAnimations];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)removeFromSuperviewWithTransition: (UIViewAnimationTransition)transition duration: (NSTimeInterval)duration
{
	[UIView beginAnimations: nil context: NULL];
	[UIView setAnimationDuration: duration];
	[UIView setAnimationTransition: transition forView: self.superview cache: YES];
	[self removeFromSuperview];
	[UIView commitAnimations];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)rotateByAngle: (CGFloat)angle 
            duration: (NSTimeInterval)duration 
         autoreverse: (BOOL)autoreverse
         repeatCount: (CGFloat)repeatCount
      timingFunction: (CAMediaTimingFunction *)timingFunction
{
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath: @"transform.rotation"];
    rotation.toValue = [NSNumber numberWithFloat: degToRad(angle)];
    rotation.duration = duration;
    rotation.repeatCount = repeatCount;
    rotation.autoreverses = autoreverse;
    rotation.removedOnCompletion = NO;
	rotation.fillMode = kCAFillModeBoth;
	rotation.timingFunction = timingFunction != nil ? timingFunction : [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation: rotation forKey: @"rotationAnimation"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)moveToPoint: (CGPoint)newPoint 
          duration: (NSTimeInterval)duration 
       autoreverse: (BOOL)autoreverse
       repeatCount: (CGFloat)repeatCount
    timingFunction: (CAMediaTimingFunction *)timingFunction
{
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath: @"position"];
    move.toValue = [NSValue valueWithCGPoint: newPoint];
    move.duration = duration;
    move.removedOnCompletion = NO;
    move.repeatCount = repeatCount;
    move.autoreverses = autoreverse;
	move.fillMode = kCAFillModeBoth;
	move.timingFunction = timingFunction != nil ? timingFunction : [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation: move forKey: @"positionAnimation"];
}

//获取截图
- (UIImage *)getImageFromView {
    CGSize s = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)addCornerWithType:(UIRectCorner)aCorners size:(CGSize)aSize {
    // 根据矩形画带圆角的曲线
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:aCorners cornerRadii:aSize];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
