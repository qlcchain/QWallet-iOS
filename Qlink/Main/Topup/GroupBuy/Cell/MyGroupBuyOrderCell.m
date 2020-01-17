//
//  MyTopupOrderCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MyGroupBuyOrderCell.h"
#import "UIView+Visuals.h"
#import "GlobalConstants.h"
#import "TopupOrderModel.h"
#import "NSString+RemoveZero.h"
#import "NSDate+Category.h"
#import "RLArithmetic.h"

@interface MyGroupBuyOrderCell ()

@property (nonatomic, copy) MyTopupOrderCancelBlock orderCancelB;
@property (nonatomic, copy) MyTopupOrderPayBlock orderPayB;
@property (nonatomic, copy) MyTopupOrderCredentialBlock orderCredentialB;
@property (nonatomic, copy) MyTopupOrderCredentialDetalBlock orderCredentialDetailB;

@end

@implementation MyGroupBuyOrderCell

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
//    _discountAmountLab.text = nil;
    _qgasAmountLab.text = nil;
}

+ (BOOL)blockchainInvoiceExist:(NSString *)invoice {
    if (invoice == nil || [invoice isEmptyString]) {
        return NO;
    }
    return YES;
}

+ (CGFloat)cellHeight:(TopupOrderModel *)model {
    CGFloat detail_const = 48;
    CGFloat invoice_const = 48;
    CGFloat pay_const = 48;
    CGFloat cardSerial_const = 30;
    CGFloat cardPW_const = 30;
    CGFloat cardPin_const = 30;
    CGFloat expiryDate_const = 30;
    CGFloat otherHeight = 453-detail_const-invoice_const-pay_const-cardSerial_const-cardPW_const-cardPin_const-expiryDate_const;
    
    CGFloat detailHeight = [model.status isEqualToString:Topup_Order_Status_SUCCESS]?detail_const:0;
    CGFloat invoiceHeight = [MyGroupBuyOrderCell blockchainInvoiceExist:model.deductionTokenInTxid]?detail_const:0;
    CGFloat payHeight = 0;
//    if ([model.payWay isEqualToString:@"FIAT"]) { // 法币支付
//        if ([model.payFiat isEqualToString:@"CNY"]) {
//            payHeight = [model.status isEqualToString:Topup_Order_Status_QGAS_PAID]?pay_const:0;
//        } else if ([model.payFiat isEqualToString:@"USD"]) {
//
//        }
//    } else if ([model.payWay isEqualToString:@"TOKEN"]) { // 代币支付
        payHeight = 0;
        if (model.deductionTokenInTxid == nil || [model.deductionTokenInTxid isEmptyString]) {
            if ([model.status isEqualToString:Topup_Order_Status_New]) {
                payHeight = pay_const;
            }
        } else {
            if (model.payTokenInTxid == nil || [model.payTokenInTxid isEmptyString]) {
                if ([model.status isEqualToString:Topup_Order_Status_DEDUCTION_TOKEN_PAID]) {
                    payHeight = pay_const;
                }
            }
        }
//    }
    
    CGFloat cardSerialHeight = (model.serialno && ![model.serialno isEmptyString])?cardSerial_const:0;
    CGFloat cardPWHeight = (model.passwd && ![model.passwd isEmptyString])?cardPW_const:0;
    CGFloat cardPinHeight = (model.pin && ![model.pin isEmptyString])?cardPin_const:0;
    CGFloat expiryDateHeight = (model.expiredtime && ![model.expiredtime isEmptyString])?expiryDate_const:0;
    
    return otherHeight+detailHeight+payHeight+invoiceHeight+cardSerialHeight+cardPWHeight+cardPinHeight+expiryDateHeight;
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
    NSString *claimStr = @"";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        country = model.product.countryEn;
        province = model.product.provinceEn;
        isp = model.product.ispEn;
        name = model.product.productNameEn;
        claimStr = @"icon_background_reim_en";
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        country = model.product.country;
        province = model.product.province;
        isp = model.product.isp;
        name = model.product.productName;
        claimStr = @"icon_background_reim";
    }
    _titleLab.text = [NSString stringWithFormat:@"%@%@%@-%@",country?:@"",province?:@"",isp?:@"",name?:@""];
    _timeLab.text = [NSDate getOutputDate:model.createDate formatStr:yyyyMMddHHmmss];
    _numLab.text = [NSString stringWithFormat:@"%@%@",model.areaCode?:@"",model.phoneNumber?:@""];
    _toClaimIcon.image = [UIImage imageNamed:claimStr];
    
    _cardSerialNumberHeight.constant = (model.serialno && ![model.serialno isEmptyString])?30:0;
    _cardPWNumberHeight.constant = (model.passwd && ![model.passwd isEmptyString])?30:0;
    _cardPinNumberHeight.constant = (model.pin && ![model.pin isEmptyString])?30:0;
    _expiryDateHeight.constant = (model.expiredtime && ![model.expiredtime isEmptyString])?30:0;
    _cardSerialNumberLab.text = model.serialno;
    _cardPWNumberLab.text = model.passwd;
    _cardPinNumberLab.text = model.pin;
    _expiryDateLab.text = model.expiredtime;
    
//    if ([model.payWay isEqualToString:@"FIAT"]) { // 法币支付
//        if ([model.payFiat isEqualToString:@"CNY"]) {
//            [self handlerPayCNY:model];
//        } else if ([model.payFiat isEqualToString:@"USD"]) {
//
//        }
//    } else if ([model.payWay isEqualToString:@"TOKEN"]) { // 代币支付
        [self handlerPayToken:model];
