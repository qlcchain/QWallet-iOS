//
//  NEOJSUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2019/10/29.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NEOJSView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NEOJSUtil : NSObject

//+ (NEOJSView *)getNEOJSView;
+ (void)addNEOJSView;
+ (void)removeNEOJSView;
+ (void)neoTransferWithFromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress assetHash:(NSString *)assetHash amount:(NSString *)amount numOfDecimals:(NSString *)numOfDecimals wif:(NSString *)wif resultHandler:(NEOJSResultBlock)resultHandler;

@end

NS_ASSUME_NONNULL_END
