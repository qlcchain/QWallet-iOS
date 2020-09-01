//
//  QSwipViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2020/8/10.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QSwipViewController.h"
#import "NSString+Trim.h"
#import "QClaimAlertView.h"
#import <TMCache/TMCache.h>
#import "NEOAddressInfoModel.h"
#import "WalletSelectViewController.h"
#import "WalletCommonModel.h"
#import "QNavigationController.h"
#import "QSwipWrapperRequestUtil.h"
#import "ContractNeoRequest.h"
#import "ContractETHRequest.h"
#import "SystemUtil.h"
#import "AFHTTPClientV2.h"
#import "NSStringUtil.h"
#import "QSwapProcessAnimateView.h"
#import <ETHFramework/ETHFramework.h>
#import "QSwapAddressModel.h"


static NSInteger minCount = 5;

@interface QSwipViewController ()

@property (weak, nonatomic) IBOutlet UIButton *invokeBtn;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (nonatomic, strong) ContractNeoRequest *neoRequest;

@property (nonatomic, assign) NSInteger warpperCheckStatu;

//// Stake From
//@property (weak, nonatomic) IBOutlet UITextField *swipFromTF;
@property (weak, nonatomic) IBOutlet UILabel *swipFromWalletNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *swipFromIcon;
@property (weak, nonatomic) IBOutlet UILabel *swipFromWalletAddressLab;
//@property (weak, nonatomic) IBOutlet UIView *swipFromWalletBack;

// Stake To
@property (weak, nonatomic) IBOutlet UITextField *swipToTF;
@property (weak, nonatomic) IBOutlet UILabel *swipToWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *swipToWalletAddressLab;
@property (weak, nonatomic) IBOutlet UIView *swipToWalletBack;
@property (weak, nonatomic) IBOutlet UILabel *swipToTsLab;
@property (weak, nonatomic) IBOutlet UIImageView *swipToIcon;

@property (weak, nonatomic) IBOutlet UILabel *balanceLab;

@property (nonatomic, strong) WalletCommonModel *swipFromWalletM;
@property (nonatomic, strong) WalletCommonModel *swipToWalletM;
@property (nonatomic, assign) double blaneOf;

@property (nonatomic, strong) QSwapProcessAnimateView *swapProcessV;


@end

@implementation QSwipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    [self configInit];
  
}

#pragma mark---layz
- (ContractNeoRequest *)neoRequest
{
    if (!_neoRequest) {
        _neoRequest = [ContractNeoRequest addContractNeoRequest];
    }
    return _neoRequest;
}

