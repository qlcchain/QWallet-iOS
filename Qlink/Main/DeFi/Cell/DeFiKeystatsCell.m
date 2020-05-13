//
//  DeFiKeystatsCell.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DeFiKeystatsCell.h"
#import "DefiProjectModel.h"
#import "NSString+RemoveZero.h"
#import "GlobalConstants.h"

@interface DeFiKeystatsCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *valLab;
@property (weak, nonatomic) IBOutlet UILabel *percentLab;


@end

@implementation DeFiKeystatsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)config:(DefiProject_KeyModel *)model {
    _nameLab.text = [NSString stringWithFormat:@"in %@",model.keyStr];
    NSString *valStr = @"";
    if ([model.keyStr isEqualToString:@"USD"]) {
        valStr = [NSString stringWithFormat:@"$%@",[model.valModel.value showfloatStr_Defi:2]];
    } else {
        valStr = [NSString stringWithFormat:@"%@ %@",[model.valModel.value showfloatStr_Defi:2],model.keyStr];
    }
    _valLab.text = valStr;
    NSString *percentStr = @"";
    if ([model.valModel.relative_1d isBiggerAndEqual:@"0"]) {
        percentStr = [NSString stringWithFormat:@"+%@%%",[model.valModel.relative_1d showfloatStr:2]];
    } else {
        percentStr = [NSString stringWithFormat:@"%@%%",[model.valModel.relative_1d showfloatStr:2]];
    }
    _percentLab.text = percentStr;
    _percentLab.textColor = [model.valModel.relative_1d isBiggerAndEqual:@"0"]?UIColorFromRGB(0x07CDB3):UIColorFromRGB(0xFF3669);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
