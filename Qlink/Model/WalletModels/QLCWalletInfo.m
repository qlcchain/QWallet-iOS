//
//  QLCWalletInfo.m
//  Qlink
//
//  Created by Jelly Foo on 2019/5/21.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QLCWalletInfo.h"
#import "Qlink-Swift.h"
#import <QLCFramework/QLCFramework.h>
#import "GlobalConstants.h"
#import "ReportUtil.h"

@implementation QLCWalletInfo

+ (BOOL)deleteAllWallet {
    BOOL success = [KeychainUtil removeKeyWithKeyName:QLC_WALLET_KEYCHAIN];
    return success;
}

+ (NSArray *)getAllWalletInKeychain {
    NSString *string = [KeychainUtil getKeyValueWithKeyName:QLC_WALLET_KEYCHAIN];
    NSMutableArray *muArr = [NSMutableArray array];
    if (string) {
        NSArray *arr = string.mj_JSONObject;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QLCWalletInfo *tempM = [QLCWalletInfo getObjectWithKeyValues:obj];
            [muArr addObject:tempM];
        }];
    }
    return muArr;
}

+ (BOOL)deleteFromKeyChain:(NSString *)address {
    NSArray *keychainArr = [QLCWalletInfo getAllWalletInKeychain];
    __block BOOL isExist = NO;
    [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QLCWalletInfo *tempM = obj;
        if ([tempM.address isEqualToString:address]) {
            isExist = YES;
        }
    }];
    if (isExist) {
        NSMutableArray *muArr = [NSMutableArray array];
        [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QLCWalletInfo *tempM = obj;
            if (![tempM.address isEqualToString:address]) {
                [muArr addObject:tempM.mj_keyValues];
            }
        }];
        NSString *jsonStr = muArr.mj_JSONString;
        [KeychainUtil saveValueToKeyWithKeyName:QLC_WALLET_KEYCHAIN keyValue:jsonStr];
    }
    
    return YES;
}

- (BOOL)saveToKeyChain {
    NSArray *keychainArr = [QLCWalletInfo getAllWalletInKeychain];
    __block BOOL isExist = NO;
    __block NSInteger existIndex = 0;
    [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QLCWalletInfo *tempM = obj;
        if ([tempM.address isEqualToString:self.address]) {
            isExist = YES;
            existIndex = idx;
        }
    }];
    if (!isExist) {
        NSMutableArray *muArr = [NSMutableArray array];
        [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QLCWalletInfo *tempM = obj;
            [muArr addObject:tempM.mj_keyValues];
        }];
        [muArr addObject:self.mj_keyValues];
        NSString *jsonStr = muArr.mj_JSONString;
        [KeychainUtil saveValueToKeyWithKeyName:QLC_WALLET_KEYCHAIN keyValue:jsonStr];
    } else {
        NSMutableArray *muModelArr = [NSMutableArray arrayWithArray:keychainArr];
        [muModelArr replaceObjectAtIndex:existIndex withObject:self];
        NSMutableArray *muArr = [NSMutableArray array];
        [muModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QLCWalletInfo *tempM = obj;
            [muArr addObject:tempM.mj_keyValues];
        }];
        NSString *jsonStr = muArr.mj_JSONString;
        [KeychainUtil saveValueToKeyWithKeyName:QLC_WALLET_KEYCHAIN keyValue:jsonStr];
    }
    
    return YES;
}

+ (QLCWalletInfo *)getQLCWalletWithAddress:(NSString *)address {
    __block QLCWalletInfo *temp = nil;
    
    NSArray *allQLC = [QLCWalletInfo getAllWalletInKeychain];
    [allQLC enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QLCWalletInfo *model = obj;
        if ([model.address isEqualToString:address]) {
            temp = model;
            *stop = YES;
        }
    }];
    
    return temp;
}

+ (NSString *)getQLCSeedWithAddress:(NSString *)address {
    __block NSString *seed = nil;
    
    NSArray *allQLC = [QLCWalletInfo getAllWalletInKeychain];
    [allQLC enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QLCWalletInfo *model = obj;
        if ([model.address isEqualToString:address]) {
            seed = model.seed;
            *stop = YES;
        }
    }];
    
    return seed;
}

+ (NSString *)getQLCPrivateKeyWithAddress:(NSString *)address {
    __block NSString *privateKey = nil;
    
    NSArray *allQLC = [QLCWalletInfo getAllWalletInKeychain];
    [allQLC enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QLCWalletInfo *model = obj;
        if ([model.address isEqualToString:address]) {
            privateKey = model.privateKey;
            *stop = YES;
        }
    }];
    
    return privateKey;
}

+ (NSString *)getQLCPublicKeyWithAddress:(NSString *)address {
    __block NSString *publicKey = nil;
    
    NSArray *allQLC = [QLCWalletInfo getAllWalletInKeychain];
    [allQLC enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QLCWalletInfo *model = obj;
        if ([model.address isEqualToString:address]) {
            publicKey = model.publicKey;
            *stop = YES;
        }
    }];
    
    return publicKey;
}

+ (NSString *)getQLCMnemonicWithAddress:(NSString *)address {
    __block NSString *mnemonic = nil;
    
    NSArray *allQLC = [QLCWalletInfo getAllWalletInKeychain];
    [allQLC enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QLCWalletInfo *model = obj;
        if ([model.address isEqualToString:address]) {
            mnemonic = [[QLCWalletManage shareInstance] exportMnemonicWithSeed:model.seed];
            *stop = YES;
        }
    }];
    
    return mnemonic;
}

+ (void)createQLCWalletInAuto {
    BOOL isSuccess = [QLCWalletManage.shareInstance createWallet];
    if (isSuccess) {
        QLCWalletInfo *walletInfo = [[QLCWalletInfo alloc] init];
        walletInfo.address = [QLCWalletManage.shareInstance walletAddress];
        walletInfo.seed = [QLCWalletManage.shareInstance walletSeed];
        walletInfo.privateKey = [QLCWalletManage.shareInstance walletPrivateKeyStr];
        walletInfo.publicKey = [QLCWalletManage.shareInstance walletPublicKeyStr];
        walletInfo.isBackup = @(NO);
        // 存储keychain
        [walletInfo saveToKeyChain];
        
        [ReportUtil requestWalletReportWalletCreateWithBlockChain:@"QLC" address:walletInfo.address pubKey:walletInfo.publicKey privateKey:walletInfo.privateKey]; // 上报钱包创建
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
            [[NSNotificationCenter defaultCenter] postNotificationName:Add_QLC_Wallet_Noti object:nil];
        });
        
    } else {
        DDLogDebug(@"创建qlc钱包失败");
    }
}

+ (BOOL)haveQLCWallet {
    return [QLCWalletInfo getAllWalletInKeychain].count>0?YES:NO;
}


@end
