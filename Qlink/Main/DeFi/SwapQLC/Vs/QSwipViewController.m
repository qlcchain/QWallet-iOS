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
#import "QSwapHashModel.h"
#import "QSwapStatusManager.h"


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
@property (weak, nonatomic) IBOutlet UILabel *lblSwapCountDesc;


@property (nonatomic, assign) NSInteger walletType;
@property (nonatomic, strong) WalletCommonModel *swipFromWalletM;
@property (nonatomic, strong) WalletCommonModel *swipToWalletM;
@property (nonatomic, assign) double blaneOf;

@property (nonatomic, strong) QSwapProcessAnimateView *swapProcessV;
@property (nonatomic, assign) BOOL userCancleSwap;


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
        _walletType = 2;
        _swipToTsLab.text = kLang(@"select_NEP5_Wallet");
        _swipToTF.placeholder = kLang(@"select_NEP5_Wallet");
    } else {
        _walletType = 1;
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
    /*
    if (![QSwapAddressModel getShareObject].ethAddress || [QSwapAddressModel getShareObject].ethAddress.length == 0) {
        kWeakSelf(self)
        [QSwipWrapperRequestUtil checkWrapperOnlineWithFetchEthAddress:@"" resultHandler:^(id  _Nullable result, BOOL success, NSString * _Nullable message) {
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
     */
    
    kWeakSelf(self)
    [QSwipWrapperRequestUtil checkWrapperOnlineWithFetchEthAddress:@"" resultHandler:^(id  _Nullable result, BOOL success, NSString * _Nullable message) {
        if (success) {
            if (weakself.walletType == 2) {
                NSInteger minCount = [[QSwapAddressModel getShareObject].minWithdrawAmount?:@"" doubleValue]/ERC20_UnitNum;
                weakself.amountTF.placeholder = [NSString stringWithFormat:kLang(@"swap_amount_min"),[NSString stringWithFormat:@"%ld",minCount]];
                weakself.lblSwapCountDesc.text = [NSString stringWithFormat:kLang(@"swap_amount_desc"),[NSString stringWithFormat:@"%ld",minCount]];
            } else {
                NSInteger minCount = [[QSwapAddressModel getShareObject].minDepositAmount?:@"" doubleValue]/QLC_UnitNum;
                weakself.amountTF.placeholder = [NSString stringWithFormat:kLang(@"swap_amount_min"),[NSString stringWithFormat:@"%ld",minCount]];
                weakself.lblSwapCountDesc.text = [NSString stringWithFormat:kLang(@"swap_amount_desc"),[NSString stringWithFormat:@"%ld",minCount]];
            }
            
            WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
            [weakself getAddressBlanceOfWithAddress:currentWalletM.address Handler:resultHandler];
        } else {
            resultHandler(nil,NO,nil);
        }
    }];
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
    _userCancleSwap = NO;
    _swapProcessV = [QSwapProcessAnimateView getInstance];
    [_swapProcessV show];
    kWeakSelf(self)
    [_swapProcessV setQCloseBlock:^{
        weakself.userCancleSwap = YES;
    }];
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
    
    if (_warpperCheckStatu == -1) {
        _warpperCheckStatu = 0;
        kWeakSelf(self)
        [self getWrapperAddresssAndBlaneOfHandler:^(id  _Nullable result, BOOL success, NSString * _Nullable message) {
            if (!success) {
                weakself.warpperCheckStatu = -1;
            }
        }];
    }
    
    if (_warpperCheckStatu == 0) {
        [kAppD.window makeToastDisappearWithText:@"Please wait"];
        return;
    }
    
    if (_walletType == 2) {
        NSInteger minCount = [[QSwapAddressModel getShareObject].minWithdrawAmount?:@"" doubleValue]/ERC20_UnitNum;
        if ([_amountTF.text.trim_whitespace doubleValue] < minCount) {
               [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"Swap quantity must be greater than %ld",minCount]];
               return;
        }
        // wrapper 余额不足
        if ([[QSwapAddressModel getShareObject].ethBalance doubleValue] < 0.01) {
            [kAppD.window makeToastDisappearWithText:kLang(@"balance_is_not_enough")];
            return;
        }
    } else {
         NSInteger minCount = [[QSwapAddressModel getShareObject].minDepositAmount?:@"" doubleValue]/QLC_UnitNum;
        if ([_amountTF.text.trim_whitespace doubleValue] < minCount) {
               [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"Swap quantity must be greater than %ld",minCount]];
               return;
        }
    }

    if ([_amountTF.text.trim_whitespace doubleValue] > _blaneOf) {
        [kAppD.window makeToastDisappearWithText:kLang(@"balance_is_not_enough")];
        return;
    }
    
    
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    QClaimAlertView *alertView = [QClaimAlertView getInstance];
    [alertView configWithFromAddress:currentWalletM.address toAddress:_swipToWalletM.address amount:_amountTF.text.trim_whitespace tokenName:currentWalletM.name fromType:currentWalletM.walletType alertTitle:@"Swap" ethAddress:currentWalletM.walletType == WalletTypeETH? currentWalletM.address:@""];
    kWeakSelf(self)
    
    [alertView setConfirmBlock:^(NSString * _Nonnull gasPrice){
        [weakself showSwapProcessView];
        // 获取钱包私钥
        [TrustWalletManage.sharedInstance exportPrivateKeyWithAddress:currentWalletM.address?:@"" :^(NSString * privateKey) {
            // lock
            if (weakself.walletType == 2 && !weakself.userCancleSwap) { // eth - > neo
                //
                [[ContractETHRequest addContractETHRequest] destoryLockhWithPrivate:privateKey address:currentWalletM.address toAddress:weakself.swipToWalletM.address wrapperAddress:[QSwapAddressModel getShareObject].ethAddress?:@"" amount:[_amountTF.text.trim_whitespace integerValue] gasPrice:gasPrice completionHandler:^(id  _Nonnull responseObject) {
                     
                     if (responseObject) {
                         QSwapHashModel *hashM = responseObject;
                         // 检测状态
                         if (!weakself.userCancleSwap) {
                             [weakself performSelector:@selector(checkLockStateWithModel:) withObject:hashM afterDelay:15];
                         }
                         
                     } else {
                         [weakself hideSwapProcessView];
                     }
                    
                }];
            } else { // neo -> eth
                
            }
            
        }];
        
    }];
    [alertView show];
     
}
// 延时调用查询状态
- (void) checkLockStateWithModel:(QSwapHashModel *) hashModel {
    kWeakSelf(self)
    [QSwipWrapperRequestUtil checkEventStatWithRhash:hashModel.rHash resultHandler:^(id  _Nullable result, BOOL success, NSString * _Nullable message) {
        if (success) {
            NSInteger state = [result[@"state"]?:@"" integerValue];
            
            // 更新提示框状态
            NSInteger statuState = state+1;
            if (hashModel.type == 2) {
                statuState -= 11;
            }
            [weakself.swapProcessV updateStage:[NSString stringWithFormat:@"%ld",statuState]];
            
            if (state == WithDrawNeoLockedDone) { // eth - >nep5 等待unlock
                if (!weakself.userCancleSwap) {
                    [QSwipWrapperRequestUtil unLockToNep5WithRhash:hashModel.rOrigin userNep5Addr:hashModel.toAddress resultHandler:^(id  _Nullable result, BOOL success, NSString * _Nullable message) {
                        if (success) {
                            // 更新本地状态
                            [QSwapHashModel updateSwapHashStateWithHash:hashModel.rHash withState:30 swapTxhash:result];
                            if (!weakself.userCancleSwap) {
                                // 重新发起查看状态
                                [weakself performSelector:@selector(checkLockStateWithModel:) withObject:hashModel afterDelay:5];
                            }
                        } else {
                            [weakself hideSwapProcessView];
                            [kAppD.window makeToastDisappearWithText:kLang(@"failed")];
                        }
                    }];
                }
            } else if (state == DepositEthLockedDone) { // nep5 - >eth 等待unlock
                [weakself hideSwapProcessView];
                [kAppD.window makeToastDisappearWithText:@"等待unlock"];
            } else if (state == DepositNeoUnLockedDone) { // nep5 - >eth unlock完成
                [weakself hideSwapProcessView];
                [kAppD.window makeToastDisappearWithText:kLang(@"success")];
            } else if ([QSwapStatusManager isClaimSuccessWithState:state]){ // eth - >nep5 unlock完成
                // 更新本地状态
                [QSwapHashModel updateSwapHashStateWithHash:hashModel.rHash withState:state swapTxhash:message];
                [weakself hideSwapProcessView];
                [kAppD.window makeToastDisappearWithText:kLang(@"success")];
            } else if (state == WithDrawNeoFetchDone || state == DepositEthFetchDone){ // 超时
                [weakself hideSwapProcessView];
                [kAppD.window makeToastDisappearWithText:@"Expired"];
            }else {
                // 重新发起查看状态
                if (!weakself.userCancleSwap) {
                    [weakself performSelector:@selector(checkLockStateWithModel:) withObject:hashModel afterDelay:5];
                }
            }
            
        } else {
            // 重新发起查看状态
            if (!weakself.userCancleSwap) {
                [weakself performSelector:@selector(checkLockStateWithModel:) withObject:hashModel afterDelay:5];
            }
            
        }
    }];
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
