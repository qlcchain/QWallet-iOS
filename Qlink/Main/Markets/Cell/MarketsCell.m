//
//  MarketsCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/14.
//  Copyright © 2018 pan. All rights reserved.
//

#import "MarketsCell.h"
#import "UIView+Visuals.h"
#import "BinaTpcsModel.h"
#import "WalletCommonModel.h"
#import "NSString+RemoveZero.h"

@implementation MarketsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_changeBtn setRoundedCorners:UIRectCornerAllCorners radius:4];
    _changeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    _changeBtn.titleLabel.lineBreakMode = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithModel:(BinaTpcsModel *)model {
    UIImage *iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"eth_%@",model.symbol.lowercaseString]];
    if (iconImage == nil) {
        iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"neo_%@",model.symbol.lowercaseString]];
    }
    if (iconImage == nil) {
        iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"eos_%@",model.symbol.lowercaseString]];
    }
    _icon.image = iconImage;
    
    _nameLab.text = model.symbol;
    _price1Lab.text = [model getNum];
    _price2Lab.text = [NSString stringWithFormat:@"%@%@", [ConfigUtil getLocalUsingCurrencySymbol],[model getPrice]];
    [_changeBtn setTitle:[NSString stringWithFormat:@"%@%@",[model getChange].show4floatStr,@"%"] forState:UIControlStateNormal];
    if ([[model getChange] doubleValue] < 0) {
        [_changeBtn setBackgroundColor:UIColorFromRGB(0xFF3669)];
    } else {
        [_changeBtn setBackgroundColor:UIColorFromRGB(0x07CDB3)];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _icon.image = nil;
    _nameLab.text = nil;
    _price1Lab.text = nil;
    _price2Lab.text = nil;
//    _changeBtn.titleLabel.text = nil;
}

@end
