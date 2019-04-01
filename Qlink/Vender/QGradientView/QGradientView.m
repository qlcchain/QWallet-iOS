//
//  QGradientView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/23.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "QGradientView.h"

@interface QGradientView () {
    CAGradientLayer *gradientLayer;
}
    
@end

@implementation QGradientView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
    
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self addQGradient];
    }
    return self;
}
    
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addQGradient];
    }
    return self;
}
    
- (void)addQGradient {
    gradientLayer = [CAGradientLayer layer];
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
    
- (void)layoutSubviews {
    [super layoutSubviews]; //if you want superclass's behaviour...  (and lay outing of children)
    // resize your layers based on the view's new frame
    gradientLayer.frame = self.bounds;
}

@end
