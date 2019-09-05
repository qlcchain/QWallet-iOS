//
//  EOSWalletInfo.m
//  Qlink
//
//  Created by Jelly Foo on 2018/12/4.
//  Copyright © 2018 pan. All rights reserved.
//

#import "EOSWalletInfo.h"
#import "Qlink-Swift.h"
#import "GlobalConstants.h"

@implementation EOSWalletInfo

+ (BOOL)deleteAllWallet {
    BOOL success = [KeychainUtil removeKeyWithKeyName:EOS_WALLET_KEYCHAIN];
    return success;
}

+ (NSArray *)getAllWalletInKeychain {
    NSString *string = [KeychainUtil getKeyValueWithKeyName:EOS_WALLET_KEYCHAIN];
    NSMutableArray *muArr = [NSMutableArray array];
    if (string) {
        NSArray *arr = string.mj_JSONObject;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EOSWalletInfo *tempM = [EOSWalletInfo getObjectWithKeyValues:obj];
            [muArr addObject:tempM];
        }];
    }
    return muArr;
}

+ (BOOL)deleteFromKeyChain:(NSString *)account_name {
    NSArray *keychainArr = [EOSWalletInfo getAllWalletInKeychain];
    __block BOOL isExist = NO;
    [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EOSWalletInfo *tempM = obj;
        if ([tempM.account_name isEqualToString:account_name]) {
            isExist = YES;
        }
    }];
    if (isExist) {
        NSMutableArray *muArr = [NSMutableArray array];
        [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EOSWalletInfo *tempM = obj;
            if (![tempM.account_name isEqualToString:account_name]) {
                [muArr addObject:tempM.mj_keyValues];
            }
        }];
        NSString *jsonStr = muArr.mj_JSONString;
        [KeychainUtil saveValueToKeyWithKeyName:EOS_WALLET_KEYCHAIN keyValue:jsonStr];
    }
    
    return YES;
}

- (BOOL)saveToKeyChain {
    NSArray *keychainArr = [EOSWalletInfo getAllWalletInKeychain];
    __block BOOL isExist = NO;
    [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EOSWalletInfo *tempM = obj;
        if ([tempM.account_name isEqualToString:self.account_name]) {
            isExist = YES;
        }
    }];
    if (!isExist) {
        NSMutableArray *muArr = [NSMutableArray array];
        [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EOSWalletInfo *tempM = obj;
            [muArr addObject:tempM.mj_keyValues];
        }];
        [muArr addObject:self.mj_keyValues];
        NSString *jsonStr = muArr.mj_JSONString;
        [KeychainUtil saveValueToKeyWithKeyName:EOS_WALLET_KEYCHAIN keyValue:jsonStr];
    }
    
    return YES;
}

+ (NSString *)getOwnerPublicKey:(NSString *)account_name {
    NSArray *keychainArr = [EOSWalletInfo getAllWalletInKeychain];
    __block NSString *result = nil;
    [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EOSWalletInfo *tempM = obj;
        if ([tempM.account_name isEqualToString:account_name]) {
            result = tempM.account_owner_public_key;
            *stop = YES;
        }
    }];
    
    return result;
}

+ (NSString *)getActivePublicKey:(NSString *)account_name {
    NSArray *keychainArr = [EOSWalletInfo getAllWalletInKeychain];
    __block NSString *result = nil;
    [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EOSWalletInfo *tempM = obj;
        if ([tempM.account_name isEqualToString:account_name]) {
            result = tempM.account_active_public_key;
            *stop = YES;
        }
    }];
    
    return result;
}

+ (NSString *)getOwnerPrivateKey:(NSString *)account_name {
    NSArray *keychainArr = [EOSWalletInfo getAllWalletInKeychain];
    __block NSString *result = nil;
    [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EOSWalletInfo *tempM = obj;
        if ([tempM.account_name isEqualToString:account_name]) {
            result = tempM.account_owner_private_key;
            *stop = YES;
        }
    }];
    
    return result;
}

+ (NSString *)getActivePrivateKey:(NSString *)account_name {
    NSArray *keychainArr = [EOSWalletInfo getAllWalletInKeychain];
    __block NSString *result = nil;
    [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EOSWalletInfo *tempM = obj;
        if ([tempM.account_name isEqualToString:account_name]) {
            result = tempM.account_active_private_key;
            *stop = YES;
        }
    }];
    
    return result;
}

@end
