//
//  VPN2ChooseCountryCell.h
//  Qlink
//
//  Created by 旷自辉 on 2018/7/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContinentModel.h"

static NSString *ChooseCountryCellReuse = @"VPN2ChooseCountryCell";
#define VPN2ChooseCountryCell_Height 35

@interface VPN2ChooseCountryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *flagImgV;
@property (weak, nonatomic) IBOutlet UILabel *countryLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

- (void)configCell:(CountryModel *)model isSelect:(BOOL) select;
@end
