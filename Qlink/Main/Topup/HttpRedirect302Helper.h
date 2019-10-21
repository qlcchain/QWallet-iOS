//
//  HttpRedirect302Helper.h
//  Qlink
//
//  Created by Jelly Foo on 2019/10/18.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpRedirect302Helper : NSObject

+ (instancetype)getShareObject;
- (void)startRedirect:(NSURL *)url completeBlock:(void(^)(NSString *urlStr))completeBlock;

@end

NS_ASSUME_NONNULL_END
