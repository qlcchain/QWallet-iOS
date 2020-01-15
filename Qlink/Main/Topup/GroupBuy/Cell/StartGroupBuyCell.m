//
//  StartGroupBuyCell.m
//  Qlink
//
//  Created by Jelly Foo on 2020/1/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import "StartGroupBuyCell.h"
#import "GroupKindModel.h"
#import "GlobalConstants.h"
#import "RLArithmetic.h"

@implementation StartGroupBuyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_typeBtn setTitleColor:UIColorFromRGB(0x1E1E24) forState:UIControlStateNormal];
    [_typeBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xF5F5F5)] forState:UIControlStateNormal];
    [_typeBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateSelected];
    [_typeBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x3091F2)] forState:UIControlStateSelected];
    
    _typeBtn.layer.cornerRadius = 4;
    _typeBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    
}

- (void)config:(GroupKindModel *)model {
    NSString *discountNumStr = @"0";
    NSString *nameStr = @"";
    NSString *language = [Language currentLanguageCode];
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        discountNumStr = @(100).sub(model.discount.mul(@(100)));
        nameStr = model.nameEn;
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        discountNumStr = model.discount.mul(@(10));
        nameStr = model.name;
    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
        discountNumStr = @(100).sub(model.discount.mul(@(100)));
        nameStr = model.nameEn;
    }
    
    NSString *discountShowStr = @"";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        discountShowStr = [NSString stringWithFormat:@"%@ off, %@ discount partners",discountNumStr,model.numberOfPeople];
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        discountShowStr = [NSString stringWithFormat:@"满%@人%@折团",model.numberOfPeople,discountNumStr];
    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
        discountShowStr = [NSString stringWithFormat:@"%@ off, %@ discount partners",discountNumStr,model.numberOfPeople];
    }
    NSString *discountShowBtnStr = [NSString stringWithFormat:@"   %@   ",discountShowStr];
    [_typeBtn setTitle:discountShowBtnStr forState:UIControlStateNormal];
    [_typeBtn setTitle:discountShowBtnStr forState:UIControlStateSelected];
}

@end
