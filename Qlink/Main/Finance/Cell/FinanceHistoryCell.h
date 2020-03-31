//
//  FinanceHistoryCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/16.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FinanceHistoryModel;

static NSString *FinanceHistoryCellReuse = @"FinanceHistoryCell";
#define FinanceHistoryCell_Height 95

@interface FinanceHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *qlcLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *toLab;

- (void)configCell:(FinanceHistoryModel *)model;


@end
