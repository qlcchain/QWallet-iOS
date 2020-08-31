//
//  QRecordCell.m
//  Qlink
//
//  Created by 旷自辉 on 2020/8/11.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QRecordCell.h"

@implementation QRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _claimBtn.layer.cornerRadius = 4.0f;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickClaim:(id)sender {
    if (_claimBlock) {
        _claimBlock();
    }
}

@end
