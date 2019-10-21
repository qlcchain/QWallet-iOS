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
#import "NSString+RegexCategory.h"
#import "RegisterMailViewController.h"
#import "UIColor+Random.h"
//#import "GlobalConstants.h"
#import "FirebaseUtil.h"

@interface LoginViewController ()


@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

// 登录
@property (weak, nonatomic) IBOutlet UITextField *loginAccountTF;
@property (weak, nonatomic) IBOutlet UITextField *loginVerifyCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *loginPWTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginVerifyCodeHeight; // 49
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
    _loginBtn.layer.cornerRadius = 6;
    _loginBtn.layer.masksToBounds = YES;
    
    _loginBtn.enabled = NO;
    _loginBtn.backgroundColor = [UIColor mainColorOfHalf];
    
    [_loginAccountTF addTarget:self action:@selector(loginTFChange:) forControlEvents:UIControlEventEditingChanged];
    [_loginVerifyCodeTF addTarget:self action:@selector(loginTFChange:) forControlEvents:UIControlEventEditingChanged];
    [_loginPWTF addTarget:self action:@selector(loginTFChange:) forControlEvents:UIControlEventEditingChanged];
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
            _loginVerifyCodeHeight.constant = 49;
        } else { // 密码登录
            _loginVerifyCodeHeight.constant = 0;
        }
        
        [self changeLoginBtnState];
    } else if (tf == _loginPWTF) {
        [self changeLoginBtnState];
    } else if (tf == _loginVerifyCodeTF) {
        [self changeLoginBtnState];
    }
}

- (void)changeLoginBtnState {
    if (_loginPWTF.text && _loginPWTF.text.length >= 6 && _loginAccountTF.text && _loginAccountTF.text.length > 0) {
        if (_loginVerifyCodeHeight.constant > 0) {
            if (_loginVerifyCodeTF.text && _loginVerifyCodeTF.text.length > 0) {
                _loginBtn.enabled = YES;
                _loginBtn.backgroundColor = [UIColor mainColor];
            } else {
                _loginBtn.enabled = NO;
                _loginBtn.backgroundColor = [UIColor mainColorOfHalf];
            }
        } else {
            _loginBtn.enabled = YES;
            _loginBtn.backgroundColor = [UIColor mainColor];
        }
    } else {
        _loginBtn.enabled = NO;
        _loginBtn.backgroundColor = [UIColor mainColorOfHalf];
    }
}

- (void)showLastLoginAccount {
    if ([UserModel haveAccountInLocal]) { // 显示最后一次登录的账号
        _loginAccountTF.text = [UserModel getLastLoginAccount];
    }
    [self loginTFChange:_loginAccountTF];
}

// 开启倒计时效果
- (void)openCountdown:(UIButton *)btn {
    NSString *btnTitle = btn.currentTitle;
    __block NSInteger time = 59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [btn setTitle:btnTitle forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                [btn setTitle:[NSString stringWithFormat:@"%.2d", seconds] forState:UIControlStateNormal];
                [btn setTitleColor:UIColorFromRGB(0x979797) forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - Action
- (IBAction)backAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)registerAction:(id)sender {
    [self.view endEditing:YES];
    
    [self jumpToRegisterMail];
}

- (IBAction)loginVerifyCodeAction:(id)sender {
    [self.view endEditing:YES];
    if (![_loginAccountTF.text isEmailAddress] && ![_loginAccountTF.text isMobileNumber]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_enter_a_valid_email_address_or_phone_number")];
        return;
    }
    [self requestVcode_signin_code];
}


- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    if (![_loginAccountTF.text isEmailAddress] && ![_loginAccountTF.text isMobileNumber]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_enter_a_valid_email_address_or_phone_number")];
        return;
    }
    
    UserModel *userM = [UserModel fetchUser:_loginAccountTF.text?:@""];
    if (!userM) { // 本地没有rsaPublicKey 验证码登录
        [self requestUser_signin_code];
    } else { // 密码登录
        [self requestSign_in];
    }
    
}

- (IBAction)forgetPWAction:(id)sender {
    [self.view endEditing:YES];
    [self jumpToForgetPW];
}

#pragma mark - Request

// 密码登录
- (void)requestSign_in {
    NSString *account = _loginAccountTF.text?:@"";
    UserModel *userM = [UserModel fetchUser:account];
    kWeakSelf(self);
    NSString *md5PW = [MD5Util md5:_loginPWTF.text?:@""];
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSDictionary *params = @{@"account":account,@"token":token};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:sign_in_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            UserModel *tempM = [UserModel getObjectWithKeyValues:responseObject];
            userM.md5PW = md5PW;
            userM.email = tempM.email;
            userM.head = tempM.head;
            userM.phone = tempM.phone;
            userM.nickname = tempM.nickname;
            userM.isLogin = @(YES);
            [UserModel storeUser:userM useLogin:NO];
            [UserModel storeLastLoginAccount:account];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:User_Login_Success_Noti object:nil];
            
            [FirebaseUtil logEventWithItemID:Firebase_Event_Login itemName:Firebase_Event_Login contentType:Firebase_Event_Login];
            
            [weakself backAction:nil];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

// 获取登录验证码
- (void)requestVcode_signin_code {
    kWeakSelf(self);
    NSDictionary *params = @{@"account":_loginAccountTF.text?:@""};
    [RequestService requestWithUrl5:vcode_signin_code_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"the_verification_code_has_been_sent_successfully")];
            [weakself openCountdown:weakself.loginVerifyCodeBtn];
        } else {
//            [kAppD.window makeToastDisappearWithText:@"Get Code Failed"];
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

// 验证码登录
- (void)requestUser_signin_code {
    kWeakSelf(self);
    NSString *account = _loginAccountTF.text?:@"";
    NSString *code = _loginVerifyCodeTF.text?:@"";
    NSDictionary *params = @{@"account":account,@"code":code};
    [RequestService requestWithUrl5:user_signin_code_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
//            NSString *rsaPublicKey = responseObject[Server_Data]?:@"";
            UserModel *model = [UserModel getObjectWithKeyValues:responseObject];
//            model.account = account;
//            model.md5PW = md5PW;
//            model.rsaPublicKey = rsaPublicKey;
            model.isLogin = @(NO);
            [UserModel storeUser:model useLogin:NO];
            
            [weakself requestSign_in];
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:User_Login_Success_Noti object:nil];
//            [weakself backAction:nil];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
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
    return;
    ChooseAreaCodeViewController *vc = [ChooseAreaCodeViewController new];
    kWeakSelf(self)
    vc.chooseB = ^(AreaCodeModel *model) {
//        weakself.areaCodeLab.text = [NSString stringWithFormat:@"+%@",@(model.code)];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToRegisterMail {
    RegisterMailViewController *vc = [RegisterMailViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
