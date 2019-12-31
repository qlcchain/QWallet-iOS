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
#import "TopupDeductionTokenModel.h"
#import "RLArithmetic.h"
#import "NSString+RemoveZero.h"


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

- (void)config:(TopupProductModel *)productM token:(TopupDeductionTokenModel *)tokenM {
    NSString *language = [Language currentLanguageCode];
    NSString *country = @"";
    NSString *province = @"";
    NSString *isp = @"";
    NSString *name = @"";
    NSString *explain = @"";
    NSString *des = @"";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        country = productM.countryEn;
        province = productM.provinceEn;
        isp = productM.ispEn;
        name = productM.nameEn;
        explain = productM.explainEn;
        des = productM.descriptionEn;
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        country = productM.country;
        province = productM.province;
        isp = productM.isp;
        name = productM.name;
        explain = productM.explain;
        des = productM.Description;
    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
        country = productM.countryEn;
        province = productM.provinceEn;
        isp = productM.ispEn;
        name = productM.nameEn;
        explain = productM.explainEn;
        des = productM.descriptionEn;
    }
    _titleLab.text = [NSString stringWithFormat:@"%@%@%@",country,province,isp];
    _subTitleLab.text = name;
    _explainLab.text = explain;
    _desLab.text = des;
    
//    NSString *rmbStr = kLang(@"rmb");
//    NSString *amountShowStr = @"";
//    if ([language isEqualToString:LanguageCode[0]]) { // 英文
//        amountShowStr = [NSString stringWithFormat:@"%@%@",kLang(@"rmb"),productM.amount];
//    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
//        amountShowStr = [NSString stringWithFormat:@"%@%@",productM.amount,kLang(@"rmb")];
//    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
//        amountShowStr = [NSString stringWithFormat:@"%@%@",kLang(@"rmb"),productM.amount];
//    }
//    NSString *amountLabFontName = _amountLab.font.fontName;
//    NSMutableAttributedString *amountAtt = [[NSMutableAttributedString alloc] initWithString:amountShowStr];
//    // .SFUIDisplay-Semibold  .SFUI-Semibold
//    [amountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:amountLabFontName size:20] range:NSMakeRange(0, amountShowStr.length)];
//    [amountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:amountLabFontName size:14] range:[amountShowStr rangeOfString:rmbStr]];
//    [amountAtt addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, amountShowStr.length)];
//    _amountLab.attributedText = amountAtt;
//
//    NSString *faitMoneyStr = [productM.discount.mul(productM.amount) showfloatStr:4];
//    NSString *deductionAmountStr = [productM.amount.mul(productM.qgasDiscount).div(tokenM.price) showfloatStr:3];
//
//    NSString *symbolStr = tokenM.symbol;
//    NSString *addStr = @"+";
//    NSString *topupAmountShowStr = @"";
//    if ([language isEqualToString:LanguageCode[0]]) { // 英文
//        topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",kLang(@"rmb"),faitMoneyStr,addStr,deductionAmountStr,symbolStr];
//    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
//        topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",faitMoneyStr,kLang(@"rmb"),addStr,deductionAmountStr,symbolStr];
//    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
//        topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",kLang(@"rmb"),faitMoneyStr,addStr,deductionAmountStr,symbolStr];
//    }
//
//    NSString *topupAmountLabFontName = _topupAmountLab.font.fontName;
//    NSMutableAttributedString *topupAmountAtt = [[NSMutableAttributedString alloc] initWithString:topupAmountShowStr];
//    // .SFUIDisplay-Semibold  .SFUI-Semibold
//    [topupAmountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:topupAmountLabFontName size:16] range:NSMakeRange(0, topupAmountShowStr.length)];
//    [topupAmountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:topupAmountLabFontName size:12] range:[topupAmountShowStr rangeOfString:rmbStr]];
//    [topupAmountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:topupAmountLabFontName size:12] range:[topupAmountShowStr rangeOfString:addStr]];
//    [topupAmountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:topupAmountLabFontName size:12] range:[topupAmountShowStr rangeOfString:symbolStr]];
//    [topupAmountAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x1E1E24) range:NSMakeRange(0, topupAmountShowStr.length)];
//    _topupAmountLab.attributedText = topupAmountAtt;
    
