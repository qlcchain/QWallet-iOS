//
//  BuySellDetailViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/8.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ClaimQLCViewController.h"
#import "WalletCommonModel.h"
////#import "QlinkTabbarViewController.h"
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
#import <SDWebImage/UIImageView+WebCache.h>
#import <OutbreakRed/OutbreakRed.h>
#import "NSString+Trim.h"
#import "SignView.h"

@interface ClaimQLCViewController ()

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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeHeight; // 50

@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (nonatomic, strong) NSDictionary *signDic;
@property (nonatomic, strong) SignView *signView;

@property (nonatomic, strong) WalletCommonModel *sendQgasWalletM;

@end

@implementation ClaimQLCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    //[self getCode];
    [self.signView loadLocalHtmlForJsWithHtmlName:@"activieSign"];
}

#pragma mark - Operation
- (void)configInit {
    _submitBtn.layer.cornerRadius = 4.0;
    _submitBtn.layer.masksToBounds = YES;
    
    _sendQgasWalletBack.hidden = YES;
    
    _qgasSendTF.placeholder = kLang(@"wallet_address");
    _canClaimAmountLab.text = [NSString stringWithFormat:@"%@ QLC",_inputCanClaimAmount?:@"0"];
}

- (void)getCode {
    if (_claimQLCType == ClaimQLCTypeMiningRewards) {
        _codeHeight.constant = 0;
    } else if (_claimQLCType == ClaimQLCTypeCLAIM_COVID) {
        _codeHeight.constant = 50;
        NSString *type = @"CLAIM_COVID_QLC";
        [self requestVcode_verify_code:type];
    }
}

#pragma mark - Request
- (void)requestGzbd_claim_qlc {
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
    NSString *toAddress = [_qgasSendTF.text?:@"" trim_whitespace];
    OR_RequestModel *requestM = [OR_RequestModel new];
    requestM.p2pId = [UserModel getTopupP2PId];
    requestM.appBuild = APP_Build;
    requestM.appVersion = APP_Version;
    requestM.serverEnv = [HWUserdefault getObjectWithKey:QLCServer_Environment];
    [kAppD.window makeToastInView:kAppD.window];
  
    [OutbreakRedSDK requestGzbd_claim_qlc2WithAccount:account token:token timestamp:timestamp signDic:self.signDic toAddress:toAddress appKey:Sign_Key scene:Sign_Activity_Scene requestM:requestM completeBlock:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nonnull responseObject, NSError * _Nonnull error) {
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

- (void)requestTrade_mining_claim {
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
    NSString *toAddress = [_qgasSendTF.text?:@"" trim_whitespace];
    NSDictionary *params = @{@"account":account,@"token":token,@"toAddress":toAddress};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl11:trade_mining_claim_Url params:params timestamp:timestamp httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            SuccessTipView *view = [SuccessTipView getInstance];
            [view showWithTitle:kLang(@"successful")];
            
            [weakself backAction:nil];
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
            //NSString *codeUrlStr = responseObject[@"codeUrl"];
            //NSURL *codeUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",codeUrlStr]];
            //[weakself.codeImg sd_setImageWithURL:codeUrl placeholderImage:nil completed:nil];
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
    vc.inputWalletType = WalletTypeNEO;
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
    if (_claimQLCType == ClaimQLCTypeMiningRewards) {
        
    } else if (_claimQLCType == ClaimQLCTypeCLAIM_COVID) {
        if (!self.signDic || self.signDic.count == 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"please_slide_erify")];
            return;
        }
    }
    
    if ([_qgasSendTF.text.trim_whitespace isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"address_is_empty")];
        return;
    }
    
    // 检查地址有效性
    BOOL validReceiveAddress = [WalletCommonModel validAddress:[_qgasSendTF.text trim_whitespace] tokenChain:NEO_Chain];
    if (!validReceiveAddress) {
        [kAppD.window makeToastDisappearWithText:kLang(@"wallet_address_is_invalidate")];
        return;
    }
    
    if (_claimQLCType == ClaimQLCTypeMiningRewards) {
        [self requestTrade_mining_claim];
    } else if (_claimQLCType == ClaimQLCTypeCLAIM_COVID) {
        [self requestGzbd_claim_qlc];
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




#pragma mark - WebViewUIDelegate
- (SignView *)signView
{
    if (!_signView) {
        _signView = [[SignView alloc] initWithFrame:_codeView.bounds];
        
        kWeakSelf(self)
        [_signView setSignResultBlock:^(NSDictionary * _Nonnull resultDic) {
            weakself.signDic = resultDic;
        }];
        
        [_codeView addSubview:_signView];
        [_signView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(weakself.codeView).offset(0);
        }];
        
    }
    return _signView;
}
@end
