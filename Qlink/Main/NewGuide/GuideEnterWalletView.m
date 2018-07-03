//
//  GuideEnterWalletView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/7/3.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "GuideEnterWalletView.h"

@interface GuideEnterWalletView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightOffset;


@end

@implementation GuideEnterWalletView

+ (GuideEnterWalletView *)getNibView {
    GuideEnterWalletView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"GuideEnterWalletView" owner:self options:nil] firstObject];
    
    return nibView;
}

- (void)showGuideTo:(CGRect)hollowOutFrame tapBlock:(void (^)(void))tapB {
//    [HWUserdefault insertObj:@(NO) withkey:NEW_GUIDE_ENTER_WALLET];
    NSNumber *guideLocal = [HWUserdefault getObjectWithKey:NEW_GUIDE_ENTER_WALLET];
    if (!guideLocal || [guideLocal boolValue] == NO) {
        UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
        CGPoint center = CGPointMake((hollowOutFrame.origin.x*2.0+hollowOutFrame.size.width)/2.0, (hollowOutFrame.origin.y*2.0+hollowOutFrame.size.height)/2.0);
        CGFloat radius = (hollowOutFrame.size.width)/2.0;
        UIView *guideBgView = [GuideEnterWalletView showNewGuideCircleWithArcCenter:center radius:radius];
        [self addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [HWUserdefault insertObj:@(YES) withkey:NEW_GUIDE_ENTER_WALLET];
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
        } else if (IS_iPhone_6) {
            _topOffset.constant = 27;
            _rightOffset.constant = 14;
        } else if (IS_iPhone6_Plus) {
            _topOffset.constant = 27;
            _rightOffset.constant = 14;
        } else if (IS_iPhoneX) {
            _topOffset.constant = 27+24;
            _rightOffset.constant = 14;
        }
        
        [keyWindow addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(keyWindow).offset(0);
        }];
    }
}

@end
