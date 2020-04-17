//
//  BuySellDetailViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/8.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ClaimQGASViewController.h"
#import <QLCFramework/QLCFramework.h>
#import "PayReceiveAddressViewController.h"
#import "QLCAddressInfoModel.h"
#import "WalletCommonModel.h"
#import "QlinkTabbarViewController.h"
#import "MainTabbarViewController.h"
#import "ChooseWalletViewController.h"
#import "NSString+RemoveZero.h"
#import "WalletSelectViewController.h"
#import "QNavigationController.h"
//#import "GlobalConstants.h"
#import "UserModel.h"
#import "MD5Util.h"
#import "RSAUtil.h"
#import "NSDate+Category.h"
#import "SuccessTipView.h"
#import "ClaimSuccessTipView.h"
#import "AppJumpHelper.h"
#import <UIImageView+WebCache.h>
#import <OutbreakRed/OutbreakRed.h>

@interface ClaimQGASViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *canClaimAmountLab;


@property (weak, nonatomic) IBOutlet UILabel *receiveAddressTipLab;
@property (weak, nonatomic) IBOutlet UILabel *sendAddressTipLab;


@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *qgasSendTF;

@property (weak, nonatomic) IBOutlet UIView *sendQgasWalletBack;
@property (weak, nonatomic) IBOutlet UIImageView *sendQgasWalletIcon;
@property (weak, nonatomic) IBOutlet UILabel *sendQgasWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *sendQgasWalletAddressLab;

@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIImageView *codeImg;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;


@property (nonatomic, strong) WalletCommonModel *sendQgasWalletM;

@end

@implementation ClaimQGASViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self getCode];
}

#pragma mark - Operation
- (void)configInit {
    _submitBtn.layer.cornerRadius = 4.0;
    _submitBtn.layer.masksToBounds = YES;
    
    _sendQgasWalletBack.hidden = YES;
    
    _qgasSendTF.placeholder = kLang(@"wallet_address");
    _canClaimAmountLab.text = [NSString stringWithFormat:@"%@ QGAS",_inputCanClaimAmount?:@"0"];
}

- (void)getCode {
    if (_claimQGASType == ClaimQGASTypeDailyEarnings) {
        NSString *type = @"CLAIM_BIND";
        [self requestVcode_verify_code:type];
    } else if (_claimQGASType == ClaimQGASTypeReferralRewards) {
        NSString *type = @"CLAIM_INVITE";
        [self requestVcode_verify_code:type];
    } else if (_claimQGASType == ClaimQGASTypeCLAIM_COVID) {
        NSString *type = @"CLAIM_COVID";
        [self requestVcode_verify_code:type];
    }
}

#pragma mark - Request

- (void)requestGzbd_receive {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSString *code = _codeTF.text?:@"";
    NSString *toAddress = _qgasSendTF.text?:@"";
    NSString *recordId = _inputCovidRecordId?:@"";
    OR_RequestModel *requestM = [OR_RequestModel new];
    requestM.p2pId = [UserModel getTopupP2PId];
    requestM.appBuild = APP_Build;
    requestM.appVersion = APP_Version;
    [kAppD.window makeToastInView:kAppD.window];
    [OutbreakRedSDK requestGzbd_receiveWithAccount:account token:token timestamp:timestamp code:code recordId:recordId toAddress:toAddress requestM:requestM completeBlock:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nonnull responseObject, NSError * _Nonnull error) {
        [kAppD.window hideToast];
        if (!error) {
            if ([responseObject[Server_Code] integerValue] == 0) {
                if (weakself.claimSuccessBlock) {
                    weakself.claimSuccessBlock();
                }
                
                 SuccessTipView *view = [SuccessTipView getInstance];
                 [view showWithTitle:kLang(@"successful")];
                 
                 [weakself backAction:nil];
             } else {
                [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
            }
        } else {
            
        }
    }];
    
}

