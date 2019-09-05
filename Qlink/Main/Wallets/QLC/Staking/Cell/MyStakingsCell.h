//
//  MyStakingsCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/8/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PledgeInfoByBeneficialModel;

static NSString *MyStakingsCellReuse = @"MyStakingsCell";
#define MyStakingsCell_Height 122

@interface MyStakingsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *stakingAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *earningsLab;


- (void)config:(PledgeInfoByBeneficialModel *)model;

@end

NS_ASSUME_NONNULL_END
