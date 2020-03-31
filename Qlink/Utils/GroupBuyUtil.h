//
//  GroupBuyUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2020/1/20.
//  Copyright © 2020 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupBuyUtil : NSObject

+ (void)requestIsInGroupBuyActiviyTime:(void(^)(BOOL isInGroupBuyActiviyTime))completeBlock;

@end

NS_ASSUME_NONNULL_END
