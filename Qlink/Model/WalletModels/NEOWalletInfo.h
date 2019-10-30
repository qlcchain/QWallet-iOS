//
//  WalletInfo.h
//  Qlink
//
//  Created by 旷自辉 on 2018/4/4.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "BBaseModel.h"

@interface NEOWalletInfo : BBaseModel

@property (nonatomic ,strong) NSString *privateKey;
@property (nonatomic ,strong) NSString *publicKey;
//@property (nonatomic ,strong) NSString *scriptHash;
@property (nonatomic ,strong) NSString *address;
@property (nonatomic ,strong) NSString *wif;
@property (nonatomic ,strong) NSNumber *isBackup;

//#pragma mark - OLD
//- (BOOL)saveToKeyChain_old;
//+ (void)deleteAllWallet_old;
//+ (NSArray *)getAllNEOWallet_old;
//+ (NEOWalletInfo *)getNEOWalletWithAddress_old:(NSString *)address;
//+ (NSString *)getNEOPrivateKeyWithAddress_old:(NSString *)address;
//+ (NSString *)getNEOEncryptedKeyWithAddress_old:(NSString *)address;
//+ (NSString *)getNEOPublickKeyWithAddress_old:(NSString *)address;
//+ (BOOL)deleteNEOWalletWithAddress_old:(NSString *)address;

#pragma mark - NEW
+ (void)updateNEOWallet_local;
+ (BOOL)deleteAllWallet;
+ (NSArray *)getAllWalletInKeychain;
+ (BOOL)deleteFromKeyChain:(NSString *)address;
- (BOOL)saveToKeyChain;
+ (NEOWalletInfo *)getNEOWalletWithAddress:(NSString *)address;
+ (NSString *)getNEOEncryptedKeyWithAddress:(NSString *)address;
+ (NSString *)getNEOPrivateKeyWithAddress:(NSString *)address;
+ (NSString *)getNEOPublicKeyWithAddress:(NSString *)address;
+ (void)createNEOWalletInAuto;
+ (BOOL)haveNEOWallet;

@end
