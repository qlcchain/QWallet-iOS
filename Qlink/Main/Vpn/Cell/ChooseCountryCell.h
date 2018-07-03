//
//  ChooseCountryCell.h
//  Qlink
//
//  Created by Jelly Foo on 2018/4/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CountryModel;

static NSString *ChooseCountryCellReuse = @"ChooseCountryCell";
#define ChooseCountryCell_Height 35

@interface ChooseCountryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *flagImgV;
@property (weak, nonatomic) IBOutlet UILabel *countryLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

- (void)configCell:(CountryModel *)model isSelect:(BOOL)isSelect;

@end
