//
//  ClaimConstants.m
//  Qlink
//
//  Created by Jelly Foo on 2019/10/10.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ClaimConstants.h"

@implementation ClaimConstants

NSString *const Claim_Type_Register = @"REGISTER"; // 注册
NSString *const Claim_Type_Invite = @"INVITE"; // 邀请
NSString *const Claim_Status_New = @"NEW"; // 新建
NSString *const Claim_Status_Success = @"SUCCESS"; // 成功
NSString *const Claim_Status_Fail = @"FAIL"; // 失败

NSString *const winq_reward_qlc_amount = @"winq_reward_qlc_amount"; // 奖励qlc数量
NSString *const winq_invite_reward_amount = @"winq_invite_reward_amount"; // 邀请一个用户奖励QGAS数量
NSString *const winq_invite_user_amount = @"winq_invite_user_amount"; // 邀请多少个用户可以领取QGAS奖励

NSString *const Invite_Status_AWARDED =  @"AWARDED";
NSString *const Invite_Status_NO_AWARD =  @"NO_AWARD";

NSString *const app_dict = @"app_dict"; // 服务器参数数据


@end
