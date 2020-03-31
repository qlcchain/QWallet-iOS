//
//  QgasVoteUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2020/2/26.
//  Copyright © 2020 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuybackBurnModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BuybackBurnUtil : NSObject

+ (void)requestBuybackBurn_list:(void(^)(NSArray<BuybackBurnModel *> *arr))listB;
+ (void)requestBuybackBurn_list_v2:(void(^)(NSArray<BuybackBurnModel *> *arr))listB;

@end

NS_ASSUME_NONNULL_END
