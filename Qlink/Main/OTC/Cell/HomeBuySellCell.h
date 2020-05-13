//
//  HomeBuySellCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/9.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@class EntrustOrderListModel;

static NSString *HomeBuySellCellReuse = @"HomeBuySellCell";
#define HomeBuySellCell_Height 190

typedef void(^HomeBuySellClickBlock)(EntrustOrderListModel *clickM);

@interface HomeBuySellCell : QBaseTableCell

- (void)config:(EntrustOrderListModel *)model clickB:(HomeBuySellClickBlock)clickB;

@end

NS_ASSUME_NONNULL_END
