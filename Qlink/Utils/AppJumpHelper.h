//
//  PushJumpHelper.h
//  Qlink
//
//  Created by Jelly Foo on 2019/11/26.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppJumpHelper : NSObject

+ (void)jumpToWallet;
+ (void)jumpToOTC;
+ (void)jumpToTopup;
+ (void)jumpToDailyEarnings;
+ (void)jumpToMyOrderList:(OTCRecordListType)listType;

@end

NS_ASSUME_NONNULL_END
