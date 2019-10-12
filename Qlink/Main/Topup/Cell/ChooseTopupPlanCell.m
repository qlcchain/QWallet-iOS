//
//  FinanceCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/11.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ChooseTopupPlanCell.h"
#import "GlobalConstants.h"
#import "TopupProductModel.h"

@implementation ChooseTopupPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _whiteBack.layer.cornerRadius = 6;
    _whiteBack.layer.masksToBounds = YES;
    _contentBack.layer.cornerRadius = 8;
    _contentBack.layer.masksToBounds = YES;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _titleLab.text = nil;
    _subTitleLab.text = nil;
    _amountLab.text = nil;
//    _tipLab.text = nil;
    _topupAmountLab.text = nil;
    _explainLab.text = nil;
    _desLab.text = nil;
}

- (void)config:(TopupProductModel *)model {
    NSString *language = [Language currentLanguageCode];
    NSString *country = @"";
    NSString *province = @"";
    NSString *isp = @"";
    NSString *name = @"";
    NSString *explain = @"";
    NSString *des = @"";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        country = model.countryEn;
        province = model.provinceEn;
        isp = model.ispEn;
        name = model.nameEn;
        explain = model.explainEn;
        des = model.descriptionEn;
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        country = model.country;
        province = model.province;
        isp = model.isp;
        name = model.name;
        explain = model.explain;
        des = model.Description;
    }
    _titleLab.text = [NSString stringWithFormat:@"%@%@%@",country,province,isp];
    _subTitleLab.text = name;
    _explainLab.text = explain;
    _desLab.text = des;
    
    NSString *rmbStr = kLang(@"rmb");
    NSString *amountShowStr = @"";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        amountShowStr = [NSString stringWithFormat:@"%@%@",kLang(@"rmb"),model.amount];
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        amountShowStr = [NSString stringWithFormat:@"%@%@",model.amount,kLang(@"rmb")];
    }
    NSMutableAttributedString *amountAtt = [[NSMutableAttributedString alloc] initWithString:amountShowStr];
    // .SFUIDisplay-Semibold
    [amountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@".SFUIDisplay-Semibold" size:30] range:NSMakeRange(0, amountShowStr.length)];
    [amountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@".SFUIDisplay-Semibold" size:14] range:[amountShowStr rangeOfString:rmbStr]];
    [amountAtt addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, amountShowStr.length)];
    _amountLab.attributedText = amountAtt;
//    _amountLab.text = [NSString stringWithFormat:@"%@%@",model.amount,kLang(@"rmb")];
    
    NSNumber *faitNum = @([model.discount doubleValue]*[model.amount doubleValue]);
    NSNumber *qgasNum = @([model.amount doubleValue]*[model.qgasDiscount doubleValue]);
    
    NSString *qgasStr = @"QGAS";
    NSString *addStr = @"+";
    NSString *topupAmountShowStr = @"";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",kLang(@"rmb"),faitNum,addStr,qgasNum,qgasStr];
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",faitNum,kLang(@"rmb"),addStr,qgasNum,qgasStr];
    }
    NSMutableAttributedString *topupAmountAtt = [[NSMutableAttributedString alloc] initWithString:topupAmountShowStr];
    // .SFUIDisplay-Semibold
    [topupAmountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@".SFUIDisplay-Semibold" size:20] range:NSMakeRange(0, topupAmountShowStr.length)];
    [topupAmountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@".SFUIDisplay-Semibold" size:14] range:[topupAmountShowStr rangeOfString:rmbStr]];
    [topupAmountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@".SFUIDisplay-Semibold" size:19] range:[topupAmountShowStr rangeOfString:addStr]];
    [topupAmountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@".SFUIDisplay-Semibold" size:14] range:[topupAmountShowStr rangeOfString:qgasStr]];
    [topupAmountAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x1E1E24) range:NSMakeRange(0, topupAmountShowStr.length)];
    _topupAmountLab.attributedText = topupAmountAtt;
//    _topupAmountLab.text = [NSString stringWithFormat:@"%@%@+%@%@",faitNum,kLang(@"rmb"),qgasNum,qgasStr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
