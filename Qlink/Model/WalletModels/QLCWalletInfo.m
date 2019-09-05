//
//  QLCWalletInfo.m
//  Qlink
//
//  Created by Jelly Foo on 2019/5/21.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QLCWalletInfo.h"
#import "Qlink-Swift.h"
#import "QLCWalletManage.h"
#import "GlobalConstants.h"

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
    [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QLCWalletInfo *tempM = obj;
        if ([tempM.address isEqualToString:self.address]) {
            isExist = YES;
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
    }
    
    return YES;
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

@end
