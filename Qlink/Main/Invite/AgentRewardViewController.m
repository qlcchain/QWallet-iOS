//
//  AgentRewardViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/1/9.
//  Copyright © 2020 pan. All rights reserved.
//

#import "AgentRewardViewController.h"
#import "UIView+Gradient.h"
#import "OpenAgentViewController.h"
#import <UIImageView+WebCache.h>
#import "UserModel.h"
#import "GlobalConstants.h"
#import "AFJSONRPCClient.h"
#import "ConfigUtil.h"
#import "NSString+RandomStr.h"
#import "RLArithmetic.h"
#import "NSString+RemoveZero.h"
#import "AgentDetailsViewController.h"

@interface AgentRewardViewController ()

@property (weak, nonatomic) IBOutlet UIView *personBack;
@property (weak, nonatomic) IBOutlet UIImageView *personIcon;
@property (weak, nonatomic) IBOutlet UILabel *personName;
@property (weak, nonatomic) IBOutlet UIView *openStateBack;
@property (weak, nonatomic) IBOutlet UILabel *openStateLab;

@property (weak, nonatomic) IBOutlet UILabel *openLab;
@property (weak, nonatomic) IBOutlet UIView *openDelegateBtnBack;

@property (weak, nonatomic) IBOutlet UIView *firstBack;
@property (weak, nonatomic) IBOutlet UIView *secondBack;

@property (weak, nonatomic) IBOutlet UIImageView *agentIcon;
@property (weak, nonatomic) IBOutlet UIImageView *rewardIcon;

@property (nonatomic) BOOL isStake1500;

@end

@implementation AgentRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self getBeneficialPledgeInfosByAddress];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshPersonView];
}

#pragma mark - Operation
- (void)configInit {
    [_personBack addVerticalQGradientWithStart:UIColorFromRGB(0xF9BD5E) end:UIColorFromRGB(0xFC7D32) frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _firstBack.layer.cornerRadius = 4;
    _firstBack.layer.masksToBounds = YES;
    
    _secondBack.layer.cornerRadius = 4;
    _secondBack.layer.masksToBounds = YES;
    
    _openLab.layer.cornerRadius = 8;
    _openLab.layer.masksToBounds = YES;
    [_openDelegateBtnBack addVerticalQGradientWithStart:UIColorFromRGB(0xFE6B4B) end:UIColorFromRGB(0xFC5140) frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _openDelegateBtnBack.layer.cornerRadius = 20;
    _openDelegateBtnBack.layer.masksToBounds = YES;
    
    _openStateBack.layer.cornerRadius = 8;
    _openStateBack.layer.masksToBounds = YES;
    _openStateBack.layer.borderColor = [UIColor whiteColor].CGColor;
    _openStateBack.layer.borderWidth = .5;
    
    _personIcon.layer.cornerRadius = 20;
    _personIcon.layer.masksToBounds = YES;
    
    NSString *agentImgStr = @"";
    NSString *rewardImgStr = @"";
    NSString *language = [Language currentLanguageCode];
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        agentImgStr = @"agent_details_en";
        rewardImgStr = @"agent_details_b_en";
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        agentImgStr = @"agent_details_ch";
        rewardImgStr = @"agent_details_b_ch";
    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
        agentImgStr = @"agent_details_en";
        rewardImgStr = @"agent_details_b_en";
    }
    _agentIcon.image = [UIImage imageNamed:agentImgStr];
    _rewardIcon.image = [UIImage imageNamed:rewardImgStr];
    
    _isStake1500 = NO;
    
    [self refreshPersonView];
    
}

- (void)refreshPersonView {
    UserModel *userM = [UserModel fetchUserOfLogin];
    [_personIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],userM.head]] placeholderImage:User_DefaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    _personName.text = userM.nickname;
    _openStateLab.text = userM.qlcAddress&&userM.qlcAddress.length>0&&_isStake1500?kLang(@"opened"):kLang(@"unopen");
}

#pragma mark - Request
- (void)getBeneficialPledgeInfosByAddress {
    UserModel *userM = [UserModel fetchUserOfLogin];
    NSString *address = @"";
    if (userM.qlcAddress && userM.qlcAddress.length > 0) {
        address = userM.qlcAddress;
    } else {
        return;
    }
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_node_release]]];
    NSString *requestId = [NSString randomOf32];
    kWeakSelf(self);
//    NSString *address = _bindWalletM.address?:@"";
    NSArray *params = @[address];
    DDLogDebug(@"pledge_getBeneficialPledgeInfosByAddress params = %@",params);
//    [kAppD.window makeToastInView:kAppD.window];
    [client invokeMethod:@"pledge_getBeneficialPledgeInfosByAddress" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
//        [kAppD.window hideToast];
        DDLogDebug(@"pledge_getBeneficialPledgeInfosByAddress responseObject=%@",responseObject);
        if (responseObject) {
            NSNumber *totalAmounts = [NSNumber numberWithLong:[responseObject[@"TotalAmounts"] longLongValue]];
            NSString *amount = totalAmounts.div(@(QLC_UnitNum));
            if ([amount integerValue] >= 1500) { // 抵押1500QLC
                weakself.isStake1500 = YES;
                [weakself refreshPersonView];
            } else {
                weakself.isStake1500 = NO;
                [weakself refreshPersonView];
            }
        } else {
//            [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"pledge_getBeneficialPledgeInfosByAddress %@",[responseObject mj_JSONString]]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [kAppD.window hideToast];
        NSLog(@"pledge_getBeneficialPledgeInfosByAddress error=%@",error);
    }];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)openDelegateAction:(id)sender {
    [self jumpToOpenDelegate];
    
    
}


- (IBAction)detailsAction:(id)sender {
    [self jumpToAgentDetails];
}


#pragma mark - Transition
- (void)jumpToOpenDelegate {
    OpenAgentViewController *vc = [OpenAgentViewController new];
    vc.inputStake1500 = _isStake1500;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToAgentDetails {
    AgentDetailsViewController *vc = [AgentDetailsViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