//    }
    
    _credentialLab.text = [model.deductionTokenInTxid isEmptyString]?@"":[NSString stringWithFormat:@"%@...%@",[model.deductionTokenInTxid substringToIndex:8],[model.deductionTokenInTxid substringFromIndex:model.deductionTokenInTxid.length-8]];
    _topupStateLab.text = [model getStatusString:TopupPayTypeGroupBuy];
    _topupStateLab.textColor = [model getStatusColor];
    _credentialDetailHeight.constant = [model.status isEqualToString:Topup_Order_Status_SUCCESS]?48:0;
    _blockchainHeight.constant = [MyGroupBuyOrderCell blockchainInvoiceExist:model.deductionTokenInTxid]?48:0;
    
    _cancelBtn.hidden = YES;
//    if ([model.status isEqualToString:Topup_Order_Status_New]) {
//        _cancelBtn.hidden = NO;
//    } else if ([model.status isEqualToString:Topup_Order_Status_DEDUCTION_TOKEN_PAID]) {
//        if (!model.payTokenInTxid || [model.payTokenInTxid isEmptyString]) {
//            _cancelBtn.hidden = NO;
//        }
//    } else if ([model.status isEqualToString:Topup_Order_Status_Pay_TOKEN_PAID]) {
////        _cancelBtn.hidden = NO;
//        _cancelBtn.hidden = YES;
//    }
}

- (void)handlerPayCNY:(TopupOrderModel *)model {
//    NSString *language = [Language currentLanguageCode];
    NSString *discountNumStr = model.originalPrice.sub(model.discountPrice);
    NSString *topupAmountStr = @"";
    NSString *payAmountStr = @"";
    NSString *discountAmountStr = @"";
    
    topupAmountStr = [NSString stringWithFormat:@"%@%@",model.originalPrice?:@"",model.localFiat?:@""];
    payAmountStr = [NSString stringWithFormat:@"%@%@",model.discountPrice,model.localFiat];
    discountAmountStr = [NSString stringWithFormat:@"-%@%@",discountNumStr,model.localFiat];
//    if ([language isEqualToString:LanguageCode[0]]) { // 英文
//        topupAmountStr = [NSString stringWithFormat:@"%@%@",kLang(@"rmb"),model.originalPrice];
//        payAmountStr = [NSString stringWithFormat:@"%@%@",kLang(@"rmb"),model.discountPrice];
//        discountAmountStr = [NSString stringWithFormat:@"-%@%@",kLang(@"rmb"),discountNumStr];
//    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
//        topupAmountStr = [NSString stringWithFormat:@"%@%@",model.originalPrice,kLang(@"rmb")];
//        payAmountStr = [NSString stringWithFormat:@"%@%@",model.discountPrice,kLang(@"rmb")];
//        discountAmountStr = [NSString stringWithFormat:@"-%@%@",discountNumStr,kLang(@"rmb")];
//    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
//        topupAmountStr = [NSString stringWithFormat:@"%@%@",kLang(@"rmb"),model.originalPrice];
//        payAmountStr = [NSString stringWithFormat:@"%@%@",kLang(@"rmb"),model.discountPrice];
//        discountAmountStr = [NSString stringWithFormat:@"-%@%@",kLang(@"rmb"),discountNumStr];
//    }
    _topupAmountLab.text = topupAmountStr;
    _payAmountLab.text = payAmountStr;
    NSString *qgasNum = model.deductionTokenAmount_str;
//    _discountAmountLab.text = discountAmountStr;
    _qgasAmountLab.text = [NSString stringWithFormat:@"%@%@",qgasNum,model.deductionToken?:@""];
    
    _payHeight.constant = [model.status isEqualToString:Topup_Order_Status_DEDUCTION_TOKEN_PAID]?48:0;
}

- (void)handlerPayToken:(TopupOrderModel *)model {
    NSString *topupAmountStr = @"";
    NSString *payAmountStr = @"";
//    NSString *discountAmountStr = @"";
    topupAmountStr = [NSString stringWithFormat:@"%@%@",model.product.localFiatMoney?:@"",model.product.localFiat?:@""];
    payAmountStr = [NSString stringWithFormat:@"%@%@",model.payTokenAmount_str,model.payToken];
//    discountAmountStr = [NSString stringWithFormat:@"-%@%@",discountNumStr,model.symbol];
    NSString *qgasNumStr = [NSString stringWithFormat:@"%@%@",model.deductionTokenAmount_str,model.deductionToken?:@""];
    
    _topupAmountLab.text = topupAmountStr;
    _payAmountLab.text = payAmountStr;
//    _discountAmountLab.text = discountAmountStr;
    _qgasAmountLab.text = qgasNumStr;
    
    _payHeight.constant = 0;
    if (model.deductionTokenInTxid == nil || [model.deductionTokenInTxid isEmptyString]) { // 未支付抵扣币
        if ([model.status isEqualToString:Topup_Order_Status_New]) {
            _payHeight.constant = 48;
        }
    } else {
        if (model.payTokenInTxid == nil || [model.payTokenInTxid isEmptyString]) { // 未支付支付币
            if ([model.status isEqualToString:Topup_Order_Status_DEDUCTION_TOKEN_PAID]) {
                _payHeight.constant = 48;
            }
        }
    }
    
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
