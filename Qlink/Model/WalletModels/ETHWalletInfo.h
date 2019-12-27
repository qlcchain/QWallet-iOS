//
//  ETHWalletInfo.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/20.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class Token;

typedef enum : NSUInteger {
    ETHWalletInfoTypeCreate = 0,
    ETHWalletInfoTypeMnemonic,
    ETHWalletInfoTypeKeystore,
    ETHWalletInfoTypePrivatekey,
    ETHWalletInfoTypeAddress,
} ETHWalletInfoType;

@interface ETHWalletInfo : BBaseModel

@property (nonatomic ,strong) NSString *mnemonic;
@property (nonatomic ,strong) NSString *keystore;
@property (nonatomic ,strong) NSString *password;

@property (nonatomic ,strong) NSString *privatekey;
@property (nonatomic ,strong) NSString *address;

@property (nonatomic ,strong) NSString *type;
@property (nonatomic ,strong) NSNumber *isBackup;
@property (nonatomic, strong) NSArray *mnemonicArr;

- (BOOL)saveToKeyChain;
+ (void)refreshTrustWallet;
+ (BOOL)deleteFromKeyChain:(NSString *)address;
+ (ETHWalletInfo *)getWalletInKeychain:(NSString *)address;
+ (BOOL)deleteAllWallet;

+ (void)createETHWalletInAuto;
+ (BOOL)haveETHWallet;

@end

NS_ASSUME_NONNULL_END
