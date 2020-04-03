//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "GroupBuyKnowDelegateView.h"
#import "UIView+Visuals.h"
#import "WalletCommonModel.h"
#import "GlobalConstants.h"
#import "UIView+PopAnimate.h"

@interface GroupBuyKnowDelegateView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;


@end

@implementation GroupBuyKnowDelegateView

+ (instancetype)getInstance {
    GroupBuyKnowDelegateView *view = [[[NSBundle mainBundle] loadNibNamed:@"GroupBuyKnowDelegateView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
//    [view configInit];
    return view;
    
}

//- (void)configInit {
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    _walletNameLab.text = currentWalletM.name;
//    _walletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[currentWalletM.address substringToIndex:8],[currentWalletM.address substringWithRange:NSMakeRange(currentWalletM.address.length - 8, 8)]];
//}

- (void)show {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
    [self.tipBack showPopAnimate];
}

- (void)hide {
    [self removeFromSuperview];
}

- (IBAction)okAction:(id)sender {
    if (_okBlock) {
        _okBlock();
    }
    [self hide];
}

- (IBAction)closeAction:(id)sender {
    [self hide];
}


@end
