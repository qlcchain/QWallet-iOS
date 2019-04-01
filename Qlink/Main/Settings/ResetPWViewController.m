//
//  ResetPWViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/31.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ResetPWViewController.h"
#import "ResetPWSuccessView.h"
#import "NSString+Valid.h"
#import "LoginPWModel.h"

@interface ResetPWViewController ()

@property (weak, nonatomic) IBOutlet UIView *currentPWBack;
@property (weak, nonatomic) IBOutlet UIView *setPWBack;
@property (weak, nonatomic) IBOutlet UIView *repeatPWBack;
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;
@property (weak, nonatomic) IBOutlet UITextField *currentPWTF;
@property (weak, nonatomic) IBOutlet UITextField *setPWTF;
@property (weak, nonatomic) IBOutlet UITextField *repeatPWTF;
@property (weak, nonatomic) IBOutlet UILabel *pwWrongLab;


@end

@implementation ResetPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self renderView];
    [self configInit];
}

#pragma mark - Operation
- (void)renderView {
    [_storeBtn cornerRadius:6];
    
    UIColor *cornerColor = UIColorFromRGB(0xE8EAEC);
    [_currentPWBack cornerRadius:6 strokeSize:1 color:cornerColor];
    [_setPWBack cornerRadius:6 strokeSize:1 color:cornerColor];
    [_repeatPWBack cornerRadius:6 strokeSize:1 color:cornerColor];
}

- (void)configInit {
    _pwWrongLab.text = nil;
    [_storeBtn setBackgroundColor:UIColorFromRGB(0xD5D8DD)];
    _storeBtn.userInteractionEnabled = NO;
    [_currentPWTF addTarget:self action:@selector(textFieldDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    [_setPWTF addTarget:self action:@selector(textFieldDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    [_setPWTF addTarget:self action:@selector(setPWTFDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    [_repeatPWTF addTarget:self action:@selector(textFieldDidEnd) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)setPWTFDidEnd {
    NSString *pw = _setPWTF.text;
    if ([pw containDigital] && [pw containLowercase] && [pw containUppercase]) {
        _pwWrongLab.text = nil;
    } else {
        _pwWrongLab.text = @"A mix of uppercase and lowercase letters, along with at least one symbol.";
        [_storeBtn setBackgroundColor:UIColorFromRGB(0xD5D8DD)];
        _storeBtn.userInteractionEnabled = NO;
    }
}

- (void)textFieldDidEnd {
    if (_currentPWTF.text && _currentPWTF.text.length > 0 && _setPWTF.text && _setPWTF.text.length > 0 && _repeatPWTF.text && _repeatPWTF.text.length > 0) {
        [_storeBtn setBackgroundColor:MAIN_PURPLE_COLOR];
        _storeBtn.userInteractionEnabled = YES;
    } else {
        [_storeBtn setBackgroundColor:UIColorFromRGB(0xD5D8DD)];
        _storeBtn.userInteractionEnabled = NO;
    }
}

- (void)showStoreSuccess {
    [[ResetPWSuccessView getInstance] show];
    kWeakSelf(self);
    [UIView animateWithDuration:2 animations:^{
        [weakself hideStoreSuccess];
    }];
}

- (void)hideStoreSuccess {
    [[ResetPWSuccessView getInstance] hide];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)storeAction:(id)sender {
    NSString *loginPW = [LoginPWModel getLoginPW];
    if (![_currentPWTF.text isEqualToString:loginPW]) {
        [kAppD.window makeToastDisappearWithText:@"Current password is wrong"];
        return;
    }
    
    if (![_currentPWTF.text isEqualToString:loginPW]) {
        [kAppD.window makeToastDisappearWithText:@"Current password is wrong"];
        return;
    }
    
    if (![_setPWTF.text isEqualToString:_repeatPWTF.text]) {
        [kAppD.window makeToastDisappearWithText:@"Repeat password is different from Set password"];
        return;
    }
    
    [LoginPWModel setLoginPW:_setPWTF.text];
    [self showStoreSuccess];
    [self performSelector:@selector(backToRoot) withObject:nil afterDelay:2];
}


@end
