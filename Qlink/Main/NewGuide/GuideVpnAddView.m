//
//  GuideVpnView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/7/3.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "GuideVpnAddView.h"

@interface GuideVpnAddView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightOffset;

@end

@implementation GuideVpnAddView

+ (GuideVpnAddView *)getNibView {
    GuideVpnAddView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"GuideVpnAddView" owner:self options:nil] firstObject];
    
    return nibView;
}

- (void)showGuideTo:(CGRect)hollowOutFrame tapBlock:(void (^)(void))tapB {
    [HWUserdefault insertObj:@(NO) withkey:NEW_GUIDE_VPN_REGISTER];
    NSNumber *guideLocal = [HWUserdefault getObjectWithKey:NEW_GUIDE_VPN_REGISTER];
    if (!guideLocal || [guideLocal boolValue] == NO) {
        UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
        CGPoint center = CGPointMake((hollowOutFrame.origin.x*2.0+hollowOutFrame.size.width)/2.0, (hollowOutFrame.origin.y*2.0+hollowOutFrame.size.height)/2.0);
        CGFloat radius = (hollowOutFrame.size.width)/2.0;
        UIView *guideBgView = [GuideVpnAddView showNewGuideCircleWithArcCenter:center radius:radius];
        [self addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [HWUserdefault insertObj:@(YES) withkey:NEW_GUIDE_VPN_REGISTER];
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
            _rightOffset.constant = 13;
        } else if (IS_iPhone_6) {
            _topOffset.constant = 27;
            _rightOffset.constant = 13;
        } else if (IS_iPhone6_Plus) {
            _topOffset.constant = 27;
            _rightOffset.constant = 13;
        } else if (IS_iPhoneX) {
            _topOffset.constant = 27+24;
            _rightOffset.constant = 13;
        }
        
        [keyWindow addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(keyWindow).offset(0);
        }];
    }
}

@end
