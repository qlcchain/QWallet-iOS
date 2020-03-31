//
//  SheetMiningUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2019/11/14.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MiningActivityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SheetMiningUtil : NSObject

+ (void)requestTrade_mining_list:(void(^)(NSArray<MiningActivityModel *> *arr))listB;

@end

NS_ASSUME_NONNULL_END
