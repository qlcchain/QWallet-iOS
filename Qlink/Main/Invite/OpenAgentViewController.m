//
//  OpenAgentViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/1/9.
//  Copyright © 2020 pan. All rights reserved.
//

#import "OpenAgentViewController.h"
#import "UIView+Gradient.h"
#import "WalletSelectViewController.h"
#import "QNavigationController.h"
#import "WalletCommonModel.h"
#import "UserModel.h"
#import "NSDate+Category.h"
#import "RSAUtil.h"
#import "QLCWalletInfo.h"
#import "OpenDelegateSuccessView.h"

@interface OpenAgentViewController ()

@property (weak, nonatomic) IBOutlet UIView *personBack;

@property (weak, nonatomic) IBOutlet UIImageView *bindWalletIcon;
@property (weak, nonatomic) IBOutlet UILabel *bindWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *bindWalletAddressLab;

@property (weak, nonatomic) IBOutlet UIButton *bindBtn;

@property (nonatomic, strong) WalletCommonModel *bindWalletM;

@end

@implementation OpenAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
//    [_personBack addQGradientWithStart:UIColorFromRGB(0xF9BD5E) end:UIColorFromRGB(0xFC7D32) frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _bindBtn.layer.cornerRadius = 4;
    _bindBtn.layer.masksToBounds = YES;
    
    _bindWalletNameLab.text = nil;
    _bindWalletAddressLab.text = nil;
}

- (void)showOpenDelegateSuccessView {
    OpenDelegateSuccessView *view = [OpenDelegateSuccessView getInstance];
    kWeakSelf(self);
    view.okBlock = ^{
        [weakself backAction:nil];
    };
    [view show];
}

#pragma mark - Request
- (void)requestUser_bind_qlc_address {
    kWeakSelf(self);
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    
    NSString *address = _bindWalletM.address?:@"";
    NSString *signature = [QLCWalletInfo signWithMessage:address address:address]?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"signature":signature,@"address":address};
    [RequestService requestWithUrl10:user_bind_qlc_address_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
//            [kAppD.window makeToastDisappearWithText:kLang(@"success")];
//            [weakself backAction:nil];
            [weakself showOpenDelegateSuccessView];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showWalletAction:(id)sender {
    kWeakSelf(self);
    WalletSelectViewController *vc = [[WalletSelectViewController alloc] init];
    vc.inputWalletType = WalletTypeQLC;
    [vc configSelectBlock:^(WalletCommonModel * _Nonnull model) {
        weakself.bindWalletM = model;
        weakself.bindWalletIcon.image = [WalletCommonModel walletIcon:model.walletType];
        weakself.bindWalletNameLab.text = model.name;
        weakself.bindWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
        
    }];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)bindAction:(id)sender {
    if (!_bindWalletM) {
        return;
    }
    
    [self requestUser_bind_qlc_address];
}


@end
