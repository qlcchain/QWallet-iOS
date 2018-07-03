//
//  GuideBaseView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/7/3.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+BlockGesture.h"

@interface GuideBaseView : UIView

+ (UIView *)showNewGuideCircleWithArcCenter:(CGPoint)center radius:(CGFloat)radius;
+ (UIView *)showNewGuideRectWithRoundedRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;
+ (UIView *)showNewGuideWithArcCenter1:(CGPoint)center1 radius1:(CGFloat)radius1 ArcCenter2:(CGPoint)center2 radius2:(CGFloat)radius2;
- (void)showGuideTo:(CGRect)hollowOutFrame tapBlock:(void (^)(void))tapB;

@end
