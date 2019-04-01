//
//  WalletInfo.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/4.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "NEOWalletInfo.h"
#import "NEOWalletUtil.h"
#import "Qlink-Swift.h"

@implementation NEOWalletInfo

/**
 将私钥和公钥还有地址 存储keychain
 @return yes
 */
- (BOOL)saveToKeyChain {
//    BOOL isFirstWallet = NO;
//    // 判断是否是第一个钱包。第一个则默认为当前钱包
//    if (![NEOWalletUtil isExistWalletPrivateKey]) {
//        [NEOWalletUtil setKeyValue:CURRENT_WALLET_KEY value:@"0"];
//        isFirstWallet = YES;
//    } else {
//        // 重新初始化 Account->将Account设为当前钱包
//        [NEOWalletManage.sharedInstance configureAccountWithMainNet:[NEOWalletUtil isMainNetOfNeo]];
//    }
    
    // 已经存在返回NO
    BOOL isExist= [NEOWalletUtil setWalletkeyWithKey:WALLET_PRIVATE_KEY withWalletValue:self.privateKey];
    if (!isExist) {
        return YES;
    }
    [NEOWalletUtil setWalletkeyWithKey:WALLET_PUBLIC_KEY withWalletValue:self.publicKey];
    [NEOWalletUtil setWalletkeyWithKey:WALLET_ADDRESS_KEY withWalletValue:self.address];
    [NEOWalletUtil setWalletkeyWithKey:WALLET_WIF_KEY withWalletValue:self.wif];
    
//    // 是第一个钱包
//    if (isFirstWallet) {
//        [NEOWalletUtil getCurrentWalletInfo];
//        [[NSNotificationCenter defaultCenter] postNotificationName:WALLET_CHANGE_TZ object:nil];
//        // 查询当前钱包资产
//        [NeoTransferUtil sendGetBalanceRequest];
//    }
    
    return YES;
    
}

+ (void)deleteAllWallet {
    [KeychainUtil removeKeyWithKeyName:WALLET_PRIVATE_KEY];
    [KeychainUtil removeKeyWithKeyName:WALLET_PUBLIC_KEY];
    [KeychainUtil removeKeyWithKeyName:WALLET_ADDRESS_KEY];
    [KeychainUtil removeKeyWithKeyName:WALLET_WIF_KEY];
}

+ (NSArray *)getAllNEOWallet {
    NSString *privateValues = [KeychainUtil getKeyValueWithKeyName:WALLET_PRIVATE_KEY];
    NSString *publicValues = [KeychainUtil getKeyValueWithKeyName:WALLET_PUBLIC_KEY];
    NSString *adderssValues = [KeychainUtil getKeyValueWithKeyName:WALLET_ADDRESS_KEY];
    NSString *wifValues = [KeychainUtil getKeyValueWithKeyName:WALLET_WIF_KEY];
    //  NSInteger walletIndex = [[KeychainUtil getKeyValueWithKeyName:CURRENT_WALLET_KEY] integerValue];
    
    NSMutableArray *privateArr = [NSMutableArray array];
    NSMutableArray *publicArr = [NSMutableArray array];
    NSMutableArray *addressArr = [NSMutableArray array];
    NSMutableArray *wifArr = [NSMutableArray array];
    if (privateValues && ![privateValues isEmptyString]) {
        [privateArr addObjectsFromArray:[privateValues componentsSeparatedByString:@","]];
        [publicArr addObjectsFromArray:[publicValues componentsSeparatedByString:@","]];
        [addressArr addObjectsFromArray:[adderssValues componentsSeparatedByString:@","]];
        [wifArr addObjectsFromArray:[wifValues componentsSeparatedByString:@","]];
    }
    NSMutableArray *resultArr = [NSMutableArray array];
    [privateArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOWalletInfo *model = [[NEOWalletInfo alloc] init];
        model.privateKey = obj;
        model.publicKey = publicArr[idx];
        model.address = addressArr[idx];
        model.wif = wifArr[idx];
        [resultArr addObject:model];
    }];
    
    return resultArr;
}

