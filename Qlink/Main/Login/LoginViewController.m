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
    _slideBlockView.frame = CGRectMake(0, 66, 44, 4);
    _slideBlockView.centerX = (SCREEN_WIDTH-20-20-20)/2.0/2.0+20;
    
    _regVerifyCodeBtn.enabled = NO;
    [_regPhoneTF  addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)scrollSliderBlock:(UIButton *)sender {
    kWeakSelf(self)
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakself.slideBlockView.centerX = sender.centerX;
    } completion:^(BOOL finished) {
    }];
}

- (void)tfChange:(UITextField *)tf {
    if (tf == _regPhoneTF) {
        if (tf.text && tf.text.length > 0) {
            _regVerifyCodeBtn.enabled = YES;
            [_regVerifyCodeBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
        } else {
            _regVerifyCodeBtn.enabled = NO;
            [_regVerifyCodeBtn setTitleColor:UIColorFromRGB(0xB3B3B3) forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Action

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
    
}

- (IBAction)loginAction:(id)sender {
    
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
    
}

- (IBAction)areaCodeAction:(id)sender {
    [self jumpToChooseAreaCode];
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
