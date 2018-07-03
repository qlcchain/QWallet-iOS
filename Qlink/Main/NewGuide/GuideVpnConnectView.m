//
//  GuideVpnConnectView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/7/3.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "GuideVpnConnectView.h"

@interface GuideVpnConnectView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerOffset;

@end

@implementation GuideVpnConnectView

+ (GuideVpnConnectView *)getNibView {
    GuideVpnConnectView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"GuideVpnConnectView" owner:self options:nil] firstObject];
    
    return nibView;
}

- (void)showGuideTo:(CGRect)hollowOutFrame tapBlock:(void (^)(void))tapB {
//    [HWUserdefault insertObj:@(NO) withkey:NEW_GUIDE_VPN_CONNECT];
    NSNumber *guideLocal = [HWUserdefault getObjectWithKey:NEW_GUIDE_VPN_CONNECT];
    if (!guideLocal || [guideLocal boolValue] == NO) {
        UIView *bgView = [UIApplication sharedApplication].keyWindow;
        UIView *guideBgView = [GuideVpnConnectView showNewGuideRectWithRoundedRect:hollowOutFrame cornerRadius:4];
        [self addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [HWUserdefault insertObj:@(YES) withkey:NEW_GUIDE_VPN_CONNECT];
            UIView *tapView = gestureRecoginzer.view;
            [tapView removeFromSuperview];
            [tapView removeGestureRecognizer:gestureRecoginzer];
            [guideBgView removeFromSuperview];
            if (tapB) {
                tapB();
            }
        }];
        
        if (IS_iPhone_5) {
            _bottomOffset.constant = SCREEN_HEIGHT - (hollowOutFrame.origin.y+hollowOutFrame.size.height) - 5;
            _centerOffset.constant = 86;
        } else if (IS_iPhone_6) {
            _bottomOffset.constant = SCREEN_HEIGHT - (hollowOutFrame.origin.y+hollowOutFrame.size.height) - 5;
            _centerOffset.constant = 86;
        } else if (IS_iPhone6_Plus) {
            _bottomOffset.constant = SCREEN_HEIGHT - (hollowOutFrame.origin.y+hollowOutFrame.size.height) - 5;
            _centerOffset.constant = 86;
        } else if (IS_iPhoneX) {
            _bottomOffset.constant = SCREEN_HEIGHT - (hollowOutFrame.origin.y+hollowOutFrame.size.height) - 5;
            _centerOffset.constant = 86;
        }
        
        [bgView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(bgView).offset(0);
        }];
    }
}

@end
