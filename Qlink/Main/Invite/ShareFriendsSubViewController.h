//
//  ShareFriendsSubViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2020/1/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, InviteAwardType) {
    InviteAwardTypeInvite = 0,
    InviteAwardTypeFriend = 1,
    InviteAwardTypeDelegate = 2,
};


@interface ShareFriendsSubViewController : QBaseViewController

@property (nonatomic, strong) NSString *input_invite_reward_amount;
@property (nonatomic) InviteAwardType inputType;

@end

NS_ASSUME_NONNULL_END
