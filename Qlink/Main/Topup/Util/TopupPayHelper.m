//
//  TopupPayHelper.m
//  Qlink
//
//  Created by Jelly Foo on 2020/2/12.
//  Copyright © 2020 pan. All rights reserved.
//

#import "TopupPayHelper.h"
#import "TopupProductModel.h"
#import "TopupOrderModel.h"
#import "GlobalConstants.h"
#import "WalletCommonModel.h"
#import "ChooseWalletViewController.h"
#import "GroupBuyUtil.h"
#import "GroupBuyDetialViewController.h"
#import "RLArithmetic.h"
#import "NSString+RemoveZero.h"
#import "UserModel.h"
#import "PhoneNumerInputView.h"
#import "TopupOrderModel.h"
#import "TopupDeductionTokenModel.h"
#import "ETHWalletManage.h"
#import "TopupPayETH_DeductionViewController.h"
#import "QNavigationController.h"
#import "QlinkTabbarViewController.h"
#import "AppDelegate.h"
#import "TopupPayQLC_DeductionViewController.h"
#import <QLCFramework/QLCWalletManage.h>

@implementation TopupPayHelper

+ (instancetype)shareInstance {
    static dispatch_once_t pred = 0;
    __strong static TopupPayHelper *sharedObj  = nil;
    dispatch_once(&pred, ^{
        sharedObj = [[self alloc] init];
    });
    return sharedObj;
}

- (void)handlerPayCNY:(TopupProductModel *)model {
    NSString *amountNum = model.localFiatAmount;
    NSString *faitStr = [model.discount.mul(model.payFiatAmount) showfloatStr:4];
    NSNumber *deductionTokenPrice = @(1);
    if ([model.payFiat isEqualToString:@"CNY"]) {
        deductionTokenPrice = _selectDeductionTokenM.price;
    } else if ([model.payFiat isEqualToString:@"USD"]) {
        deductionTokenPrice = _selectDeductionTokenM.usdPrice;
    }
    NSString *qgasStr = [model.payFiatAmount.mul(model.qgasDiscount).div(deductionTokenPrice) showfloatStr:3];
    NSString *message = [NSString stringWithFormat:kLang(@"use_to_purchase__yuan_of_phone_charge_for_deduction"),amountNum,qgasStr,_selectDeductionTokenM.symbol,faitStr];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    kWeakSelf(self);
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    UIAlertAction *alertBuy = [UIAlertAction actionWithTitle:kLang(@"purchase") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 老版本
//        if ([weakself.selectDeductionTokenM.chain isEqualToString:ETH_Chain]) {
//            [weakself jumpToTopupPayETH_Deduction_CNY:model];
//        } else if ([weakself.selectDeductionTokenM.chain isEqualToString:QLC_Chain]) {
//            [weakself jumpToTopupPayQLC_Deduction_CNY:model];
//        }
        // 新版
       [weakself requestTopup_order:model];
    }];
    [alertC addAction:alertBuy];
    alertC.modalPresentationStyle = UIModalPresentationFullScreen;
    [kAppD.window.rootViewController presentViewController:alertC animated:YES completion:nil];
}

- (void)handlerPayToken:(TopupProductModel *)model {
    NSString *amountNum = model.localFiatAmount;
    NSString *fait1Str = model.discount.mul(model.payFiatAmount);
//    NSString *faitMoneyStr = [model.discount.mul(model.payFiatAmount) showfloatStr:4];
    NSString *deduction1Str = model.payFiatAmount.mul(model.qgasDiscount);
    NSNumber *deductionTokenPrice = @(1);
    if ([model.payFiat isEqualToString:@"CNY"]) {
        deductionTokenPrice = _selectDeductionTokenM.price;
    } else if ([model.payFiat isEqualToString:@"USD"]) {
        deductionTokenPrice = _selectDeductionTokenM.usdPrice;
    }
    NSString *deductionAmountStr = [model.payFiatAmount.mul(model.qgasDiscount).div(deductionTokenPrice) showfloatStr:3];
    NSNumber *payTokenPrice = [model.payFiat isEqualToString:@"CNY"]?model.payTokenCnyPrice:[model.payFiat isEqualToString:@"USD"]?model.payTokenUsdPrice:@(0);
    NSString *payAmountStr = [fait1Str.sub(deduction1Str).div(payTokenPrice) showfloatStr:3];
    // Top-up value %@ %@\npay %@ %@ and %@ %@
    // localFiatAmount  lacalFait    qgasStr        payTokenAmount
    NSString *message = [NSString stringWithFormat:kLang(@"use_to_purchase__yuan_of_phone_charge_for_deduction_1"),amountNum, model.localFiat, deductionAmountStr,_selectDeductionTokenM.symbol,payAmountStr, model.payTokenSymbol];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    kWeakSelf(self);
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    UIAlertAction *alertBuy = [UIAlertAction actionWithTitle:kLang(@"purchase") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself requestTopup_order:model];
    }];
    [alertC addAction:alertBuy];
    alertC.modalPresentationStyle = UIModalPresentationFullScreen;
    [kAppD.window.rootViewController presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - Request
- (void)requestTopup_order:(TopupProductModel *)model {
    kWeakSelf(self);
    NSString *account = @"";
    UserModel *userM = [UserModel fetchUserOfLogin];
    if ([UserModel haveLoginAccount]) {
        account = userM.account;
    }
    NSString *p2pId = [UserModel getTopupP2PId];
    NSString *productId = model.ID?:@"";
    NSString *phoneNumber = _selectPhoneNum?:@"";
    NSString *localFiatAmount = [NSString stringWithFormat:@"%@",model.localFiatAmount];
    NSString *deductionTokenId = _selectDeductionTokenM.ID?:@"";
    NSDictionary *params = @{@"account":account,@"p2pId":p2pId,@"productId":productId,@"phoneNumber":phoneNumber,@"localFiatAmount":localFiatAmount,@"deductionTokenId":deductionTokenId?:@""};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl10:topup_order_v2_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            
            TopupOrderModel *orderM = [TopupOrderModel getObjectWithKeyValues:responseObject[@"order"]];
            
            if ([weakself.selectDeductionTokenM.chain isEqualToString:ETH_Chain]) {
                [weakself jumpToTopupPayETH_Deduction:orderM];
            } else if ([weakself.selectDeductionTokenM.chain isEqualToString:QLC_Chain]) {
                [weakself jumpToTopupPayQLC_Deduction:orderM];
            }
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
//        [weakself hidePayLoadView];
    }];
}



