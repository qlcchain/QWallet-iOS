//
//  QSwapProcessAnimateView.m
//  Qlink
//
//  Created by 旷自辉 on 2020/8/24.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QSwapProcessAnimateView.h"
#import "UIView+Visuals.h"
#import "GlobalConstants.h"
#import "UIView+PopAnimate.h"

@interface QSwapProcessAnimateView()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UILabel *importantLab;
@property (weak, nonatomic) IBOutlet UILabel *stageLab;
@property (weak, nonatomic) IBOutlet UIView *stageBack;

@end

@implementation QSwapProcessAnimateView

+ (instancetype)getInstance {
    QSwapProcessAnimateView *view = [[[NSBundle mainBundle] loadNibNamed:@"QSwapProcessAnimateView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    view.stageBack.layer.cornerRadius = view.stageBack.width/2.0;
    view.stageBack.layer.masksToBounds = YES;
    return view;
}

- (void)show {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.stageLab.text = @"1";
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


#pragma mark --- Action
- (IBAction)closeAction:(id)sender {
    [self hide];
}
@end
