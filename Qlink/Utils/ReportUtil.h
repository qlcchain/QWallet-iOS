//
//  ReportUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/15.
//  Copyright © 2018 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReportUtil : NSObject

+ (void)requestWalletReportWalletCreateWithBlockChain:(NSString *)blockChain address:(NSString *)address pubKey:(NSString *)pubKey privateKey:(nullable NSString *)privateKey;
+ (void)requestWalletReportWalletRransferWithAddressFrom:(NSString *)addressFrom addressTo:(NSString *)addressTo blockChain:(NSString *)blockChain symbol:(NSString *)symbol amount:(NSString *)amount txid:(NSString *)txid;

@end

NS_ASSUME_NONNULL_END
