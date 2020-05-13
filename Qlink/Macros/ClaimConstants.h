//
//  ClaimConstants.h
//  Qlink
//
//  Created by Jelly Foo on 2019/10/10.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClaimConstants : NSObject

extern NSString *const Claim_Type_Register; // 注册
extern NSString *const Claim_Type_Invite; // 邀请
extern NSString *const Claim_Status_New; // 新建
extern NSString *const Claim_Status_Success; // 成功
extern NSString *const Claim_Status_Fail; // 失败

extern NSString *const winq_reward_qlc_amount; // 奖励qlc数量
extern NSString *const winq_invite_reward_amount; // 邀请一个用户奖励QGAS数量
extern NSString *const winq_invite_user_amount; // 邀请多少个用户可以领取QGAS奖励

extern NSString *const Invite_Status_AWARDED;
extern NSString *const Invite_Status_NO_AWARD;

extern NSString *const app_dict; // 服务器参数数据

@end

NS_ASSUME_NONNULL_END
