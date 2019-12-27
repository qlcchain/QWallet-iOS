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
#import "ReportUtil.h"

@implementation NEOWalletInfo

#pragma mark - OLD
/**
 将私钥和公钥还有地址 存储keychain
 @return yes
 */
- (BOOL)saveToKeyChain_old {
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

+ (void)deleteAllWallet_old {
    [KeychainUtil removeKeyWithKeyName:WALLET_PRIVATE_KEY];
    [KeychainUtil removeKeyWithKeyName:WALLET_PUBLIC_KEY];
    [KeychainUtil removeKeyWithKeyName:WALLET_ADDRESS_KEY];
    [KeychainUtil removeKeyWithKeyName:WALLET_WIF_KEY];
}

+ (NSArray *)getAllNEOWallet_old {
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

+ (NEOWalletInfo *)getNEOWalletWithAddress_old:(NSString *)address {
    __block NEOWalletInfo *walletInfo = nil;
    
    NSArray *allNEO = [NEOWalletInfo getAllNEOWallet_old];
    [allNEO enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOWalletInfo *model = obj;
        if ([model.address isEqualToString:address]) {
            walletInfo = model;
            *stop = YES;
        }
    }];
    
    return walletInfo;
}

+ (NSString *)getNEOPrivateKeyWithAddress_old:(NSString *)address {
    __block NSString *privateKey = nil;
    
    NSArray *allNEO = [NEOWalletInfo getAllNEOWallet_old];
    [allNEO enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOWalletInfo *model = obj;
        if ([model.address isEqualToString:address]) {
            privateKey = model.privateKey;
            *stop = YES;
        }
    }];
    
    return privateKey;
}

+ (NSString *)getNEOEncryptedKeyWithAddress_old:(NSString *)address {
    __block NSString *encryptedKey = nil;
    
    NSArray *allNEO = [NEOWalletInfo getAllNEOWallet_old];
    [allNEO enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOWalletInfo *model = obj;
        if ([model.address isEqualToString:address]) {
            encryptedKey = model.wif;
            *stop = YES;
        }
    }];
    
    return encryptedKey;
}

+ (NSString *)getNEOPublickKeyWithAddress_old:(NSString *)address {
    __block NSString *publicKey = nil;
    
    NSArray *allNEO = [NEOWalletInfo getAllNEOWallet_old];
    [allNEO enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOWalletInfo *model = obj;
        if ([model.address isEqualToString:address]) {
            publicKey = model.publicKey;
            *stop = YES;
        }
    }];
    
    return publicKey;
}

+ (BOOL)deleteNEOWalletWithAddress_old:(NSString *)address {
    NSString *getAddress = address;
    NSString *getPrivateKey = [NEOWalletInfo getNEOPrivateKeyWithAddress_old:address];
    NSString *getPublicKey = [NEOWalletInfo getNEOPublickKeyWithAddress_old:address];
    NSString *getWif = [NEOWalletInfo getNEOEncryptedKeyWithAddress_old:address];
    
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
    
    [self saveToKeychainWithWalletArr_old:privateArr key:WALLET_PRIVATE_KEY];
    [self saveToKeychainWithWalletArr_old:publicArr key:WALLET_PUBLIC_KEY];
    [self saveToKeychainWithWalletArr_old:addressArr key:WALLET_ADDRESS_KEY];
    [self saveToKeychainWithWalletArr_old:wifArr key:WALLET_WIF_KEY];
    
    return YES;
}

+ (BOOL)saveToKeychainWithWalletArr_old:(NSArray *)arr key:(NSString *)walletKey {
    NSMutableString *muStr = [NSMutableString string];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [muStr appendString:obj];
        if (idx != arr.count - 1) {
            [muStr appendString:@","];
        }
    }];
    return [KeychainUtil saveValueToKeyWithKeyName:walletKey keyValue:muStr];
}








#pragma mark - NEW
+ (void)updateNEOWallet_local {
    NSArray *local_old_Arr = [NEOWalletInfo getAllNEOWallet_old];
    [local_old_Arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOWalletInfo *model = obj;
        [model saveToKeyChain];
    }];
}

+ (BOOL)deleteAllWallet {
    BOOL success = [KeychainUtil removeKeyWithKeyName:NEO_WALLET_KEYCHAIN];
    return success;
}

+ (NSArray *)getAllWalletInKeychain {
    NSString *string = [KeychainUtil getKeyValueWithKeyName:NEO_WALLET_KEYCHAIN];
    NSMutableArray *muArr = [NSMutableArray array];
    if (string) {
        NSArray *arr = string.mj_JSONObject;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NEOWalletInfo *tempM = [NEOWalletInfo getObjectWithKeyValues:obj];
            [muArr addObject:tempM];
        }];
    }
    return muArr;
}

