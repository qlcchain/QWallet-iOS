//
//  NewOrderTransferUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2019/8/20.
//  Copyright © 2019 pan. All rights reserved.
//

#import "NewOrderQLCTransferUtil.h"
#import "QLCAddressInfoModel.h"
#import "WalletCommonModel.h"
#import "GlobalConstants.h"
#import "WalletsViewController.h"
#import "QlinkTabbarViewController.h"
#import "QLCTransferToServerConfirmView.h"
#import <QLCFramework/QLCFramework.h>

@implementation NewOrderQLCTransferUtil

#pragma mark - Transfer QLC
+ (void)transferQLC:(NSString *)tokenName amountStr:(NSString *)amountStr successB:(void(^)(NSString *sendAddress, NSString *txid))successB {
    // 判断当前钱包
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (!currentWalletM || currentWalletM.walletType != WalletTypeQLC) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_switch_to_qlc_wallet")];
        return;
    }
    
    // 判断QLC钱包的QLC asset
    QLCTokenModel *asset = [kAppD.tabbarC.walletsVC getQLCAsset:tokenName];
    if (!asset) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",kLang(@"current_wallet_have_not"),tokenName]];
        return;
    }
    if ([asset.balance doubleValue] < [amountStr doubleValue]) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",kLang(@"current_wallet_have_not_enough"),tokenName]];
        return;
    }
    
    // 检查平台地址
    NSString *qlcAddress = [QLCWalletManage shareInstance].qlcMainAddress;
    if ([qlcAddress isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
    //    [self jumpToSellOrderAddress:qlcAddress qgasAsset:qgasAsset fromAddress:currentWalletM.address];
    [self showSellComfirmView:qlcAddress asset:asset fromAddress:currentWalletM.address amountStr:amountStr memo:@"" successB:successB];
}

+ (void)showSellComfirmView:(NSString *)qlcAddress asset:(QLCTokenModel *)asset fromAddress:(NSString *)fromAddress amountStr:(NSString *)amountStr memo:(NSString *)memo successB:(void(^)(NSString *sendAddress, NSString *txid))successB {
    QLCTransferToServerConfirmView *view = [QLCTransferToServerConfirmView getInstance];
    [view configWithAddress:qlcAddress amount:amountStr?:@"" tokenName:asset.tokenName];
    kWeakSelf(self);
    view.confirmBlock = ^{
        [weakself sendTransferToServer:asset fromAddress:fromAddress amountStr:amountStr memo:memo successB:successB];
    };
    [view show];
}

+ (void)sendTransferToServer:(QLCTokenModel *)selectAsset fromAddress:(NSString *)fromAddress amountStr:(NSString *)amountStr memo:(NSString *)memo successB:(void(^)(NSString *sendAddress, NSString *txid))successB {
    NSString *tokenName = selectAsset.tokenName;
    NSString *to = [QLCWalletManage shareInstance].qlcMainAddress?:@"";
    NSUInteger amount = [selectAsset getTransferNum:amountStr?:@""];
    NSString *sender = nil;
    NSString *receiver = nil;
    NSString *message = nil;
    NSString *data = memo?:@"";
    BOOL workInLocal = YES;
    [kAppD.window makeToastInView:kAppD.window text:kLang(@"process___") userInteractionEnabled:NO hideTime:0];
//    kWeakSelf(self);
    BOOL isMainNetwork = [ConfigUtil isMainNetOfChainNetwork];
    [[QLCWalletManage shareInstance] sendAssetWithTokenName:tokenName to:to amount:amount sender:sender receiver:receiver message:message data:data isMainNetwork:isMainNetwork workInLocal:workInLocal successHandler:^(NSString * _Nullable responseObj) {
        [kAppD.window hideToast];
//        [kAppD.window makeToastDisappearWithText:kLang(@"transfer_successful")];
        
        if (successB) {
            successB(fromAddress, responseObj);
        }
        
    } failureHandler:^(NSError * _Nullable error, NSString * _Nullable message) {
        [kAppD.window hideToast];
    }];
}


@end
