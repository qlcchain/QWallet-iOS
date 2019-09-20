//
//  QContractView.h
//  Qlink
//
//  Created by Jelly Foo on 2019/9/4.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QContractView : UIView

//+ (instancetype)shareInstance;
+ (QContractView *)addQContractView;
+ (void)removeQContractView:(QContractView *)contractV;
- (void)config;

#pragma mark - Benefit Pledge
- (void)benefit_createMultiSig:(NSString *)neo_publicKey neo_wifKey:(NSString *)neo_wifKey fromAddress:(NSString *)fromAddress qlcAddress:(NSString *)qlcAddress qlcAmount:(NSString *)qlcAmount lockTime:(NSString *)lockTime qlc_privateKey:(NSString *)qlc_privateKey qlc_publicKey:(NSString *)qlc_publicKey resultHandler:(void (^)(NSString *result, BOOL success))resultHandler;
#pragma mark - Benefit Pledge pledgestart状态调用
- (void)benefit_getnep5transferbytxid:(NSString *)lockTxId qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey resultHandler:(void (^)(NSString *result, BOOL success))resultHandler;
#pragma mark - Benefit Withdraw
- (void)request_benefit_neo_address:(NSString *)lockTxId resultHandler:(void (^)(NSString *result, BOOL success))resultHandler;
- (void)nep5_benefitWithdraw:(NSString *)lockTxId beneficial:(NSString *)beneficial amount:(NSString *)amount qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey neo_publicKey:(NSString *)neo_publicKey resultHandler:(void (^)(NSString *result, BOOL success))resultHandler;
#pragma mark - Mintage Pledge
- (void)mintage_createMultiSig:(NSString *)neo_publicKey neo_wifKey:(NSString *)neo_wifKey fromAddress:(NSString *)fromAddress qlcAddress:(NSString *)qlcAddress qlcAmount:(NSString *)qlcAmount lockTime:(NSString *)lockTime qlc_privateKey:(NSString *)qlc_privateKey qlc_publicKey:(NSString *)qlc_publicKey tokenName:(NSString *)tokenName tokenSymbol:(NSString *)tokenSymbol totalSupply:(NSString *)totalSupply decimals:(NSString *)decimals resultHandler:(void (^)(NSString *result, BOOL success))resultHandler;
#pragma mark - Mintag Withdraw
- (void)nep5_mintageWithdraw:(NSString *)lockTxId tokenId:(NSString *)tokenId resultHandler:(void (^)(NSString *result, BOOL success))resultHandler;


//- (void)nep5_prePareBenefitPledge:(NSString *)qlcAddress qlcAmount:(NSString *)qlcAmount multiSigAddress:(NSString *)multiSigAddress neo_publicKey:(NSString *)neo_publicKey lockTxId:(NSString *)lockTxId qlc_privateKey:(NSString *)qlc_privateKey qlc_publicKey:(NSString *)qlc_publicKey resultHandler:(void (^)(NSString *result, BOOL success))resultHandle;
//- (void)nep5_benefitPledge:(NSString *)lockTxId qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey resultHandler:(void (^)(NSString *result, BOOL success))resultHandler;

@end

NS_ASSUME_NONNULL_END