+ (BOOL)deleteFromKeyChain:(NSString *)address {
    [self deleteNEOWalletWithAddress_old:address];
    
    NSArray *keychainArr = [NEOWalletInfo getAllWalletInKeychain];
    __block BOOL isExist = NO;
    [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOWalletInfo *tempM = obj;
        if ([tempM.address isEqualToString:address]) {
            isExist = YES;
        }
    }];
    if (isExist) {
        NSMutableArray *muArr = [NSMutableArray array];
        [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NEOWalletInfo *tempM = obj;
            if (![tempM.address isEqualToString:address]) {
                [muArr addObject:tempM.mj_keyValues];
            }
        }];
        NSString *jsonStr = muArr.mj_JSONString;
        [KeychainUtil saveValueToKeyWithKeyName:NEO_WALLET_KEYCHAIN keyValue:jsonStr];
    }
    
    return YES;
}

- (BOOL)saveToKeyChain {
    NSArray *keychainArr = [NEOWalletInfo getAllWalletInKeychain];
    __block BOOL isExist = NO;
    __block NSInteger existIndex = 0;
    [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOWalletInfo *tempM = obj;
        if ([tempM.address isEqualToString:self.address]) {
            existIndex = idx;
            isExist = YES;
        }
    }];
    if (!isExist) {
        NSMutableArray *muArr = [NSMutableArray array];
        [keychainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NEOWalletInfo *tempM = obj;
            [muArr addObject:tempM.mj_keyValues];
        }];
        [muArr addObject:self.mj_keyValues];
        NSString *jsonStr = muArr.mj_JSONString;
        [KeychainUtil saveValueToKeyWithKeyName:NEO_WALLET_KEYCHAIN keyValue:jsonStr];
    } else {
        NSMutableArray *muModelArr = [NSMutableArray arrayWithArray:keychainArr];
        [muModelArr replaceObjectAtIndex:existIndex withObject:self];
        NSMutableArray *muArr = [NSMutableArray array];
        [muModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NEOWalletInfo *tempM = obj;
            [muArr addObject:tempM.mj_keyValues];
        }];
        NSString *jsonStr = muArr.mj_JSONString;
        [KeychainUtil saveValueToKeyWithKeyName:NEO_WALLET_KEYCHAIN keyValue:jsonStr];
    }
    
    return YES;
}

+ (NEOWalletInfo *)getNEOWalletWithAddress:(NSString *)address {
    __block NEOWalletInfo *temp = nil;
    
    NSArray *allNEO = [NEOWalletInfo getAllWalletInKeychain];
    [allNEO enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOWalletInfo *model = obj;
        if ([model.address isEqualToString:address]) {
            temp = model;
            *stop = YES;
        }
    }];
    
    return temp;
}

+ (NSString *)getNEOEncryptedKeyWithAddress:(NSString *)address {
    __block NSString *seed = nil;
    
    NSArray *allNEO = [NEOWalletInfo getAllWalletInKeychain];
    [allNEO enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOWalletInfo *model = obj;
        if ([model.address isEqualToString:address]) {
            seed = model.wif;
            *stop = YES;
        }
    }];
    
    return seed;
}

+ (NSString *)getNEOPrivateKeyWithAddress:(NSString *)address {
    __block NSString *privateKey = nil;
    
    NSArray *allNEO = [NEOWalletInfo getAllWalletInKeychain];
    [allNEO enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOWalletInfo *model = obj;
        if ([model.address isEqualToString:address]) {
            privateKey = model.privateKey;
            *stop = YES;
        }
    }];
    
    return privateKey;
}

+ (NSString *)getNEOPublicKeyWithAddress:(NSString *)address {
    __block NSString *publicKey = nil;
    
    NSArray *allNEO = [NEOWalletInfo getAllWalletInKeychain];
    [allNEO enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOWalletInfo *model = obj;
        if ([model.address isEqualToString:address]) {
            publicKey = model.publicKey;
            *stop = YES;
        }
    }];
    
    return publicKey;
}

+ (void)createNEOWalletInAuto {
    BOOL isSuccess = [NEOWalletManage.sharedInstance createWallet];
    if (isSuccess) {
        NEOWalletInfo *walletInfo = [[NEOWalletInfo alloc] init];
        walletInfo.address = [NEOWalletManage.sharedInstance getWalletAddress];
        walletInfo.wif = [NEOWalletManage.sharedInstance getWalletWif];
        walletInfo.privateKey = [NEOWalletManage.sharedInstance getWalletPrivateKey];
        walletInfo.publicKey = [NEOWalletManage.sharedInstance getWalletPublicKey];
        walletInfo.isBackup = @(NO);
        // 存储keychain
        [walletInfo saveToKeyChain];
        
        [ReportUtil requestWalletReportWalletCreateWithBlockChain:@"NEO" address:walletInfo.address pubKey:walletInfo.publicKey privateKey:walletInfo.privateKey]; // 上报钱包创建
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
            [[NSNotificationCenter defaultCenter] postNotificationName:Add_NEO_Wallet_Noti object:nil];
        });
        
    } else {
        DDLogDebug(@"创建neo钱包失败");
    }
}

+ (BOOL)haveNEOWallet {
    return [NEOWalletInfo getAllWalletInKeychain].count>0?YES:NO;
}



@end
