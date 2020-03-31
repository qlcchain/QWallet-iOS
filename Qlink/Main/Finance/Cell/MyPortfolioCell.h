//
//  MyPortfolioCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/12.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FinanceOrderModel;

static NSString *MyPortfolioCellReuse = @"MyPortfolioCell";
#define MyPortfolioCell_Height 112

typedef void(^RedeemBlock)(NSInteger row);

@interface MyPortfolioCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *principalKeyLab;
@property (weak, nonatomic) IBOutlet UILabel *principalValLab;
@property (weak, nonatomic) IBOutlet UILabel *cumulativeEarnKeyLab;
@property (weak, nonatomic) IBOutlet UILabel *cumulativeEarnValLab;
@property (weak, nonatomic) IBOutlet UILabel *maturityDateKeyLab;
@property (weak, nonatomic) IBOutlet UILabel *maturityDateValLab;
@property (weak, nonatomic) IBOutlet UIButton *redeemBtn;

@property (nonatomic, copy) RedeemBlock redeemB;
@property (nonatomic) NSInteger row;

- (void)configCell:(FinanceOrderModel *)model;

@end
