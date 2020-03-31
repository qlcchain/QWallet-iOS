//
//  TabbarHelper.h
//  Qlink
//
//  Created by Jelly Foo on 2019/11/21.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedPointModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabbarHelper : NSObject

+ (void)requestUser_red_pointWithCompleteBlock:(void(^)(RedPointModel *redPointM))completeBlock;

@end

NS_ASSUME_NONNULL_END
