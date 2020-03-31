//
//  EOSWalletInfo.h
//  Qlink
//
//  Created by Jelly Foo on 2018/12/4.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EOSWalletInfo : BBaseModel

@property (nonatomic ,strong) NSString *account_name;
@property (nonatomic ,strong) NSString *account_active_public_key;;
@property (nonatomic ,strong) NSString *account_active_private_key;
@property (nonatomic ,strong) NSString *account_owner_public_key;
@property (nonatomic ,strong) NSString *account_owner_private_key;
@property (nonatomic ,strong) NSNumber *isBackup;

- (BOOL)saveToKeyChain;
+ (BOOL)deleteFromKeyChain:(NSString *)account_name;
+ (BOOL)deleteAllWallet;
+ (NSArray *)getAllWalletInKeychain;

+ (NSString *)getOwnerPublicKey:(NSString *)account_name;
+ (NSString *)getActivePublicKey:(NSString *)account_name;
+ (NSString *)getOwnerPrivateKey:(NSString *)account_name;
+ (NSString *)getActivePrivateKey:(NSString *)account_name;

+ (BOOL)haveEOSWallet;

@end

NS_ASSUME_NONNULL_END
