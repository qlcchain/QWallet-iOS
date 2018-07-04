//
//  GuideSettingMoreView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/7/3.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "GuideSettingMoreView.h"

@interface GuideSettingMoreView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftOffset;

@end

@implementation GuideSettingMoreView

+ (GuideSettingMoreView *)getNibView {
    GuideSettingMoreView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"GuideSettingMoreView" owner:self options:nil] firstObject];
    
    return nibView;
}

- (void)showGuideToCircle1:(CGRect)circleFrame1 circle2:(CGRect)circleFrame2 tapBlock:(void (^)(void))tapB {
    [HWUserdefault insertObj:@(NO) withkey:NEW_GUIDE_SETTING_MORE];
    NSNumber *guideLocal = [HWUserdefault getObjectWithKey:NEW_GUIDE_SETTING_MORE];
    if (!guideLocal || [guideLocal boolValue] == NO) {
        UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
        CGPoint center1 = CGPointMake((circleFrame1.origin.x*2.0+circleFrame1.size.width)/2.0, (circleFrame1.origin.y*2.0+circleFrame1.size.height)/2.0);
        CGFloat radius1 = (circleFrame1.size.width)/2.0;
        CGPoint center2 = CGPointMake((circleFrame2.origin.x*2.0+circleFrame2.size.width)/2.0, (circleFrame2.origin.y*2.0+circleFrame2.size.height)/2.0);
        CGFloat radius2 = (circleFrame2.size.width)/2.0;
        UIView *guideBgView = [GuideSettingMoreView showNewGuideWithArcCenter1:center1 radius1:radius1 ArcCenter2:center2 radius2:radius2];
        [self addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [HWUserdefault insertObj:@(YES) withkey:NEW_GUIDE_SETTING_MORE];
            UIView *tapView = gestureRecoginzer.view;
            [tapView removeFromSuperview];
            [tapView removeGestureRecognizer:gestureRecoginzer];
            [guideBgView removeFromSuperview];
            if (tapB) {
                tapB();
            }
        }];
        
        if (IS_iPhone_5) {
            _topOffset.constant = 27;
            _rightOffset.constant = 14;
            _bottomOffset.constant = -3;
            _leftOffset.constant = 18;
        } else if (IS_iPhone_6) {
            _topOffset.constant = 27;
            _rightOffset.constant = 14;
            _bottomOffset.constant = -3;
            _leftOffset.constant = 18;
        } else if (IS_iPhone6_Plus) {
            _topOffset.constant = 27;
            _rightOffset.constant = 14;
            _bottomOffset.constant = -3;
            _leftOffset.constant = 18;
        } else if (IS_iPhoneX) {
            _topOffset.constant = 27+24;
            _rightOffset.constant = 14;
            _bottomOffset.constant = -3;
            _leftOffset.constant = 18;
        }
        
        [keyWindow addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(keyWindow).offset(0);
        }];
    }
}

@end