#pragma mark - Operation
- (void)configInit {
    
    _invokeBtn.layer.cornerRadius = 4;
    _invokeBtn.layer.masksToBounds = YES;
    _invokeBtn.userInteractionEnabled = NO; // D5D8DD
    _invokeBtn.backgroundColor = UIColorFromRGB(0xD5D8DD);
    //_swipFromWalletBack.hidden = YES;
    _swipToWalletBack.hidden = YES;
    
     WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeETH) {
        _swipToTsLab.text = kLang(@"select_NEP5_Wallet");
        _swipToTF.placeholder = kLang(@"select_NEP5_Wallet");
    } else {
        _swipToTsLab.text = kLang(@"select_ERC20_Wallet");
        _swipToTF.placeholder = kLang(@"select_ERC20_Wallet");
    }
    kWeakSelf(self)
    [self getWrapperAddresssAndBlaneOfHandler:^(id  _Nullable result, BOOL success, NSString * _Nullable message) {
        if (!success) {
            [weakself getWrapperAddresssAndBlaneOfHandler:^(id  _Nullable result, BOOL success, NSString * _Nullable message) {
                if (success) {
                    weakself.warpperCheckStatu = 1;
                } else {
                    weakself.warpperCheckStatu = -1;
                }
                
            }];
        } else {
            weakself.warpperCheckStatu = 1;
        }
    }];
    _swipFromIcon.image = [WalletCommonModel walletIcon:currentWalletM.walletType];
    _swipFromWalletAddressLab.text = currentWalletM.address;
    _swipFromWalletNameLab.text = currentWalletM.name;
    
    [_amountTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
}
#pragma mark ------------request
- (void) getWrapperAddresssAndBlaneOfHandler:(QWrapperResultBlock)resultHandler {
    // 获取wrapper 地址
    if (![QSwapAddressModel getShareObject].ethAddress || [QSwapAddressModel getShareObject].ethAddress.length == 0) {
        kWeakSelf(self)
        [QSwipWrapperRequestUtil checkWrapperOnlineResultHandler:^(id  _Nullable result, BOOL success, NSString * _Nullable message) {
            if (success) {
                WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
                [weakself getAddressBlanceOfWithAddress:currentWalletM.address Handler:resultHandler];
            } else {
                resultHandler(nil,NO,nil);
            }
        }];
    } else {
        WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
        [self getAddressBlanceOfWithAddress:currentWalletM.address Handler:resultHandler];
    }
}
/// 得到当前钱包佘额
/// @param address address
- (void) getAddressBlanceOfWithAddress:(NSString *) address Handler:(QWrapperResultBlock)resultHandler
{
    
    kWeakSelf(self)
    [[ContractETHRequest addContractETHRequest] getBalanceOfhWithAddress:address completionHandler:^(id  _Nonnull responseObject) {
        if (responseObject && !([responseObject containsString:@"null"] || [responseObject containsString:@"NULL"])  && [responseObject doubleValue]>0) {
            NSString *blanceStr = [NSStringUtil notRounding:responseObject afterPoint:2]?:@"";
            weakself.blaneOf = [blanceStr doubleValue];
            weakself.balanceLab.text = [NSString stringWithFormat:@"%@: %@ QLC",kLang(@"balance"),blanceStr];
            resultHandler(nil,YES,nil);
        } else if (responseObject && [responseObject doubleValue] == 0) {
            resultHandler(nil,YES,nil);
        } else {
            resultHandler(nil,NO,nil);
        }
    }];
}
#pragma mark---进度load
- (void)showSwapProcessView {
    _swapProcessV = [QSwapProcessAnimateView getInstance];
    [_swapProcessV show];
}

- (void)hideSwapProcessView {
    if (_swapProcessV) {
        [_swapProcessV hide];
        _swapProcessV = nil;
    }
}
#pragma mark - 刷新UI
- (void)refreshInvokeBtnState {
    if (![_amountTF.text.trim_whitespace isEmptyString] && ![_swipToTF.text.trim_whitespace isEmptyString]) {
        _invokeBtn.userInteractionEnabled = YES;
        _invokeBtn.backgroundColor = MAIN_BLUE_COLOR;
    } else {
        _invokeBtn.userInteractionEnabled = NO;
        _invokeBtn.backgroundColor = UIColorFromRGB(0xD5D8DD);
    }
}

- (void)changedTextField:(UITextField *)textField {
    [self refreshInvokeBtnState];
}


#pragma mark---Action
- (IBAction)confirmAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if (!_swipToWalletM) {
        [kAppD.window makeToastDisappearWithText:@"Swap To is empty"];
        return;
    }
    if ([_amountTF.text.trim_whitespace doubleValue] < minCount) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"Swap quantity must be greater than %ld",minCount]];
        return;
    }
    
    if (_warpperCheckStatu == 0) {
        [kAppD.window makeToastDisappearWithText:@"Please wait"];
        return;
    }
    
    if (_warpperCheckStatu == -1) {
        _warpperCheckStatu = 0;
        [self getWrapperAddresssAndBlaneOfHandler:^(id  _Nullable result, BOOL success, NSString * _Nullable message) {
            
        }];
    }

    if ([_amountTF.text.trim_whitespace doubleValue] > _blaneOf) {
        [kAppD.window makeToastDisappearWithText:kLang(@"balance_is_not_enough")];
        return;
    }
    
    NSString *wrapperAddress = @"0x0A8EFAacbeC7763855b9A39845DDbd03b03775C1";
