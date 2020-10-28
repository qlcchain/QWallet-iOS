//
//  UrlCell.m
//  Qlink
//
//  Created by 旷自辉 on 2020/10/27.
//  Copyright © 2020 pan. All rights reserved.
//

#import "UrlCell.h"

@implementation UrlCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)clearUrlAction:(id)sender {
    if (_clearBlock) {
        _clearBlock(self.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
