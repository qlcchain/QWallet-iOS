//
//  GuideUnlockWalletView.m
//  Qlink
//
//  Created by 旷自辉 on 2018/7/4.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "GuideUnlockWalletView.h"

@interface GuideUnlockWalletView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOffset;

@end

@implementation GuideUnlockWalletView

+ (GuideUnlockWalletView *)getNibView {
    GuideUnlockWalletView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"GuideUnlockWalletView" owner:self options:nil] firstObject];
    
    return nibView;
}

- (void)showGuideTo:(CGRect)hollowOutFrame tapBlock:(void (^)(void))tapB {
    [HWUserdefault insertObj:@(NO) withkey:NEW_GUIDE_VPN_SERVER_LOCATION];
    NSNumber *guideLocal = [HWUserdefault getObjectWithKey:NEW_GUIDE_UNLOCK_WALLET];
    if (!guideLocal || [guideLocal boolValue] == NO) {
        UIView *bgView = [UIApplication sharedApplication].keyWindow;
       
        UIView *guideBgView = [GuideUnlockWalletView showNewGuideRectWithRoundedRect:hollowOutFrame cornerRadius:4];
        //        UIView *guideBgView = [GuideVpnCountryView showNewGuideCircleWithArcCenter:center radius:radius];
        [self addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [HWUserdefault insertObj:@(YES) withkey:NEW_GUIDE_VPN_SERVER_LOCATION];
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
            _topOffset.constant = 38;
        }
        
        [bgView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(bgView).offset(0);
        }];
    }
}

@end
