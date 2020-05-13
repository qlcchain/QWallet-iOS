//
//  DeFiHistoricalstatsCell.h
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DefiHistoricalStatsListModel;

static NSString *DeFiHistoricalstatsCell_Reuse = @"DeFiHistoricalstatsCell";
#define DeFiHistoricalstatsCell_Height 64

@interface DeFiHistoricalstatsCell : UITableViewCell

- (void)config:(DefiHistoricalStatsListModel *)model;

@end

NS_ASSUME_NONNULL_END
