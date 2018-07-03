//
//  ManageFundsView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/29.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "WalletMenuView.h"

@interface WalletMenuView ()

@property (nonatomic, copy) WalletMenuBlock menuB;

@end

@implementation WalletMenuView

+ (WalletMenuView *)getNibView {
    WalletMenuView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"WalletMenuView" owner:self options:nil] firstObject];
    
    return nibView;
}

- (void)configWalletMenu:(WalletMenuBlock)block {
    _menuB = block;
}

- (IBAction)registeredAssetsAction:(id)sender {
    if (_menuB) {
        _menuB(RegisteredAssets);
    }
}

- (IBAction)sendFundsAction:(id)sender {
    if (_menuB) {
        _menuB(SendFunds);
    }
}

- (IBAction)viewHistoryAction:(id)sender {
    if (_menuB) {
        _menuB(ViewHistory);
    }
}

- (IBAction)buyQlcAction:(id)sender {
    if (_menuB) {
        _menuB(BuyQlc);
    }
}

@end
