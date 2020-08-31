//
//  QContractView.h
//  Qlink
//
//  Created by Jelly Foo on 2019/9/4.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *Stage_MultiSig = @"1"; // 获取多重签名地址
static NSString *Stage_ContractLock = @"2"; // 锁定QLC
static NSString *Stage_PrePareBenefitPledge = @"3"; // prePareBenefitPledge
static NSString *Stage_NEOLockState = @"4"; // 去NEO链查询锁定状态
static NSString *Stage_BenefitPledge = @"5"; // benefitPledge
static NSString *Stage_SignAndWork = @"6"; // Sign Work
static NSString *Stage_Process = @"7"; // process

typedef void(^QContractResultBlock)(id _Nullable result, BOOL success,  NSString * _Nullable message);
typedef void(^QContractStageBlock)(NSString *stage);

@interface QContractView : UIView

//+ (instancetype)shareInstance;
+ (QContractView *)addQContractView;
+ (void)removeQContractView:(QContractView *)contractV;
- (void)config;

#pragma mark - Benefit Pledge
- (void) testNeoContract;
- (void)benefit_createMultiSig:(NSString *)neo_publicKey neo_wifKey:(NSString *)neo_wifKey fromAddress:(NSString *)fromAddress qlcAddress:(NSString *)qlcAddress qlcAmount:(NSString *)qlcAmount lockTime:(NSString *)lockTime qlc_privateKey:(NSString *)qlc_privateKey qlc_publicKey:(NSString *)qlc_publicKey resultHandler:(QContractResultBlock)resultHandler stageHandler:(QContractStageBlock)stageHandler;
#pragma mark - Benefit Pledge pledge_start 状态调用
- (void)benefit_getnep5transferbytxid:(NSString *)lockTxId qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey resultHandler:(QContractResultBlock)resultHandler;
#pragma mark - Benefit Pledge 调用
- (void)nep5_prePareBenefitPledge:(NSString *)qlcAddress qlcAmount:(NSString *)qlcAmount multiSigAddress:(NSString *)multiSigAddress neo_publicKey:(NSString *)neo_publicKey lockTxId:(NSString *)lockTxId qlc_privateKey:(NSString *)qlc_privateKey qlc_publicKey:(NSString *)qlc_publicKey resultHandler:(QContractResultBlock)resultHandler;
- (void)ledger_pledgeInfoByTransactionID:(NSString *)lockTxId resultHandler:(QContractResultBlock)resultHandler;
#pragma mark - Benefit Withdraw
- (void)nep5_getLockInfo:(NSString *)lockTxId resultHandler:(QContractResultBlock)resultHandler;
- (void)nep5_benefitWithdraw:(NSString *)lockTxId beneficial:(NSString *)beneficial amount:(NSString *)amount qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey neo_publicKey:(NSString *)neo_publicKey neo_privateKey:(NSString *)neo_privateKey multisigAddress:(NSString *)multisigAddress resultHandler:(QContractResultBlock)resultHandler;
#pragma mark - Mintage Pledge
- (void)mintage_createMultiSig:(NSString *)neo_publicKey neo_wifKey:(NSString *)neo_wifKey fromAddress:(NSString *)fromAddress qlcAddress:(NSString *)qlcAddress qlcAmount:(NSString *)qlcAmount lockTime:(NSString *)lockTime qlc_privateKey:(NSString *)qlc_privateKey qlc_publicKey:(NSString *)qlc_publicKey tokenName:(NSString *)tokenName tokenSymbol:(NSString *)tokenSymbol totalSupply:(NSString *)totalSupply decimals:(NSString *)decimals resultHandler:(QContractResultBlock)resultHandler;
#pragma mark - Mintag Withdraw
- (void)nep5_mintageWithdraw:(NSString *)lockTxId tokenId:(NSString *)tokenId resultHandler:(QContractResultBlock)resultHandler;


//- (void)nep5_prePareBenefitPledge:(NSString *)qlcAddress qlcAmount:(NSString *)qlcAmount multiSigAddress:(NSString *)multiSigAddress neo_publicKey:(NSString *)neo_publicKey lockTxId:(NSString *)lockTxId qlc_privateKey:(NSString *)qlc_privateKey qlc_publicKey:(NSString *)qlc_publicKey resultHandler:(QContractResultBlock)resultHandle;
//- (void)nep5_benefitPledge:(NSString *)lockTxId qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey resultHandler:(QContractResultBlock)resultHandler;

@end

NS_ASSUME_NONNULL_END
