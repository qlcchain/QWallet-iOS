//
//  UnlockWalletViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/2.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "UnlockWalletViewController.h"
#import "WalletUtil.h"
#import "AppDelegate.h"
#import "QlinkTabbarViewController.h"
#import "NSDate+Category.h"
#import "UnderlineView.h"
#import "GuideUnlockWalletView.h"

@interface UnlockWalletViewController ()

@property (weak, nonatomic) IBOutlet UITextField *pwTF;
@property (weak, nonatomic) IBOutlet UnderlineView *txtLineView;

@end

@implementation UnlockWalletViewController

- (IBAction)clickDelPass:(id)sender {
    
    [WalletUtil removeChainKey:WALLET_PASS_KEY];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _txtLineView.textField = _pwTF;
    //注意：事件类型是：`UIControlEventEditingChanged`
//    [self performSelector:@selector(pwtfBecomeFirstResponder) withObject:self afterDelay:.5];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self pwtfBecomeFirstResponder];
    [self addNewGuideUnlockWallet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) pwtfBecomeFirstResponder
{
    [_pwTF becomeFirstResponder];
}

- (void)pwtfResignFirstResponder {
    [_pwTF resignFirstResponder];
}

#pragma mark - Config View
- (void) addNewGuideUnlockWallet {
    [HWUserdefault insertObj:@(NO) withkey:NEW_GUIDE_UNLOCK_WALLET];
    NSNumber *guideLocal = [HWUserdefault getObjectWithKey:NEW_GUIDE_UNLOCK_WALLET];
    if (!guideLocal || [guideLocal boolValue] == NO) {
        [self pwtfResignFirstResponder];
        CGRect hollowOutFrame = CGRectMake((SCREEN_WIDTH-145)/2,14+STATUS_BAR_HEIGHT,145,88);
        @weakify_self
        [[GuideUnlockWalletView getNibView] showGuideTo:hollowOutFrame tapBlock:^{
            [weakSelf pwtfBecomeFirstResponder];
        }];
    }
}

#pragma mark - Action
- (IBAction)pwEyeAction:(UIButton *)sender {
    _pwTF.secureTextEntry = sender.selected;
     sender.selected = !sender.selected;
}

- (IBAction)continueAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([_pwTF.text.trim isEmptyString]) {
        [AppD.window showHint:NSStringLocalizable(@"pass_input")];
        return;
    }
    if (_pwTF.text.trim.length < 6) {
        [AppD.window showHint:NSStringLocalizable(@"pass_format")];
        return;
    }
   
    NSString *passStr = [WalletUtil getKeyValue:WALLET_PASS_KEY];
    if ([passStr isEqualToString:_pwTF.text.trim]) {
        
        [WalletUtil setUnlock:NO];
        NSString *enterBackTime = [[NSDate date] formattedDateYearYueRi:@"yyyy-MM-dd HH:mm:ss"];
        [HWUserdefault insertString:enterBackTime withkey:INPUNT_PASS_TIME_KEY];
        
        if ([WalletUtil isExistWalletPrivateKey]) { // 钱包私钥是否存在) {
            [self dismissAnimated:YES];
            [WalletUtil manageContiueWork];
        } else {
            [WalletUtil checkWalletPassAndPrivateKey:self TransitionFrom:[WalletUtil getCheckFrom]];
            [self moveNavgationViewController:self];
        }
       
    } else {
         [AppD.window showHint:NSStringLocalizable(@"pass_same")];
    }
}

- (IBAction)cancelAction:(id)sender {
    
    
    [self.view endEditing:YES];
    
    [WalletUtil manageCancelWork];
    
    [self dismissAnimated:YES];
    
    
}

- (void)dismissAnimated:(BOOL) animated {
   // [self dismissViewControllerAnimated:YES completion:nil];
    [self leftNavBarItemPressedWithPop:YES];
}


#pragma textfield delegate


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
