//
//  GuideBackupKeyView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/7/4.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "GuideBackupKeyView.h"

@interface GuideBackupKeyView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOffset;
@property (weak, nonatomic) IBOutlet UIImageView *dottedBoxView;

@end

@implementation GuideBackupKeyView

+ (GuideBackupKeyView *)getNibView {
    GuideBackupKeyView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"GuideBackupKeyView" owner:self options:nil] firstObject];
    
    return nibView;
}

- (void)showGuideTo:(CGRect)hollowOutFrame tapBlock:(void (^)(void))tapB {
//    [HWUserdefault insertObj:@(NO) withkey:NEW_GUIDE_VPN_LIST];
    NSNumber *guideLocal = [HWUserdefault getObjectWithKey:NEW_GUIDE_VPN_LIST];
    if (!guideLocal || [guideLocal boolValue] == NO) {
        UIView *bgView = [UIApplication sharedApplication].keyWindow;
        UIView *guideBgView = [GuideBackupKeyView showNewGuideRectWithRoundedRect:hollowOutFrame cornerRadius:4];
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
            _topOffset.constant = 145;
            _dottedBoxView.image = [UIImage imageNamed:@"img_floating_layer_copy_address_5"];
        } else if (IS_iPhone_6) {
            _topOffset.constant = 145;
        } else if (IS_iPhone6_Plus) {
            _topOffset.constant = 145 - 10;
            _dottedBoxView.image = [UIImage imageNamed:@"img_floating_layer_copy_address_6p"];
        } else if (IS_iPhoneX) {
            _topOffset.constant = 145 + 24;
        }
        
        [bgView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(bgView).offset(0);
        }];
    }
}

@end
