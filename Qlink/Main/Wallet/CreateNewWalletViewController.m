//
//  CreateNewWalletViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/29.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "CreateNewWalletViewController.h"
#import "NewWalletViewController.h"
#import "WalletUtil.h"
#import "AppDelegate.h"
#import "QlinkTabbarViewController.h"
#import "UnderlineView.h"

@interface CreateNewWalletViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtPass1;
@property (weak, nonatomic) IBOutlet UITextField *txtPass2;

@property (weak, nonatomic) IBOutlet UnderlineView *pass1View;
@property (weak, nonatomic) IBOutlet UnderlineView *pass2View;

@end

@implementation CreateNewWalletViewController

- (IBAction)clickCheck:(UIButton *)sender {
    
    if (sender.tag == 10) { // pass1
        if (!sender.selected) {
            sender.selected = YES;
            _txtPass1.secureTextEntry = NO;
        } else {
            sender.selected = NO;
            _txtPass1.secureTextEntry = YES;
        }
    } else { //pass2
        if (!sender.selected) {
            sender.selected = YES;
            _txtPass2.secureTextEntry = NO;
        } else {
            sender.selected = NO;
            _txtPass2.secureTextEntry = YES;
        }
    }
    
}
- (IBAction)clcikBack:(id)sender {
    
    [WalletUtil manageCancelWork];
    [self.view endEditing:YES];
    [self leftNavBarItemPressedWithPop:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    _pass1View.textField = _txtPass1;
    _pass2View.textField = _txtPass2;
    //注意：事件类型是：`UIControlEventEditingChanged`
    [self performSelector:@selector(txtBecomeFirstResponder) withObject:self afterDelay:.6];
    
    
}
- (void) txtBecomeFirstResponder
{
    [_txtPass1 becomeFirstResponder];
}

- (IBAction)continueAction:(id)sender {
    
     [self.view endEditing:YES];
    
    if ([_txtPass1.text.trim isBlankString] || [_txtPass2.text.trim isBlankString]) {
        [AppD.window showHint:NSStringLocalizable(@"pass_input")];
        return;
    } else if (![_txtPass1.text.trim isEqualToString:_txtPass2.text.trim]){
        [AppD.window showHint:NSStringLocalizable(@"pass_same")];
        return;
    }
    // 保存密码
    [WalletUtil setKeyValue:WALLET_PASS_KEY value:_txtPass1.text.trim];
    [self pushToNewWallet];
}

- (void)pushToNewWallet {
    NewWalletViewController *vc = [[NewWalletViewController alloc] initWithJump:PassJump];
    [self.navigationController pushViewController:vc animated:YES];
    // 移除当前vc
    [self moveNavgationViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
