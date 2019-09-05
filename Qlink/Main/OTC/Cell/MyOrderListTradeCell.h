//
//  MyOrderListCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/10.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    RecordListTypePosted,
    RecordListTypeProcessing,
    RecordListTypeCompleted,
    RecordListTypeClosed,
    RecordListTypeAppealed,
} RecordListType;

@class TradeOrderListModel;

static NSString *MyOrderListTradeCellReuse = @"MyOrderListTradeCell";
static NSInteger const MyOrderListTradeCell_Height = 137;

@interface MyOrderListTradeCell : UITableViewCell

- (void)config:(TradeOrderListModel *)model type:(RecordListType)type;

@end

NS_ASSUME_NONNULL_END
