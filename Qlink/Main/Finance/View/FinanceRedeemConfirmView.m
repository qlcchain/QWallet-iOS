//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "FinanceRedeemConfirmView.h"
#import "UIView+Visuals.h"
#import "WalletCommonModel.h"
#import "Qlink-Swift.h"

@interface FinanceRedeemConfirmView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *walletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *walletAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *principalLab;
@property (weak, nonatomic) IBOutlet UILabel *earningsLab;


@end

@implementation FinanceRedeemConfirmView

+ (instancetype)getInstance {
    FinanceRedeemConfirmView *view = [[[NSBundle mainBundle] loadNibNamed:@"FinanceRedeemConfirmView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    [view configInit];
    return view;
}

- (void)configInit {
    NSString *address = [NEOWalletManage.sharedInstance getWalletAddress];
    WalletCommonModel *currentWalletM = [WalletCommonModel getWalletWithAddress:address];
    _walletNameLab.text = currentWalletM.name;
    _walletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[currentWalletM.address substringToIndex:8],[currentWalletM.address substringWithRange:NSMakeRange(currentWalletM.address.length - 8, 8)]];
}

- (void)configWithPrincipal:(NSString *)principal earnings:(NSString *)earnings {
    _principalLab.text = [NSString stringWithFormat:@"%@ QLC",principal];
    _earningsLab.text = [NSString stringWithFormat:@"%@ QLC",earnings];
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
