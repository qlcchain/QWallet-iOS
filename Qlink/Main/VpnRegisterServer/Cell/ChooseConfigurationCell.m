//
//  ChooseConfigurationCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/8/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "ChooseConfigurationCell.h"

@implementation ChooseConfigurationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithName:(NSString *)name {
    _nameLab.text = name;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _nameLab.text = nil;
}


@end
