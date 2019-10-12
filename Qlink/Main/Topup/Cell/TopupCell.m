//
//  FinanceCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/11.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TopupCell.h"
#import "GlobalConstants.h"
#import "TopupProductModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation TopupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _discountBack.layer.cornerRadius = 14;
    _discountBack.layer.masksToBounds = YES;
    _discountBack.layer.borderWidth = 1;
    _discountBack.layer.borderColor = [UIColor whiteColor].CGColor;
    _contentBack.layer.cornerRadius = 10;
    _contentBack.layer.masksToBounds = YES;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _titleLab.text = nil;
    _subTitleLab.text = nil;
    _checkDiscountLab.text = nil;
    _discountLab.text = nil;
    _desLab.text = nil;
}

- (void)config:(TopupProductModel *)model {
    NSString *language = [Language currentLanguageCode];
    NSString *country = @"";
    NSString *province = @"";
    NSString *isp = @"";
    NSString *name = @"";
    NSNumber *discountNum = @(0);
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        country = model.countryEn;
        province = model.provinceEn;
        isp = model.ispEn;
        name = model.nameEn;
        discountNum = @(100-[model.discount doubleValue]*100);
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        country = model.country;
        province = model.province;
        isp = model.isp;
        name = model.name;
        discountNum = @([model.discount doubleValue]*10);
    }
    _titleLab.text = [NSString stringWithFormat:@"%@%@%@",country,province,isp];
    _subTitleLab.text = name;
    _checkDiscountLab.text = kLang(@"view_your_exclusive_offers");
    
    NSString *discountStr = kLang(@"_discount");
    NSString *discountShowStr = [NSString stringWithFormat:@"%@%@",discountNum,discountStr];
    NSMutableAttributedString *discountAtt = [[NSMutableAttributedString alloc] initWithString:discountShowStr];
    // .SFUIDisplay-Semibold
    [discountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@".SFUIDisplay-Semibold" size:30] range:NSMakeRange(0, discountShowStr.length)];
    [discountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@".SFUIDisplay-Semibold" size:14] range:[discountShowStr rangeOfString:discountStr]];
    [discountAtt addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, discountShowStr.length)];
    _discountLab.attributedText = discountAtt;
//    _discountLab.text = [NSString stringWithFormat:@"%@%@",@([model.discount doubleValue]*10),kLang(@"_discount")];
    
    _desLab.text = kLang(@"recharge_phone_bill");
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.imgPath]];
    [_backImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"topup_guangdong_mobile"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
