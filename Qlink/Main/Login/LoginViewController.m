//
//  LoginViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/9.
//  Copyright © 2019 pan. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPWViewController.h"
#import "ChooseAreaCodeViewController.h"
#import "AreaCodeModel.h"
#import "MD5Util.h"
#import "UserModel.h"
#import "NSDate+Category.h"
#import "RSAUtil.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *slideBlockView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aroundScrollWidth;
@property (weak, nonatomic) IBOutlet UIScrollView *aroundScroll;
@property (weak, nonatomic) IBOutlet UIButton *switchToRegisterBtn;
@property (weak, nonatomic) IBOutlet UIButton *switchToLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneAreaCodeWidth; // 58

// 注册
@property (weak, nonatomic) IBOutlet UILabel *areaCodeLab;
@property (weak, nonatomic) IBOutlet UITextField *regPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *regVerifyCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *regVerifyCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *regPWTF;
@property (weak, nonatomic) IBOutlet UITextField *regRepeatPWTF;
@property (weak, nonatomic) IBOutlet UITextField *regInviteCodeTF;
@property (weak, nonatomic) IBOutlet UILabel *regTermLab;

// 登录
@property (weak, nonatomic) IBOutlet UITextField *loginAccountTF;
@property (weak, nonatomic) IBOutlet UITextField *loginPWTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginVerifyBtnWidth; // 100
@property (weak, nonatomic) IBOutlet UIButton *loginVerifyCodeBtn;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self viewInit];
}

#pragma mark - Operation
- (void)viewInit {
    _slideBlockView.layer.cornerRadius = 2;
    _slideBlockView.layer.masksToBounds = YES;
    _registerBtn.layer.cornerRadius = 6;
    _registerBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 6;
    _loginBtn.layer.masksToBounds = YES;
    _aroundScrollWidth.constant = 2*SCREEN_WIDTH;
    _slideBlockView.frame = CGRectMake(0, 66, 80, 4);
    _slideBlockView.centerX = (SCREEN_WIDTH-20-20-20)/2.0/2.0+20;
    _loginVerifyBtnWidth.constant = 0;
    
    _regVerifyCodeBtn.enabled = NO;
    _registerBtn.enabled = NO;
    _loginBtn.enabled = NO;
    
    [_regPhoneTF  addTarget:self action:@selector(regTFChange:) forControlEvents:UIControlEventEditingChanged];
    [_regVerifyCodeTF addTarget:self action:@selector(regTFChange:) forControlEvents:UIControlEventEditingChanged];
    [_regPWTF addTarget:self action:@selector(regTFChange:) forControlEvents:UIControlEventEditingChanged];
    [_regRepeatPWTF addTarget:self action:@selector(regTFChange:) forControlEvents:UIControlEventEditingChanged];
    [_loginAccountTF addTarget:self action:@selector(loginTFChange:) forControlEvents:UIControlEventEditingChanged];
    [_loginPWTF addTarget:self action:@selector(loginTFChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)scrollSliderBlock:(UIButton *)sender {
    kWeakSelf(self)
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakself.slideBlockView.centerX = sender.centerX;
    } completion:^(BOOL finished) {
    }];
}

