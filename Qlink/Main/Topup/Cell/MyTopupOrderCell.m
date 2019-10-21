//
//  MyTopupOrderCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MyTopupOrderCell.h"
#import "UIView+Visuals.h"
#import "GlobalConstants.h"
#import "TopupOrderModel.h"
#import "NSString+RemoveZero.h"

@interface MyTopupOrderCell ()

@property (nonatomic, copy) MyTopupOrderCancelBlock orderCancelB;
@property (nonatomic, copy) MyTopupOrderPayBlock orderPayB;
@property (nonatomic, copy) MyTopupOrderCredentialBlock orderCredentialB;
@property (nonatomic, copy) MyTopupOrderCredentialDetalBlock orderCredentialDetailB;

@end

@implementation MyTopupOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _contentBack.layer.cornerRadius = 4;
    _contentBack.layer.masksToBounds = YES;
    _payBtn.layer.cornerRadius = 2;
    _payBtn.layer.masksToBounds = YES;
    _payBtn.layer.borderColor = UIColorFromRGB(0xFF3669).CGColor;
    _payBtn.layer.borderWidth = 1;
    _cancelBtn.layer.cornerRadius = 2;
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
    _cancelBtn.layer.borderWidth = 1;
    
    [_contentBack addShadowWithOpacity:1.0 shadowColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:0.5] shadowOffset:CGSizeMake(0,4) shadowRadius:10 andCornerRadius:4];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _titleLab.text = nil;
    _timeLab.text = nil;
    _numLab.text = nil;
    _topupAmountLab.text = nil;
    _payAmountLab.text = nil;
    _topupStateLab.text = nil;
    _discountAmountLab.text = nil;
    _qgasAmountLab.text = nil;
}

+ (CGFloat)cellHeight:(TopupOrderModel *)model {
    CGFloat otherHeight = 333-48-48;
    CGFloat detailHeight = [model.status isEqualToString:Topup_Order_Status_SUCCESS]?48:0;
    CGFloat payHeight = [model.status isEqualToString:Topup_Order_Status_QGAS_PAID]?48:0;
    
    return otherHeight+detailHeight+payHeight;
}

- (void)config:(TopupOrderModel *)model cancelB:(MyTopupOrderCancelBlock)cancelB payB:(MyTopupOrderPayBlock)payB credentialB:(MyTopupOrderCredentialBlock)credentialB credetialDetalB:(MyTopupOrderCredentialDetalBlock)credentialDetailB {
    _orderCancelB = cancelB;
    _orderPayB = payB;
    _orderCredentialB = credentialB;
    _orderCredentialDetailB = credentialDetailB;
    NSString *language = [Language currentLanguageCode];
    NSString *country = @"";
    NSString *province = @"";
    NSString *isp = @"";
    NSString *name = @"";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        country = model.productCountryEn;
        province = model.productProvinceEn;
        isp = model.productIspEn;
        name = model.productNameEn;
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        country = model.productCountry;
        province = model.productProvince;
        isp = model.productIsp;
        name = model.productName;
    }
    _titleLab.text = [NSString stringWithFormat:@"%@%@%@-%@",country,province,isp,name];
    _timeLab.text = model.orderTime;
    _numLab.text = [NSString stringWithFormat:@"%@%@",model.areaCode,model.phoneNumber];
    
//    NSNumber *discountNum = @([model.originalPrice doubleValue] - [model.discountPrice doubleValue]);
    NSString *discountNumStr = [NSString stringFromDouble:[model.originalPrice doubleValue] - [model.discountPrice doubleValue]];
    NSString *topupAmountStr = @"";
    NSString *payAmountStr = @"";
    NSString *discountAmountStr = @"";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        topupAmountStr = [NSString stringWithFormat:@"%@%@",kLang(@"rmb"),model.originalPrice];
        payAmountStr = [NSString stringWithFormat:@"%@%@",kLang(@"rmb"),model.discountPrice];
        discountAmountStr = [NSString stringWithFormat:@"-%@%@",kLang(@"rmb"),discountNumStr];
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        topupAmountStr = [NSString stringWithFormat:@"%@%@",model.originalPrice,kLang(@"rmb")];
        payAmountStr = [NSString stringWithFormat:@"%@%@",model.discountPrice,kLang(@"rmb")];
        discountAmountStr = [NSString stringWithFormat:@"-%@%@",discountNumStr,kLang(@"rmb")];
    }
    _topupAmountLab.text = topupAmountStr;
    _payAmountLab.text = payAmountStr;
    NSNumber *qgasNum = model.qgasAmount;
    _discountAmountLab.text = discountAmountStr;
    _qgasAmountLab.text = [NSString stringWithFormat:@"%@QGAS",qgasNum];
    
    _credentialLab.text = [model.txid isEmptyString]?@"":[NSString stringWithFormat:@"%@...%@",[model.txid substringToIndex:8],[model.txid substringFromIndex:model.txid.length-8]];
    _topupStateLab.text = [model getStatusString];
    _topupStateLab.textColor = [model getStatusColor];
    _credentialDetailHeight.constant = [model.status isEqualToString:Topup_Order_Status_SUCCESS]?48:0;
    _payHeight.constant = [model.status isEqualToString:Topup_Order_Status_QGAS_PAID]?48:0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cancelAction:(id)sender {
    if (_orderCancelB) {
        _orderCancelB();
    }
}

- (IBAction)payAction:(id)sender {
    if (_orderPayB) {
        _orderPayB();
    }
}

- (IBAction)credentialAction:(id)sender {
    if (_orderCredentialB) {
        _orderCredentialB();
    }
}

- (IBAction)credentialDetailAction:(id)sender {
    if (_orderCredentialDetailB) {
        _orderCredentialDetailB();
    }
}



@end