//    NSString *privateKey = @"6048ad0d8cd9a99b8c94ae7347091cb1230f34a92ce30f2aa78c7ed59a62c3cd";
//    NSString *address = @"0xE0632e90d6eB6649CfD82f6d625769cCf9E7762f";
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    QClaimAlertView *alertView = [QClaimAlertView getInstance];
    [alertView configWithFromAddress:currentWalletM.address toAddress:_swipToWalletM.address amount:_amountTF.text.trim_whitespace tokenName:currentWalletM.name fromType:currentWalletM.walletType alertTitle:@"Swap" ethAddress:currentWalletM.walletType == WalletTypeETH? currentWalletM.address:@""];
    kWeakSelf(self)
    
    [alertView setConfirmBlock:^(NSString * _Nonnull gasPrice){
        [weakself showSwapProcessView];
        // 获取钱包私钥
        [TrustWalletManage.sharedInstance exportPrivateKeyWithAddress:currentWalletM.address?:@"" :^(NSString * privateKey) {
           // lock
            [[ContractETHRequest addContractETHRequest] destoryLockhWithPrivate:privateKey address:currentWalletM.address toAddress:weakself.swipToWalletM.address wrapperAddress:wrapperAddress amount:[_amountTF.text.trim_whitespace integerValue] gasPrice:gasPrice completionHandler:^(id  _Nonnull responseObject) {
               [weakself hideSwapProcessView];
           }];
        }];
        
    }];
    [alertView show];
     
}

//- (IBAction)clickSwipFromBtn:(id)sender {
//    _swipFromWalletBack.hidden = YES;
//    _swipFromWalletM = nil;
//    _swipFromTF.text = @"";
//
//    [self refreshInvokeBtnState];
//
//}
//
//- (IBAction)clickSwipFromShowBtn:(id)sender {
//    kWeakSelf(self);
//    WalletSelectViewController *vc = [[WalletSelectViewController alloc] init];
//    vc.inputWalletType = WalletTypeNEO;
//    [vc configSelectBlock:^(WalletCommonModel * _Nonnull model) {
//        weakself.swipFromWalletBack.hidden = NO;
//        weakself.swipFromWalletM = model;
//
//        weakself.swipFromWalletNameLab.text = model.name;
//        weakself.swipFromWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
//        weakself.swipFromTF.text = model.address;
//
//       // [weakself requestNEOAddressInfo:model.address];
//        [weakself refreshInvokeBtnState];
//    }];
//    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
//    nav.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:nav animated:YES completion:nil];
//}

- (IBAction)clickSwipToBtn:(id)sender {
    
    _swipToWalletBack.hidden = YES;
    _swipToWalletM = nil;
    _swipToTF.text = @"";
    
    [self refreshInvokeBtnState];
}
- (IBAction)clickSwipToShowBtn:(id)sender {
    kWeakSelf(self);
    WalletSelectViewController *vc = [[WalletSelectViewController alloc] init];
     WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeNEO) {
        vc.inputWalletType = WalletTypeETH;
    } else {
        vc.inputWalletType = WalletTypeNEO;
    }
    
    [vc configSelectBlock:^(WalletCommonModel * _Nonnull model) {
        weakself.swipToWalletBack.hidden = NO;
        weakself.swipToWalletM = model;
        
        weakself.swipToWalletNameLab.text = model.name;
        weakself.swipToWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
        weakself.swipToTF.text = model.address;
        weakself.swipToIcon.image = [WalletCommonModel walletIcon:model.walletType];
       // [weakself requestNEOAddressInfo:model.address];
        [weakself refreshInvokeBtnState];
    }];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

@end
