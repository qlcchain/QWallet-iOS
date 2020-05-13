//
//  TopupProductSubCell.m
//  Qlink
//
//  Created by Jelly Foo on 2020/2/11.
//  Copyright © 2020 pan. All rights reserved.
//

#import "TopupProductSubCell.h"
#import "GlobalConstants.h"
#import "TopupProductModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+RemoveZero.h"
#import "RLArithmetic.h"
#import "TopupDeductionTokenModel.h"
#import "GroupPeopleView.h"

@interface TopupProductSubCell ()

@property (weak, nonatomic) IBOutlet UIView *discountBack;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *discountLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *originLab;
@property (weak, nonatomic) IBOutlet UILabel *alreadyLab;

@property (weak, nonatomic) IBOutlet UIView *peopleBack;
@property (nonatomic, strong) GroupPeopleView *groupPeopleV;


@end

@implementation TopupProductSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.selectedBackgroundView = kClickEffectImageView;
    
    if (!_groupPeopleV) {
        _groupPeopleV = [GroupPeopleView getInstance];
        [_peopleBack addSubview:_groupPeopleV];
        kWeakSelf(self);
        [_groupPeopleV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(weakself.peopleBack).offset(0);
        }];
    }
    
    _discountBack.layer.cornerRadius = 8;
    _discountBack.layer.masksToBounds = YES;
    _discountBack.layer.borderColor = UIColorFromRGB(0xE84E36).CGColor;
    _discountBack.layer.borderWidth = .5;
    _icon.layer.cornerRadius = 4;
    _icon.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _icon.image = nil;
    _titleLab.text = nil;
    _discountLab.text = nil;
    _priceLab.text = nil;
    _originLab.text = nil;
    _alreadyLab.text = nil;
}

- (void)config:(TopupProductModel *)productM token:(TopupDeductionTokenModel *)tokenM isInGroupBuyActivityTime:(BOOL)isInGroupBuyActivityTime groupBuyMinimumDiscount:(NSString *)groupBuyMinimumDiscount {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],productM.imgPath]];
    [_icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"topup_guangdong_mobile"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    BOOL supportGroupBuy = NO;
    if ([productM.payWay isEqualToString:@"FIAT"]) { // 法币支付
        if ([productM.payFiat isEqualToString:@"CNY"]) {

        } else if ([productM.payFiat isEqualToString:@"USD"]) {

        }
    } else if ([productM.payWay isEqualToString:@"TOKEN"]) { // 代币支付
        if (isInGroupBuyActivityTime) {
//            if ([productM.haveGroupBuy isEqualToString:@"yes"]) {
                supportGroupBuy = YES;
//            }
        }
    }
    
    NSString *language = [Language currentLanguageCode];
    NSString *countryStr = @"";
    NSString *provinceStr = @"";
    NSString *ispStr = @"";
    NSString *nameStr = @"";
    NSString *explainStr = @"";
    NSString *discountNumStr = @"0";
    NSString *discountShowStr = @"";
    NSString *alreadyStr = @"";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        countryStr = productM.countryEn;
        provinceStr = productM.provinceEn;
        ispStr = productM.ispEn;
        nameStr = productM.nameEn;
        explainStr = productM.explainEn;
        if (supportGroupBuy) {
            discountNumStr = @(100).sub(groupBuyMinimumDiscount.mul(@(100)));
            discountShowStr = [NSString stringWithFormat:@"Up to %@%% off",discountNumStr];
            alreadyStr = [NSString stringWithFormat:@"%@ open",productM.orderTimes];
        } else {
            discountNumStr = @(100).sub(productM.discount.mul(@(100)));
            discountShowStr = [NSString stringWithFormat:@"Limited offering of %@%% off dicount",discountNumStr];
            alreadyStr = [NSString stringWithFormat:@"%@ sold",productM.orderTimes];
        }
        
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        countryStr = productM.country;
        provinceStr = productM.province;
        ispStr = productM.isp;
        nameStr = productM.name;
        explainStr = productM.explain;
        
        if (supportGroupBuy) {
            discountNumStr = groupBuyMinimumDiscount.mul(@(10));
            discountShowStr = [NSString stringWithFormat:@"团购低至%@折",discountNumStr];
            alreadyStr = [NSString stringWithFormat:@"已拼%@+件",productM.orderTimes];
        } else {
            discountNumStr = productM.discount.mul(@(10));
            discountShowStr = [NSString stringWithFormat:@"限时优惠%@折",discountNumStr];
            alreadyStr = [NSString stringWithFormat:@"已售%@+件",productM.orderTimes];
        }
    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
        countryStr = productM.countryEn;
        provinceStr = productM.provinceEn;
        ispStr = productM.ispEn;
        nameStr = productM.nameEn;
        explainStr = productM.explainEn;
        
        if (supportGroupBuy) {
            discountNumStr = @(100).sub(groupBuyMinimumDiscount.mul(@(100)));
            discountShowStr = [NSString stringWithFormat:@"Up to %@%% off",discountNumStr];
            alreadyStr = [NSString stringWithFormat:@"%@ open",productM.orderTimes];
        } else {
            discountNumStr = @(100).sub(productM.discount.mul(@(100)));
            discountShowStr = [NSString stringWithFormat:@"Limited offering of %@%% off dicount",discountNumStr];
            alreadyStr = [NSString stringWithFormat:@"%@ sold",productM.orderTimes];
        }
        
    }
    
    NSString *localFiatStr = productM.localFiat?:@"";
    NSString *localAmountShowStr  = [NSString stringWithFormat:@"%@ %@",productM.localFiatAmount,localFiatStr];
    NSString *amountShowStr  = localAmountShowStr;
    if (supportGroupBuy) {
        NSString *fait1Str = productM.discount.mul(productM.payFiatAmount);
//        NSString *deduction1Str = productM.payFiatAmount.mul(productM.qgasDiscount);
        NSString *payTokenSymbol = productM.payTokenSymbol?:@"";
        NSNumber *payTokenPrice = [productM.payFiat isEqualToString:@"CNY"]?productM.payTokenCnyPrice:[productM.payFiat isEqualToString:@"USD"]?productM.payTokenUsdPrice:@(0);
//        NSString *payAmountStr = [fait1Str.sub(deduction1Str).div(payTokenPrice) showfloatStr:3];
        NSString *payAmountStr = [fait1Str.div(payTokenPrice) showfloatStr:3];
        amountShowStr = [NSString stringWithFormat:@"%@ %@",payAmountStr,payTokenSymbol];
    }
    //中划线
    NSDictionary *amountAttribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *amountAttribtStr = [[NSMutableAttributedString alloc]initWithString:amountShowStr attributes:amountAttribtDic];
    _originLab.attributedText = amountAttribtStr;
    
