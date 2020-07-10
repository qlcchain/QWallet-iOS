//
//  DefiPriceCell.m
//  Qlink
//
//  Created by 旷自辉 on 2020/7/8.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DefiPriceCell.h"
#import "DefiTokenModel.h"
#import "NSString+Calculate.h"
#import "NSString+RemoveZero.h"
#import "GlobalConstants.h"

@implementation DefiPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) config:(DefiTokenModel *) tokenM
{
    _lblsysbol.text = tokenM.symbol?:@"";
     CGFloat price = tokenM.price? [tokenM.price floatValue] : 0;
    _lblPrice.text = [@"$" stringByAppendingFormat:@"%.2f",price];
    CGFloat gains = tokenM.percentChange24h? [tokenM.percentChange24h floatValue] : 0;
    _lblGains.text = [NSString stringWithFormat:@"%.2f%%",gains];
    
    _lblGains.textColor = [tokenM.percentChange24h isBiggerAndEqual:@"0"]?UIColorFromRGB(0x07CDB3):UIColorFromRGB(0xFF3669);
    
    _zfIcon.image = [tokenM.percentChange24h isBiggerAndEqual:@"0"]?[UIImage imageNamed:@"icon_arrow_up"]:[UIImage imageNamed:@"icon_arrow_down"];
    
    CGFloat marketValue = tokenM.marketCap? [tokenM.marketCap floatValue] : 0;
    NSString *marketValueStr  = [NSString countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",marketValue]];
    _lblMarketValue.text = [@"$" stringByAppendingFormat:@"%@",marketValueStr];
    
    
    CGFloat circulatingSupply = tokenM.circulatingSupply? [tokenM.circulatingSupply floatValue] : 0;
    NSString *circulatingSupplyStr  = [NSString countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",circulatingSupply]];
    _lblCrculation.text = [NSString stringWithFormat:@"%@ %@",circulatingSupplyStr,tokenM.symbol?:@""];
}

@end
