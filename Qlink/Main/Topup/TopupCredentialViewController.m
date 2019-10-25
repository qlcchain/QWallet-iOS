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
    
    [_topGradientBack addQGradientWithStart:UIColorFromRGB(0x4986EE) end:UIColorFromRGB(0x4752E9) frame:CGRectMake(_topGradientBack.left, _topGradientBack.top, SCREEN_WIDTH, _topGradientBack.height)];
}

#pragma mark - Operation
- (void)configInit {
    NSNumber *faitStr = _inputCredentailM.discountPrice;
    NSNumber *qgasStr = _inputCredentailM.qgasAmount;
    
    NSString *symbolStr = _inputCredentailM.symbol;
    NSString *addStr = @"+";
    NSString *topupAmountShowStr = @"";
    NSString *projectStr = @"";
    NSString *language = [Language currentLanguageCode];
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",kLang(@"rmb"),faitStr,addStr,qgasStr,symbolStr];
        projectStr = [NSString stringWithFormat:@"Top up-%@Phone bill-%@",_inputCredentailM.originalPrice?:@"",_inputCredentailM.phoneNumber?:@""];
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",faitStr,kLang(@"rmb"),addStr,faitStr,symbolStr];
        projectStr = [NSString stringWithFormat:@"话费慢充-%@元手机话费-%@",_inputCredentailM.originalPrice?:@"",_inputCredentailM.phoneNumber?:@""];
    }
    
    _amountLab.text = topupAmountShowStr;
    _timeLab.text = _inputCredentailM.orderTime;
    _projectLab.text = projectStr;
    NSString *numStr = @"";
    if (_inputCredentailM.number && _inputCredentailM.number.length > 8) { // 去掉年月日
        numStr = [_inputCredentailM.number substringFromIndex:8];
    }
    _numLab.text = numStr;
    _txidLab.text = _inputCredentailM.txid;
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)txidAction:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QLC_Transaction_Url,_inputCredentailM.txid?:@""]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}


@end
