//
//  ForgetPWViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/9.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ForgetPWViewController.h"
#import "ChooseAreaCodeViewController.h"
#import "AreaCodeModel.h"
#import "MD5Util.h"
#import "RSAUtil.h"
#import "UserModel.h"
#import "NSDate+Category.h"

@interface ForgetPWViewController ()

@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *pwNewTF;
@property (weak, nonatomic) IBOutlet UITextField *pwRepeatTF;
@property (weak, nonatomic) IBOutlet UILabel *areaCodeLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneAreaCodeWidth; // 58


@end

@implementation ForgetPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self dataInit];
    [self viewInit];
}

#pragma mark - Operation
- (void)viewInit {
    _confirmBtn.layer.cornerRadius = 6;
    _confirmBtn.layer.masksToBounds = YES;
}

- (void)dataInit {
    _verifyCodeBtn.enabled = NO;
    _confirmBtn.enabled = NO;
    
    [_phoneTF  addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
    [_verifyCodeTF addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
    [_pwNewTF addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
    [_pwRepeatTF addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)tfChange:(UITextField *)tf {
    if (tf == _phoneTF) {
        // 更改获取验证码按钮状态
        if (tf.text && tf.text.length > 0) {
            _verifyCodeBtn.enabled = YES;
            [_verifyCodeBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
        } else {
            _verifyCodeBtn.enabled = NO;
            [_verifyCodeBtn setTitleColor:UIColorFromRGB(0xB3B3B3) forState:UIControlStateNormal];
        }
        [self changeConfirmBtnState];
    } else if (tf == _verifyCodeTF) {
        [self changeConfirmBtnState];
    } else if (tf == _pwNewTF) {
        [self changeConfirmBtnState];
    } else if (tf == _pwRepeatTF) {
        [self changeConfirmBtnState];
    }
}

- (void)changeConfirmBtnState {
    if (_phoneTF.text && _phoneTF.text.length > 0 && _verifyCodeTF.text && _verifyCodeTF.text.length > 0 && _pwNewTF.text && _pwNewTF.text.length >= 6 && _pwRepeatTF.text && _pwRepeatTF.text.length >= 6) {
        _confirmBtn.enabled = YES;
    } else {
        _confirmBtn.enabled = NO;
    }
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmAction:(id)sender {
    if (![_pwNewTF.text isEqualToString:_pwRepeatTF.text]) {
        [kAppD.window makeToastDisappearWithText:@"两次输入的密码不同"];
        return;
    }
    [self requestUser_change_password];
}

- (IBAction)verifyCodeAction:(id)sender {
    [self requestVcode_change_password_code];
}

- (IBAction)mailFindAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _phoneAreaCodeWidth.constant = 0;
        _phoneTF.placeholder = @"邮箱";
        [sender setTitle:@"手机找回" forState:UIControlStateNormal];
    } else {
        _phoneAreaCodeWidth.constant = 58;
        _phoneTF.placeholder = @"手机号";
        [sender setTitle:@"邮箱找回" forState:UIControlStateNormal];
    }
}

- (IBAction)areaCodeAction:(id)sender {
    [self jumpToChooseAreaCode];
}

#pragma mark - Request
- (void)requestVcode_change_password_code {
//    kWeakSelf(self);
    NSDictionary *params = @{@"account":_phoneTF.text?:@""};
    [RequestService requestWithUrl:vcode_change_password_code_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:@"获取验证码成功"];
        } else {
            [kAppD.window makeToastDisappearWithText:@"获取验证码失败"];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestUser_change_password {
    NSString *account = _phoneTF.text?:@"";
    UserModel *userM = [UserModel fetchUser:account];
    if (!userM) {
        return;
    }
    kWeakSelf(self);
    NSString *md5PW = [MD5Util md5:_pwNewTF.text?:@""];
    NSString *timestamp = [NSString stringWithFormat:@"%@",@([NSDate getTimestampFromDate:[NSDate date]])];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSString *code = _verifyCodeTF.text?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"password":md5PW,@"code":code};
    [RequestService requestWithUrl:user_change_password_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            userM.md5PW = md5PW;
            [UserModel storeUser:userM];
            
            [kAppD.window makeToastDisappearWithText:@"修改密码成功"];
            [weakself backAction:nil];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - Transition
- (void)jumpToChooseAreaCode {
    ChooseAreaCodeViewController *vc = [ChooseAreaCodeViewController new];
    kWeakSelf(self)
    vc.chooseB = ^(AreaCodeModel *model) {
        weakself.areaCodeLab.text = [NSString stringWithFormat:@"+%@",@(model.code)];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
