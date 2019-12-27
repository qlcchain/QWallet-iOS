//
//  QLCWalletInfo.h
//  Qlink
//
//  Created by Jelly Foo on 2019/5/21.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

@class QLCTokenModel;

@interface QLCWalletInfo : BBaseModel

@property (nonatomic ,strong) NSString *privateKey;
@property (nonatomic ,strong) NSString *publicKey;
@property (nonatomic ,strong) NSString *address;
@property (nonatomic ,strong) NSString *seed;
@property (nonatomic ,strong) NSNumber *isBackup;

- (BOOL)saveToKeyChain;
+ (BOOL)deleteFromKeyChain:(NSString *)address;
+ (BOOL)deleteAllWallet;
+ (NSArray *)getAllWalletInKeychain;

+ (QLCWalletInfo *)getQLCWalletWithAddress:(NSString *)address;
+ (NSString *)getQLCSeedWithAddress:(NSString *)address;
+ (NSString *)getQLCMnemonicWithAddress:(NSString *)address;
+ (NSString *)getQLCPrivateKeyWithAddress:(NSString *)address;
+ (NSString *)getQLCPublicKeyWithAddress:(NSString *)address;

+ (void)createQLCWalletInAuto;
+ (BOOL)haveQLCWallet;

@end
