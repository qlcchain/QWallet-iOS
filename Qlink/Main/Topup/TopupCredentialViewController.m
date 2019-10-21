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

@interface TopupCredentialViewController ()

@property (weak, nonatomic) IBOutlet UIView *topGradientBack;
@property (weak, nonatomic) IBOutlet UILabel *sendLab;
@property (weak, nonatomic) IBOutlet UILabel *receiveLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *projectLab;
@property (weak, nonatomic) IBOutlet UILabel *txidLab;


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
//    _sendLab.text = [NSString stringWithFormat:@"%@%@",_inputCredentailM.areaCode,_inputCredentailM.phoneNumber];
    _sendLab.text = _inputCredentailM.phoneNumber;
//    _receiveLab;
    NSString *payAmountStr = [NSString stringWithFormat:@"%@%@",_inputCredentailM.discountPrice,kLang(@"rmb")];
    NSString *qgasAmountStr = [NSString stringWithFormat:@"%@%@",_inputCredentailM.qgasAmount,@"QGAS"];
    _amountLab.text = [NSString stringWithFormat:@"%@+%@",payAmountStr,qgasAmountStr];
    _timeLab.text = _inputCredentailM.orderTime;
//    _projectLab.text;
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
