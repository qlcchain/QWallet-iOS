//
//  RegisterSetPWViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/22.
//  Copyright © 2019 pan. All rights reserved.
//

#warning 暂未用到此页面

#import "RegisterSetPWViewController.h"
#import "MD5Util.h"
#import "UserModel.h"
#import "UIColor+Random.h"
//#import "GlobalConstants.h"

@interface RegisterSetPWViewController ()

//@property (weak, nonatomic) IBOutlet UITextField *pwTF;
//@property (weak, nonatomic) IBOutlet UITextField *pwRepeatTF;
//@property (weak, nonatomic) IBOutlet UITextField *inviteCodeTF;
//@property (weak, nonatomic) IBOutlet UIButton *registerBtn;


@end

@implementation RegisterSetPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

//    [self viewInit];
}

//#pragma mark - Operation
//- (void)viewInit {
//    _registerBtn.layer.cornerRadius = 6;
//    _registerBtn.layer.masksToBounds = YES;
//
//    _registerBtn.enabled = NO;
//    _registerBtn.backgroundColor = [UIColor mainColorOfHalf];
//
//    [_pwTF addTarget:self action:@selector(regTFChange:) forControlEvents:UIControlEventEditingChanged];
//    [_pwRepeatTF addTarget:self action:@selector(regTFChange:) forControlEvents:UIControlEventEditingChanged];
//}
//
//- (void)regTFChange:(UITextField *)tf {
//    if (tf == _pwTF) {
//        [self changeRegisterBtnState];
//    } else if (tf == _pwRepeatTF) {
//        [self changeRegisterBtnState];
//    }
//}
//
//- (void)changeRegisterBtnState {
//    if (_pwTF.text && _pwTF.text.length >= 6 && _pwRepeatTF.text && _pwRepeatTF.text.length >= 6) {
//        _registerBtn.enabled = YES;
//        _registerBtn.backgroundColor = [UIColor mainColor];
//    } else {
//        _registerBtn.enabled = NO;
//        _registerBtn.backgroundColor = [UIColor mainColorOfHalf];
//    }
//}
//
//#pragma mark - Action
//- (IBAction)backAction:(id)sender {
//    [self.view endEditing:YES];
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (IBAction)registerAction:(id)sender {
//    [self.view endEditing:YES];
//    if (![_pwTF.text isEqualToString:_pwRepeatTF.text]) {
//        [kAppD.window makeToastDisappearWithText:kLang(@"the_passwords_are_different")];
//        return;
//    }
//    [self requestSign_up];
//}
//
//#pragma mark - Request
//// 注册
//- (void)requestSign_up {
//    kWeakSelf(self);
//    NSString *account = _inputAccount;
//    NSString *md5PW = [MD5Util md5:_pwTF.text?:@""];
//    NSDictionary *params = @{@"account":account,@"password":md5PW,@"code":_inputVerifyCode,@"number":_inviteCodeTF.text?:@"",@"p2pId":[UserModel getOwnP2PId]};
//    [kAppD.window makeToastInView:kAppD.window];
//    [RequestService requestWithUrl5:sign_up_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        [kAppD.window hideToast];
//        if ([responseObject[Server_Code] integerValue] == 0) {
//            //            NSString *rsaPublicKey = responseObject[Server_Data]?:@"";
//            UserModel *model = [UserModel getObjectWithKeyValues:responseObject];
//            //            model.account = account;
//            model.md5PW = md5PW;
//            //            model.rsaPublicKey = rsaPublicKey;
//            model.isLogin = @(YES);
//            [UserModel storeUser:model useLogin:NO];
//            [UserModel storeLastLoginAccount:account];
//
//            [[NSNotificationCenter defaultCenter] postNotificationName:User_Login_Success_Noti object:nil];
//            [weakself backAction:nil];
//        } else {
//            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        [kAppD.window hideToast];
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
