//
//  EditTextViewController.m
//  PNRouter
//
//  Created by 旷自辉 on 2018/9/15.
//  Copyright © 2018年 旷自辉. All rights reserved.
//

#import "EditTextViewController.h"
#import "UserModel.h"
#import "NSString+Base64.h"
#import "NSString+HexStr.h"
#import "NSString+Trim.h"
#import "MD5Util.h"
#import "RSAUtil.h"
#import "NSDate+Category.h"
#import "UIColor+Random.h"
//#import "GlobalConstants.h"

@interface EditTextViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeBackHeight; // 49
@property (weak, nonatomic) IBOutlet UILabel *phonePrefixLab;

@property (nonatomic ,assign) EditType editType;

@end

@implementation EditTextViewController

#pragma mark - Observe
- (void)addObserve {
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype) initWithType:(EditType) type {
    if (self = [super init]) {
        self.editType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserve];
    
    _codeBackHeight.constant = 0;
    NSString *phonePrefix = @"";
    
    switch (self.editType) {
        case EditUsername:
        {
            _lblNavTitle.text = kLang(@"edit_username");
            _nameTF.placeholder = kLang(@"please_enter_username");
            _nameTF.text = [UserModel fetchUserOfLogin].nickname?:@"";
        }
            break;
        case EditEmail:
        {
            _lblNavTitle.text = kLang(@"edit_email");
            _nameTF.placeholder = kLang(@"please_enter_email");
            _nameTF.text = [UserModel fetchUserOfLogin].email?:@"";
            _codeBackHeight.constant = 49;
            _codeBtn.enabled = NO;
            [_nameTF addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
        }
            break;
        case EditPhone:
        {
            phonePrefix = @"+86";
            _lblNavTitle.text = kLang(@"edit_phone");
            _nameTF.placeholder = kLang(@"please_enter_phone");
            _nameTF.text = [UserModel fetchUserOfLogin].phone?:@"";
            _codeBackHeight.constant = 49;
            _codeBtn.enabled = NO;
            [_nameTF addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
        }
            break;
        default:
            break;
    }
    _phonePrefixLab.text = phonePrefix;
    
    [self performSelector:@selector(beginFirst) withObject:self afterDelay:0.7];
    
}

#pragma mark - Action
- (IBAction)backAction:(id)sender {
    [self leftNavBarItemPressedWithPop:YES];
}

- (IBAction)verifyCodeAction:(id)sender {
    NSString *name = [NSString trimWhitespaceAndNewline:_nameTF.text?:@""];
    switch (self.editType) {
        case EditUsername:
        {
        }
            break;
        case EditEmail:
        {
            [self requestVcode_change_email_code:name];
        }
            break;
        case EditPhone:
        {
            [self requestVcode_change_phone_code:name];
        }
            break;
        default:
            break;
    }
    
}

- (IBAction)okAction:(id)sender {
    [self.view endEditing:YES];
    
    NSString *name = [NSString trimWhitespaceAndNewline:_nameTF.text?:@""];
    NSString *code = [NSString trimWhitespaceAndNewline:_codeTF.text?:@""];
    switch (self.editType) {
        case EditUsername:
        {
            if ([name isEmptyString]) {
                [kAppD.window makeToastDisappearWithText:kLang(@"username_cannot_be_empty")];
            } else {
                [self requestUser_change_nickname:name];
            }
        }
            break;
        case EditEmail:
        {
            if ([name isEmptyString]) {
                [kAppD.window makeToastDisappearWithText:kLang(@"email_cannot_be_empty")];
                return;
            }
            if ([code isEmptyString]) {
                [kAppD.window makeToastDisappearWithText:kLang(@"code_cannot_be_empty")];
                return;
            }
            [self requestUser_change_email:name code:code];
        }
            break;
        case EditPhone:
        {
            if ([name isEmptyString]) {
                [kAppD.window makeToastDisappearWithText:kLang(@"phone_cannot_be_empty")];
                return;
            }
            if ([code isEmptyString]) {
                [kAppD.window makeToastDisappearWithText:kLang(@"code_cannot_be_empty")];
                return;
            }
            [self requestUser_change_phone:name code:code];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Operation
- (void)beginFirst {
    [_nameTF becomeFirstResponder];
}

- (void)tfChange:(UITextField *)tf {
    if (tf == _nameTF) {
        // 更改获取登录验证码按钮状态
        if (tf.text && tf.text.length > 0) {
            _codeBtn.enabled = YES;
            [_codeBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
        } else {
            _codeBtn.enabled = NO;
            [_codeBtn setTitleColor:UIColorFromRGB(0xB3B3B3) forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Request
// 修改昵称
- (void)requestUser_change_nickname:(NSString *)nickname {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSDictionary *params = @{@"account":account,@"token":token,@"nickname":nickname};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:user_change_nickname_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            userM.nickname = nickname;
            [UserModel storeUser:userM useLogin:NO];
            
            [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
            [weakself backAction:nil];
        } else {
            [kAppD.window makeToastDisappearWithText:kLang(@"failed_")];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

// 获取修改邮箱验证码
- (void)requestVcode_change_email_code:(NSString *)email {
    //    kWeakSelf(self);
    UserModel *userM = [UserModel fetchUserOfLogin];
    NSString *account = userM.account?:@"";
    NSDictionary *params = @{@"account":account,@"email":email};
    [RequestService requestWithUrl5:vcode_change_email_code_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"the_verification_code_has_been_sent_successfully")];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

// 修改邮箱
- (void)requestUser_change_email:(NSString *)email code:(NSString *)code {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSDictionary *params = @{@"account":account,@"token":token,@"email":email,@"code":code};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:user_change_email_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            userM.email = email;
            [UserModel storeUser:userM useLogin:NO];
            
            [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
            [weakself backAction:nil];
        } else {
            [kAppD.window makeToastDisappearWithText:kLang(@"failed_")];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

// 获取修改手机验证码
- (void)requestVcode_change_phone_code:(NSString *)phone {
    //    kWeakSelf(self);
    UserModel *userM = [UserModel fetchUserOfLogin];
    NSString *account = userM.account?:@"";
    NSDictionary *params = @{@"account":account,@"phone":phone};
    [RequestService requestWithUrl5:vcode_change_phone_code_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"the_verification_code_has_been_sent_successfully")];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

// 修改手机
- (void)requestUser_change_phone:(NSString *)phone code:(NSString *)code {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSDictionary *params = @{@"account":account,@"token":token,@"phone":phone,@"code":code};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:user_change_phone_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            userM.phone = phone;
            [UserModel storeUser:userM useLogin:NO];
            
            [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
            [weakself backAction:nil];
        } else {
            [kAppD.window makeToastDisappearWithText:kLang(@"failed_")];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

#pragma mark - Noti


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
