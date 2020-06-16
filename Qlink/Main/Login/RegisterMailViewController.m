//
//  RegisterMailViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/22.
//  Copyright © 2019 pan. All rights reserved.
//

#import "RegisterMailViewController.h"
#import "NSString+RegexCategory.h"
#import "MD5Util.h"
#import "UserModel.h"
#import "UIColor+Random.h"
//#import "GlobalConstants.h"
#import "FirebaseUtil.h"
#import "SystemUtil.h"
#import "JPushTagHelper.h"
#import "NSString+Trim.h"
#import "SignView.h"

@interface RegisterMailViewController()

@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;
@property (weak, nonatomic) IBOutlet UITextField *pwRepeatTF;
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (nonatomic, strong) NSDictionary *signDic;
@property (nonatomic, strong) SignView *signView;

@end

@implementation RegisterMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self viewInit];
    [self.signView loadLocalHtmlForJsWithHtmlName:@"registerSign"];
    self.signView.hidden = YES;
}

#pragma mark - Operation
- (void)viewInit {
    _registerBtn.layer.cornerRadius = 6;
    _registerBtn.layer.masksToBounds = YES;
    
    _verifyCodeBtn.enabled = NO;
    _registerBtn.enabled = NO;
    _registerBtn.backgroundColor = [UIColor mainColorOfHalf];
    
    [_emailTF  addTarget:self action:@selector(regTFChange:) forControlEvents:UIControlEventEditingChanged];
    [_verifyCodeTF addTarget:self action:@selector(regTFChange:) forControlEvents:UIControlEventEditingChanged];
    [_pwTF addTarget:self action:@selector(regTFChange:) forControlEvents:UIControlEventEditingChanged];
    [_pwRepeatTF addTarget:self action:@selector(regTFChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)regTFChange:(UITextField *)tf {
    if (tf == _emailTF) {
        // 更改获取注册验证码按钮状态
        if (tf.text && tf.text.length > 0) {
            _verifyCodeBtn.enabled = YES;
            [_verifyCodeBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
        } else {
            _verifyCodeBtn.enabled = NO;
            [_verifyCodeBtn setTitleColor:UIColorFromRGB(0xB3B3B3) forState:UIControlStateNormal];
        }
        [self changeRegisterBtnState];
    } else if (tf == _verifyCodeTF) {
        [self changeRegisterBtnState];
    } else if (tf == _pwTF) {
        [self changeRegisterBtnState];
    } else if (tf == _pwRepeatTF) {
        [self changeRegisterBtnState];
    }
}

- (void)changeRegisterBtnState {
    if (_emailTF.text.trim_whitespace && _emailTF.text.trim_whitespace.length > 0 && _verifyCodeTF.text.trim_whitespace && _verifyCodeTF.text.trim_whitespace.length > 0 && _pwTF.text.trim_whitespace && _pwTF.text.trim_whitespace.length >= 6 && _pwRepeatTF.text.trim_whitespace && _pwRepeatTF.text.trim_whitespace.length >= 6) {
        _registerBtn.enabled = YES;
        _registerBtn.backgroundColor = [UIColor mainColor];
    } else {
        _registerBtn.enabled = NO;
        _registerBtn.backgroundColor = [UIColor mainColorOfHalf];
    }
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

- (void)dismiss {
    [self.view endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - Action
- (IBAction)backAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

// 获取注册验证码
- (IBAction)regVerifyCodeAction:(id)sender {
    [self.view endEditing:YES];
    if (![[_emailTF.text trim_whitespace] isEmailAddress]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_enter_a_valid_email_address")];
        return;
    }
    if (self.signDic) {
        self.signDic = nil;
        [self.signView loadLocalHtmlForJsWithHtmlName:@"registerSign"];
    }
    if (self.signView.hidden) {
        self.signView.hidden = NO;
    }
    
}

- (IBAction)registerAction:(id)sender {
    [self.view endEditing:YES];
    if (![[_emailTF.text trim_whitespace] isEmailAddress]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_enter_a_valid_email_address")];
        return;
    }
    if (![[_pwTF.text trim_whitespace] isEqualToString:[_pwRepeatTF.text trim_whitespace]]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"the_passwords_are_different")];
        return;
    }
    [self requestSign_up];
}


#pragma mark - Request
// 获取注册验证码
- (void)requestSignup_code {
    NSString *account = [_emailTF.text?:@"" trimAndLowercase];
    kWeakSelf(self);
    NSDictionary *params = @{@"account":account,@"appKey":Sign_Key,@"scene":Sign_Scene,@"sig":self.signDic[@"sig"]?:@"",@"afsToken":self.signDic[@"token"]?:@"",@"sessionId":self.signDic[@"sid"]?:@""};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl10:signup_code_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"the_verification_code_has_been_sent_successfully")];
            [weakself openCountdown:weakself.verifyCodeBtn];
        } else {
            //            [kAppD.window makeToastDisappearWithText:@"Get Code Failed"];
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
        [kAppD.window makeToastDisappearWithText:error.localizedDescription?:@""];
    }];
}

// 注册
- (void)requestSign_up {
    kWeakSelf(self);
    NSString *account = [_emailTF.text?:@"" trimAndLowercase];
    NSString *md5PW = [MD5Util md5:[_pwTF.text?:@"" trim_whitespace]];
    NSString *code = [_verifyCodeTF.text?:@"" trim_whitespace];
    NSString *number = [_inviteCodeTF.text?:@"" trim_whitespace];
    NSDictionary *params = @{@"account":account,@"password":md5PW,@"code":code,@"number":number,@"p2pId":[UserModel getOwnP2PId]};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl10:sign_up_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            //            NSString *rsaPublicKey = responseObject[Server_Data]?:@"";
            UserModel *model = [UserModel getObjectWithKeyValues:responseObject];
            //            model.account = account;
            model.md5PW = md5PW;
            //            model.rsaPublicKey = rsaPublicKey;
            model.isLogin = @(YES);
            [UserModel storeUserByID:model];
            [UserModel storeLastLoginAccount:account];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:User_Login_Success_Noti object:nil];
            
            [SystemUtil requestBind_jpush]; // 绑定极光推送
            [JPushTagHelper setTags]; // 极光设置tag
            
            [FirebaseUtil logEventWithItemID:Firebase_Event_Register itemName:Firebase_Event_Register contentType:Firebase_Event_Register];
            
            [weakself dismiss];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}





#pragma mark - WebViewUIDelegate

- (SignView *)signView
{
    if (!_signView) {
        _signView = [[SignView alloc] initWithFrame:_codeView.bounds];
        
        kWeakSelf(self)
        [_signView setSignResultBlock:^(NSDictionary * _Nonnull resultDic) {
            weakself.signDic = resultDic;
            [weakself requestSignup_code];
        }];
        
        [_codeView addSubview:_signView];
        
    }
    return _signView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
