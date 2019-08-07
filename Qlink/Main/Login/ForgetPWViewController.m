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
#import "NSString+RegexCategory.h"
#import "SetPWViewController.h"

@interface ForgetPWViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;

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
    _nextBtn.layer.cornerRadius = 6;
    _nextBtn.layer.masksToBounds = YES;
}

- (void)dataInit {
    _titleLab.text = _inputTitle?:kLang(@"forget_password");
    _verifyCodeBtn.enabled = NO;
    _nextBtn.enabled = NO;
    _nextBtn.backgroundColor = [UIColor mainColorOfHalf];
    
    [_emailTF  addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
    [_verifyCodeTF addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)tfChange:(UITextField *)tf {
    if (tf == _emailTF) {
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
    }
}

- (void)changeConfirmBtnState {
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

- (IBAction)nextAction:(id)sender {
    [self.view endEditing:YES];
    
    if (![_emailTF.text isEmailAddress]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_enter_a_valid_email_address")];
        return;
    }
    
    [self jumpToSetPW];
}

- (IBAction)verifyCodeAction:(id)sender {
    [self.view endEditing:YES];
    
    if (![_emailTF.text isEmailAddress]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_enter_a_valid_email_address")];
        return;
    }
    
    [self requestVcode_change_password_code];
}

#pragma mark - Request
- (void)requestVcode_change_password_code {
    kWeakSelf(self);
    NSDictionary *params = @{@"account":_emailTF.text?:@""};
    [RequestService requestWithUrl:vcode_change_password_code_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"the_verification_code_has_been_sent_successfully")];
            [weakself openCountdown:weakself.verifyCodeBtn];
        } else {
//            [kAppD.window makeToastDisappearWithText:@"Get Code Failed."];
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - Transition
- (void)jumpToChooseAreaCode {
    return;
    ChooseAreaCodeViewController *vc = [ChooseAreaCodeViewController new];
    kWeakSelf(self)
    vc.chooseB = ^(AreaCodeModel *model) {
//        weakself.areaCodeLab.text = [NSString stringWithFormat:@"+%@",@(model.code)];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToSetPW {
    SetPWViewController *vc = [SetPWViewController new];
    vc.inputVerifyCode = _verifyCodeTF.text?:@"";
    vc.inputAccount = _emailTF.text?:@"";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
