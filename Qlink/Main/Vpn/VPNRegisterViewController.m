//
//  VPNAddViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2018/3/30.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VPNRegisterViewController.h"
#import "VPNRegisterView1.h"
#import "VPNRegisterView2.h"
#import "VPNRegisterView3.h"
#import "ChooseContinentViewController.h"
#import "ChooseCountryUtil.h"
#import "SeizeVPNViewController.h"
#import <NetworkExtension/NetworkExtension.h>
#import "SelectCountryModel.h"
#import "VPNFileUtil.h"
#import "HistoryRecrdInfo.h"
#import "WalletUtil.h"
#import "HeartbeatUtil.h"
#import "TransferUtil.h"
#import "VPNOperationUtil.h"
#import "Qlink-Swift.h"

typedef enum : NSUInteger {
    RegisterStepOne,
    RegisterStepTwo,
    RegisterStepThree,
} RegisterStep;

@interface VPNRegisterViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) VPNRegisterView1 *registerV1;
@property (nonatomic, strong) VPNRegisterView2 *registerV2;
@property (nonatomic, strong) VPNRegisterView3 *registerV3;
@property (weak, nonatomic) IBOutlet UIImageView *stepOneV;
@property (weak, nonatomic) IBOutlet UIImageView *stepTwoV;
@property (weak, nonatomic) IBOutlet UIImageView *stepThreeV;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic) RegisterStep registerStep;
@property (nonatomic) BOOL assetIsValidate;
@property (nonatomic,copy) NSString *hex;
@end

@implementation VPNRegisterViewController

#pragma mark - Noti
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vpnStatusChange:) name:VPN_STATUS_CHANGE_NOTI object:nil];
}

- (instancetype) initWithRegisterType:(RegisterType) type
{
    if (self = [super init]) {
        _registerType = type;
    }
    return self;
}

- (instancetype) initWithRegisterType:(RegisterType) type withVPNName:(NSString *) name withSeizePrice:(NSString *) seize_price withOldPrice:(NSString *) old_price vpnAddress:(NSString *)address vpnP2pid:(NSString *) toP2pid
{
    if (self = [super init]) {
        _registerType = type;
        self.vpnName = name;
        self.seizePrice = seize_price;
        self.oldPrice = old_price;
        self.vpnAddress = address;
        self.vpnP2pid = toP2pid;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _registerStep = RegisterStepOne;
    [self dataInit];
    [self configView];
    if (_registerType == SeizeVPN) {
        [self.registerV1 setVPNName:self.vpnName deposit:self.seizePrice oldPrice:self.oldPrice];
    } else if (_registerType == UpdateVPN) {
        _lblNavTitle.text = NSStringLocalizable(@"vpn_detail");
        [self configureVPNInfo];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.registerV1.frame = _contentView.bounds;
//    self.registerV2.frame = _contentView.bounds;
//    self.registerV3.frame = _contentView.bounds;
}

#pragma mark - Operation
- (void)dataInit {
    if (_registerType == SeizeVPN || _registerType == UpdateVPN) {
        _assetIsValidate = YES;
    } else {
         _assetIsValidate = NO;
    }
}

#pragma -mark UPDATE_VPN初始化
- (void) configureVPNInfo
{
    if (_registerType == UpdateVPN) {
        [self.registerV1 setVPNInfo:self.vpnInfo];
        [self.registerV2 setVPNInfo:self.vpnInfo];
        [self.registerV3 setVPNInfo:self.vpnInfo];
    }
}

- (void)configView {
    [_contentView addSubview:self.registerV1];
    [self.registerV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(_contentView).offset(0);
    }];
    [_contentView addSubview:self.registerV2];
    [self.registerV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(_contentView).offset(0);
    }];
    [_contentView addSubview:self.registerV3];
    [self.registerV3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(_contentView).offset(0);
    }];
    
    [_nextBtn setTitle:NSStringLocalizable(@"next") forState:UIControlStateNormal];
    if (_registerStep == RegisterStepOne) {
        [_contentView bringSubviewToFront:self.registerV1];
        _stepOneV.image = [UIImage imageNamed:@"icon_step_one"];
        _stepTwoV.image = [UIImage imageNamed:@"icon_step_two"];
        _stepThreeV.image = [UIImage imageNamed:@"icon_step_three"];
    } else if (_registerStep == RegisterStepTwo) {
        [_contentView bringSubviewToFront:self.registerV2];
        _stepOneV.image = [UIImage imageNamed:@"icon_step_one_completed"];
        _stepTwoV.image = [UIImage imageNamed:@"icon_step_two_being"];
        _stepThreeV.image = [UIImage imageNamed:@"icon_step_three"];
    } else if (_registerStep == RegisterStepThree) {
        [_contentView bringSubviewToFront:self.registerV3];
        [_nextBtn setTitle:NSStringLocalizable(@"finsh") forState:UIControlStateNormal];
        _stepOneV.image = [UIImage imageNamed:@"icon_step_one_completed"];
        _stepTwoV.image = [UIImage imageNamed:@"icon_step_two_complete"];
        _stepThreeV.image = [UIImage imageNamed:@"icon_step_three_being"];
    }
}

