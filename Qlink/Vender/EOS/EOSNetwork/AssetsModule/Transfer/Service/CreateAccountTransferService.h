//
//  TransferService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/2/9.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "RichListRequest.h"
#import "GetRateRequest.h"
#import "EOS_TransactionResult.h"


typedef NS_OPTIONS(NSUInteger, CreateAccountPushTransactionType) {
    CreateAccountPushTransactionTypeTransfer ,// 转账
};

@protocol CreateAccountTransferServiceDelegate<NSObject>
- (void)pushTransactionDidFinish:(EOS_TransactionResult *)result;
//- (void)approveDidFinish:(EOS_TransactionResult *)result;
//- (void)askQuestionDidFinish:(EOS_TransactionResult *)result;
//- (void)answerQuestionDidFinish:(EOS_TransactionResult *)result;
//- (void)registeToVoteSystemQuestionDidFinish:(EOS_TransactionResult *)result;


@end

@interface CreateAccountTransferService : BaseService

@property(nonatomic, weak) id<CreateAccountTransferServiceDelegate> delegate;

@property(nonatomic, copy) NSString *newaccount_action;
@property(nonatomic, copy) NSString *newaccount_code;// contract
@property(nonatomic, copy) NSString *newaccount_binargs;

@property(nonatomic, copy) NSString *buyram_action;
@property(nonatomic, copy) NSString *buyram_code;// contract
@property(nonatomic, copy) NSString *buyram_binargs;

@property(nonatomic, copy) NSString *stake_action;
@property(nonatomic, copy) NSString *stake_code;// contract
@property(nonatomic, copy) NSString *stake_binargs;

@property(nonatomic, copy) NSString *sender;

// available_keys
@property(nonatomic, strong) NSArray *available_keys;

// pushTransaction
- (void)pushTransaction;
@property (nonatomic) CreateAccountPushTransactionType pushTransactionType;

@property(nonatomic, strong) RichListRequest *richListRequest;



@property(nonatomic, strong) GetRateRequest *getRateRequest;

@property(nonatomic, strong) NSMutableArray *richListDataArray;


@property(nonatomic , copy) NSString *password;

@property(nonatomic , copy) NSString *permission;

@property (nonatomic) NSInteger operationType;


// 获取关注的所有账号
- (void)getRichlistAccount:(CompleteBlock)complete;


/**
 get_rate
 */
- (void)get_rate:(CompleteBlock)complete;


@property(nonatomic, copy) NSString *ref_block_num;
@end
