//
//  MyCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/10.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MyCell.h"

@implementation MyShowModel

@end

@implementation MyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _redView.layer.cornerRadius = 4;
    _redView.layer.masksToBounds = YES;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _titleLab.text = nil;
    _icon.image = nil;
}

- (void)configCellWithModel:(MyShowModel *)model {
    _titleLab.text = model.title;
    _icon.image = [UIImage imageNamed:model.icon];
    _redView.hidden = !model.showRed;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
