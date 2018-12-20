//
//  SettingsCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/31.
//  Copyright © 2018 pan. All rights reserved.
//

#import "SettingsCell.h"

@implementation SettingsShowModel

@end

@implementation SettingsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithModel:(SettingsShowModel *)model {
    if (model.haveNextPage) {
        _swit.hidden = YES;
        _detailLab.hidden = NO;
        _arrow.hidden = NO;
        _detailLab.text = model.detail;
    } else {
        _swit.hidden = NO;
        _detailLab.hidden = YES;
        _arrow.hidden = YES;
    }
    _titleLab.text = model.title;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _titleLab.text = nil;
    _detailLab.text = nil;
}

@end
