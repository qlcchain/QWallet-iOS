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
    [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ETHWalletInfo *tempM = obj;
        if ([tempM.address isEqualToString:self.address]) {
            isExist = YES;
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
    }
    
    return YES;
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

@end
