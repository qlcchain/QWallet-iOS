//
//  ChooseCurrencyCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/31.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ChooseCurrencyCell.h"
#import "ConfigUtil.h"

@implementation ChooseCurrencyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithCurrency:(NSString *)currency {
    _currentcyLab.text = currency;
    if ([currency isEqualToString:[ConfigUtil getLocalUsingCurrency]]) {
        _selectIcon.hidden = NO;
    } else {
        _selectIcon.hidden = YES;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _currentcyLab.text = nil;
}


@end
