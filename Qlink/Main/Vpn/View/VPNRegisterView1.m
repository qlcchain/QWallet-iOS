//
//  VPNRegisterView1.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/8.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VPNRegisterView1.h"
#import "VPNRegisterViewController.h"
#import "UnderlineView.h"
#import "SelectCountryModel.h"

#define ChooseCountry @"Choose a country"

@interface VPNRegisterView1 () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UnderlineView *vpnNameUnderlineV;
@property (weak, nonatomic) IBOutlet UILabel *countryLab;
@property (weak, nonatomic) IBOutlet UITextField *vpnNameTF;
@property (weak, nonatomic) IBOutlet UITextField *depositTF;
@property (weak, nonatomic) IBOutlet UnderlineView *depositUnderlineV;
@property (weak, nonatomic) IBOutlet UITextField *claimTF;
@property (weak, nonatomic) IBOutlet UnderlineView *claimUnderlineV;
@property (nonatomic, strong) NSString *deposit;
@property (nonatomic, strong) NSString *claim;

@end

@implementation VPNRegisterView1

- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCountryNoti:) name:SELECT_COUNTRY_NOTI_VPNREGISTER object:nil];
}

+ (VPNRegisterView1 *)getNibView {
    VPNRegisterView1 *nibView = [[[NSBundle mainBundle] loadNibNamed:@"VPNRegisterView1" owner:self options:nil] firstObject];
//    [nibView layoutIfNeeded];
    [nibView addObserve];
    [nibView configVPNView];
    
    return nibView;
}

- (void)configVPNView {
    _vpnNameUnderlineV.textField = _vpnNameTF;
    _depositUnderlineV.textField = _depositTF;
    _claimUnderlineV.textField = _claimTF;
    _claimTF.userInteractionEnabled = NO;
    
    [_vpnNameTF addTarget:self action:@selector(vpnNameEndEdit) forControlEvents:UIControlEventEditingDidEnd];
}

- (void) configView
{
    
}

- (BOOL)isEmptyOfCountry {
    BOOL empty = NO;
    if (self.selectCountry == nil || [self.selectCountry isEmptyString]) {
        empty = YES;
    }
    return empty;
}

- (BOOL)isEmptyOfDeposit {
    BOOL empty = NO;
    if (self.depositTF.text == nil || self.depositTF.text.length <= 0) {
        empty = YES;
    }
    return empty;
}

- (BOOL)isEmptyOfClaim {
    BOOL empty = NO;
    if (self.claimTF.text == nil || self.claimTF.text.length <= 0) {
        empty = YES;
    }
    return empty;
}

- (BOOL)isEmptyOfVPNName {
    BOOL empty = NO;
    if (self.vpnNameTF.text == nil || self.vpnNameTF.text.length <= 0) {
        empty = YES;
    }
    return empty;
}

- (void)setClaimText:(NSString *)text {
    _claimTF.text = text;
}

- (void)vpnNameEndEdit {
    _vpnName = _vpnNameTF.text;
    [_registerVC validateAssetIsexist];
}

- (void)enableClaim {
    _claimTF.userInteractionEnabled = YES;
    [_claimTF becomeFirstResponder];
}

- (void)unableClaim {
    _claimTF.text = nil;
    _claimTF.userInteractionEnabled = NO;
    [_claimTF resignFirstResponder];
}

#pragma mark - Action
- (IBAction)chooseCountryAction:(id)sender {
    [_registerVC jumpToChooseContinent];
}

#pragma mark - Noti
- (void)selectCountryNoti:(NSNotification *)noti {
    SelectCountryModel *selelctM = noti.object;
    _selectCountryM = selelctM;
    _countryLab.text = _selectCountryM.country.uppercaseString;
    _selectCountry = _selectCountryM.country;
}

#pragma mark - UITextField delegate
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == _depositTF) {
        if (AppD.balanceInfo) {
            if ([textField.text floatValue] > [AppD.balanceInfo.qlc floatValue]) {
                textField.text = AppD.balanceInfo.qlc;
            }
        }
    }
}

//textField.text 输入之前的值 string 输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _depositTF) {
        BOOL isHaveDian = YES;
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {
            isHaveDian = NO;
        }
        if (string.length >0) {
            if (textField.text.length == 0) {
                if([string isEqualToString:@"."]) {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            // 当第一个为0时  第二个必须为点
            if (textField.text.length == 1 && [textField.text isEqualToString:@"0"]) {
                if (![string isEqualToString:@"."]) {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            if ([string isEqualToString:@"."]) {
                if (!isHaveDian) { // 还没有点
                    isHaveDian = YES;
                    return YES;
                } else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            } else {
                if (isHaveDian) {//存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        return NO;
                    }
                } else {
                    return YES;
                }
            }
        }
    }
    return YES;
}

#pragma mark - Lazy
- (NSString *)vpnName {
    _vpnName = _vpnNameTF.text?:@"";
    return _vpnName;
}

//- (void)setVpnName:(NSString *)vpnName {
//    self.vpnName
//}

- (NSString *)deposit {
    _deposit = _depositTF.text?:@"";
    return _deposit;
}

- (NSString *)claim {
    _claim = _claimTF.text?:@"";
    return _claim;
}

- (NSString *)selectCountry
{
    _selectCountry = _countryLab.text?:@"";
    if ([_selectCountry isEqualToString:ChooseCountry]) {
        _selectCountry = @"";
    }
    return _selectCountry;
}

- (void) setVPNName:(NSString *) name deposit:(NSString *) seizePrice oldPrice:(NSString *) oldPrice
{
    _vpnNameTF.text = name;
    _vpnNameTF.enabled = NO;
    _depositTF.text = seizePrice;
    _depositTF.enabled = NO;
    _claimTF.text = oldPrice;
}

- (void) setVPNInfo:(VPNInfo *) mode
{
    _vpnNameTF.text = mode.vpnName?:@"";
    _vpnNameTF.enabled = NO;
    _countryLab.text = mode.country?:@"";
    _depositTF.text = mode.qlc?:@"";
    _depositTF.enabled = NO;
}
@end
