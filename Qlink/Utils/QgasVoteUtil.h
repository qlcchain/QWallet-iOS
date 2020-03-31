//
//  QgasVoteUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2020/2/26.
//  Copyright © 2020 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, QgasVoteState) {
    QgasVoteStateNotyet = 1,
    QgasVoteStateOngoing = 2,
    QgasVoteStateDone = 3,
};

@interface QgasVoteUtil : NSObject

+ (void)requestState:(void(^)(QgasVoteState state))completeBlock;

@end

NS_ASSUME_NONNULL_END
