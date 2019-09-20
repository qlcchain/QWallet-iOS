//
//  StakingUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2019/9/18.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StakingUtil : NSObject

+ (BOOL)isRedeemable:(NSTimeInterval)withdrawTime;

@end

NS_ASSUME_NONNULL_END
