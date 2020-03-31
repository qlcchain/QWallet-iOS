//
//  ETHWalletInfo.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/20.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ETHWalletInfo.h"
#import "Qlink-Swift.h"
#import <ETHFramework/ETHFramework.h>
#import "GlobalConstants.h"
#import "ReportUtil.h"

@implementation ETHWalletInfo

+ (BOOL)deleteAllWallet {
    BOOL success = [KeychainUtil removeKeyWithKeyName:ETH_WALLET_KEYCHAIN];
    return success;
}

+ (NSArray *)getAllWalletInKeychain {
    NSString *string = [KeychainUtil getKeyValueWithKeyName:ETH_WALLET_KEYCHAIN];
    NSMutableArray *muArr = [NSMutableArray array];
    if (string) {
        NSArray *arr = string.mj_JSONObject;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ETHWalletInfo *tempM = [ETHWalletInfo getObjectWithKeyValues:obj];
            [muArr addObject:tempM];
        }];
    }
    return muArr;
}

+ (BOOL)deleteFromKeyChain:(NSString *)address {
    NSArray *keychainArr = [ETHWalletInfo getAllWalletInKeychain];
    __block BOOL isExist = NO;
    [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ETHWalletInfo *tempM = obj;
        if ([tempM.address isEqualToString:address]) {
            isExist = YES;
        }
    }];
    if (isExist) {
        NSMutableArray *muArr = [NSMutableArray array];
        [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ETHWalletInfo *tempM = obj;
            if (![tempM.address isEqualToString:address]) {
                [muArr addObject:tempM.mj_keyValues];
            }
        }];
        NSString *jsonStr = muArr.mj_JSONString;
        [KeychainUtil saveValueToKeyWithKeyName:ETH_WALLET_KEYCHAIN keyValue:jsonStr];
    }
    
    return YES;
}

- (BOOL)saveToKeyChain {
    NSArray *keychainArr = [ETHWalletInfo getAllWalletInKeychain];
    __block BOOL isExist = NO;
    __block NSInteger existIndex = 0;
    [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ETHWalletInfo *tempM = obj;
        if ([tempM.address isEqualToString:self.address]) {
            isExist = YES;
            existIndex = idx;
        }
    }];
    if (!isExist) {
        NSMutableArray *muArr = [NSMutableArray array];
        [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ETHWalletInfo *tempM = obj;
            [muArr addObject:tempM.mj_keyValues];
        }];
        [muArr addObject:self.mj_keyValues];
        NSString *jsonStr = muArr.mj_JSONString;
        [KeychainUtil saveValueToKeyWithKeyName:ETH_WALLET_KEYCHAIN keyValue:jsonStr];
    } else {
        NSMutableArray *muModelArr = [NSMutableArray arrayWithArray:keychainArr];
        [muModelArr replaceObjectAtIndex:existIndex withObject:self];
        NSMutableArray *muArr = [NSMutableArray array];
        [muModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ETHWalletInfo *tempM = obj;
            [muArr addObject:tempM.mj_keyValues];
        }];
        NSString *jsonStr = muArr.mj_JSONString;
        [KeychainUtil saveValueToKeyWithKeyName:ETH_WALLET_KEYCHAIN keyValue:jsonStr];
    }
    
    return YES;
}

+ (ETHWalletInfo *)getWalletInKeychain:(NSString *)address {
    __block ETHWalletInfo *result = nil;
    NSString *string = [KeychainUtil getKeyValueWithKeyName:ETH_WALLET_KEYCHAIN];
    if (string) {
        NSArray *arr = string.mj_JSONObject;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ETHWalletInfo *tempM = [ETHWalletInfo getObjectWithKeyValues:obj];
            if ([address isEqualToString:tempM.address]) {
                result = tempM;
                *stop = YES;
            }
        }];
    }
    return result;
}

+ (void)refreshTrustWallet {
    NSArray *keychainArr = [ETHWalletInfo getAllWalletInKeychain];
    [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ETHWalletInfo *tempM = obj;
        BOOL isExist = [TrustWalletManage.sharedInstance walletIsExistWithAddress:tempM.address?:@""];
        if (!isExist) {
            BOOL isWatch = NO;
            NSString *privatekey = tempM.privatekey;
            NSString *address = tempM.address;
            if ([tempM.type integerValue] == 4) {
                isWatch = YES;
                privatekey = nil;
            }
            [TrustWalletManage.sharedInstance importWalletWithPrivateKeyInput:privatekey addressInput:address isWatch:isWatch :^(BOOL success, NSString * address) {
                DDLogDebug(@"ETH钱包导入：%@",@(success));
                
                [[NSNotificationCenter defaultCenter] postNotificationName:Add_ETH_Wallet_Noti object:nil];
            }];
        }
    }];
}


+ (void)createETHWalletInAuto {
//    kWeakSelf(self);
    [TrustWalletManage.sharedInstance createInstantWallet:^(NSArray<NSString *> * arr, NSString *address) {
        
        [TrustWalletManage.sharedInstance exportPrivateKeyWithAddress:address?:@"" :^(NSString * privateKey) {
            
            ETHWalletInfo *walletInfo = [[ETHWalletInfo alloc] init];
            walletInfo.privatekey = privateKey;
            walletInfo.mnemonic = @"";
            walletInfo.keystore = @"";
            walletInfo.password = @"";
            walletInfo.address = address;
            walletInfo.type = @"0"; // 创建
            walletInfo.isBackup = @(NO);
            walletInfo.mnemonicArr = arr;
            // 存储keychain
            [walletInfo saveToKeyChain];
            
            [TrustWalletManage.sharedInstance exportPublicKeyWithAddress:walletInfo.address :^(NSString * _Nullable publicKey) {
                [ReportUtil requestWalletReportWalletCreateWithBlockChain:@"ETH" address:address pubKey:publicKey?:@"" privateKey:walletInfo.privatekey]; // 上报钱包创建
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
                [[NSNotificationCenter defaultCenter] postNotificationName:Add_ETH_Wallet_Noti object:nil];
            });
        }];
    }];
}

+ (BOOL)haveETHWallet {
    return TrustWalletManage.sharedInstance.isHavaWallet;
}


@end
