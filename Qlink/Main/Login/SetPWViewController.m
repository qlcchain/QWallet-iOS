//
//  SetPWViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/22.
//  Copyright © 2019 pan. All rights reserved.
//

#import "SetPWViewController.h"
#import "UserModel.h"
#import "MD5Util.h"
#import "NSDate+Category.h"
#import "RSAUtil.h"

@interface SetPWViewController ()

@property (weak, nonatomic) IBOutlet UITextField *pwNewTF;
@property (weak, nonatomic) IBOutlet UITextField *pwRepeatTF;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;


@end

@implementation SetPWViewController

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
    _confirmBtn.enabled = NO;
    _confirmBtn.backgroundColor = [UIColor mainColorOfHalf];
    
    [_pwNewTF addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
    [_pwRepeatTF addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)tfChange:(UITextField *)tf {
    if (tf == _pwNewTF) {
        [self changeConfirmBtnState];
    } else if (tf == _pwRepeatTF) {
        [self changeConfirmBtnState];
    }
}

- (void)changeConfirmBtnState {
    if (_pwNewTF.text && _pwNewTF.text.length >= 6 && _pwRepeatTF.text && _pwRepeatTF.text.length >= 6) {
        _confirmBtn.enabled = YES;
        _confirmBtn.backgroundColor = [UIColor mainColor];
    } else {
        _confirmBtn.enabled = NO;
        _confirmBtn.backgroundColor = [UIColor mainColorOfHalf];
    }
}

- (void)backToRoot {
    [self.view endEditing:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmAction:(id)sender {
    [self.view endEditing:YES];
    
    if (![_pwNewTF.text isEqualToString:_pwRepeatTF.text]) {
        [kAppD.window makeToastDisappearWithText:@"The passwords are different."];
        return;
    }
    [self requestUser_change_password];
}

#pragma mark - Request
- (void)requestUser_change_password {
    NSString *account = _inputAccount;
    UserModel *userM = [UserModel fetchUser:account];
    if (!userM) {
        return;
    }
    kWeakSelf(self);
    NSString *md5PW = [MD5Util md5:_pwNewTF.text?:@""];
    NSString *timestamp = [NSString stringWithFormat:@"%@",@([NSDate getTimestampFromDate:[NSDate date]])];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSString *code = _inputVerifyCode;
    NSDictionary *params = @{@"account":account,@"token":token,@"password":md5PW,@"code":code};
    [RequestService requestWithUrl:user_change_password_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            userM.md5PW = md5PW;
            [UserModel storeUser:userM];
            
            [kAppD.window makeToastDisappearWithText:@"Success."];
            [weakself backToRoot];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
