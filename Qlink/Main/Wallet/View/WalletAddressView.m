//
//  ManageFundsView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/29.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "WalletAddressView.h"
#import "UIView+Animation.h"

#import "HMScanner.h"

@implementation WalletAddressView

+ (WalletAddressView *)getNibView {
    WalletAddressView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"WalletAddressView" owner:self options:nil] firstObject];
    nibView.lblAddress.text = [CurrentWalletInfo getShareInstance].address;
    [nibView centerCodeImage];
    return nibView;
}

- (void) centerCodeImage
{
    @weakify_self
    [HMScanner qrImageWithString:[CurrentWalletInfo getShareInstance].address avatar:nil completion:^(UIImage *image) {
        weakSelf.codeImageView.image = image;
    }];
}

- (IBAction)backAction:(id)sender {
    
    
    [self zoomOutAnimationDuration:.6 target:self callback:@selector(dismiss)];
}
- (IBAction)clickCopy:(id)sender {
    //  通用的粘贴板
    UIPasteboard *pBoard = [UIPasteboard generalPasteboard];
    if (_lblAddress.text) {
        pBoard.string = _lblAddress.text;
        [AppD.window showHint:NSStringLocalizable(@"copy_successs")];
        //[self showHint:NSStringLocalizable(@"copy_successs")];
    }
}

- (void)dismiss {
    [self removeFromSuperview];
}


@end
