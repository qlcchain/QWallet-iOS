//
//  UIView+ToastAlert.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/27.
//  Copyright © 2018 pan. All rights reserved.
//

#import "UIView+ToastAlert.h"
#import "WalletAlertView.h"
#import "VpnToastView.h"

@implementation UIView (ToastAlert)

// 钱包操作alertview
- (void) showWalletAlertViewWithTitle:(NSString *) alertTitle msg:(NSMutableAttributedString *) msgArrtrbuted isShowTwoBtn:(BOOL) isTwo block:(void (^)(void))calculateBlock;
{
    WalletAlertView *alertView = [WalletAlertView loadWalletAlertView];
    //alertView.lblTitle.text = @"CONFIRM PURCHASE";
    if ([NSStringUtil getNotNullValue:alertTitle]) {
        alertView.lblTitle.text = alertTitle;
    } else {
        alertView.lblTitle.text = NSStringLocalizable(@"purchase");
    }
    
    alertView.lblMsg.attributedText = msgArrtrbuted;
    [alertView showIsTwoBtn:isTwo];
    
    alertView.yesClickBlock = ^{
        if (calculateBlock) {
            calculateBlock();
        }
        
    };
}
// vpn操作alertview
+ (void) showVPNToastAlertViewWithTopImageName:(NSString *) imageName content:(NSString *) content block:(void (^)(void))clickYesBlock
{
    VpnToastView *alertView = [VpnToastView loadVPN2ToastView];
    alertView.topImageView.image = [UIImage imageNamed:imageName];
    alertView.lblContent.text = content;
    [alertView showToastView];
    alertView.yesClickBlock = ^{
        if (clickYesBlock) {
            clickYesBlock();
        }
    };
}

@end
