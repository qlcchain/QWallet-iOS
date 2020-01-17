//
//  TopupViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TopupCredentialViewController.h"
#import "MyThemes.h"
#import <SwiftTheme/SwiftTheme-Swift.h>
#import "UIView+Gradient.h"
#import "TopupOrderModel.h"
#import "GlobalConstants.h"
#import "NSString+RemoveZero.h"

@interface TopupCredentialViewController ()

@property (weak, nonatomic) IBOutlet UIView *topGradientBack;
//@property (weak, nonatomic) IBOutlet UILabel *sendLab;
//@property (weak, nonatomic) IBOutlet UILabel *receiveLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *projectLab;
@property (weak, nonatomic) IBOutlet UILabel *txidLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;


@end

@implementation TopupCredentialViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.theme_backgroundColor = globalBackgroundColorPicker;
    
    [self configInit];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_topGradientBack addHorizontalQGradientWithStart:UIColorFromRGB(0x4986EE) end:UIColorFromRGB(0x4752E9) frame:CGRectMake(_topGradientBack.left, _topGradientBack.top, SCREEN_WIDTH, _topGradientBack.height)];
}

#pragma mark - Operation
- (void)configInit {
    NSNumber *faitStr = @(0);
    
    NSString *qgasStr = @"0";
    NSString *symbolStr = @"";
    if (_inputPayType == TopupPayTypeNormal) {
        qgasStr = [NSString stringWithFormat:@"%@",_inputCredentailM.qgasAmount];
        symbolStr = _inputCredentailM.symbol;
    } else if (_inputPayType == TopupPayTypeGroupBuy) {
        qgasStr = [NSString doubleToString:_inputCredentailM.deductionTokenAmount];
        symbolStr = _inputCredentailM.deductionToken;
    }
    
    NSString *addStr = @"+";
    NSString *topupAmountShowStr = @"";
    NSString *projectStr = @"";
    NSString *paySymbolStr = @"";
    NSNumber *localShowStr = @(0);
    NSString *localSymbolStr = @"";
    if ([_inputCredentailM.payWay isEqualToString:@"FIAT"]) { // 法币支付
        if ([_inputCredentailM.payFiat isEqualToString:@"CNY"]) {
            faitStr = _inputCredentailM.discountPrice;
            paySymbolStr = _inputCredentailM.localFiat;
            localShowStr = _inputCredentailM.originalPrice;
            localSymbolStr = _inputCredentailM.localFiat;
        } else if ([_inputCredentailM.payFiat isEqualToString:@"USD"]) {
            
        }
    } else if ([_inputCredentailM.payWay isEqualToString:@"TOKEN"]) { // 代币支付
        faitStr = _inputCredentailM.payTokenAmount_str;
        
        if (_inputPayType == TopupPayTypeNormal) {
            paySymbolStr = _inputCredentailM.payTokenSymbol;
            localShowStr = _inputCredentailM.localFiatMoney;
            localSymbolStr = _inputCredentailM.localFiat;
        } else if (_inputPayType == TopupPayTypeGroupBuy) {
            paySymbolStr = _inputCredentailM.payToken;
            localShowStr = _inputCredentailM.product.localFiatMoney;
            localSymbolStr = _inputCredentailM.product.localFiat;
        }
    }
    topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",faitStr,paySymbolStr,addStr,qgasStr,symbolStr];
    projectStr = [NSString stringWithFormat:kLang(@"top_up__phone_bill__"),localShowStr?:@"" ,localSymbolStr?:@"",_inputCredentailM.phoneNumber?:@""];
    
//    NSString *language = [Language currentLanguageCode];
//    if ([language isEqualToString:LanguageCode[0]]) { // 英文
//        topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",kLang(@"rmb"),faitStr,addStr,qgasStr,symbolStr];
//        projectStr = [NSString stringWithFormat:kLang(@"top_up__phone_bill__"),_inputCredentailM.originalPrice?:@"",_inputCredentailM.phoneNumber?:@""];
//    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
//        topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",faitStr,kLang(@"rmb"),addStr,qgasStr,symbolStr];
//        projectStr = [NSString stringWithFormat:kLang(@"top_up__phone_bill__"),_inputCredentailM.originalPrice?:@"",_inputCredentailM.phoneNumber?:@""];
//    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
//        topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",kLang(@"rmb"),faitStr,addStr,qgasStr,symbolStr];
//        projectStr = [NSString stringWithFormat:kLang(@"top_up__phone_bill__"),_inputCredentailM.originalPrice?:@"",_inputCredentailM.phoneNumber?:@""];
//    }
    
    _amountLab.text = topupAmountShowStr;
    _timeLab.text = _inputCredentailM.orderTime;
    _projectLab.text = projectStr;
    NSString *numStr = @"";
    if (_inputCredentailM.number && _inputCredentailM.number.length > 8) { // 去掉年月日
        numStr = [_inputCredentailM.number substringFromIndex:8];
    }
    _numLab.text = numStr;
    
    if (_inputPayType == TopupPayTypeNormal) {
        _txidLab.text = _inputCredentailM.txid;
    } else if (_inputPayType == TopupPayTypeGroupBuy) {
        _txidLab.text = _inputCredentailM.deductionTokenInTxid;
    }
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)txidAction:(id)sender {
    NSString *str = @"";
    if (_inputPayType == TopupPayTypeNormal) {
        str = [NSString stringWithFormat:@"%@%@",QLC_Transaction_Url,_inputCredentailM.txid?:@""];
    } else if (_inputPayType == TopupPayTypeGroupBuy) {
        str = [NSString stringWithFormat:@"%@%@",QLC_Transaction_Url,_inputCredentailM.deductionTokenInTxid?:@""];
    }
    NSURL *url = [NSURL URLWithString:str];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}


@end
