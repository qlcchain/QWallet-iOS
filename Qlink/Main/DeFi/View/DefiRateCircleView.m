//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "DefiRateCircleView.h"
#import "UIView+Visuals.h"
#import "GlobalConstants.h"
#import "UIView+PopAnimate.h"
#import "DefiProjectModel.h"

static CGFloat rateLineWidth = 3;

@interface DefiRateCircleView ()

//@property (weak, nonatomic) IBOutlet UIView *tipBack;
//@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *ratingLab;

@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation DefiRateCircleView

+ (instancetype)getInstance {
    DefiRateCircleView *view = [[[NSBundle mainBundle] loadNibNamed:@"DefiRateCircleView" owner:self options:nil] lastObject];
//    [view.tipBack cornerRadius:8];
    
//    [view drawArc];
    return view;
}

- (void)config:(DefiProjectModel *)model {
    NSString *iconStr = [[model.name lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    _icon.image = [UIImage imageNamed:iconStr];
    _titleLab.text = [model getShowName];
    _ratingLab.text = [NSString stringWithFormat:@"%@：%@",kLang(@"defi_rating"),[DefiProjectModel getRatingStr:model.rating]];
}

- (void)refreshRating:(NSString *)rating {
    _ratingLab.text = [NSString stringWithFormat:@"%@：%@",kLang(@"defi_rating"),[DefiProjectModel getRatingStr:rating]];
}

#pragma mark 绘制圆弧

- (void)drawArc:(NSString *)weight {
    CGFloat offset = 22.5;
    CGFloat originStartAngle = M_PI - M_PI/180 * offset;
    CGFloat originEndAngle = M_PI*2 + M_PI/180 * offset;
    CGFloat startWeight = 1-[weight floatValue];
    CGFloat allAngle = originEndAngle - originStartAngle;
    CGFloat startAngle = allAngle*startWeight+originStartAngle;
    
    _bezierPath = [UIBezierPath bezierPath];
    //画圆弧
    [_bezierPath addArcWithCenter:CGPointMake(rate_radius, rate_radius) radius:rate_radius-rateLineWidth/2.0 startAngle:originEndAngle endAngle:startAngle clockwise:NO];
//    [_bezierPath setLineWidth:5];

    //画圆弧
//    [bezierPath addArcWithCenter:CGPointMake(self.centerX - 100, self.centerY) radius:50 startAngle:0 endAngle:M_PI clockwise:YES];

    //如果没有闭合，只会显示弧线。
//    [bezierPath addLineToPoint:CGPointMake(self.centerX + 50, self.centerY)];
//    [bezierPath closePath];
    //  设置颜色（颜色设置也可以放在最上面，只要在绘制前都可以）
//    [[UIColor redColor] setStroke];
//    [[UIColor clearColor] setFill];
    // 描边和填充
//    [_bezierPath stroke];
//    [_bezierPath fill];
    
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.strokeColor = [UIColor redColor].CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
        // 默认设置路径宽度为0，使其在起始状态下不显示
        _shapeLayer.lineWidth = rateLineWidth;
    //    layer.lineCap = kCALineCapRound;
    //    layer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:_shapeLayer];
    }
    
    _shapeLayer.path = _bezierPath.CGPath;
    
    
    // 创建Animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    _shapeLayer.autoreverses = NO;
    animation.duration = 2.0;

    // 设置layer的animation
    [_shapeLayer addAnimation:animation forKey:nil];
    
//    kWeakSelf(self);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [weakself drawArc2];
//    });
}


@end
