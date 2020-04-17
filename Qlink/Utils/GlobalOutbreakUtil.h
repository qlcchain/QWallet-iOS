//
//  GlobalOutbreakUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2020/4/15.
//  Copyright © 2020 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GlobalOutbreakUtil : NSObject

+ (void)transitionToGlobalOutbreak;
+ (void)requestGzbd_focus:(void(^)(NSString *subsidised,NSString *isolationDays,NSString *claimedQgas))completeBlock;

@end

NS_ASSUME_NONNULL_END