+ (NEOWalletInfo *)getNEOWalletWithAddress:(NSString *)address {
    __block NEOWalletInfo *walletInfo = nil;
    
    NSArray *allNEO = [NEOWalletInfo getAllNEOWallet];
    [allNEO enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOWalletInfo *model = obj;
        if ([model.address isEqualToString:address]) {
            walletInfo = model;
            *stop = YES;
        }
    }];
    
    return walletInfo;
}

+ (NSString *)getNEOPrivateKeyWithAddress:(NSString *)address {
    __block NSString *privateKey = nil;
    
    NSArray *allNEO = [NEOWalletInfo getAllNEOWallet];
    [allNEO enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOWalletInfo *model = obj;
        if ([model.address isEqualToString:address]) {
            privateKey = model.privateKey;
            *stop = YES;
        }
    }];
    
    return privateKey;
}

+ (NSString *)getNEOEncryptedKeyWithAddress:(NSString *)address {
    __block NSString *encryptedKey = nil;
    
    NSArray *allNEO = [NEOWalletInfo getAllNEOWallet];
    [allNEO enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOWalletInfo *model = obj;
        if ([model.address isEqualToString:address]) {
            encryptedKey = model.wif;
            *stop = YES;
        }
    }];
    
    return encryptedKey;
}

+ (NSString *)getNEOPublickKeyWithAddress:(NSString *)address {
    __block NSString *publicKey = nil;
    
    NSArray *allNEO = [NEOWalletInfo getAllNEOWallet];
    [allNEO enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOWalletInfo *model = obj;
        if ([model.address isEqualToString:address]) {
            publicKey = model.publicKey;
            *stop = YES;
        }
    }];
    
    return publicKey;
}

+ (BOOL)deleteNEOWalletWithAddress:(NSString *)address {
    NSString *getAddress = address;
    NSString *getPrivateKey = [NEOWalletInfo getNEOPrivateKeyWithAddress:address];
    NSString *getPublicKey = [NEOWalletInfo getNEOPublickKeyWithAddress:address];
    NSString *getWif = [NEOWalletInfo getNEOEncryptedKeyWithAddress:address];
    
    NSString *privateValues = [KeychainUtil getKeyValueWithKeyName:WALLET_PRIVATE_KEY];
    NSString *publicValues = [KeychainUtil getKeyValueWithKeyName:WALLET_PUBLIC_KEY];
    NSString *adderssValues = [KeychainUtil getKeyValueWithKeyName:WALLET_ADDRESS_KEY];
    NSString *wifValues = [KeychainUtil getKeyValueWithKeyName:WALLET_WIF_KEY];
    NSMutableArray *privateArr = [NSMutableArray array];
    NSMutableArray *publicArr = [NSMutableArray array];
    NSMutableArray *addressArr = [NSMutableArray array];
    NSMutableArray *wifArr = [NSMutableArray array];
    if (privateValues && ![privateValues isEmptyString]) {
        [privateArr addObjectsFromArray:[privateValues componentsSeparatedByString:@","]];
        [publicArr addObjectsFromArray:[publicValues componentsSeparatedByString:@","]];
        [addressArr addObjectsFromArray:[adderssValues componentsSeparatedByString:@","]];
        [wifArr addObjectsFromArray:[wifValues componentsSeparatedByString:@","]];
        
        [privateArr removeObject:getPrivateKey];
        [publicArr removeObject:getPublicKey];
        [addressArr removeObject:getAddress];
        [wifArr removeObject:getWif];
    }
    
    [self saveToKeychainWithWalletArr:privateArr key:WALLET_PRIVATE_KEY];
    [self saveToKeychainWithWalletArr:publicArr key:WALLET_PUBLIC_KEY];
    [self saveToKeychainWithWalletArr:addressArr key:WALLET_ADDRESS_KEY];
    [self saveToKeychainWithWalletArr:wifArr key:WALLET_WIF_KEY];
    
    return YES;
}

+ (BOOL)saveToKeychainWithWalletArr:(NSArray *)arr key:(NSString *)walletKey {
    NSMutableString *muStr = [NSMutableString string];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [muStr appendString:obj];
        if (idx != arr.count - 1) {
            [muStr appendString:@","];
        }
    }];
    return [KeychainUtil saveValueToKeyWithKeyName:walletKey keyValue:muStr];
}

@end
