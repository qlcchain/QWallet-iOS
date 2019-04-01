//
//  WalletCommonModel.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/7.
//  Copyright © 2018 pan. All rights reserved.
//

#import "WalletCommonModel.h"
#import <ETHFramework/ETHFramework.h>
#import "NEOWalletUtil.h"
//#import <NEOFramework/NEOFramework.h>
#import "NeoTransferUtil.h"
#import "Qlink-Swift.h"
#import "ETHWalletInfo.h"
#import "EOSWalletInfo.h"

@implementation WalletCommonModel

+ (void)deleteAllWallet {
    [ETHWalletInfo deleteAllWallet];
    [NEOWalletInfo deleteAllWallet];
}

+ (void)walletInit {
    [ETHWalletInfo refreshTrustWallet]; // 如果keychain中的钱包在Trust中没有则自动导入
    BOOL haveEthWallet = TrustWalletManage.sharedInstance.isHavaWallet;
    BOOL haveNeoWallet = [NEOWalletInfo getAllNEOWallet].count>0?YES:NO;
    BOOL haveEosWallet = NO;
    if (haveEthWallet) {
        [WalletCommonModel refreshETHWallet];
    }
    if (haveNeoWallet) {
        [WalletCommonModel refreshNEOWallet];
    }
    if (haveEosWallet) {
        
    }
    // 进入请求钱包数据
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (!currentWalletM) { // 当前没有选择钱包
        if ([WalletCommonModel getAllWalletModel].count > 0) { // 默认选择第一个钱包
            currentWalletM = [WalletCommonModel getAllWalletModel].firstObject;
            [WalletCommonModel setCurrentSelectWallet:currentWalletM];
        }
    }
    if (currentWalletM) {
        [WalletCommonModel refreshCurrentWallet]; // 刷新当前钱包
    }
    
    if (![NEOWalletManage.sharedInstance haveDefaultWallet]) {
        NSString *address = [WalletCommonModel getDefaultNEOWalletAddress];
        if (address != nil) {
            [WalletCommonModel setDefaulNEOWallet:address];
        }
    }
}

+ (void)addWalletModel:(WalletCommonModel *)model {
    __block BOOL isExist = NO;
    NSArray *localArr = [HWUserdefault getObjectWithKey:Local_All_Wallet];
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WalletCommonModel *tempM = [WalletCommonModel getObjectWithKeyValues:obj];
        if (model.walletType == WalletTypeEOS) {
            if ([tempM.account_name isEqualToString:model.account_name]) {
                isExist = YES;
            }
        } else {
            if ([tempM.address isEqualToString:model.address]) {
                isExist = YES;
            }
        }
    }];
    if (!isExist) {
        NSMutableArray *allArr = [NSMutableArray array];
        [allArr addObjectsFromArray:localArr];
        [allArr addObject:model.mj_keyValues];
        [HWUserdefault insertObj:allArr withkey:Local_All_Wallet];
    }
}

+ (void)deleteWalletModel:(WalletCommonModel *)model {
    __block BOOL isExist = NO;
    __block NSInteger index = 0;
    NSArray *localArr = [HWUserdefault getObjectWithKey:Local_All_Wallet];
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WalletCommonModel *tempM = [WalletCommonModel getObjectWithKeyValues:obj];
        if (model.walletType == WalletTypeEOS) {
            if ([tempM.account_name isEqualToString:model.account_name]) {
                isExist = YES;
                index = idx;
            }
        } else {
            if ([tempM.address isEqualToString:model.address]) {
                isExist = YES;
                index = idx;
            }
        }
    }];
    if (isExist) {
        NSMutableArray *allArr = [NSMutableArray array];
        [allArr addObjectsFromArray:localArr];
        [allArr removeObjectAtIndex:index];
        [HWUserdefault insertObj:allArr withkey:Local_All_Wallet];
    }
}

+ (void)updateWalletModel:(WalletCommonModel *)model {
    __block BOOL isExist = NO;
    __block NSInteger index = 0;
    NSMutableArray *localArr = [NSMutableArray arrayWithArray:[HWUserdefault getObjectWithKey:Local_All_Wallet]];
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WalletCommonModel *tempM = [WalletCommonModel getObjectWithKeyValues:obj];
        if (model.walletType == WalletTypeEOS) {
            if ([tempM.account_name isEqualToString:model.account_name]) {
                isExist = YES;
                index = idx;
            }
        } else {
            if ([tempM.address isEqualToString:model.address]) {
                isExist = YES;
                index = idx;
            }
        }
    }];
    if (isExist) {
        [localArr replaceObjectAtIndex:index withObject:model.mj_keyValues];
        [HWUserdefault insertObj:localArr withkey:Local_All_Wallet];
    }
}

+ (NSArray *)getAllWalletModel {
    NSMutableArray *resultArr = [NSMutableArray array];
    NSArray *localArr = [HWUserdefault getObjectWithKey:Local_All_Wallet];
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WalletCommonModel *model = [WalletCommonModel getObjectWithKeyValues:obj];
        [resultArr addObject:model];
    }];
    return resultArr;
}

+ (void)setCurrentSelectWallet:(WalletCommonModel *)model {
    NSMutableArray *allArr = [NSMutableArray array];
    NSArray *localArr = [HWUserdefault getObjectWithKey:Local_All_Wallet];
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WalletCommonModel *tempM = [WalletCommonModel getObjectWithKeyValues:obj];
        tempM.isSelect = NO;
        if (model.walletType == WalletTypeEOS) {
            if ([tempM.account_name isEqualToString:model.account_name]) {
                tempM.isSelect = YES;
            }
        } else {
            if ([tempM.address isEqualToString:model.address]) {
                tempM.isSelect = YES;
            }
        }
        [allArr addObject:tempM.mj_keyValues];
    }];
    [HWUserdefault insertObj:allArr withkey:Local_All_Wallet];