- (void)vpnStatusChange:(NSNotification *)noti {
    if (_registerStep == RegisterStepTwo) {
        NEVPNStatus status = (NEVPNStatus)[noti.object integerValue];
        switch (status) {
                case NEVPNStatusInvalid:
                break;
                case NEVPNStatusDisconnected:
                break;
                case NEVPNStatusConnecting:
                break;
                case NEVPNStatusConnected:
            {
            }
                break;
                case NEVPNStatusReasserting:
                break;
                case NEVPNStatusDisconnecting:
            {
            }
                break;
            default:
                break;
        }
    }
}

- (void)validateAssetIsexist {
    if (_registerType == RegisterVPN) {
        [self requestValidateAssetIsexist];
    }
}
- (void)storeRegisterVPN:(NSDictionary *)dic {
    VPNInfo *localVpnInfo = [VPNInfo new];
    localVpnInfo.bg_tableName = VPNREGISTER_TABNAME;
    localVpnInfo.vpnName = dic[@"vpnName"];
    localVpnInfo.country = dic[@"country"];
    localVpnInfo.p2pId = dic[@"p2pId"];
    localVpnInfo.address = dic[@"address"];
    localVpnInfo.qlc = dic[@"qlc"];
    localVpnInfo.registerQlc = dic[@"qlc"];
    localVpnInfo.connectNum = dic[@"connectNum"];
    localVpnInfo.connectCost = dic[@"connectCost"];
    localVpnInfo.ipV4Address = dic[@"ipV4Address"];
    localVpnInfo.bandwidth = dic[@"bandWidth"];
    localVpnInfo.profileLocalPath = dic[@"profileLocalPath"];
    localVpnInfo.isMainNet = [WalletUtil checkServerIsMian];
    [localVpnInfo bg_saveOrUpdate];
    // 更新keyChain
    [VPNOperationUtil saveArrayToKeyChain];
}

#pragma mark - Request
- (void)requestValidateAssetIsexist {
    @weakify_self
    NSDictionary *params = @{@"vpnName":_registerV1.vpnName,@"type":@"3"};
    [RequestService requestWithUrl:validateAssetIsexist_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == Server_Code_Success) {
            if ([responseObject[Server_Data][@"isExist"] integerValue] == 0) { // vpnname不存在
                weakSelf.registerType = RegisterVPN;
                _assetIsValidate = YES;
//                [weakSelf.registerV1 unableClaim];
            } else { // vpnname存在
                _assetIsValidate = YES;
//                [weakSelf.registerV1 enableClaim];
                weakSelf.registerType = SeizeVPNWhenRegister;
                weakSelf.vpnName = weakSelf.registerV1.vpnName;
//                weakSelf.seizePrice = nil;
                NSString *oldPrice = [NSString stringWithFormat:@"%@",@([responseObject[Server_Data][@"qlc"] floatValue])];
                weakSelf.oldPrice = oldPrice;
                [weakSelf.registerV1 setClaimText:oldPrice];
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [AppD.window showHint:error.domain];
    }];
    
}

