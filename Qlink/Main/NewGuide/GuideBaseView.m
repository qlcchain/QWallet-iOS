//
//  GuideBaseView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/7/3.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "GuideBaseView.h"

@implementation GuideBaseView

+ (UIView *)showNewGuideCircleWithArcCenter:(CGPoint)center radius:(CGFloat)radius{
    // 这里创建指引在这个视图在window上
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    //    bgView.backgroundColor = [UIColorFromRGB(0x323232) colorWithAlphaComponent:0.8];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    //create path 重点来了（**这里需要添加第一个路径）
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    // 这里添加第二个路径 （这个是圆）
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:NO]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    //shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    [bgView.layer setMask:shapeLayer];
    
    return bgView;
}

+ (UIView *)showNewGuideRectWithRoundedRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius {
    // 这里创建指引在这个视图在window上
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    //    bgView.backgroundColor = [UIColorFromRGB(0x323232) colorWithAlphaComponent:0.8];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    //create path 重点来了（**这里需要添加第一个路径）
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    // 这里添加第二个路径 （这个是矩形）
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] bezierPathByReversingPath]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    //shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    [bgView.layer setMask:shapeLayer];
    
    return bgView;
}

+ (UIView *)showNewGuideWithArcCenter1:(CGPoint)center1 radius1:(CGFloat)radius1 ArcCenter2:(CGPoint)center2 radius2:(CGFloat)radius2 {
    // 这里创建指引在这个视图在window上
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    //    bgView.backgroundColor = [UIColorFromRGB(0x323232) colorWithAlphaComponent:0.8];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    //create path 重点来了（**这里需要添加第一个路径）
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    
    // 这里添加第二个路径 （这个是圆）
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:center1 radius:radius1 startAngle:0 endAngle:2*M_PI clockwise:NO]];
    
    // 这里添加第三个路径 （这个是圆）
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:center2 radius:radius2 startAngle:0 endAngle:2*M_PI clockwise:NO]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    //shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    [bgView.layer setMask:shapeLayer];
    
    return bgView;
}

- (void)showGuideTo:(CGRect)hollowOutFrame tapBlock:(void (^)(void))tapB {
    
}

@end
