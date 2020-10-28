//
//  DefiListCell.m
//  Qlink
//
//  Created by 旷自辉 on 2020/10/27.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DefiListCell.h"

@implementation DefiListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _iconImgView.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
