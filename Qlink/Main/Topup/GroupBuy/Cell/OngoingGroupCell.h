//
//  OngoingGroupCell.h
//  Qlink
//
//  Created by Jelly Foo on 2020/1/13.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@class GroupBuyListModel;

static NSString *OngoingGroupCell_Reuse = @"OngoingGroupCell";
#define OngoingGroupCell_Height 60

typedef void(^OngoingGroupJoinBlock)(GroupBuyListModel *joinM);

@interface OngoingGroupCell : QBaseTableCell

- (void)config:(GroupBuyListModel *)model joinB:(OngoingGroupJoinBlock)joinB;

@end

NS_ASSUME_NONNULL_END
