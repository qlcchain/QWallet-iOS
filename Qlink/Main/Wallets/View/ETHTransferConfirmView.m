//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ETHTransferConfirmView.h"
#import "UIView+Visuals.h"
#import "WalletCommonModel.h"
#import "GlobalConstants.h"
#import "UIView+PopAnimate.h"

@interface ETHTransferConfirmView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *walletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *walletAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *sendtoLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *gasfeeLab;

@end

@implementation ETHTransferConfirmView

+ (instancetype)getInstance {
    ETHTransferConfirmView *view = [[[NSBundle mainBundle] loadNibNamed:@"ETHTransferConfirmView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
//    [view configInit];
    return view;
}

//- (void)configInit {
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    _walletNameLab.text = currentWalletM.name;
//    _walletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[currentWalletM.address substringToIndex:8],[currentWalletM.address substringWithRange:NSMakeRange(currentWalletM.address.length - 8, 8)]];
//}

- (void)configWithFromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress amount:(NSString *)amount gasfee:(NSString *)gasfee {
    
    WalletCommonModel *walletM = [WalletCommonModel getWalletWithAddress:fromAddress];
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    _walletNameLab.text = walletM.name;
    _walletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[walletM.address substringToIndex:8],[walletM.address substringWithRange:NSMakeRange(walletM.address.length - 8, 8)]];
    
    _sendtoLab.text = toAddress;
    _amountLab.text = amount;
    _gasfeeLab.text = gasfee;
}

- (void)configWithName:(NSString *)nameFrom sendFrom:(NSString *)sendFrom sendTo:(NSString *)sendTo amount:(NSString *)amount gasfee:(NSString *)gasfee {
    _walletNameLab.text = nameFrom;
    _walletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[sendFrom substringToIndex:8],[sendFrom substringWithRange:NSMakeRange(sendFrom.length - 8, 8)]];
    _sendtoLab.text = sendTo;
    _amountLab.text = amount;
    _gasfeeLab.text = gasfee;
}

- (void)show {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
    [self.tipBack showPopAnimate];
}

- (void)hide {
    [self removeFromSuperview];
}

- (IBAction)okAction:(id)sender {
    if (_confirmBlock) {
        _confirmBlock();
    }
    [self hide];
}

- (IBAction)closeAction:(id)sender {
    [self hide];
}


@end
