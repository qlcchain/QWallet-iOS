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

@property (nonatomic, strong) WalletCommonModel *sendQgasWalletM;

@end

@implementation ClaimQGASViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
    _submitBtn.layer.cornerRadius = 4.0;
    _submitBtn.layer.masksToBounds = YES;
    
    _sendQgasWalletBack.hidden = YES;
    
    _qgasSendTF.placeholder = kLang(@"wallet_address");
    _canClaimAmountLab.text = [NSString stringWithFormat:@"%@ QGAS",_inputCanClaimAmount?:@"0"];
}

#pragma mark - Request
- (void)requestReward_claim_bind {
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
    NSDictionary *params = @{@"account":account,@"token":token,@"toAddress":toAddress};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl11:reward_claim_bind_Url params:params timestamp:timestamp httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
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

- (void)requestReward_claim_invite {
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
    NSDictionary *params = @{@"account":account,@"token":token,@"toAddress":toAddress};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl11:reward_claim_invite_Url params:params timestamp:timestamp httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
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
        [WalletCommonModel setCurrentSelectWallet:model]; // 切换钱包
    }];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
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
    
    if (_claimQGASType == ClaimQGASTypeDailyEarnings) {
        [self requestReward_claim_bind];
    } else if (_claimQGASType == ClaimQGASTypeReferralRewards) {
        [self requestReward_claim_invite];
    }
}

- (IBAction)sendQgasWalletCloseAction:(id)sender {
    _sendQgasWalletM = nil;
    _sendQgasWalletBack.hidden = YES;
    _qgasSendTF.text = nil;
}


#pragma mark - Transition

- (void)jumpToChooseWallet {
    ChooseWalletViewController *vc = [[ChooseWalletViewController alloc] init];
    vc.showBack = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
