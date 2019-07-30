//
//  OrderStatusUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/24.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderStatusUtil : NSObject

+ (NSString *)getStatusStr:(NSString *)_status;
+ (UIColor *)getStatusColor:(NSString *)_status;

@end

NS_ASSUME_NONNULL_END
