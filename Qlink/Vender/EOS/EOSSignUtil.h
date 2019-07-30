//
//  CryptoUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2018/12/18.
//  Copyright © 2018 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSSignUtil : NSObject

+ (NSString *)eosSignWithPrivateKey:(NSString *)privateKey message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
