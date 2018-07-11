//
//  GuidenSettingView.m
//  Qlink
//
//  Created by 旷自辉 on 2018/7/4.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "GuidenSettingView.h"

@interface GuidenSettingView ()

@property (weak, nonatomic) IBOutlet UIImageView *dottedBoxView;

@end

@implementation GuidenSettingView

+ (GuidenSettingView *)getNibView {
    GuidenSettingView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"GuidenSettingView" owner:self options:nil] firstObject];
    
    return nibView;
}

- (void)showGuideTo:(CGRect)hollowOutFrame tapBlock:(void (^)(void))tapB {
    [HWUserdefault insertObj:@(NO) withkey:NEW_GUIDE_WALLET_DETAIL];
    NSNumber *guideLocal = [HWUserdefault getObjectWithKey:NEW_GUIDE_WALLET_DETAIL];
    if (!guideLocal || [guideLocal boolValue] == NO) {
        UIView *bgView = [UIApplication sharedApplication].keyWindow;
        
        UIView *guideBgView = [GuidenSettingView showNewGuideRectWithRoundedRect:hollowOutFrame cornerRadius:4];
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
            _topOffset.constant = 95 + 4;
            _dottedBoxView.image = [UIImage imageNamed:@"img_floating_layer_settings_5"];
        } else if (IS_iPhone_6) {
            
        } else if (IS_iPhone6_Plus) {
            _topOffset.constant = 95 - 3;
            _dottedBoxView.image = [UIImage imageNamed:@"img_floating_layer_settings_6p"];
        } else if (IS_iPhoneX) {
            _topOffset.constant = 95 - 20;
        }
        
        [bgView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(bgView).offset(0);
        }];
    }
}

@end
