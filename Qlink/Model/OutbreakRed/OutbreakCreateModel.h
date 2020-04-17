//
//  OutbreakCreateModel.h
//  Qlink
//
//  Created by Jelly Foo on 2020/4/17.
//  Copyright © 2020 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OutbreakCreateModel : BBaseModel

@property (nonatomic, strong) NSString *claimedQgas;
@property (nonatomic, strong) NSString *isolationDays;
@property (nonatomic, strong) NSString *subsidised;
@property (nonatomic, strong) NSString *pledgeQlcBase;
@property (nonatomic, strong) NSString *pledgeQlcDays;
@property (nonatomic, strong) NSString *rewardQlcAmount;
@property (nonatomic, strong) NSString *rewardQlcDays;
//pledgeQlcBase：qlc抵押基数
//pledgeQlcDays：最多补贴抵押天数
//rewardQlcAmount：补贴QLC数量
//rewardQlcDays：隔离多少天可以补贴QLC

@end



NS_ASSUME_NONNULL_END