//    [HWUserdefault insertObj:model.mj_keyValues withkey:Current_Select_Wallet];
    
    [WalletCommonModel refreshCurrentWallet];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Wallet_Change_Noti object:nil];
}

+ (void)refreshCurrentWallet {
    WalletCommonModel *curretWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (curretWalletM.walletType == WalletTypeETH) {
        // ETH切换钱包
        [TrustWalletManage.sharedInstance switchWalletWithAddress:curretWalletM.address];
    } else if (curretWalletM.walletType == WalletTypeNEO) {
        [WalletCommonModel setDefaulNEOWallet:curretWalletM.address];
    } else if (curretWalletM.walletType == WalletTypeEOS) {
        
    }
}

+ (void)setDefaulNEOWallet:(NSString *)address {
    NSString *privateKey = [NEOWalletInfo getNEOPrivateKeyWithAddress:address];
    // 得到当前钱包对象
    [NEOWalletManage.sharedInstance getWalletWithPrivatekeyWithPrivatekey:privateKey];
    // 选取交易网络
    [NEOWalletManage configO3NetworkWithIsMain:[NEOWalletUtil isMainNetOfNeo]];
    // 重新初始化 Account->将Account设为当前钱包
    [NEOWalletManage.sharedInstance configureAccountWithMainNet:[NEOWalletUtil isMainNetOfNeo]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        // 查询当前NEO钱包资产
        [NeoTransferUtil sendGetBalanceRequest];
    });
    if ([NEOWalletManage.sharedInstance haveDefaultWallet]) {
        DDLogDebug(@"重新选择neo钱包：%@",[NEOWalletManage.sharedInstance getWalletAddress]);
    }
    [WalletCommonModel storeDefaultNEOWalletAddress:address];
}

+ (void)removeCurrentSelectWallet {
    NSMutableArray *allArr = [NSMutableArray array];
    NSArray *localArr = [HWUserdefault getObjectWithKey:Local_All_Wallet];
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WalletCommonModel *tempM = [WalletCommonModel getObjectWithKeyValues:obj];
        tempM.isSelect = NO;
        [allArr addObject:tempM.mj_keyValues];
    }];
    [HWUserdefault insertObj:allArr withkey:Local_All_Wallet];
}

+ (WalletCommonModel *)getCurrentSelectWallet {
    __block WalletCommonModel *result = nil;
    NSArray *localArr = [HWUserdefault getObjectWithKey:Local_All_Wallet];
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WalletCommonModel *tempM = [WalletCommonModel getObjectWithKeyValues:obj];
        if (tempM.isSelect == YES) {
            result = tempM;
        }
    }];
    return result;
    
//    NSDictionary *walletDic = [HWUserdefault getObjectWithKey:Current_Select_Wallet];
//    WalletCommonModel *model = [WalletCommonModel getObjectWithKeyValues:walletDic];
//    return model;
}

#pragma mark - ETH
+ (void)refreshETHWallet {
    NSArray *ethWalletArr = [TrustWalletManage.sharedInstance getAllWalletModel];
    // 赋值名字
    [ethWalletArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WalletModel *walletM = obj;
        WalletCommonModel *commonM = [[WalletCommonModel alloc] init];
        commonM.address = walletM.address;
        commonM.isWatch = walletM.isWatch;
        commonM.symbol = walletM.symbol?:@"ETH";
        commonM.walletType = WalletTypeETH;
        if (walletM.name == nil || walletM.name.length <= 0) {
            NSString *name = [NSString stringWithFormat:@"ETH-Wallet %@",@(idx+1)];
            commonM.name = name;
        }
        commonM.isSelect = NO;
        [WalletCommonModel addWalletModel:commonM];
    }];
}

#pragma mark - NEO
+ (void)refreshNEOWallet {
    NSArray *walletArr = [NEOWalletInfo getAllNEOWallet];
    // 赋值名字
    [walletArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOWalletInfo *walletM = obj;
        WalletCommonModel *commonM = [[WalletCommonModel alloc] init];
        commonM.address = walletM.address;
        commonM.symbol = @"NEO";
        commonM.walletType = WalletTypeNEO;
        NSString *name = [NSString stringWithFormat:@"NEO-Wallet %@",@(idx+1)];
        commonM.name = name;
        commonM.isSelect = NO;
        [WalletCommonModel addWalletModel:commonM];
    }];
}

+ (void)storeDefaultNEOWalletAddress:(NSString *)address {
    [HWUserdefault insertObj:address withkey:Default_NEOWallet_Address];
}

+ (NSString *)getDefaultNEOWalletAddress {
    NSString *address = [HWUserdefault getObjectWithKey:Default_NEOWallet_Address];
    if (address == nil) {
        NSArray *walletArr = [NEOWalletInfo getAllNEOWallet];
        if (walletArr.count > 0) {
            NEOWalletInfo *walletM = walletArr.firstObject;
            address = walletM.address;
        }
    }
    return address;
}

#pragma mark - EOS
+ (void)refreshEOSWallet {
    NSArray *walletArr = [EOSWalletInfo getAllWalletInKeychain];
    // 赋值名字
    [walletArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EOSWalletInfo *walletM = obj;
        WalletCommonModel *commonM = [[WalletCommonModel alloc] init];
        commonM.account_name = walletM.account_name;
        commonM.symbol = @"EOS";
        commonM.walletType = WalletTypeEOS;
        NSString *name = [NSString stringWithFormat:@"EOS-Wallet %@",@(idx+1)];
        commonM.name = name;
        commonM.isSelect = NO;
        [WalletCommonModel addWalletModel:commonM];
    }];
}


@end
