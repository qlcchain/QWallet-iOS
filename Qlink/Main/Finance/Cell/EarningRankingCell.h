//
//  EarningRankingCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QBaseTableCell.h"

@class EarningsRankingModel;

static NSString *EarningRankingCellReuse = @"EarningRankingCell";
#define EarningRankingCell_Height 64

@interface EarningRankingCell : QBaseTableCell

@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *earnLab;


- (void)configCell:(EarningsRankingModel *)model;

@end
