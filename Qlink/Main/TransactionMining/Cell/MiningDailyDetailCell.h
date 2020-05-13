//
//  MiningDailyDetailCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/11/13.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@class MiningRewardListModel;

static NSString *MiningDailyDetailCell_Reuse = @"MiningDailyDetailCell";
#define MiningDailyDetailCell_Height 95

@interface MiningDailyDetailCell : QBaseTableCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *qgasLab;

- (void)config:(MiningRewardListModel *)model;

@end

NS_ASSUME_NONNULL_END
