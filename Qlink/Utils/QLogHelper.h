//
//  QLogHelper.h
//  Qlink
//
//  Created by Jelly Foo on 2019/9/29.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLogHelper : NSObject

+ (void)requestLog_saveWithClass:(NSString *)className method:(NSString *)method logStr:(NSString *)logStr;

@end

NS_ASSUME_NONNULL_END
