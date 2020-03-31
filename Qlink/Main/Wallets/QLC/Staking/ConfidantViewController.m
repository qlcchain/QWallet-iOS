//
//  ConfidantViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/8/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ConfidantViewController.h"

@interface ConfidantViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *securityCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation ConfidantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
    _confirmBtn.layer.cornerRadius = 4;
    _confirmBtn.layer.masksToBounds = YES;
    _confirmBtn.userInteractionEnabled = NO; // D5D8DD
    _confirmBtn.backgroundColor = UIColorFromRGB(0xD5D8DD);
    
    [_emailTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [_securityCodeTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
}

- (void)changedTextField:(UITextField *)textField {
    [self refreshConfirmBtnState];
}

- (void)refreshConfirmBtnState {
    if (![_emailTF.text isEmptyString] && ![_securityCodeTF.text isEmptyString]) {
        _confirmBtn.userInteractionEnabled = YES;
        _confirmBtn.backgroundColor = MAIN_BLUE_COLOR;
    } else {
        _confirmBtn.userInteractionEnabled = NO;
        _confirmBtn.backgroundColor = UIColorFromRGB(0xD5D8DD);
    }
}

#pragma mark - Request
- (void)sendSecurityCode {
    NSString *urlStr = @"https://myconfidant.io/api/explorer";
    NSDictionary *params = @{@"action": @"sendSecurityCode",@"email_address": @"dzerix@gmail.com"};
    NSLog(@"sendSecurityCode url = %@    params = %@",urlStr,params);
    [RequestService normalRequestWithBaseURLStr8:urlStr params:params httpMethod:HttpMethodPost userInfo:nil requestManagerType: QRequestManagerTypeJSON successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        NSLog(@"sendSecurityCode responseObject=%@",responseObject);
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        DDLogDebug(@"sendSecurityCode error=%@",error);
    }];
}

#pragma mark - Action

- (IBAction)sendSecurityCodeAction:(id)sender {
    
}

- (IBAction)confirmAction:(id)sender {
    [self.view endEditing:YES];
    if ([_emailTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"your_email_is_empty")];
        return;
    }


    if ([_securityCodeTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"security_code_is_empty")];
        return;
    }
    

}

@end
