//
//  ETHWalletInfo.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/20.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

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

- (BOOL)saveToKeyChain;
+ (void)refreshTrustWallet;
+ (BOOL)deleteFromKeyChain:(NSString *)address;
+ (BOOL)deleteAllWallet;

@end

NS_ASSUME_NONNULL_END
