//
//  ContractETHRequest.h
//  Qlink
//
//  Created by 旷自辉 on 2020/8/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContractETHRequest : UIView

+ (ContractETHRequest *)addContractETHRequest;
- (void) destoryLockhWithPrivate:(NSString *) privateKey address:(NSString *) address toAddress:(NSString *) toAddress wrapperAddress:(NSString *) wrapperAddress amount:(NSInteger) amount gasPrice:(NSString *) gasPrice completionHandler:(void (^)(id responseObject)) successed;
- (void) destoryFetchWithPrivate:(NSString *) privateKey address:(NSString *) address rhash:(NSString *) rhash gasPrice:(NSString *) gasPrice completionHandler:(void (^)(id responseObject)) success;
- (void) getBalanceOfhWithAddress:(NSString *) address completionHandler:(void (^)(id responseObject)) success;
- (void) getGasPriceCompletionHandler:(void (^)(id responseObject)) success;
- (void) isSueUnlockWithPrivate:(NSString *) privateKey address:(NSString *) address rHash:(NSString *) rHash oHash:(NSString *) oHash gasPrice:(NSString *) gasPrice CompletionHandler:(void (^)(id responseObject)) success;
- (void) tarnsrefTo;
@end

NS_ASSUME_NONNULL_END
