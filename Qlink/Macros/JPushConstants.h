//
//  JPushConstants.h
//  Qlink
//
//  Created by Jelly Foo on 2019/10/22.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const JPush_Tag_Jump = @"JPush_Tag_Jump"; // 本地推送跳转标志

@interface JPushConstants : NSObject

extern NSString *const JPush_Tag_All;
extern NSString *const JPush_Tag_Debit;
extern NSString *const JPush_Tag_QWallet_Test;

extern NSString *const JPush_Extra_Skip;
extern NSString *const JPush_Extra_Skip_Debit;
extern NSString *const JPush_Extra_Skip_Trade_Order;

@end

NS_ASSUME_NONNULL_END
