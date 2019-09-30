//
//  FinanceCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/11.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopupProductModel;

static NSString *ChooseTopupPlanCellReuse = @"ChooseTopupPlanCell";
#define ChooseTopupPlanCell_Height 196

@interface ChooseTopupPlanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UILabel *topupAmountLab;
@property (weak, nonatomic) IBOutlet UIView *whiteBack;
@property (weak, nonatomic) IBOutlet UILabel *explainLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;

- (void)config:(TopupProductModel *)model;

@end