// 查询vpn资产信息
- (void)requestssIdquery {
    @weakify_self
    [AppD.window showHudInView:self.view hint:nil];
    NSDictionary *params = @{@"ssId":_registerV1.vpnName};
    [RequestService requestWithUrl:ssIdquery_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [AppD.window hideHud];
        if ([responseObject[Server_Code] integerValue] == Server_Code_Success) {
            weakSelf.vpnP2pid = responseObject[Server_Data][@"p2pId"]?:@"";
            weakSelf.vpnAddress = responseObject[Server_Data][@"address"]?:@"";
            [weakSelf scrollToStepTwo];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [AppD.window hideHud];
        [AppD.window showHint:error.domain];
    }];
    
}

// vpn验证成功后调用
- (void)requestRegisterVpnByFeeV3 {
    if (_registerType == UpdateVPN) {
        [self sendUpdateVPNRequest];
    } else {
        [self registerVPNAndTranQLC];
    }
}



//获取主网地址
- (void) sendMainAddressRequst
{
    [AppD.window showHudInView:self.view hint:nil];
    if (self.registerType == SeizeVPN || self.registerType == SeizeVPNWhenRegister) {
        [self getHexWithAddress:[NSStringUtil getNotNullValue:_vpnAddress]];
    } else {
        // 获取主网地址地址
        @weakify_self
        [RequestService requestWithUrl:mainAddress_Url params:@[] httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
            if ([responseObject[Server_Code] integerValue] == Server_Code_Success) {
                NSDictionary *dataDic = [responseObject objectForKey:@"data"];
                if (dataDic) {
                    NSString *toAddress = [dataDic objectForKey:@"address"];
                    weakSelf.vpnAddress = [NSStringUtil getNotNullValue:toAddress];
                    [weakSelf getHexWithAddress:weakSelf.vpnAddress];
                } else {
                    [AppD.window hideHud];
                }
            } else {
                [AppD.window hideHud];
                [weakSelf.view showHint:responseObject[Server_Msg]];
            }
            
        } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
            [AppD.window hideHud];
            [AppD.window showHint:NSStringLocalizable(@"request_error")];
        }];
    }
}

/**
 获取hex
 @param toAddress 发送到地址
 */
- (void) getHexWithAddress:(NSString *) toAddress  {
    @weakify_self
    NSString *qlc = _registerV1.deposit;
    // 获取主测网的hash
    NSString *tokenHash = AESSET_TEST_HASH;
    if ([WalletUtil checkServerIsMian]) {
        tokenHash = AESSET_MAIN_HASH;
    }
    // 获取 hex
    [WalletManage.shareInstance3 sendQLCWithAddressWithIsQLC:true address:toAddress tokeHash:tokenHash qlc:qlc completeBlock:^(NSString* complete) {
        if ([[NSStringUtil getNotNullValue:complete] isEmptyString]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [AppD.window hideHud];
                [AppD.window showHint:NSStringLocalizable(@"VPNRegFailed")];
            });
        } else { // 获取到hex
            // 检测vpn配置文件
            [AppD.window hideHud];
            weakSelf.hex = complete;
            [weakSelf.registerV2 verifyProfile];
        }
    }];
}

