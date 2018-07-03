//
//  GuideClickWalletView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/7/3.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "GuideClickWalletView.h"

@interface GuideClickWalletView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightOffset;

@end

@implementation GuideClickWalletView

+ (GuideClickWalletView *)getNibView {
    GuideClickWalletView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"GuideClickWalletView" owner:self options:nil] firstObject];
    
    return nibView;
}

- (void)showGuideTo:(CGRect)hollowOutFrame tapBlock:(void (^)(void))tapB {
//    [HWUserdefault insertObj:@(NO) withkey:NEW_GUIDE_CLICK_WALLET];
    NSNumber *guideLocal = [HWUserdefault getObjectWithKey:NEW_GUIDE_CLICK_WALLET];
    if (!guideLocal || [guideLocal boolValue] == NO) {
        UIView *bgView = [UIApplication sharedApplication].keyWindow;
//        CGRect hollowOutFrame = [toView.superview convertRect:toView.frame toView:bgView];
        CGPoint center = CGPointMake((hollowOutFrame.origin.x*2.0+hollowOutFrame.size.width)/2.0, (hollowOutFrame.origin.y*2.0+hollowOutFrame.size.height)/2.0);
        CGFloat radius = (hollowOutFrame.size.width)/2.0;
        //        @weakify_self
        UIView *guideBgView = [GuideClickWalletView showNewGuideCircleWithArcCenter:center radius:radius];
        [self addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [HWUserdefault insertObj:@(YES) withkey:NEW_GUIDE_CLICK_WALLET];
            UIView *tapView = gestureRecoginzer.view;
            [tapView removeFromSuperview];
            [tapView removeGestureRecognizer:gestureRecoginzer];
            [guideBgView removeFromSuperview];
            if (tapB) {
                tapB();
            }
        }];
        
        if (IS_iPhone_5) {
            _bottomOffset.constant = -2;
            _rightOffset.constant = 20;
        } else if (IS_iPhone_6) {
            _bottomOffset.constant = -2;
            _rightOffset.constant = 20;
        } else if (IS_iPhone6_Plus) {
            _bottomOffset.constant = -2;
            _rightOffset.constant = 20;
        } else if (IS_iPhoneX) {
            _bottomOffset.constant = -2;
            _rightOffset.constant = 20;
        }
        
        [bgView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(bgView).offset(0);
        }];
    }
}

@end