#pragma mark - Transition

- (void)jumpToTopupPayETH_Deduction:(TopupOrderModel *)orderM {
    // 检查平台地址
    NSString *ethAddress = [ETHWalletManage shareInstance].ethMainAddress;
    if ([ethAddress isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
    if ([TopupOrderModel checkPayTokenChainServerAddressIsEmpty:orderM]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
    TopupPayETH_DeductionViewController *vc = [TopupPayETH_DeductionViewController new];
    vc.sendDeductionAmount = [NSString stringWithFormat:@"%@",orderM.qgasAmount];
    vc.sendDeductionToAddress = ethAddress;
    vc.sendDeductionMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.qgasAmount?:@""];
    vc.sendPayTokenAmount = [NSString stringWithFormat:@"%@",orderM.payTokenAmount_str];
    vc.sendPayTokenToAddress = [TopupOrderModel getPayTokenChainServerAddress:orderM];
    vc.sendPayTokenMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.payTokenAmount_str?:@""];
    vc.inputPayToken = orderM.payTokenSymbol;
    vc.inputDeductionToken = _selectDeductionTokenM.symbol?:@"OKB";
//    vc.inputProductM = productM;
    vc.inputOrderM = orderM;
//    vc.inputAreaCode = [self getGlobalRoamingFromCountryCodeLab];
//    vc.inputPhoneNumber = _phoneTF.text?:@"";
//    vc.inputDeductionTokenId = _selectDeductionTokenM.ID?:@"";
    vc.inputPayType = TopupPayTypeNormal;
    [((QNavigationController *)kAppD.tabbarC.selectedViewController) pushViewController:vc animated:YES];
}

- (void)jumpToTopupPayQLC_Deduction:(TopupOrderModel *)orderM {
    // 检查平台地址
    NSString *qlcAddress = [QLCWalletManage shareInstance].qlcMainAddress;
    if ([qlcAddress isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
    if ([TopupOrderModel checkPayTokenChainServerAddressIsEmpty:orderM]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
    TopupPayQLC_DeductionViewController *vc = [TopupPayQLC_DeductionViewController new];
    vc.sendDeductionAmount = [NSString stringWithFormat:@"%@",orderM.qgasAmount];
    vc.sendDeductionToAddress = qlcAddress;
    vc.sendDeductionMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.qgasAmount?:@""];
    vc.sendPayTokenAmount = [NSString stringWithFormat:@"%@",orderM.payTokenAmount_str];
    vc.sendPayTokenToAddress = [TopupOrderModel getPayTokenChainServerAddress:orderM];
    vc.sendPayTokenMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.payTokenAmount_str?:@""];
    vc.inputPayToken = orderM.payTokenSymbol;
    vc.inputDeductionToken = _selectDeductionTokenM.symbol?:@"QGAS";
//    vc.inputProductM = productM;
    vc.inputOrderM = orderM;
//    vc.inputAreaCode = [self getGlobalRoamingFromCountryCodeLab];
//    vc.inputPhoneNumber = _phoneTF.text?:@"";
//    vc.inputDeductionTokenId = _selectDeductionTokenM.ID?:@"";
    vc.inputPayType = TopupPayTypeNormal;
    [((QNavigationController *)kAppD.tabbarC.selectedViewController) pushViewController:vc animated:YES];
}

@end
