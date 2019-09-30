//
//  WalletCommonModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/7.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBaseModel.h"
#import "ProjectEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletCommonModel : BBaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic) BOOL isWatch;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic) WalletType walletType;
@property (nonatomic, strong) NSNumber *balance;
@property (nonatomic) BOOL isSelect; // 是否是当前钱包

// NEO
@property (nonatomic ,strong) NSString *privateKey;
@property (nonatomic ,strong) NSString *publicKey;
@property (nonatomic ,strong) NSString *wif;

// EOS
@property (nonatomic, strong) NSString *account_name;

+ (void)deleteAllWallet;
+ (void)walletInit;
+ (void)addWalletModel:(WalletCommonModel *)model;
+ (void)deleteWalletModel:(WalletCommonModel *)model;
+ (void)removeCurrentSelectWallet;
+ (void)updateWalletModel:(WalletCommonModel *)model;
+ (NSArray *)getAllWalletModel;
+ (NSArray *)getWalletModelWithType:(WalletType)type;
+ (void)setCurrentSelectWallet:(WalletCommonModel *)model;
+ (WalletCommonModel *)getCurrentSelectWallet;
+ (WalletCommonModel *)getWalletWithAddress:(NSString *)address;

+ (void)refreshCurrentWallet;
+ (void)setDefaulNEOWallet:(NSString *)address;

+ (UIImage *)walletIcon:(WalletType)type;
+ (BOOL)validAddress:(NSString *)address tokenChain:(NSString *)tokenChain;
+ (WalletType)walletTypeFromTokenChain:(NSString *)tokenChain;
+ (NSString *)chainFromTokenChain:(NSString *)tokenChain;

#pragma mark - ETH
+ (void)refreshETHWallet;

#pragma mark - NEO
+ (void)refreshNEOWallet;

#pragma mark - EOS
+ (void)refreshEOSWallet;

#pragma mark - QLC
+ (void)refreshQLCWallet;
+ (BOOL)haveQLCWallet;


@end

NS_ASSUME_NONNULL_END
