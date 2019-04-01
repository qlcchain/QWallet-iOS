//
//  WalletSelectCell.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "WalletSelectCell.h"

@implementation WalletSelectCell

- (void) cellSelect:(BOOL) isSelect
{
    if (isSelect) {
        _selectBtn.image = [UIImage imageNamed:@"icon_the_selected"];
    } else {
         _selectBtn.image = [UIImage imageNamed:@"icon_the_uncheck"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
