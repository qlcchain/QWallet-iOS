//
//  InviteRankView.h
//  Qlink
//
//  Created by Jelly Foo on 2019/10/18.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^InviteRankHeightBlock)(CGFloat height);

@interface InviteRankView : UIView

+ (instancetype)getInstance;
- (void)startRefresh;
- (void)config:(InviteRankHeightBlock)heightB;
- (void)updateTable:(NSString *)invite_reward_amount;

@end

NS_ASSUME_NONNULL_END
