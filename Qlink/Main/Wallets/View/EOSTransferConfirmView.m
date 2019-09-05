//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "EOSTransferConfirmView.h"
#import "UIView+Visuals.h"
#import "WalletCommonModel.h"
#import "GlobalConstants.h"

@interface EOSTransferConfirmView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *walletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *walletAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *sendtoLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *memoLab;
@property (weak, nonatomic) IBOutlet UIView *memoBack;


@end

@implementation EOSTransferConfirmView

+ (instancetype)getInstance {
    EOSTransferConfirmView *view = [[[NSBundle mainBundle] loadNibNamed:@"EOSTransferConfirmView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    [view configInit];
    return view;
}

- (void)configInit {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    _walletNameLab.text = currentWalletM.name;
    _walletAddressLab.text = currentWalletM.account_name;
}

- (void)configWithAddress:(NSString *)sendto amount:(NSString *)amount memo:(NSString *)memo {
    _sendtoLab.text = sendto;
    _amountLab.text = amount;
    _memoLab.text = memo;
}

- (void)configWithWallet:(WalletCommonModel *)fromM to:(NSString *)sendto amount:(NSString *)amount memo:(NSString *)memo showMemo:(BOOL)showMemo {
    _walletNameLab.text = fromM.name;
    _walletAddressLab.text = fromM.account_name;
    _sendtoLab.text = sendto;
    _amountLab.text = amount;
    _memoLab.text = memo;
    _memoBack.hidden = !showMemo;
}

- (void)show {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
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