- (void)requestReward_claim_bind_v2 {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSString *toAddress = _qgasSendTF.text?:@"";
    NSString *code = _codeTF.text?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"toAddress":toAddress,@"code":code};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl11:reward_claim_bind_v2_Url params:params timestamp:timestamp httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            ClaimSuccessTipView *view = [ClaimSuccessTipView getInstance];
            [view showWithTitle:kLang(@"successful") tip:kLang(@"use_qgas_to_get_phone_bill_discount_or_just_trade_in_otc_market_")];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
                [AppJumpHelper jumpToTopup];
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
           [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
       }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

- (void)requestReward_claim_invite_v2 {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSString *toAddress = _qgasSendTF.text?:@"";
    NSString *code = _codeTF.text?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"toAddress":toAddress,@"code":code};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl11:reward_claim_invite_v2_Url params:params timestamp:timestamp httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            SuccessTipView *view = [SuccessTipView getInstance];
            [view showWithTitle:kLang(@"successful")];
            
            [weakself backAction:nil];
        } else {
           [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
       }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

- (void)requestVcode_verify_code:(NSString *)type {
    kWeakSelf(self);
    UserModel *userM = [UserModel fetchUserOfLogin];
    NSString *account = userM.account?:@"";
    NSDictionary *params = @{@"account":account,@"type":type};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl10:vcode_verify_code_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
//            [kAppD.window makeToastDisappearWithText:kLang(@"the_verification_code_has_been_sent_successfully")];
            NSString *codeUrlStr = responseObject[@"codeUrl"];
            NSURL *codeUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",codeUrlStr]];
            [weakself.codeImg sd_setImageWithURL:codeUrl placeholderImage:nil completed:nil];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}


#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showSendAddressAction:(id)sender {
    kWeakSelf(self);
    WalletSelectViewController *vc = [[WalletSelectViewController alloc] init];
    vc.inputWalletType = WalletTypeQLC;
    [vc configSelectBlock:^(WalletCommonModel * _Nonnull model) {
        weakself.sendQgasWalletBack.hidden = NO;
        weakself.sendQgasWalletM = model;
        weakself.sendQgasWalletIcon.image = [WalletCommonModel walletIcon:model.walletType];
        weakself.sendQgasWalletNameLab.text = model.name;
        weakself.sendQgasWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
        weakself.qgasSendTF.text = model.address;
//        [WalletCommonModel setCurrentSelectWallet:model]; // 切换钱包
    }];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}


- (IBAction)submitAction:(id)sender {
    if ([_qgasSendTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"address_is_empty")];
        return;
    }
    
    // 检查地址有效性
    BOOL validReceiveAddress = [WalletCommonModel validAddress:_qgasSendTF.text tokenChain:QLC_Chain];
    if (!validReceiveAddress) {
        [kAppD.window makeToastDisappearWithText:kLang(@"wallet_address_is_invalidate")];
        return;
    }
    
    if ([_codeTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"code_cannot_be_empty")];
        return;
    }
    
    if (_claimQGASType == ClaimQGASTypeDailyEarnings) {
        [self requestReward_claim_bind_v2];
    } else if (_claimQGASType == ClaimQGASTypeReferralRewards) {
        [self requestReward_claim_invite_v2];
    } else if (_claimQGASType == ClaimQGASTypeCLAIM_COVID) {
        [self requestGzbd_receive];
    }
}

- (IBAction)sendQgasWalletCloseAction:(id)sender {
    _sendQgasWalletM = nil;
    _sendQgasWalletBack.hidden = YES;
    _qgasSendTF.text = nil;
}

- (IBAction)codeAction:(id)sender {
    if (![UserModel haveLoginAccount]) {
        [kAppD presentLoginNew];
        return;
    }
    
    [self getCode];
}


#pragma mark - Transition

- (void)jumpToChooseWallet {
    ChooseWalletViewController *vc = [[ChooseWalletViewController alloc] init];
    vc.showBack = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