- (void)regTFChange:(UITextField *)tf {
    if (tf == _regPhoneTF) {
        // 更改获取注册验证码按钮状态
        if (tf.text && tf.text.length > 0) {
            _regVerifyCodeBtn.enabled = YES;
            [_regVerifyCodeBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
        } else {
            _regVerifyCodeBtn.enabled = NO;
            [_regVerifyCodeBtn setTitleColor:UIColorFromRGB(0xB3B3B3) forState:UIControlStateNormal];
        }
        [self changeRegisterBtnState];
    } else if (tf == _regVerifyCodeTF) {
        [self changeRegisterBtnState];
    } else if (tf == _regPWTF) {
        [self changeRegisterBtnState];
    } else if (tf == _regRepeatPWTF) {
        [self changeRegisterBtnState];
    }
}

- (void)loginTFChange:(UITextField *)tf {
    if (tf == _loginAccountTF) {
        // 更改获取登录验证码按钮状态
        if (tf.text && tf.text.length > 0) {
            _loginVerifyCodeBtn.enabled = YES;
            [_loginVerifyCodeBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
        } else {
            _loginVerifyCodeBtn.enabled = NO;
            [_loginVerifyCodeBtn setTitleColor:UIColorFromRGB(0xB3B3B3) forState:UIControlStateNormal];
        }
        
        UserModel *userM = [UserModel fetchUser:tf.text?:@""];
        if (!userM) { // 本地没有rsaPublicKey 验证码登录
            _loginVerifyBtnWidth.constant = 100;
            _loginPWTF.placeholder = @"验证码";
            _loginPWTF.secureTextEntry = NO;
        } else { // 密码登录
            _loginVerifyBtnWidth.constant = 0;
            _loginPWTF.placeholder = @"密码";
            _loginPWTF.secureTextEntry = YES;
        }
        
        [self changeLoginBtnState];
    } else if (tf == _loginPWTF) {
        [self changeLoginBtnState];
    }
}

- (void)changeRegisterBtnState {
    if (_regPhoneTF.text && _regPhoneTF.text.length > 0 && _regVerifyCodeTF.text && _regVerifyCodeTF.text.length > 0 && _regPWTF.text && _regPWTF.text.length >= 6 && _regRepeatPWTF.text && _regRepeatPWTF.text.length >= 6) {
        _registerBtn.enabled = YES;
    } else {
        _registerBtn.enabled = NO;
    }
}

- (void)changeLoginBtnState {
    if (_loginPWTF.text && _loginPWTF.text.length >= 6 && _loginAccountTF.text && _loginAccountTF.text.length > 0) {
        _loginBtn.enabled = YES;
    } else {
        _loginBtn.enabled = NO;
    }
}

- (void)switchToLogin {
    [self switchToLoginAction:_switchToLoginBtn];
    [self loginTFChange:_loginAccountTF];
}

#pragma mark - Action
- (IBAction)backAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)switchToRegisterAction:(UIButton *)sender {
    [self scrollSliderBlock:sender];
    [_aroundScroll scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, _aroundScroll.height) animated:YES];
    [_switchToRegisterBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    [_switchToLoginBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
}

- (IBAction)switchToLoginAction:(UIButton *)sender {
    [self scrollSliderBlock:sender];
    [_aroundScroll scrollRectToVisible:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, _aroundScroll.height) animated:YES];
    [_switchToRegisterBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [_switchToLoginBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
}

- (IBAction)registerAction:(id)sender {
    if (![_regPWTF.text isEqualToString:_regRepeatPWTF.text]) {
        [kAppD.window makeToastDisappearWithText:@"两次输入的密码不同"];
        return;
    }
    [self requestSign_up];
}

- (IBAction)loginVerifyCodeAction:(id)sender {
    [self requestVcode_signin_code];
}


- (IBAction)loginAction:(id)sender {
    UserModel *userM = [UserModel fetchUser:_loginAccountTF.text?:@""];
    if (!userM) { // 本地没有rsaPublicKey 验证码登录
        [self requestUser_signin_code];
    } else { // 密码登录
        [self requestSign_in];
    }
    
}

- (IBAction)mailRegisterAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _phoneAreaCodeWidth.constant = 0;
        _regPhoneTF.placeholder = @"邮箱";
        [sender setTitle:@"手机注册" forState:UIControlStateNormal];
    } else {
        _phoneAreaCodeWidth.constant = 58;
        _regPhoneTF.placeholder = @"手机号";
        [sender setTitle:@"邮箱注册" forState:UIControlStateNormal];
    }
}

- (IBAction)forgetPWAction:(id)sender {
    [self jumpToForgetPW];
}

// 获取注册验证码
- (IBAction)regVerifyCodeAction:(id)sender {
    [self requestSignup_code];
}

- (IBAction)areaCodeAction:(id)sender {
    [self jumpToChooseAreaCode];
}

#pragma mark - Request
// 获取注册验证码
- (void)requestSignup_code {
//    kWeakSelf(self);
    NSDictionary *params = @{@"account":_regPhoneTF.text?:@""};
    [RequestService requestWithUrl:signup_code_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:@"获取验证码成功"];
        } else {
            [kAppD.window makeToastDisappearWithText:@"获取验证码失败"];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

// 注册
- (void)requestSign_up {
    kWeakSelf(self);
    NSString *account = _regPhoneTF.text?:@"";
    NSString *md5PW = [MD5Util md5:_regPWTF.text?:@""];
    NSDictionary *params = @{@"account":account,@"password":md5PW,@"code":_regVerifyCodeTF.text?:@"",@"number":_regInviteCodeTF.text?:@"",@"p2pId":[UserModel getOwnP2PId]};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:sign_up_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
//            NSString *rsaPublicKey = responseObject[Server_Data]?:@"";
            UserModel *model = [UserModel getObjectWithKeyValues:responseObject];
//            model.account = account;
            model.md5PW = md5PW;
//            model.rsaPublicKey = rsaPublicKey;
            model.isLogin = @(NO);
            [UserModel storeUser:model];
            
            // 滑动到登录页
            [weakself switchToLogin];
            weakself.loginAccountTF.text = model.account;
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

// 密码登录
- (void)requestSign_in {
    NSString *account = _loginAccountTF.text?:@"";
    UserModel *userM = [UserModel fetchUser:account];
    kWeakSelf(self);
    NSString *md5PW = [MD5Util md5:_loginPWTF.text?:@""];
    NSString *timestamp = [NSString stringWithFormat:@"%@",@([NSDate getTimestampFromDate:[NSDate date]])];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSDictionary *params = @{@"account":account,@"token":token};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:sign_in_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
//            NSString *rsaPublicKey = responseObject[Server_Data]?:@"";
//            UserModel *model = [UserModel getObjectWithKeyValues:responseObject];
//            userM.account = account;
            userM.md5PW = md5PW;
//            userM.rsaPublicKey = rsaPublicKey;
            userM.isLogin = @(YES);
            [UserModel storeUser:userM];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:User_Login_Success_Noti object:nil];
            [weakself backAction:nil];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

// 获取登录验证码
- (void)requestVcode_signin_code {
    //    kWeakSelf(self);
    NSDictionary *params = @{@"account":_loginAccountTF.text?:@""};
    [RequestService requestWithUrl:vcode_signin_code_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:@"获取验证码成功"];
        } else {
            [kAppD.window makeToastDisappearWithText:@"获取验证码失败"];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

// 验证码登录
- (void)requestUser_signin_code {
    kWeakSelf(self);
    NSString *account = _loginAccountTF.text?:@"";
    NSString *code = _loginPWTF.text?:@"";
    NSDictionary *params = @{@"account":account,@"code":code};
    [RequestService requestWithUrl:user_signin_code_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
//            NSString *rsaPublicKey = responseObject[Server_Data]?:@"";
            UserModel *model = [UserModel getObjectWithKeyValues:responseObject];
//            model.account = account;
//            model.md5PW = md5PW;
//            model.rsaPublicKey = rsaPublicKey;
            model.isLogin = @(YES);
            [UserModel storeUser:model];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:User_Login_Success_Noti object:nil];
            [weakself backAction:nil];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - Transition
- (void)jumpToForgetPW {
    ForgetPWViewController *vc = [ForgetPWViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

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
