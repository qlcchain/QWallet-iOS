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
    cchEthRedemptionStatusInit                      = 0,  //初始化状态
    cchEthRedemptionStatusWaitEthLockVerify         = 1,  //等待eth链上lock数据确认
    cchEthRedemptionStatusTryNeoLock                = 2, //准备调用neo contrack lock
    cchEthRedemptionStatusWaitNeoLockVerify         = 3,  //等待neo链上lock数据确认
    cchEthRedemptionStatusWaitClaim                 = 4,  //neo lock完成，等待用户claim
    cchEthRedemptionStatusWaitNeoUnlockVerify       = 5,  //等待neo链上unlock数据确认
    cchEthRedemptionStatusTryEthBlackhole           = 6,  //准备调用eth unlock 销毁之前锁定的用户erc20 token
    cchEthRedemptionStatusWaitEthUnlockVerify       = 7,  //eth unlock数据验证
    cchEthRedemptionStatusClaimOk                   = 8,  //用户正常赎回erc20资产完成
    cchEthRedemptionStatusTimeoutTryUnlock          = 9,  //用户在正常时间内没有claim，wrapper尝试去eth上unlock对应的erc20 token
    cchEthRedemptionStatusTimeoutUnlockVerify       = 10, //用户等待eth上unlock数据确认
    cchEthRedemptionStatusTimeoutUnlockOk           = 11, //用户超时，eth上erc20资产正常释放
    cchEthRedemptionStatusTimeoutDesLock            = 12, //抵押超时，可以赎回
    cchEthRedemptionStatusFailed                    = 13, //本次赎回失败，没有锁定成功
    cchEthRedemptionStatusFailedFetchTimeout        = 14, //本次抵押失败，fetch超时，用户可以赎回
    cchEthRedemptionStatusRevoking                  = 20, //超时赎回中
    cchEthRedemptionStatusClaimking                 = 21 //赎回中
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
