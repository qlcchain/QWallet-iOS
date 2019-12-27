//
//  ChooseCountryCodeCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/12/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ChooseCountryCodeCell.h"
#import "TopupCountryModel.h"

@interface ChooseCountryCodeCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectImg;


@end

@implementation ChooseCountryCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)config:(TopupCountryModel *)model isSelect:(BOOL)isSelect {
    _titleLab.text = [NSString stringWithFormat:@"%@ %@",model.nameEn,model.globalRoaming];
    _selectImg.hidden = !isSelect;
}


@end
