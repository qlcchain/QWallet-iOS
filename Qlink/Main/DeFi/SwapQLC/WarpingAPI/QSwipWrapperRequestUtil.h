//
//  QSwipWrapperRequestUtil.h
//  Qlink
//
//  Created by 旷自辉 on 2020/8/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
  // deposit
    DepositInitLockerState = 0,
    DepositNeoLockedDone = 1,
    DepositEthLockedPending =2,
    DepositEthLockedDone =3, // 等待eth unlock
    DepositEthUnLockedDone =4,// 等待eth unlock
    DepositNeoUnLockedPending =5,
    DepositNeoUnLockedDone =6, //unlock 完成
    DepositEthFetchPending =7,
    DepositEthFetchDone =8, // nep5失败，超时,等待续回
    DepositNeoFetchPending =9, //续回中
    DepositNeoFetchDone =10, // 续回完成
    // withdraw
    WithDrawEthLockedDone =11,
    WithDrawNeoLockedPending =12,
    WithDrawNeoLockedDone =13,// 等待neo unlock
    WithDrawNeoUnLockedPending =14, // unlock中
    WithDrawNeoUnLockedDone =15,
    WithDrawEthUnlockPending =16,
    WithDrawEthUnlockDone =17, // unlock 完成
    WithDrawNeoFetchPending =18,
    WithDrawNeoFetchDone =19, // erc20失败，超时,等待续回
    WithDrawEthFetchDone =20, // 续回完成
    // 自己添加状态
    lockTimeoutState =29, // 超时
    claimingState =30, // 兑换中
    revokeingState =31// 续回中
    
} ETHTokenLockState;

typedef enum : NSUInteger {
    Nep5ActionUserLock = 0,
    Nep5ActionWrapperUnlock = 1,
    Nep5ActionRefundUser = 2,
    Nep5ActionWrapperLock = 3,
    Nep5ActionUserUnlock = 4,
    Nep5ActionRefundWrapper = 5
} Nep5ActionNoticeType;

typedef void(^QWrapperResultBlock)(id _Nullable result, BOOL success,  NSString * _Nullable message);

@interface QSwipWrapperRequestUtil : NSObject

+ (void) checkWrapperOnlineResultHandler:(QWrapperResultBlock)resultHandler;
+ (void) checkEventStatWithRhash:(NSString *) rHash resultHandler:(QWrapperResultBlock)resultHandler;
+ (void) nep5LockNoticeWithType:(NSString *) type hash:(NSString *) hash amount:(NSString *) amount resultHandler:(QWrapperResultBlock)resultHandler;
+ (void) withdrawApiUnLockWithNepTxHash:(NSString *)nepTxhash rHash:(NSString *) rHash rOright:(NSString *) rOright resultHandler:(QWrapperResultBlock)resultHandler;
// unlock 到 nepo
+ (void) unLockToNep5WithRhash:(NSString *) rOrigin userNep5Addr:(NSString *) nep5Address resultHandler:(QWrapperResultBlock)resultHandler;
@end

NS_ASSUME_NONNULL_END