// 注册并转帐
- (void) registerVPNAndTranQLC
{
    [AppD.window showHudInView:self.view hint:nil];
     @weakify_self
    NSString *vpnName = _registerV1.vpnName?:@"";
    NSString *country = _registerV1.selectCountry?:@"";
    NSString *p2pId = [ToxManage getOwnP2PId];
    NSString *address = [CurrentWalletInfo getShareInstance].address;
    NSString *qlc = _registerV1.deposit;
    NSString *connectCost = _registerV3.hourlyFee?:@"";
    NSString *connectNum = _registerV3.connectNum?:@"";
    NSString *ipV4Address = @"";
    NSString *bandWidth = @"";
    //    NSString *profileLocalPath = [VPNFileUtil getVPNPathWithFileName:_registerV2.profileName]?:@"";
    NSString *profileLocalPath = _registerV2.profileName?:@"";
    if (!weakSelf.vpnInfo) {
        _vpnInfo = [[VPNInfo alloc] init];
        _vpnInfo.vpnName = vpnName;
        _vpnInfo.cost = qlc;
        _vpnInfo.address = address;
        if (weakSelf.registerType == SeizeVPN || weakSelf.registerType == SeizeVPNWhenRegister) {
            _vpnInfo.address = [NSStringUtil getNotNullValue:_vpnAddress];
            _vpnInfo.p2pId = [NSStringUtil getNotNullValue:_vpnP2pid];
        }
    }
    
    NSDictionary *params = @{@"vpnName":vpnName,@"country":country,@"p2pId":p2pId,@"address":address,@"tx":weakSelf.hex,@"qlc":qlc,@"connectCost":connectCost,@"connectNum":connectNum,@"ipV4Address":ipV4Address,@"bandWidth":bandWidth,@"profileLocalPath":profileLocalPath};
    
    [RequestService requestWithUrl:ssIdregisterVpnByFeeV4_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [VPNUtil.shareInstance stopVPN]; // 关掉vpn连接
        [AppD.window hideHud];
        if ([responseObject[Server_Code] integerValue] == Server_Code_Success) {
            // 移除抢注的vs
            if (weakSelf.registerType == SeizeVPN || weakSelf.registerType == SeizeVPNWhenRegister) {
                if (weakSelf.registerType == SeizeVPN) {
                    [weakSelf moveNavgationBackOneViewController];
                }
                //TODO:转账成功之后发p2p消息告诉接收者
                [TransferUtil sendVPNConnectSuccessMessageWithVPNInfo:_vpnInfo withType:5];
                [[NSNotificationCenter defaultCenter] postNotificationName:SEIZE_VPN_SUCCESS_NOTI object:nil];
            }
            // 发送扣款通知
            [TransferUtil sendLocalNotificationWithQLC:_vpnInfo.cost isIncome:NO];
            // 保存交易记录
            [WalletUtil saveTranQLCRecordWithQlc:_vpnInfo.cost txtid:[NSStringUtil getNotNullValue:responseObject[@"recordId"]] neo:@"0" recordType:5 assetName:_vpnInfo.vpnName friendNum:0 p2pID:[NSStringUtil getNotNullValue:_vpnInfo.p2pId] connectType:0 isReported:NO];
            // 本地保存注册的vpn资产
            [weakSelf storeRegisterVPN:params];
            // 发送心跳
            [HeartbeatUtil sendHeartbeatRequest];
            [weakSelf back];
        } else {
            [weakSelf.view showHint:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [VPNUtil.shareInstance stopVPN]; // 关掉vpn连接
        [AppD.window hideHud];
        [AppD.window showHint:error.domain];
    }];
}

- (void) sendUpdateVPNRequest
{
    @weakify_self
    self.vpnInfo.vpnName = _registerV1.vpnName?:@"";
    self.vpnInfo.country = _registerV1.selectCountry?:@"";
    self.vpnInfo.p2pId = [ToxManage getOwnP2PId];
    self.vpnInfo.qlc = _registerV1.deposit;
    self.vpnInfo.connectCost = _registerV3.hourlyFee?:@"";
    self.vpnInfo.connectNum = _registerV3.connectNum?:@"";
    self.vpnInfo.ipV4Address = @"";
    self.vpnInfo.bandwidth = @"";
    self.vpnInfo.profileLocalPath = _registerV2.profileName?:@"";
    [AppD.window showHudInView:self.view hint:nil];
    
    NSDictionary *params = @{@"vpnName":self.vpnInfo.vpnName,@"country":self.vpnInfo.country,@"p2pId":self.vpnInfo.p2pId,@"qlc":self.vpnInfo.qlc,@"connectCost":self.vpnInfo.connectCost,@"connectNum":self.vpnInfo.connectNum,@"ipV4Address":self.vpnInfo.ipV4Address,@"bandWidth":self.vpnInfo.bandwidth,@"profileLocalPath":self.vpnInfo.profileLocalPath};
    [RequestService requestWithUrl:ssIdupdateVpnInfoV3_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
         [VPNUtil.shareInstance stopVPN]; // 关掉vpn连接
        [AppD.window hideHud];
        if ([responseObject[Server_Code] integerValue] == Server_Code_Success) {
            // 修改本地数据库
            [weakSelf.vpnInfo bg_saveOrUpdateAsync:^(BOOL isSuccess) {
                if (isSuccess) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_ASSETS_TZ object:nil];
                }
            }];
            [weakSelf back];
        } else {
            [AppD.window showHint:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
         [VPNUtil.shareInstance stopVPN]; // 关掉vpn连接
        [AppD.window hideHud];
        [AppD.window showHint:error.domain];
    }];
    
    //    code = 0;
    //    isFirstRegister = 1;
    //    msg = "Request success";
    //    recordId = d5ac8e7a69641fda9e688f410b3e5c2efc8102df5df8406e3a905de3f2e723b0;
    //    vpnName = Ovpnjf;
}

