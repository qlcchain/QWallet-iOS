//
//  ManageFundsView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/29.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "WalletAddressView.h"
#import "UIView+Animation.h"
#import "WalletCommonModel.h"
#import "SGQRCodeObtain.h"

@implementation WalletAddressView

+ (WalletAddressView *)getNibView {
    WalletAddressView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"WalletAddressView" owner:self options:nil] firstObject];
    nibView.lblAddress.text = [WalletCommonModel getCurrentSelectWallet].address;
    [nibView centerCodeImage];
    return nibView;
}

- (void) centerCodeImage {
    _codeImageView.image = [SGQRCodeObtain generateQRCodeWithData:[WalletCommonModel getCurrentSelectWallet].address?:@"" size:_codeImageView.width logoImage:nil ratio:0.15];
//    kWeakSelf(self);
//    [HMScanner qrImageWithString:[WalletCommonModel getCurrentSelectWallet].address avatar:nil completion:^(UIImage *image) {
//        weakself.codeImageView.image = image;
//    }];
}

- (IBAction)backAction:(id)sender {
    
    [self zoomOutAnimationDuration:.6 target:self callback:@selector(dismiss)];
}
- (IBAction)clickCopy:(id)sender {
    //  通用的粘贴板
    UIPasteboard *pBoard = [UIPasteboard generalPasteboard];
    if (_lblAddress.text) {
        pBoard.string = _lblAddress.text;
        [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"copy_successs")];
    }
}

- (void)dismiss {
    [self removeFromSuperview];
}


@end
