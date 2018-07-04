//
//  GuidenSettingView.m
//  Qlink
//
//  Created by 旷自辉 on 2018/7/4.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "GuidenSettingView.h"

@implementation GuidenSettingView

+ (GuidenSettingView *)getNibView {
    GuidenSettingView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"GuidenSettingView" owner:self options:nil] firstObject];
    
    return nibView;
}

- (void)showGuideTo:(CGRect)hollowOutFrame tapBlock:(void (^)(void))tapB {
    //    [HWUserdefault insertObj:@(NO) withkey:NEW_GUIDE_WALLET_DETAIL];
    NSNumber *guideLocal = nil;//[HWUserdefault getObjectWithKey:NEW_GUIDE_WALLET_DETAIL];
    if (!guideLocal || [guideLocal boolValue] == NO) {
        UIView *bgView = [UIApplication sharedApplication].keyWindow;
        
        UIView *guideBgView = [GuidenSettingView showNewGuideRectWithRoundedRect:hollowOutFrame cornerRadius:4];
        //        UIView *guideBgView = [GuideVpnCountryView showNewGuideCircleWithArcCenter:center radius:radius];
        [self addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [HWUserdefault insertObj:@(YES) withkey:NEW_GUIDE_WALLET_DETAIL];
            UIView *tapView = gestureRecoginzer.view;
            [tapView removeFromSuperview];
            [tapView removeGestureRecognizer:gestureRecoginzer];
            [guideBgView removeFromSuperview];
            if (tapB) {
                tapB();
            }
        }];
        if (IS_iPhone_5) {
            
        } else if (IS_iPhone_6) {
            
        } else if (IS_iPhone6_Plus) {
            
        } else if (IS_iPhoneX) {
            _topOffset.constant = 95-20;
        }
        
        [bgView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(bgView).offset(0);
        }];
    }
}

@end