//    抵扣币金额     =    原价*抵扣币折扣
//    抵扣币数量     =    抵扣币金额/抵扣币价格
//    支付法币金额  =    原价*产品折扣
//    支付代币金额  =    支付法币金额-抵扣币金额
//    支付代币数量  =    支付代币金额/支付代币价格
    
    NSString *rmbStr = productM.localFiat?:@"";
    NSString *amountShowStr  = [NSString stringWithFormat:@"%@ %@",productM.localFaitMoney,rmbStr];
    NSString *amountLabFontName = _amountLab.font.fontName;
    NSMutableAttributedString *amountAtt = [[NSMutableAttributedString alloc] initWithString:amountShowStr];
    // .SFUIDisplay-Semibold  .SFUI-Semibold
    [amountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:amountLabFontName size:20] range:NSMakeRange(0, amountShowStr.length)];
    [amountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:amountLabFontName size:14] range:[amountShowStr rangeOfString:rmbStr]];
    [amountAtt addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, amountShowStr.length)];
    _amountLab.attributedText = amountAtt;
    
    NSString *fait1Str = productM.discount.mul(productM.payTokenMoney);
    NSString *faitMoneyStr = [productM.discount.mul(productM.payTokenMoney) showfloatStr:4];
    NSString *deduction1Str = productM.payTokenMoney.mul(productM.qgasDiscount);
    NSNumber *deductionTokenPrice = @(1);
    if ([productM.payFiat isEqualToString:@"CNY"]) {
        deductionTokenPrice = tokenM.price;
    } else if ([productM.payFiat isEqualToString:@"USD"]) {
        deductionTokenPrice = tokenM.usdPrice;
    }
    NSString *deductionAmountStr = [productM.payTokenMoney.mul(productM.qgasDiscount).div(deductionTokenPrice) showfloatStr:3];
    
    NSString *deductionSymbolStr = tokenM.symbol;
    NSString *addStr = @"+";
    NSString *topupAmountShowStr = @"";
    NSString *payTokenSymbol = @"";
    if ([productM.payWay isEqualToString:@"FIAT"]) {
        payTokenSymbol = rmbStr;
        topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",faitMoneyStr,payTokenSymbol,addStr,deductionAmountStr,deductionSymbolStr];
    } else if ([productM.payWay isEqualToString:@"TOKEN"]) {
        payTokenSymbol = productM.payTokenSymbol?:@"";
        NSNumber *payTokenPrice = [productM.payFiat isEqualToString:@"CNY"]?productM.payTokenCnyPrice:[productM.payFiat isEqualToString:@"USD"]?productM.payTokenUsdPrice:@(0);
        NSString *payAmountStr = [fait1Str.sub(deduction1Str).div(payTokenPrice) showfloatStr:3];
        topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",payAmountStr,payTokenSymbol,addStr,deductionAmountStr,deductionSymbolStr];
    }
    
    NSString *topupAmountLabFontName = _topupAmountLab.font.fontName;
    NSMutableAttributedString *topupAmountAtt = [[NSMutableAttributedString alloc] initWithString:topupAmountShowStr];
    // .SFUIDisplay-Semibold  .SFUI-Semibold
    [topupAmountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:topupAmountLabFontName size:16] range:NSMakeRange(0, topupAmountShowStr.length)];
    [topupAmountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:topupAmountLabFontName size:12] range:[topupAmountShowStr rangeOfString:payTokenSymbol]];
    [topupAmountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:topupAmountLabFontName size:12] range:[topupAmountShowStr rangeOfString:addStr]];
    [topupAmountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:topupAmountLabFontName size:12] range:[topupAmountShowStr rangeOfString:deductionSymbolStr]];
    [topupAmountAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x1E1E24) range:NSMakeRange(0, topupAmountShowStr.length)];
    _topupAmountLab.attributedText = topupAmountAtt;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
