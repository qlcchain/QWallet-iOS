//
//  VPN2ChooseCountryCell.m
//  Qlink
//
//  Created by 旷自辉 on 2018/7/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VPN2ChooseCountryCell.h"

@implementation VPN2ChooseCountryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCell:(CountryModel *)model isSelect:(BOOL) select
{
    _flagImgV.image = [UIImage imageNamed:model.countryImage];
    _countryLab.text = model.name;
    _selectBtn.selected = select;
}

@end
