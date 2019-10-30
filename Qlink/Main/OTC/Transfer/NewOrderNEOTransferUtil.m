//
//  NewOrderTransferUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2019/8/20.
//  Copyright © 2019 pan. All rights reserved.
//

#import "NewOrderNEOTransferUtil.h"
#import "NEOAddressInfoModel.h"
#import "GlobalConstants.h"
#import "WalletCommonModel.h"
#import "NEOWalletUtil.h"
#import "WalletsViewController.h"
#import "QlinkTabbarViewController.h"
#import "NeoTransferUtil.h"
#import "NEOTransferConfirmView.h"
#import "NEOWalletInfo.h"
#import "NEOJSUtil.h"

@interface NewOrderNEOTransferUtil ()

@end

@implementation NewOrderNEOTransferUtil

#pragma mark - Transfer
+ (void)transferNEO:(NSString *)tokenName amountStr:(NSString *)amountStr successB:(NEOTransferSuccessBlock)successB {
    
    // 判断当前钱包
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (!currentWalletM || currentWalletM.walletType != WalletTypeNEO) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_switch_to_neo_wallet")];
        return;
    }
    
    // 判断NEO钱包的asset
    NEOAssetModel *asset = [kAppD.tabbarC.walletsVC getNEOAsset:tokenName];
    if (!asset) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",kLang(@"current_wallet_have_not"),tokenName]];
        return;
    }
    
    // 检查平台地址
    NSString *serverAddress = [NeoTransferUtil getShareObject].neoMainAddress;
    if ([serverAddress isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
//    // 转QLC需要gas检查
//    if ([asset.asset_symbol isEqualToString:@"QLC"]) {
//        __block NSNumber *gas = @(0);
//        NSArray *sourceArr = [kAppD.tabbarC.walletsVC getNEOSource];
//        [sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NEOAssetModel *asset = obj;
//            if ([asset.asset_symbol isEqualToString:@"GAS"]) {
//                gas = asset.amount;
//            }
//        }];
//        if (([gas doubleValue] < GAS_Control)) {
//            [kAppD.window showWalletAlertViewWithTitle:NSStringLocalizable(@"prompt") msg:[[NSMutableAttributedString alloc] initWithString:NSStringLocalizable(@"neo_nep5_gas_less")] isShowTwoBtn:NO block:^{
//            }];
//            return;
//        }
//    }
    
    [NewOrderNEOTransferUtil showNEOTransferConfirmView:asset amountStr:amountStr to_address:serverAddress successB:successB];
}

+ (void)showNEOTransferConfirmView:(NEOAssetModel *)asset amountStr:(NSString *)amountStr to_address:(NSString *)to_address successB:(NEOTransferSuccessBlock)successB {
    NSString *address = to_address;
    NSString *memo = APP_NAME;
    NSString *amount = [NSString stringWithFormat:@"%@ %@",amountStr,asset.asset_symbol];
    NEOTransferConfirmView *view = [NEOTransferConfirmView getInstance];
    [view configWithAddress:address amount:amount];
    kWeakSelf(self);
    view.confirmBlock = ^{
        [weakself sendTransfer:asset amountStr:amountStr to_address:to_address memo:memo successB:successB];
    };
    [view show];
}

+ (void)sendTransfer:(NEOAssetModel *)asset amountStr:(NSString *)amountStr to_address:(NSString *)to_address memo:(NSString *)memo successB:(NEOTransferSuccessBlock)successB {
    NSInteger decimals = [NEO_Decimals integerValue];
    NSString *tokenHash = asset.asset_hash;
    NSString *assetName = asset.asset;
    NSString *toAddress = to_address;
    NSString *amount = amountStr;
    NSString *symbol = asset.asset_symbol;
    NSString *fromAddress = [WalletCommonModel getCurrentSelectWallet].address;
    NSString *remarkStr = memo;
    NSInteger assetType = 1; // 0:neo、gas  1:代币nep5
    if ([symbol isEqualToString:@"GAS"] || [symbol isEqualToString:@"NEO"]) {
        assetType = 0;
    }
    BOOL isNEOMainNetTransfer = YES;
    double fee = NEO_fee;
    [kAppD.window makeToastInView:kAppD.window text:NSStringLocalizable(@"loading")];
    
    NSString *wif = [NEOWalletInfo getNEOEncryptedKeyWithAddress:fromAddress]?:@"";
    NSString *decimalStr = NEO_Decimals;
    [NEOJSUtil addNEOJSView];
    [kAppD.window makeToastInView:kAppD.window text:kLang(@"process___")];
    [NEOJSUtil neoTransferWithFromAddress:fromAddress toAddress:toAddress assetHash:tokenHash amount:amount numOfDecimals:decimalStr wif:wif resultHandler:^(id  _Nullable result, BOOL success, NSString * _Nullable message) {
        [kAppD.window hideToast];
        [NEOJSUtil removeNEOJSView];
        if (success) {
            NSString *txid = result;
            if (successB) {
                successB(fromAddress, txid);
            }
        }
    }];
    
    // 原生停用
//    [NEOWalletUtil sendNEOWithTokenHash:tokenHash decimals:decimals assetName:assetName amount:amount toAddress:toAddress fromAddress:fromAddress symbol:symbol assetType:assetType mainNet:isNEOMainNetTransfer remarkStr:remarkStr fee:fee successBlock:^(NSString *txid) {
//        [kAppD.window hideToast];
//        if (successB) {
//            successB(fromAddress, txid);
//        }
//    } failureBlock:^{
//        [kAppD.window hideToast];
//    }];
}


@end
