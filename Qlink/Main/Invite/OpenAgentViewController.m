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
#import "UserUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GlobalConstants.h"
#import "AFJSONRPCClient.h"
#import "ConfigUtil.h"
#import "NSString+RandomStr.h"
#import "RLArithmetic.h"
#import "NSString+RemoveZero.h"
#import "OpenDelegateCheckView.h"
#import "AppJumpHelper.h"
#import "MyStakingsViewController.h"
#import "FirebaseUtil.h"

@interface OpenAgentViewController ()

@property (weak, nonatomic) IBOutlet UIView *personBack;
@property (weak, nonatomic) IBOutlet UIImageView *personIcon;
@property (weak, nonatomic) IBOutlet UILabel *personName;
@property (weak, nonatomic) IBOutlet UIView *openStateBack;
@property (weak, nonatomic) IBOutlet UILabel *openStateLab;


@property (weak, nonatomic) IBOutlet UIImageView *bindWalletIcon;
@property (weak, nonatomic) IBOutlet UILabel *bindWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *bindWalletAddressLab;

@property (weak, nonatomic) IBOutlet UIButton *bindBtn;

@property (nonatomic, strong) WalletCommonModel *bindWalletM;
@property (nonatomic) BOOL isStake1500;

@end

@implementation OpenAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
    [_personBack addVerticalQGradientWithStart:UIColorFromRGB(0xF9BD5E) end:UIColorFromRGB(0xFC7D32) frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _bindBtn.layer.cornerRadius = 4;
    _bindBtn.layer.masksToBounds = YES;
    
    _bindWalletNameLab.text = nil;
    _bindWalletAddressLab.text = nil;
    
    _openStateBack.layer.cornerRadius = 8;
    _openStateBack.layer.masksToBounds = YES;
    _openStateBack.layer.borderColor = [UIColor whiteColor].CGColor;
    _openStateBack.layer.borderWidth = .5;
    
    _personIcon.layer.cornerRadius = 20;
    _personIcon.layer.masksToBounds = YES;
    
    _isStake1500 = _inputStake1500;
    
    [self refreshPersonView];
}

- (void)refreshPersonView {
    UserModel *userM = [UserModel fetchUserOfLogin];
    [_personIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],userM.head]] placeholderImage:User_DefaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    _personName.text = userM.nickname;
    _openStateLab.text = userM.qlcAddress&&userM.qlcAddress.length>0&&_isStake1500?kLang(@"opened"):kLang(@"unopen");
}

- (void)showOpenDelegateSuccessView {
    OpenDelegateSuccessView *view = [OpenDelegateSuccessView getInstance];
    kWeakSelf(self);
    view.okBlock = ^{
        [weakself backAction:nil];
    };
    [view show];
}

- (void)showOpenDelegateCheckView {
    OpenDelegateCheckView *view = [OpenDelegateCheckView getInstance];
    kWeakSelf(self);
    view.okBlock = ^{
//        [AppJumpHelper jumpToWallet];
        [weakself jumpToMyStakings];
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
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl10:user_bind_qlc_address_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
//            [kAppD.window makeToastDisappearWithText:kLang(@"success")];
//            [weakself backAction:nil];
            [UserUtil updateUserInfo];
//            [weakself showOpenDelegateSuccessView];
            [weakself getBeneficialPledgeInfosByAddress];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

- (void)getBeneficialPledgeInfosByAddress {
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_node_release]]];
    NSString *requestId = [NSString randomOf32];
    kWeakSelf(self);
    NSString *address = _bindWalletM.address?:@"";
    NSArray *params = @[address];
    DDLogDebug(@"pledge_getBeneficialPledgeInfosByAddress params = %@",params);
    [kAppD.window makeToastInView:kAppD.window];
    [client invokeMethod:@"pledge_getBeneficialPledgeInfosByAddress" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
        [kAppD.window hideToast];
        DDLogDebug(@"pledge_getBeneficialPledgeInfosByAddress responseObject=%@",responseObject);
        if (responseObject) {
            NSNumber *totalAmounts = [NSNumber numberWithLong:[responseObject[@"TotalAmounts"] longLongValue]];
            NSString *amount = totalAmounts.div(@(QLC_UnitNum));
            if ([amount integerValue] >= 1500) { // 抵押1500QLC
                weakself.isStake1500 = YES;
                [weakself showOpenDelegateSuccessView];
                [weakself refreshPersonView];
                
                [FirebaseUtil logEventWithItemID:PartnerPlan_OpenDelegate_Success itemName:PartnerPlan_OpenDelegate_Success contentType:PartnerPlan_OpenDelegate_Success];
            } else {
                weakself.isStake1500 = NO;
                [weakself showOpenDelegateCheckView];
                [weakself refreshPersonView];
            }
        } else {
            [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"pledge_getBeneficialPledgeInfosByAddress %@",[responseObject mj_JSONString]]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [kAppD.window hideToast];
        NSLog(@"pledge_getBeneficialPledgeInfosByAddress error=%@",error);
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
        
//        [weakself getBeneficialPledgeInfosByAddress];
    }];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)bindAction:(id)sender {
    
    [FirebaseUtil logEventWithItemID:Topup_Home_PartnerPlan_Be_Recharge_Partner itemName:Topup_Home_PartnerPlan_Be_Recharge_Partner contentType:Topup_Home_PartnerPlan_Be_Recharge_Partner];
    
    if (!_bindWalletM) {
        return;
    }
    
    [self requestUser_bind_qlc_address];
}

#pragma mark - Transition
- (void)jumpToMyStakings {
    NSString *inputAddress = _bindWalletM.address?:@"";
    if ([inputAddress isEmptyString]) {
        [AppJumpHelper jumpToWallet];
        return;
    }
    MyStakingsViewController *vc = [MyStakingsViewController new];
    vc.inputAddress = inputAddress;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
