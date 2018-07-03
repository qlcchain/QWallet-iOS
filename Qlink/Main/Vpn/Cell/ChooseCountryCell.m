//
//  ChooseCountryCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "ChooseCountryCell.h"
#import "ContinentModel.h"

@implementation ChooseCountryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _flagImgV.image = nil;
    _countryLab.text = nil;
}

- (void)configCell:(CountryModel *)model isSelect:(BOOL)isSelect {
    _flagImgV.image = [UIImage imageNamed:model.countryImage];
    _countryLab.text = model.name;
    _selectBtn.selected = isSelect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
