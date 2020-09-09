//
//  QSwapStatusManager.m
//  Qlink
//
//  Created by 旷自辉 on 2020/8/24.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QSwapStatusManager.h"
#import "QSwapHashModel.h"
#import "GlobalConstants.h"
#import "QSwipWrapperRequestUtil.h"

static float afterDelay = 15.0;

@implementation QSwapStatusManager

+ (instancetype) getShareQSwapStatusManager
{
    static QSwapStatusManager *shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
    });
    return shareObject;
}

/// 根据wrapper状态更新本地
/// @param rHash parames
- (void) updateSwapStatusWithRhash:(NSString *) rHash
{
    [self performSelector:@selector(sendWrapperStateRequestWithRhash:) withObject:rHash afterDelay:afterDelay];
}
- (void) sendWrapperStateRequestWithRhash:(NSString *) rHash
{
    kWeakSelf(self)
    [QSwipWrapperRequestUtil checkEventStatWithRhash:rHash resultHandler:^(id  _Nullable result, BOOL success, NSString * _Nullable message) {
        if (success) {
            NSInteger state = [result[@"state"]?:@"" integerValue];
            NSString *resultRhash = [@"0x" stringByAppendingString:result[@"rHash"]?:@""];
            if (state == DepositNeoFetchDone || state == WithDrawEthFetchDone || [QSwapStatusManager isClaimSuccessWithState:state]) {
                // 更新本地状态
                [QSwapHashModel updateSwapHashStateWithHash:resultRhash withState:state];
                // 发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:SWAP_Status_Change_Noti object:@[rHash,@(state)]];
            } else {
                [weakself performSelector:@selector(sendWrapperStateRequestWithRhash:) withObject:rHash afterDelay:3];
            }
        } else {
           [weakself performSelector:@selector(sendWrapperStateRequestWithRhash:) withObject:rHash afterDelay:3];
        }
    }];
}

+ (BOOL) isClaimSuccessWithState:(NSInteger) state
{
    if ((state >=15 && state <=17) || (state >=4 && state <=6)) {
        return YES;
    } else {
        return NO;
    }
}
@end