#pragma mark - Aciton
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backAction:(id)sender {
    [self back];
}

- (IBAction)cancelAction:(id)sender {
    [self back];
}

- (IBAction)nextBtnAction:(UIButton *)sender {
    if (_registerStep == RegisterStepOne) {
        if ([_registerV1 isEmptyOfCountry]) {
            [AppD.window showHint:NSStringLocalizable(@"choose_country")];
            return;
        }
        if ([_registerV1 isEmptyOfDeposit]) {
            [AppD.window showHint:NSStringLocalizable(@"depost_empty")];
            return;
        }
//        if ([_registerV1 isEmptyOfClaim]) {
//            [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionCenten title:@"请填写claim"];
//            return;
//        }
        if ([_registerV1 isEmptyOfVPNName]) {
            [AppD.window showHint:NSStringLocalizable(@"vpnName_empty")];
            return;
        }
        if (_registerType == SeizeVPNWhenRegister) {
            if ([_registerV1.deposit floatValue] <= [_registerV1.claim floatValue]) {
                [AppD.window showHint:NSStringLocalizable(@"original_price")];
                return;
            }
        }
        
        if (_assetIsValidate) { // vpnname不存在
            if (_registerType == SeizeVPNWhenRegister) {
                [self requestssIdquery];
            } else {
                [self scrollToStepTwo];
            }
        }
    } else if (_registerStep == RegisterStepTwo) {
        if ([_registerV2 isEmptyOfProfile]) {
            [AppD.window showHint:NSStringLocalizable(@"choose_a_profile")];
            return;
        }
//        [self.registerV2 verifyProfile];
        [self scrollToStepThree];
    } else if (_registerStep == RegisterStepThree) {
        
        if (_registerType == UpdateVPN) {
            [self.registerV2 verifyProfile];
        } else {
            [self sendMainAddressRequst];
        }
        
//        [self.registerV2 verifyProfile];
//        [self requestRegisterVpnByFeeV3];
//        [self back];
    }
}

- (void)scrollToStepTwo {
    _registerStep = RegisterStepTwo;
    [self configView];
}

- (void)scrollToStepThree {
    _registerStep = RegisterStepThree;
    [self configView];
}

#pragma mark - Transition
- (void)jumpToChooseContinent {
    [ChooseCountryUtil shareInstance].entry = VPNRegister;
    ChooseContinentViewController *vc = [[ChooseContinentViewController alloc] init];
    if (_registerV1.selectCountry) {
        vc.inputContinent = [ChooseCountryUtil getContinentOfCountry:_registerV1.selectCountry];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToSeizeVPN {
    SeizeVPNViewController *vc = [[SeizeVPNViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Lazy
- (VPNRegisterView1 *)registerV1 {
    if (!_registerV1) {
        _registerV1 = [VPNRegisterView1 getNibView];
        _registerV1.registerVC = self;
    }
    
    return _registerV1;
}

- (VPNRegisterView2 *)registerV2 {
    if (!_registerV2) {
        _registerV2 = [VPNRegisterView2 getNibView];
        _registerV2.registerVC = self;
    }
    
    return _registerV2;
}

- (VPNRegisterView3 *)registerV3 {
    if (!_registerV3) {
        _registerV3 = [VPNRegisterView3 getNibView];
        _registerV3.registerVC = self;
    }
    
    return _registerV3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
