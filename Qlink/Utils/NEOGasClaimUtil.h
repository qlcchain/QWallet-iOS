//
//  NEOGasClaimUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/29.
//  Copyright © 2018 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    NEOGasClaimStatusNone,
//    NEOGasClaimStatusSync,
//    NEOGasClaimStatusSyncLoading,
    NEOGasClaimStatusClaim,
    NEOGasClaimStatusClaimLoading,
    NEOGasClaimStatusClaimSuccess,
    NEOGasClaimStatusClaimFail,
} NEOGasClaimStatus;

@interface NEOGasClaimUtil : NSObject

+ (instancetype)shareInstance;

@property (nonatomic) NEOGasClaimStatus claimStatus;

@end

NS_ASSUME_NONNULL_END
