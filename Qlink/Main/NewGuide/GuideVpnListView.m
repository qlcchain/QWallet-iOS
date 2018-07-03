//
//  GuideVpnListView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/7/3.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "GuideVpnListView.h"

@interface GuideVpnListView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOffset;

@end

@implementation GuideVpnListView

+ (GuideVpnListView *)getNibView {
    GuideVpnListView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"GuideVpnListView" owner:self options:nil] firstObject];
    
    return nibView;
}

- (void)showGuideTo:(CGRect)hollowOutFrame tapBlock:(void (^)(void))tapB {
//    [HWUserdefault insertObj:@(NO) withkey:NEW_GUIDE_VPN_LIST];
    NSNumber *guideLocal = [HWUserdefault getObjectWithKey:NEW_GUIDE_VPN_LIST];
    if (!guideLocal || [guideLocal boolValue] == NO) {
        UIView *bgView = [UIApplication sharedApplication].keyWindow;
        //        CGRect hollowOutFrame = [toView.superview convertRect:toView.frame toView:bgView];
        //        CGPoint center = CGPointMake((hollowOutFrame.origin.x*2.0+hollowOutFrame.size.width)/2.0, (hollowOutFrame.origin.y*2.0+hollowOutFrame.size.height)/2.0);
        //        CGFloat radius = (hollowOutFrame.size.width)/2.0;
        //        @weakify_self
        UIView *guideBgView = [GuideVpnListView showNewGuideRectWithRoundedRect:hollowOutFrame cornerRadius:4];
        //        UIView *guideBgView = [GuideVpnCountryView showNewGuideCircleWithArcCenter:center radius:radius];
        [self addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [HWUserdefault insertObj:@(YES) withkey:NEW_GUIDE_VPN_LIST];
            UIView *tapView = gestureRecoginzer.view;
            [tapView removeFromSuperview];
            [tapView removeGestureRecognizer:gestureRecoginzer];
            [guideBgView removeFromSuperview];
            if (tapB) {
                tapB();
            }
        }];
        
        if (IS_iPhone_5) {
            _topOffset.constant = 173;
        } else if (IS_iPhone_6) {
            _topOffset.constant = 173;
        } else if (IS_iPhone6_Plus) {
            _topOffset.constant = 173;
        } else if (IS_iPhoneX) {
            _topOffset.constant = 173;
        }
        
        [bgView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(bgView).offset(0);
        }];
    }
}

@end
