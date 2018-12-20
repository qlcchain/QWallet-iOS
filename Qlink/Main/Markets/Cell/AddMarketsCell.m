//
//  AddMarketsCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/28.
//  Copyright © 2018 pan. All rights reserved.
//

#import "AddMarketsCell.h"

@implementation AddMarketsCell

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
    
    _titleLab.text = nil;
}

- (void)configCellWithTitle:(NSString *)title isSelect:(BOOL)isSelect {
    _titleLab.text = title;
    [_selectBtn setImage:isSelect?[UIImage imageNamed:@"icon_selected_purple"]:[UIImage imageNamed:@"icon_unselected_purple"] forState:UIControlStateNormal];
}

@end
