//
//  ETHWalletDetailCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/26.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ETHWalletDetailCell.h"

@implementation ETHWalletDetailCell

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

- (void)configCellWithTitle:(NSString *)title {
    _titleLab.text = title;
}

@end
