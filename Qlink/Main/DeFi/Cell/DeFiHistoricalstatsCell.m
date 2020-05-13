//
//  DeFiHistoricalstatsCell.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DeFiHistoricalstatsCell.h"
#import "DefiHistoricalStatsListModel.h"
#import "NSString+RemoveZero.h"
#import "GlobalConstants.h"

@interface DeFiHistoricalstatsCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *tvlUsdLab;
@property (weak, nonatomic) IBOutlet UILabel *usdPoorLab;
@property (weak, nonatomic) IBOutlet UILabel *tvlEthLab;
@property (weak, nonatomic) IBOutlet UILabel *ethPoorLab;


@end

@implementation DeFiHistoricalstatsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)config:(DefiHistoricalStatsListModel *)model {
    // 07CDB3+   F50F6D-
    UIColor *color1 = UIColorFromRGB(0x07CDB3);
    UIColor *color2 = UIColorFromRGB(0xF50F6D);
    
    NSString *timeStr = model.statsDate;
    if (timeStr && timeStr.length > 10) {
        timeStr = [timeStr substringToIndex:10];
    }
    _timeLab.text = timeStr;
    
    NSString *tvlUsd_defi = [model.tvlUsd showfloatStr_Defi:2];
    _tvlUsdLab.text = [NSString stringWithFormat:@"$%@",tvlUsd_defi];
    
    NSString *usdPoor_defi = [model.usdPoor showfloatStr_Defi:2];
    _usdPoorLab.text = [NSString stringWithFormat:@"%@",usdPoor_defi];
    _usdPoorLab.textColor = [model.usdPoor isBiggerAndEqual:@"0"]?color1:color2;
    
    NSString *tvlEth_defi = [model.tvlEth showfloatStr_Defi:2];
    _tvlEthLab.text = [NSString stringWithFormat:@"%@ ETH",tvlEth_defi];
    
    NSString *ethPoor_defi = [model.ethPoor showfloatStr_Defi:2];
    _ethPoorLab.text = [NSString stringWithFormat:@"%@ ETH",ethPoor_defi];
    _ethPoorLab.textColor = [model.ethPoor isBiggerAndEqual:@"0"]?color1:color2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
