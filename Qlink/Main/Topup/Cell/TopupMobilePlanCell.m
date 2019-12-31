//
//  TopupMobilePlanCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/12/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TopupMobilePlanCell.h"
#import "UIColor+Random.h"
#import "TopupProductModel.h"
#import "GlobalConstants.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RLArithmetic.h"

@interface TopupMobilePlanCell ()

@property (weak, nonatomic) IBOutlet UIView *contentBack;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *discountLab;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;

@property (weak, nonatomic) IBOutlet UIView *locationBack;
@property (weak, nonatomic) IBOutlet UILabel *locationLab;


@property (weak, nonatomic) IBOutlet UIView *soldoutBack;
@property (weak, nonatomic) IBOutlet UIView *soldout_topTipBack;
@property (weak, nonatomic) IBOutlet UIView *soldout_tipBack;
@property (weak, nonatomic) IBOutlet UILabel *soldout_topTipLab;
@property (weak, nonatomic) IBOutlet UILabel *soldout_tipLab;


@end

@implementation TopupMobilePlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _contentBack.layer.cornerRadius = 8;
    _contentBack.layer.masksToBounds = YES;
//    _contentBack.backgroundColor = [UIColor RandomColor];
    
    _locationBack.layer.cornerRadius = 8;
    _locationBack.layer.masksToBounds = YES;
    
    _soldoutBack.layer.cornerRadius = 6;
    _soldoutBack.layer.masksToBounds = YES;
    _soldout_tipBack.layer.cornerRadius = 13;
    _soldout_tipBack.layer.masksToBounds = YES;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    
}


- (void)config:(TopupProductModel *)model {
    
    NSString *language = [Language currentLanguageCode];
    NSString *discountNumStr = @"0";
    NSString *titleStr = @"";
    NSString *locationStr = @"";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        discountNumStr = @(100).sub(model.discount.mul(@(100)));
        titleStr = [NSString stringWithFormat:@"%@%@%@",model.countryEn,model.provinceEn,model.ispEn];
        locationStr = model.countryEn.uppercaseString;
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        discountNumStr = model.discount.mul(@(10));
        titleStr = [NSString stringWithFormat:@"%@%@%@",model.country,model.province,model.isp];
        locationStr = model.country;
    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
        discountNumStr = @(100).sub(model.discount.mul(@(100)));
        titleStr = [NSString stringWithFormat:@"%@%@%@",model.countryEn,model.provinceEn,model.ispEn];
        locationStr = model.countryEn.uppercaseString;
    }
    _titleLab.text = titleStr;
    _locationLab.text = locationStr;
    
    NSString *discountStr = kLang(@"_discount");
    NSString *discountShowStr = [NSString stringWithFormat:@"%@%@",discountNumStr,discountStr];
    NSMutableAttributedString *discountAtt = [[NSMutableAttributedString alloc] initWithString:discountShowStr];
    // .SFUIDisplay-Semibold  .SFUI-Semibold
    [discountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@".SFUIDisplay-Semibold" size:20] range:NSMakeRange(0, discountShowStr.length)];
    [discountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@".SFUIDisplay-Semibold" size:14] range:[discountShowStr rangeOfString:discountStr]];
    [discountAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xff3669) range:NSMakeRange(0, discountShowStr.length)];
    _discountLab.attributedText = discountAtt;

    _tipLab.text = kLang(@"recharge_phone_bill");
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.imgPath]];
    [_img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"topup_guangdong_mobile"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    
    _soldoutBack.hidden = (model.stock && [model.stock doubleValue] == 0)?NO:YES;// 售罄
    _soldout_topTipLab.text = kLang(@"coming_soon_next_month");
    _soldout_tipLab.text = kLang(@"sold_out");
}

@end
