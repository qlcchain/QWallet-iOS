//
//  LoginInputPWViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ETHExportKeystorePWViewController.h"
#import "LoginPWModel.h"
#import "QlinkTabbarViewController.h"
#import "ConfigUtil.h"
#import "ETHExportKeystoreViewController.h"

@interface ETHExportKeystorePWViewController ()

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIView *passwrodBack;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;
@property (weak, nonatomic) IBOutlet UIView *confirmPasswrodBack;
@property (weak, nonatomic) IBOutlet UITextField *confirmPWTF;
//@property (weak, nonatomic) IBOutlet UIButton *fingerprintBtn;

@end

@implementation ETHExportKeystorePWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self renderView];
    [self configInit];
}

#pragma mark - Operation
- (void)renderView {
    [_confirmBtn cornerRadius:6];
    
    UIColor *cornerColor = UIColorFromRGB(0xE8EAEC);
    [_passwrodBack cornerRadius:6 strokeSize:1 color:cornerColor];
    [_confirmPasswrodBack cornerRadius:6 strokeSize:1 color:cornerColor];
    _confirmBtn.theme_backgroundColor = globalBackgroundColorPicker;
}

- (void)configInit {
//    [_joinBtn setBackgroundColor:UIColorFromRGB(0xD5D8DD)];
//    _joinBtn.userInteractionEnabled = NO;
//    [_pwTF addTarget:self action:@selector(textFieldDidEnd) forControlEvents:UIControlEventEditingDidEnd];
//    _fingerprintBtn.hidden = ![ConfigUtil getLocalTouch];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmAction:(id)sender {
    [self.view endEditing:YES];
//    if (!_pwTF.text || _pwTF.text.length <= 0) {
//        [kAppD.window makeToastDisappearWithText:@"please Enter Password"];
//        return;
//    }
//    if (!_confirmPWTF.text || _confirmPWTF.text.length <= 0) {
//        [kAppD.window makeToastDisappearWithText:@"please Confirm Password"];
//        return;
//    }
    if (![_confirmPWTF.text?:@"" isEqualToString:_pwTF.text?:@""]) {
        [kAppD.window makeToastDisappearWithText:@"The passwords are different"];
        return;
    }
    
    [self jumpToETHExportKeystore];
}


#pragma mark - Transition
- (void)jumpToETHExportKeystore {
    ETHExportKeystoreViewController *vc = [[ETHExportKeystoreViewController alloc] init];
    vc.inputPW = _pwTF.text?:@"";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
