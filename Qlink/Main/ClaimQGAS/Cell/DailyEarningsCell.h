//
//  DailyEarningsCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/10/9.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RewardListModel;

static NSString *DailyEarningsCellReuse = @"DailyEarningsCell";
#define DailyEarningsCell_Height 95

@interface DailyEarningsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *qgasLab;

- (void)config:(RewardListModel *)model;


@end

NS_ASSUME_NONNULL_END
