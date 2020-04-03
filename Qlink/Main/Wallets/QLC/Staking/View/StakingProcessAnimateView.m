//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "StakingProcessAnimateView.h"
#import "UIView+Visuals.h"
#import "GlobalConstants.h"
#import "UIView+PopAnimate.h"

@interface StakingProcessAnimateView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UILabel *importantLab;
@property (weak, nonatomic) IBOutlet UILabel *stageLab;
@property (weak, nonatomic) IBOutlet UIView *stageBack;

@end

@implementation StakingProcessAnimateView

+ (instancetype)getInstance {
    StakingProcessAnimateView *view = [[[NSBundle mainBundle] loadNibNamed:@"StakingProcessAnimateView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    view.stageBack.layer.cornerRadius = view.stageBack.width/2.0;
    view.stageBack.layer.masksToBounds = YES;
    return view;
}

- (void)show {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.stageLab.text = @"0";
    [kAppD.window addSubview:self];
    
    [self addScaleAnimate:_stageBack];
}

- (void)hide {
    [self removeScaleAnimate:_stageBack];
    [self removeFromSuperview];
}

- (void)updateStage:(NSString *)text {
    self.stageLab.text = text;
}

- (void)addScaleAnimate:(UIView *)view {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.6;
    scaleAnimation.repeatCount = HUGE_VALF;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fromValue = @(0.8);
    scaleAnimation.toValue = @(1.2);
    [view.layer addAnimation:scaleAnimation forKey:@"scale-layer"];
}

- (void)removeScaleAnimate:(UIView *)view {
    [view.layer removeAllAnimations];
}


@end
