//
//  WalletCommonModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/7.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    WalletTypeETH,
    WalletTypeEOS,
    WalletTypeNEO,
    WalletTypeQLC,
} WalletType;

@interface WalletCommonModel : BBaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic) BOOL isWatch;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic) WalletType walletType;
@property (nonatomic, strong) NSNumber *balance;
@property (nonatomic) BOOL isSelect;

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
+ (void)setCurrentSelectWallet:(WalletCommonModel *)model;
+ (WalletCommonModel *)getCurrentSelectWallet;
+ (WalletCommonModel *)getWalletWithAddress:(NSString *)address;

+ (void)refreshCurrentWallet;
+ (void)setDefaulNEOWallet:(NSString *)address;

#pragma mark - ETH
+ (void)refreshETHWallet;

#pragma mark - NEO
+ (void)refreshNEOWallet;

#pragma mark - EOS
+ (void)refreshEOSWallet;

#pragma mark - QLC
+ (void)refreshQLCWallet;


@end

NS_ASSUME_NONNULL_END
