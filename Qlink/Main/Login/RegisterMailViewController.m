//
//  RegisterMailViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/22.
//  Copyright © 2019 pan. All rights reserved.
//

#import "RegisterMailViewController.h"
#import "RegisterSetPWViewController.h"
#import "NSString+RegexCategory.h"

@interface RegisterMailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@end

@implementation RegisterMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self viewInit];
}

#pragma mark - Operation
- (void)viewInit {
    _nextBtn.layer.cornerRadius = 6;
    _nextBtn.layer.masksToBounds = YES;
    
    _verifyCodeBtn.enabled = NO;
    _nextBtn.enabled = NO;
    _nextBtn.backgroundColor = [UIColor mainColorOfHalf];
    
    [_emailTF  addTarget:self action:@selector(regTFChange:) forControlEvents:UIControlEventEditingChanged];
    [_verifyCodeTF addTarget:self action:@selector(regTFChange:) forControlEvents:UIControlEventEditingChanged];
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
    }
}

- (void)changeRegisterBtnState {
    if (_emailTF.text && _emailTF.text.length > 0 && _verifyCodeTF.text && _verifyCodeTF.text.length > 0) {
        _nextBtn.enabled = YES;
        _nextBtn.backgroundColor = [UIColor mainColor];
    } else {
        _nextBtn.enabled = NO;
        _nextBtn.backgroundColor = [UIColor mainColorOfHalf];
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

#pragma mark - Action
- (IBAction)backAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

// 获取注册验证码
- (IBAction)regVerifyCodeAction:(id)sender {
    [self.view endEditing:YES];
    if (![_emailTF.text isEmailAddress]) {
        [kAppD.window makeToastDisappearWithText:@"Please enter a valid email address."];
        return;
    }
    [self requestSignup_code];
}

- (IBAction)nextAction:(id)sender {
    [self.view endEditing:YES];
    if (![_emailTF.text isEmailAddress]) {
        [kAppD.window makeToastDisappearWithText:@"Please enter a valid email address."];
        return;
    }

    [self jumpToRegisterSetPW];
}


#pragma mark - Request
// 获取注册验证码
- (void)requestSignup_code {
    kWeakSelf(self);
    NSDictionary *params = @{@"account":_emailTF.text?:@""};
    [RequestService requestWithUrl:signup_code_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:@"Sent Code Success."];
            [weakself openCountdown:weakself.verifyCodeBtn];
        } else {
            //            [kAppD.window makeToastDisappearWithText:@"Get Code Failed"];
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - Transition
- (void)jumpToRegisterSetPW {
    RegisterSetPWViewController *vc = [RegisterSetPWViewController new];
    vc.inputAccount = _emailTF.text?:@"";
    vc.inputVerifyCode = _verifyCodeTF.text?:@"";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
