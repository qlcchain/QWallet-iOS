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

@interface ForgetPWViewController ()

@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *pwNewTF;
@property (weak, nonatomic) IBOutlet UITextField *pwRepeatTF;
@property (weak, nonatomic) IBOutlet UILabel *areaCodeLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneAreaCodeWidth; // 58


@end

@implementation ForgetPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self viewInit];
}

#pragma mark - Operation
- (void)viewInit {
    _confirmBtn.layer.cornerRadius = 6;
    _confirmBtn.layer.masksToBounds = YES;
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmAction:(id)sender {
    
}

- (IBAction)verifyCodeAction:(id)sender {
    
}

- (IBAction)mailFindAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _phoneAreaCodeWidth.constant = 0;
        _phoneTF.placeholder = @"邮箱";
        [sender setTitle:@"手机找回" forState:UIControlStateNormal];
    } else {
        _phoneAreaCodeWidth.constant = 58;
        _phoneTF.placeholder = @"手机号";
        [sender setTitle:@"邮箱找回" forState:UIControlStateNormal];
    }
}

- (IBAction)areaCodeAction:(id)sender {
    [self jumpToChooseAreaCode];
}

#pragma mark - Transition
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
