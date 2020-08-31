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
/// @param parames parames
- (void) updateSwapStatusWithPrames:(NSArray *) parames
{
    [self performSelector:@selector(sendWrapperStateRequestWitPrames:) withObject:parames afterDelay:afterDelay];
}
- (void) sendWrapperStateRequestWitPrames:(NSArray *) parames
{
    kWeakSelf(self)
    [QSwipWrapperRequestUtil checkEventStatWithRhash:[parames[0] substringFromIndex:2] resultHandler:^(id  _Nullable result, BOOL success, NSString * _Nullable message) {
        if (success) {
            NSInteger state = [result[@"status"]?:@"" integerValue];
            NSString *rHash = [@"0x" stringByAppendingString:result[@"hash"]?:@""];
            if (state == 11 || state == 14) {
                // 更新本地状态
                [QSwapHashModel updateSwapHashStateWithHash:rHash withState:state];
                // 发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:SWAP_Status_Change_Noti object:@[rHash,@(state)]];
            } else {
                [weakself performSelector:@selector(sendWrapperStateRequestWitPrames:) withObject:parames afterDelay:3];
            }
        } else {
           [weakself performSelector:@selector(sendWrapperStateRequestWitPrames:) withObject:parames afterDelay:3];
        }
    }];
}
@end
