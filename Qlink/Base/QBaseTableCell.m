//
//  QBaseTableCell.m
//  Qlink
//
//  Created by Jelly Foo on 2020/4/9.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QBaseTableCell.h"
#import "GlobalConstants.h"

@implementation QBaseTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectedBackgroundView = kClickEffectCellImageView;
//    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor redColor]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
