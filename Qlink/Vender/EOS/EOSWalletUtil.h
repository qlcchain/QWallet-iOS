//
//  EOSWalletUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2018/12/5.
//  Copyright © 2018 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOS_TokenInfo.h"
#import "EOSResourceResult.h"
#import "EOS_AccountResult.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    EOSOperationTypeTransfer = 1, // 转账
    EOSOperationTypeStake, // 抵押
    EOSOperationTypeReclaim, // 赎回
    EOSOperationTypeBuyRam, // 买ram
    EOSOperationTypeSellRam, // 卖ram
    EOSOperationTypeCreateAccount, // 创建账号
} EOSOperationType;

@class EOSSymbolModel;

typedef void(^EOSImportCompleteBlock)(BOOL success);

@interface EOSWalletUtil : NSObject

@property (nonatomic) EOSOperationType operationType;

// 转账
@property(nonatomic , strong) EOS_TokenInfo *currentToken;

// 抵押/赎回  交易内存
@property(nonatomic , strong) EOS_AccountResult *accountResult;
@property(nonatomic , strong) EOSResourceResult *eosResourceResult;

+ (instancetype)shareInstance;

#pragma mark - 创建
//- (void)createAccountWithAccountName:(NSString *)accountName;
//- (void)checkAccountExistWithAccountName:(NSString *)accountName complete:(void(^)(BOOL isExist))block;
- (void)createAccountWithFrom:(NSString *)from to:(NSString *)to ownerPublicKey:(NSString *)ownerPublicKey activePublicKey:(NSString *)activePublicKey buyRamEOSAmount:(NSString *)buyRamEOSAmount stakeCpuAmount:(NSString *)stakeCpuAmount stakeNetAmount:(NSString *)stakeNetAmount;

#pragma mark - 导入
- (void)importWithAccountName:(NSString *)accountName private_activeKey:(NSString *)private_activeKey private_ownerKey:(nullable NSString *)private_ownerKey complete:(EOSImportCompleteBlock)block;

#pragma mark - 转账
- (void)transferWithSymbol:(EOSSymbolModel *)symbolM From:(NSString *)fromName to:(NSString *)toName amount:(NSString *)amount memo:(NSString *)memo;

#pragma mark - CPU/NET(抵押/赎回)
- (void)stakeWithCpuAmount:(NSString *)cpuAmount netAmount:(NSString *)netAmount from:(NSString *)fromName to:(NSString *)toName operationType:(EOSOperationType)operationType;

#pragma mark - RAM(内存管理)
- (void)stakeWithEosAmount:(NSString *)eosAmount from:(NSString *)fromName to:(NSString *)toName bytes:(NSString *)bytes operationType:(EOSOperationType)operationType;

@end

NS_ASSUME_NONNULL_END
