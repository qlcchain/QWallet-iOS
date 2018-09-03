//
//  GuideNewWalletView.m
//  Qlink
//
//  Created by 旷自辉 on 2018/7/4.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "GuideNewWalletView.h"

@interface GuideNewWalletView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOffset;

@end

@implementation GuideNewWalletView
+ (GuideNewWalletView *)getNibView {
    GuideNewWalletView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"GuideNewWalletView" owner:self options:nil] firstObject];
    
    return nibView;
}

- (void)showGuideTo:(CGRect)hollowOutFrame tapBlock:(void (^)(void))tapB {
//    [HWUserdefault insertObj:@(NO) withkey:NEW_GUIDE_CREATE_NEW_WALLET];
    NSNumber *guideLocal = [HWUserdefault getObjectWithKey:NEW_GUIDE_CREATE_NEW_WALLET];
    if (!guideLocal || [guideLocal boolValue] == NO) {
        UIView *bgView = [UIApplication sharedApplication].keyWindow;
        
        UIView *guideBgView = [GuideNewWalletView showNewGuideRectWithRoundedRect:hollowOutFrame cornerRadius:4];
        [self addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [HWUserdefault insertObj:@(YES) withkey:NEW_GUIDE_CREATE_NEW_WALLET];
            UIView *tapView = gestureRecoginzer.view;
            [tapView removeFromSuperview];
            [tapView removeGestureRecognizer:gestureRecoginzer];
            [guideBgView removeFromSuperview];
            if (tapB) {
                tapB();
            }
        }];
         _topOffset.constant = hollowOutFrame.origin.y-5.5;
        if (IS_iPhone_5) {
            
        } else if (IS_iPhone_6) {
            
        } else if (IS_iPhone6_Plus) {
            
        } else if (IS_iPhoneX) {
           
        }
        
        [bgView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(bgView).offset(0);
        }];
    }
}

@end
