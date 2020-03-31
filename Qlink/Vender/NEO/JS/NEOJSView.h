//
//  QContractView.h
//  Qlink
//
//  Created by Jelly Foo on 2019/9/4.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^NEOJSResultBlock)(id _Nullable result, BOOL success,  NSString * _Nullable message);

@interface NEOJSView : UIView

+ (NEOJSView *)add;
- (void)remove;
- (void)config;

- (void)neoTransferWithFromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress assetHash:(NSString *)assetHash amount:(NSString *)amount numOfDecimals:(NSString *)numOfDecimals wif:(NSString *)wif resultHandler:(NEOJSResultBlock)resultHandler;

- (void)claimgasWithPrivateKey:(NSString *)privateKey resultHandler:(NEOJSResultBlock)resultHandler;



@end

NS_ASSUME_NONNULL_END
