//
//  ETHWalletAddressViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "PayReceiveAddressViewController.h"
#import "WalletCommonModel.h"
#import "UIView+DottedBox.h"
#import "SGQRCodeObtain.h"
#import "PayETHViewController.h"
#import "TradeOrderInfoModel.h"
//#import "GlobalConstants.h"
#import "PayNEOViewController.h"
#import "PayQLCViewController.h"

@interface PayReceiveAddressViewController ()

@property (weak, nonatomic) IBOutlet UIView *qrcodeBack;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImgV;
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *topTipLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation PayReceiveAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self renderView];
    [self configInit];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_boxView addDottedBox:UIColorFromRGB(0xC0C0C0) fillColor:[UIColor clearColor] cornerRadius:6 lineWidth:1];
}

#pragma mark - Operation
- (void)renderView {
    UIColor *shadowColor = [UIColorFromRGB(0x1F314A) colorWithAlphaComponent:0.12];
    [_qrcodeBack shadowWithColor:shadowColor offset:CGSizeMake(0, 2) opacity:1 radius:4];
    
    _confirmBtn.layer.cornerRadius = 4;
    _confirmBtn.layer.masksToBounds = YES;
}

- (void)configInit {
    NSString *gasStr = @"";
    NSString *topTipStr = @"";
    _titleLab.text = [NSString stringWithFormat:@"%@ %@",_tradeM.payToken,kLang(@"receivable_address")];
    gasStr = [NSString stringWithFormat:@"%@ %@",_tradeM.usdtAmount?:@"",_tradeM.payToken];
    topTipStr = [NSString stringWithFormat:@"%@ %@ %@",kLang(@"please_send"),gasStr,kLang(@"to_the_address_as_below_to_place_your_order")];
//    if (_inputAddressType == PayReceiveAddressTypeUSDT) {
//    } else if (_inputAddressType == PayReceiveAddressTypeQGAS) {
//        _titleLab.text = @"QGAS Receivable Address";
//        gasStr = [NSString stringWithFormat:@"%@ QGAS",_tradeM.qgasAmount?:@""];
//        topTipStr = [NSString stringWithFormat:@"Please send %@ to the QLC Chain address as below to place your order.",gasStr];
//    }
    NSMutableAttributedString *topTipAtt = [[NSMutableAttributedString alloc] initWithString:topTipStr];
    [topTipAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x030303) range:NSMakeRange(0, topTipStr.length)];
    [topTipAtt addAttribute:NSForegroundColorAttributeName value:MAIN_BLUE_COLOR range:[topTipStr rangeOfString:gasStr]];
    [topTipAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, topTipStr.length)];
    _topTipLab.attributedText = topTipAtt;
    
    _addressLab.text = _tradeM.usdtToAddress?:@"";
    
    // @"eth_usdt"
    NSString *chain = [WalletCommonModel chainFromTokenChain:_tradeM.payTokenChain];
    NSString *imgStr = [NSString stringWithFormat:@"%@_%@",[chain lowercaseString],[_tradeM.payToken lowercaseString]];
    UIImage *img = [UIImage imageNamed:imgStr];
//    UIImage *img = _inputAddressType == PayReceiveAddressTypeUSDT?[UIImage imageNamed:@"eth_usdt"]:[UIImage imageNamed:@"qlc_qgas"];
    _qrcodeImgV.image = [SGQRCodeObtain generateQRCodeWithData:_tradeM.usdtToAddress?:@"" size:_qrcodeImgV.width logoImage:img ratio:0.2 logoImageCornerRadius:0 logoImageBorderWidth:0 logoImageBorderColor:[UIColor clearColor]];
}

//- (void)showSubmitSuccess {
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Submitted Successfully! " message:@"Verification status will be updated on the ME page." preferredStyle:UIAlertControllerStyleAlert];
//    kWeakSelf(self)
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [weakself.navigationController popToRootViewControllerAnimated:YES];
//    }];
//    [alertVC addAction:action1];
//    [self presentViewController:alertVC animated:YES completion:nil];
//}

#pragma mark -Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareAction:(id)sender {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[_qrcodeImgV.image] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAirDrop];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityVC animated:YES completion:nil];
    activityVC.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        if (completed) {
            NSLog(@"Share Success");
        } else {
            NSLog(@"Share Failed == %@",activityError.description);
        }
    };
}

- (IBAction)copyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _addressLab.text?:@"";
    [kAppD.window makeToastDisappearWithText:kLang(@"copied")];
    
}

- (IBAction)confirmAction:(id)sender {
    NSString *tokenChain = _tradeM.payTokenChain;
    if ([tokenChain isEqualToString:QLC_Chain]) {
        [self jumpToPayQLC];
    } else if ([tokenChain isEqualToString:NEO_Chain]) {
        [self jumpToPayNEO];
    } else if ([tokenChain isEqualToString:EOS_Chain]) {
        
    } else if ([tokenChain isEqualToString:ETH_Chain]) {
        [self jumpToPayETH];
    }
    
}

#pragma mark - Transition
- (void)jumpToPayETH {
    PayETHViewController *vc = [PayETHViewController new];
    vc.transferToRoot = _backToRoot;
    vc.transferToTradeDetail = _transferToTradeDetail;
    vc.sendAmount = _tradeM.usdtAmount?:@"";
    vc.sendToAddress = _tradeM.usdtToAddress?:@"";
    vc.sendMemo = _tradeM.number?:@"";
    vc.inputTradeOrderId = _tradeM.ID;
    vc.inputPayToken = _tradeM.payToken;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToPayNEO {
    PayNEOViewController *vc = [PayNEOViewController new];
    vc.transferToRoot = _backToRoot;
    vc.transferToTradeDetail = _transferToTradeDetail;
    vc.sendAmount = _tradeM.usdtAmount?:@"";
    vc.sendToAddress = _tradeM.usdtToAddress?:@"";
    vc.sendMemo = _tradeM.number?:@"";
    vc.inputTradeOrderId = _tradeM.ID;
    vc.inputPayToken = _tradeM.payToken;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToPayQLC {
    PayQLCViewController *vc = [PayQLCViewController new];
    vc.transferToRoot = _backToRoot;
    vc.transferToTradeDetail = _transferToTradeDetail;
    vc.sendAmount = _tradeM.usdtAmount?:@"";
    vc.sendToAddress = _tradeM.usdtToAddress?:@"";
    vc.sendMemo = _tradeM.number?:@"";
    vc.inputTradeOrderId = _tradeM.ID;
    vc.inputPayToken = _tradeM.payToken;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