//    NSString *desStr = [NSString stringWithFormat:@"%@%@%@",countryStr,provinceStr,ispStr];
    NSString *titleShowStr = [NSString stringWithFormat:@"%@ %@ %@\n%@",countryStr,ispStr,localAmountShowStr,explainStr];
    NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:titleShowStr];
    [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, titleShowStr.length)];
    [titleAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x2B2B2B) range:NSMakeRange(0, titleShowStr.length)];
    [titleAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xF32A40) range:[titleShowStr rangeOfString:countryStr]];
    _titleLab.attributedText = titleAtt;
    
    _discountLab.text = discountShowStr;
    _alreadyLab.text = alreadyStr;

    NSString *discount = [NSString stringWithFormat:@"%@",productM.discount];
    NSString *fait1Str = discount.mul(productM.payFiatAmount);
    NSString *faitMoneyStr = [discount.mul(productM.payFiatAmount) showfloatStr:4];
    NSString *deduction1Str = productM.payFiatAmount.mul(productM.qgasDiscount);
    NSNumber *deductionTokenPrice = @(1);
    if ([productM.payFiat isEqualToString:@"CNY"]) {
        deductionTokenPrice = tokenM.price;
    } else if ([productM.payFiat isEqualToString:@"USD"]) {
        deductionTokenPrice = tokenM.usdPrice;
    }
    NSString *deductionAmountStr = [productM.payFiatAmount.mul(productM.qgasDiscount).div(deductionTokenPrice) showfloatStr:3];
    NSString *deductionSymbolStr = tokenM.symbol;
    NSString *addStr = @"+";
    NSString *topupAmountShowStr = @"";
    NSString *payTokenSymbol = @"";
    if ([productM.payWay isEqualToString:@"FIAT"]) {
        payTokenSymbol = localFiatStr;
        topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",faitMoneyStr,payTokenSymbol,addStr,deductionAmountStr,deductionSymbolStr];
    } else if ([productM.payWay isEqualToString:@"TOKEN"]) {
        if (supportGroupBuy) {
            topupAmountShowStr = [TopupProductModel getAmountShow:productM tokenM:tokenM groupDiscount:groupBuyMinimumDiscount];
        } else {
            payTokenSymbol = productM.payTokenSymbol?:@"";
            NSNumber *payTokenPrice = [productM.payFiat isEqualToString:@"CNY"]?productM.payTokenCnyPrice:[productM.payFiat isEqualToString:@"USD"]?productM.payTokenUsdPrice:@(0);
            NSString *payAmountStr = [fait1Str.sub(deduction1Str).div(payTokenPrice) showfloatStr:3];
            topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",payAmountStr,payTokenSymbol,addStr,deductionAmountStr,deductionSymbolStr];
        }
    }
    _priceLab.text = topupAmountShowStr;
    
    if ([productM.haveGroupBuy isEqualToString:@"yes"] && productM.items && [productM.items isKindOfClass:[NSArray class]]) {
        _peopleBack.hidden = NO;
        [_groupPeopleV configAssemble:productM.items];
    } else {
        _peopleBack.hidden = YES;
    }
    
}

@end
