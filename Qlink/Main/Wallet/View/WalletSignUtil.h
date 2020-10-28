//
//  WalletSignUtil.h
//  Qlink
//
//  Created by 旷自辉 on 2020/10/23.
//  Copyright © 2020 pan. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef void (^sendComplete)(BOOL isComplete, NSString *result);
typedef void (^getComplete)(NSString *privateKey);

@interface WalletSignUtil : NSObject

+ (void) signAndSendEthTranserWithPamaerDic:(NSDictionary *) signDic gasPrice:(NSString *)gasPrice sendComplete:(sendComplete)sendComplete;

+ (NSInteger)numberWithHexString:(NSString *)hexString;

+ (void) getEthWalletPrivate:(NSString *) address getComplete:(getComplete) getComplete;

@end

NS_ASSUME_NONNULL_END
