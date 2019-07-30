//
//  ChooseAreaCodeCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/9.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ChooseAreaCodeCell.h"
#import "AreaCodeModel.h"

@implementation ChooseAreaCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _nameLab.text = nil;
    _codeLab.text = nil;
}

- (void)configCell:(AreaCodeModel *)model {
    _nameLab.text = model.en;
    _codeLab.text = [NSString stringWithFormat:@"+%@",@(model.code)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
