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
    DepositEthLockedDone =3,
    DepositEthUnLockedDone =4,
    DepositNeoUnLockedPending =5,
    DepositNeoUnLockedDone =6,
    DepositEthFetchPending =7,
    DepositEthFetchDone =8,
    DepositNeoFetchDone =9,
    // withdraw
    WithDrawEthLockedDone =10,
    WithDrawNeoLockedPending =11,
    WithDrawNeoLockedDone =12, // 等待unlock
    WithDrawNeoUnLockedDone =13,
    WithDrawEthUnlockPending =14,
    WithDrawEthUnlockDone =15,
    WithDrawNeoFetchPending =16,
    WithDrawNeoFetchDone =17,
    WithDrawEthFetchDone =18,
    // 失败
    Failed =19,
    Invalid =20
} ETHTokenLockState;

typedef enum : NSUInteger {
    cchNep5MortgageStatusInit                       = 0, //初始化状态
    cchNep5MortgageStatusWaitNeoLockVerify          = 1,  //等待neo链上lock数据确认
    cchNep5MortgageStatusTryEthLock                 = 2,  //准备调用eth contrack lock
    cchNep5MortgageStatusWaitEthLockVerify          = 3,  //等待eth链上lock数据确认
    cchNep5MortgageStatusWaitClaim                  = 4,  //ethlock完成，等待用户claim
    cchNep5MortgageStatusWaitEthUnlockVerify        = 5,  //等待eth链上unlock数据确认
    cchNep5MortgageStatusTryNeoUnlock               = 6,  //wrapper尝试调用neo unlock to wrapper
    cchNep5MortgageStatusWaitNeoUnlockVerify        = 7,  //等待neo链上unlock数据确认
    cchNep5MortgageStatusClaimOk                    = 8,  //用户正常换取erc20资产完成
    cchNep5MortgageStatusTimeoutTryDestroy          = 9,  //用户在正常时间内没有claim，wrapper尝试去eth上destroy对应的erc20资产
    cchNep5MortgageStatusTimeoutDestroyVerify       = 10, //用户等待eth上destory数据确认
    cchNep5MortgageStatusTimeoutDestroyOk           = 11, //用户超时，eth上erc20资产正常销毁
    cchNep5MortgageStatusTimeoutDesLock             = 12, //抵押超时，可以赎回
    cchNep5MortgageStatusFailed                     = 13, //本次抵押失败,没有锁定成功
    cchNep5MortgageStatusFailedFetchTimeout         = 14, //本次抵押失败，fetch超时，用户可以赎回
    cchNep5MortgageStatusRevoking                   = 20, //超时赎回中
    cchNep5MortgageStatusClaimking                  = 21 //赎回中
} NEOTokenLockState;

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
@end

NS_ASSUME_NONNULL_END
