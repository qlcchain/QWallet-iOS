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

@interface EditTextViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeBackHeight; // 49

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
    
    switch (self.editType) {
        case EditUsername:
        {
            _lblNavTitle.text = @"Edit Username";
            _nameTF.placeholder = @"Please enter Username";
            _nameTF.text = [UserModel fetchUserOfLogin].nickname?:@"";
        }
            break;
        case EditEmail:
        {
            _lblNavTitle.text = @"Edit Email";
            _nameTF.placeholder = @"Please enter Email";
            _nameTF.text = [UserModel fetchUserOfLogin].email?:@"";
            _codeBackHeight.constant = 49;
            _codeBtn.enabled = NO;
            [_nameTF addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
        }
            break;
        case EditPhone:
        {
            _lblNavTitle.text = @"Edit Phone";
            _nameTF.placeholder = @"Please enter Phone";
            _nameTF.text = [UserModel fetchUserOfLogin].phone?:@"";
            _codeBackHeight.constant = 49;
            _codeBtn.enabled = NO;
            [_nameTF addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
        }
            break;
        default:
            break;
    }
    
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
                [kAppD.window makeToastDisappearWithText:@"Username cannot be empty"];
            } else {
                [self requestUser_change_nickname:name];
            }
        }
            break;
        case EditEmail:
        {
            if ([name isEmptyString]) {
                [kAppD.window makeToastDisappearWithText:@"Email cannot be empty"];
                return;
            }
            if ([code isEmptyString]) {
                [kAppD.window makeToastDisappearWithText:@"Code cannot be empty"];
                return;
            }
            [self requestUser_change_email:name code:code];
        }
            break;
        case EditPhone:
        {
            if ([name isEmptyString]) {
                [kAppD.window makeToastDisappearWithText:@"Phone cannot be empty"];
                return;
            }
            if ([code isEmptyString]) {
                [kAppD.window makeToastDisappearWithText:@"Code cannot be empty"];
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
    NSString *timestamp = [NSString stringWithFormat:@"%@",@([NSDate getTimestampFromDate:[NSDate date]])];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSDictionary *params = @{@"account":account,@"token":token,@"nickname":nickname};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:user_change_nickname_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            userM.nickname = nickname;
            [UserModel storeUser:userM];
            
            [kAppD.window makeToastDisappearWithText:@"修改成功"];
            [weakself backAction:nil];
        } else {
            [kAppD.window makeToastDisappearWithText:@"修改失败"];
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
    [RequestService requestWithUrl:vcode_change_email_code_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:@"获取验证码成功"];
        } else {
            [kAppD.window makeToastDisappearWithText:@"获取验证码失败"];
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
    NSString *timestamp = [NSString stringWithFormat:@"%@",@([NSDate getTimestampFromDate:[NSDate date]])];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSDictionary *params = @{@"account":account,@"token":token,@"email":email,@"code":code};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:user_change_email_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            userM.email = email;
            [UserModel storeUser:userM];
            
            [kAppD.window makeToastDisappearWithText:@"修改成功"];
            [weakself backAction:nil];
        } else {
            [kAppD.window makeToastDisappearWithText:@"修改失败"];
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
    [RequestService requestWithUrl:vcode_change_phone_code_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:@"获取验证码成功"];
        } else {
            [kAppD.window makeToastDisappearWithText:@"获取验证码失败"];
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
    NSString *timestamp = [NSString stringWithFormat:@"%@",@([NSDate getTimestampFromDate:[NSDate date]])];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSDictionary *params = @{@"account":account,@"token":token,@"phone":phone,@"code":code};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:user_change_phone_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            userM.phone = phone;
            [UserModel storeUser:userM];
            
            [kAppD.window makeToastDisappearWithText:@"修改成功"];
            [weakself backAction:nil];
        } else {
            [kAppD.window makeToastDisappearWithText:@"修改失败"];
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
