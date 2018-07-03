//
//  WalletViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "WalletViewController.h"
#import "SkyRadiusView.h"
#import "WalletPublicAddressViewController.h"
#import "WalletMenuView.h"
#import "BuyQlcView.h"
#import "SendFundsView.h"
#import "WalletAddressView.h"
#import <Hero/Hero-Swift.h>
#import "RatesMode.h"
//#import "WalletDetailViewController.h"
//#import "UIView+Animation.h"
#import "UIView+Animation.h"
#import "ProfileViewController.h"
#import "HistoryRecordsViewController.h"
#import "BalanceInfo.h"
#import "WalletUtil.h"
#import "SRRefreshView.h"
#import "WalletQRViewController.h"
#import "MyAssetsView.h"
//#import "UIButton+UserHead.h"
#import "NSDate+Category.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "VPNRegisterViewController.h"
#import "Qlink-Swift.h"
#import "SettingViewController.h"
#import "GuideEnterWalletView.h"
#import "GuideSettingMoreView.h"

#define WAIL_TIME 30

@interface WalletViewController () <UIScrollViewDelegate,SRRefreshDelegate>
{
    MyAssetsView *assetsView;
}

@property (weak, nonatomic) IBOutlet UIView *menuBack;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *refreshScroll;
@property (weak, nonatomic) IBOutlet UIButton *userHeadBtn;
@property (weak, nonatomic) IBOutlet UIImageView *testView1;
@property (weak, nonatomic) IBOutlet UILabel *lblNeo;
@property (weak, nonatomic) IBOutlet UILabel *lblQlc;
@property (weak, nonatomic) IBOutlet UILabel *lblGas;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewConstraintH;

@property (nonatomic ,strong) BalanceInfo *balanceInfo;
@property (nonatomic ,strong) RatesMode *ratesInfo;

@property (weak, nonatomic) IBOutlet UILabel *lblmyNEO;
@property (weak, nonatomic) IBOutlet UILabel *lblmyQLC;
@property (weak, nonatomic) IBOutlet UILabel *lblmyGAS;

@property (nonatomic, strong) SRRefreshView *slimeView;

@end

@implementation WalletViewController
- (IBAction)clickDetail:(id)sender {
    
//    WalletDetailViewController *vc = [[WalletDetailViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    SettingViewController *vc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
     self.navigationController.isHeroEnabled = NO;
    if (!_slimeView) {
        [_refreshScroll addSubview:self.slimeView];
    }
    
//    [self addNewGuide];
    [self addNewGuideEnterWallet];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 得到当前钱包信息
    if ( [WalletUtil isExistWalletPrivateKey]) {
        [WalletUtil getCurrentWalletInfo];
    };
    if (![WalletUtil shareInstance].isLock) {
        [self reSendReqeuest];
    }

    [self addWalletMenu];

    // 注册钱包发生变化时  获取资产通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(walletDidChange:) name:WALLET_CHANGE_TZ object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reSendReqeuest) name:WALLET_RELOAD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeServer:) name:CHANGE_SERVER_NOTI object:nil];
}

#pragma mark - Config View
- (void)refreshContent {
    
}

- (void)addNewGuideEnterWallet {
    CGRect hollowOutFrame = [_settingBtn.superview convertRect:_settingBtn.frame toView:[UIApplication sharedApplication].keyWindow];
    @weakify_self
    [[GuideEnterWalletView getNibView] showGuideTo:hollowOutFrame tapBlock:^{
        [weakSelf addNewGuideSettingMore];
    }];
}

- (void)addNewGuideSettingMore {
    CGRect circleFrame1 = [_settingBtn.superview convertRect:_settingBtn.frame toView:[UIApplication sharedApplication].keyWindow];
    CGRect circleFrame2 = CGRectMake((3.0*(0.0+1.0)-2.0)*SCREEN_WIDTH/(3.0*3.0), SCREEN_HEIGHT - 49, 49, 49);
    [[GuideSettingMoreView getNibView] showGuideToCircle1:circleFrame1 circle2:circleFrame2 tapBlock:^{
        
    }];
}

- (void) changeServer:(NSNotification *) noti
{
    if (assetsView) {
        [assetsView dismiss];
        assetsView = nil;
    }
    AppD.balanceInfo = nil;
    _lblmyQLC.text = @"0";
    _lblmyNEO.text = @"0";
    _lblmyGAS.text = @"0";
    
    [self reSendReqeuest];
}

- (void)addWalletMenu {
    // 计算contentview高度
    _contentViewConstraintH.constant = SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-Tab_BAR_HEIGHT-20;
    @weakify_self
    WalletMenuView *menu = [WalletMenuView getNibView];
    [_menuBack addSubview:menu];
    [menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(weakSelf.menuBack).offset(0);
//        make.height.mas_equalTo(@(.5));
    }];
    [menu configWalletMenu:^(WalletType type) {
    
            switch (type) {
                case RegisteredAssets: {
                    [self showRegisteredAssets];
                }
                    break;
                case SendFunds: {
                    if (!self.balanceInfo) {
                        [AppD.window showHint:NSStringLocalizable(@"wait")];
                    } else {
                        [self showSendFunds];
                    }
                }
                    break;
                case ViewHistory: {
                    [self showViewHistory];
                }
                    break;
                case BuyQlc: {
                    if (!self.balanceInfo || !self.ratesInfo) {
                        [AppD.window showHint:NSStringLocalizable(@"wait")];
                    } else {
                       [self showBuyQlc];
                    }
                }
                    break;
                    
                default:
                    break;
            }
    }];
}

/**
 显示 registered assets view
 */
- (void)showRegisteredAssets {
//    WalletAddressView *view = [WalletAddressView getNibView];
//    [view.codeBtn addTarget:self action:@selector(clcikCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
//    view.frame = CGRectMake(0, 0, _menuBack.width, _menuBack.height);
//    [_menuBack addSubview:view];
//    [view zoomInAnimationDuration:.6];
    
    assetsView = [MyAssetsView getNibView];
    assetsView.frame = CGRectMake(0, 0, _menuBack.width, _menuBack.height);
    [_menuBack addSubview:assetsView];
    [assetsView zoomInAnimationDuration:.6];
    
    @weakify_self
    [assetsView setSetBlock:^(id mode) {
        if ([mode isKindOfClass:[VPNInfo class]]) { // vpn
            [weakSelf jumpRegisterVPNWithMode:(VPNInfo *)mode];
        } else { // wifi
            
        }
       
    }];
}

- (void) clcikCodeBtn:(UIButton *) sender
{
    WalletPublicAddressViewController *vc = [[WalletPublicAddressViewController alloc] init];
    self.navigationController.isHeroEnabled = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 显示send funds view
 */
- (void)showSendFunds {
    SendFundsView *view = [SendFundsView getNibView];
    view.frame = CGRectMake(0, 0, _menuBack.width, _menuBack.height);
    [_menuBack addSubview:view];
    [view zoomInAnimationDuration:.6];
    
    __weak __typeof__(view) bView = view;
    @weakify_self
    [bView setSendBlock:^(BalanceType type) {
        switch (type) {
            case TxtChangeType:
                // qlc 为 0 时 不能输入
                if ([weakSelf.balanceInfo.qlc floatValue] == 0.f) {
                    bView.txtMoney.text = @"";
                    break;
                }
                if ([bView.txtMoney.text floatValue] > [weakSelf.balanceInfo.qlc floatValue]) {
                    bView.txtMoney.text = weakSelf.balanceInfo.qlc;
                }
                break;
            case MaxType:
                // qlc 为 0 时 不能输入
                if ([weakSelf.balanceInfo.qlc floatValue] == 0.f) {
                    bView.txtMoney.text = @"";
                    break;
                }
                bView.txtMoney.text = weakSelf.balanceInfo.qlc;
                break;
            case CodeType:
                [weakSelf jumpQRVCWithAddressView:bView.lblAddress];
                break;
            case SendNowType:
                // gas 检查
                if ([self.balanceInfo.gas floatValue] <= 0.00000001) {
                    [AppD.window showWalletAlertViewWithTitle:NSStringLocalizable(@"prompt") msg:[[NSMutableAttributedString alloc] initWithString:NSStringLocalizable(@"sendig_gas_tran")] isShowTwoBtn:NO block:nil];
                } else {
                 // 确认是否交易
                        NSString *msg = [NSString stringWithFormat:@"%@ %@ %@%@?",NSStringLocalizable(@"want_send"),bView.txtMoney.text,NSStringLocalizable(@"qlc_to"),bView.lblAddress.text];
                        NSMutableAttributedString *msgArrtrbuted = [[NSMutableAttributedString alloc] initWithString:msg];
                        [msgArrtrbuted addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:16.0] range:[msg rangeOfString:bView.txtMoney.text]];
                    @weakify_self
                        [AppD.window showWalletAlertViewWithTitle:NSStringLocalizable(@"withdrawal") msg:msgArrtrbuted isShowTwoBtn:YES block:^{
                            
                             [weakSelf sendFundsRequestWithAddressTo:bView.lblAddress.text.trim qlc:bView.txtMoney.text.trim];
                        }];
                    
                }
               
                break;
                
            default:
                break;
        }
    }];
}
#pragma -mark jump vc
- (void) jumpQRVCWithAddressView:(UILabel *) lblAddress
{
    __weak typeof(lblAddress) weakAddress = lblAddress;
    WalletQRViewController *vc = [[WalletQRViewController alloc] initWithCodeQRCompleteBlock:^(NSString *codeValue) {
        weakAddress.text = codeValue;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) jumpRegisterVPNWithMode:(VPNInfo *) mode
{
    VPNRegisterViewController *vc = [[VPNRegisterViewController alloc] initWithRegisterType:UpdateVPN];
    vc.vpnInfo = mode;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 显示view history view
 */
- (void)showViewHistory {
    [self pushToHistory];
}


- (void)pushToHistory {
    HistoryRecordsViewController *vc = [[HistoryRecordsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 显示buy qlc view
 */
- (void)showBuyQlc {
    BuyQlcView *view = [BuyQlcView getNibView];
    view.frame = CGRectMake(0, 0, _menuBack.width, _menuBack.height);
    view.lblNEOToQLC.text = _lblNeo.text;
    [_menuBack addSubview:view];
    [view zoomInAnimationDuration:.6];
    
    __weak __typeof__(view) bView = view;
    @weakify_self
    [bView setBuyBlcok:^(BuyType type) {
        switch (type) {
            case BuyQLCType:
                [self sendBuyQLCRequestWithNeo:bView.txtNEO.text];
                break;
            case BuyMaxType:
                
                if ([weakSelf.balanceInfo.neo floatValue] == 0.f) {
                    bView.txtQLC.text = @"";
                    bView.txtNEO.text = @"";
                    break;
                }
                bView.txtNEO.text = weakSelf.balanceInfo.neo;
                bView.txtQLC.text = [NSString stringWithFormat:@"%.2f",[bView.txtNEO.text floatValue]*[weakSelf.ratesInfo.neoInfo.qlc floatValue]];
                break;
                
            case BuyTxtChangeType:
                
                if ([bView.txtNEO.text floatValue] == 0.f) {
                    bView.txtQLC.text = @"";
                    bView.txtNEO.text = @"";
                    break;
                }
                if ([bView.txtNEO.text floatValue] > [weakSelf.balanceInfo.neo floatValue]) {
                    bView.txtNEO.text = weakSelf.balanceInfo.neo;
                }
                bView.txtQLC.text = [NSString stringWithFormat:@"%.2f",[bView.txtNEO.text floatValue]*[weakSelf.ratesInfo.neoInfo.qlc floatValue]];
                break;
                
            default:
                break;
        }
    }];
}



#pragma mark - Action
- (IBAction)personAction:(id)sender {
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _refreshScroll) {
//        if (_refreshScroll.contentOffset.y > 0) { // 禁止上滑
//            _refreshScroll.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
//        }
        
        if (_slimeView) {
            [_slimeView scrollViewDidScroll];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _refreshScroll) {
        if (_slimeView) {
            [_slimeView scrollViewDidEndDraging];
        }
    }
}

#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView {
    [self reSendReqeuest];
}

- (void)endRefresh {
    [_slimeView endRefresh];
}

/**
 重新请求资产 和汇率
 */
- (void) reSendReqeuest
{
    // 获取汇率
    [self sendGetRateRequest];
}

/**
 neo 兑换 qlc 请求
 @param neo neo
 */
- (void) sendBuyQLCRequestWithNeo:(NSString *) neo
{
    [AppD.window showHudInView:self.view hint:NSStringLocalizable(@"Loading")];
    // 获取NEO交换地址
    [RequestService requestWithUrl:mainAddress_Url params:@[] httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
         NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        if (dataDic) {
           NSString *toAddress = [dataDic objectForKey:@"address"];
            // 获取未交易记录
            @weakify_self
            [WalletManage.shareInstance3 sendNEOTranQLCWithAddressWithAddress:toAddress tokeHash:@"" qlc:neo completeBlock:^(NSString* complete) {
                if ([[NSStringUtil getNotNullValue:complete] isEmptyString]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [AppD.window hideHud];
                        [AppD.window showHint:NSStringLocalizable(@"buy_qlc")];
                    });
                } else {
                    // 发送兑换请求
                    NSDictionary *parames = @{@"tx":complete,@"exchangeId":[WalletUtil getExChangeId],@"address":[CurrentWalletInfo getShareInstance].address,@"neo":neo};
                    [RequestService requestWithUrl:neoExchangeQlcV2_Url params:parames httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
                        [AppD.window hideHud];
                        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
                        if (dataDic) {
                            BOOL result = [[dataDic objectForKey:@"result"] boolValue];
                            if (result) { // 兑换成功
                                [weakSelf.view showWalletAlertViewWithTitle:NSStringLocalizable(@"purchase_successful") msg:[[NSMutableAttributedString alloc] initWithString:NSStringLocalizable(@"withdrawal_soon")] isShowTwoBtn:NO block:nil];
                                [weakSelf performSelector:@selector(reSendReqeuest) withObject:self afterDelay:WAIL_TIME];
                                [WalletUtil saveTranQLCRecordWithQlc:@"0" txtid:[NSStringUtil getNotNullValue:[dataDic objectForKey:@"recordId"]] neo:neo recordType:1 assetName:@"" friendNum:0 p2pID:@"" connectType:0 isReported:NO];
                            } else {
                                [AppD.window showHint:NSStringLocalizable(@"buy_qlc")]; // 兑换失败
                            }
                        } else {
                            [AppD.window showHint:[responseObject objectForKey:@"msg"]];
                        }
                    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
                        [AppD.window hideHud];
                        [AppD.window showHint:NSStringLocalizable(@"request_error")];
                    }];
                }
            }];
        } else {
            [AppD.window hideHud];
            [AppD.window showHint:[responseObject objectForKey:@"msg"]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [AppD.window hideHud];
        [AppD.window showHint:NSStringLocalizable(@"request_error")];
    }];
    
     
    
//    [AppD.window showHudInView:self.view hint:@"Loading.."];
//
//   // NSLog(@"--%@---%@",[CurrentWalletInfo getShareInstance].wif,[CurrentWalletInfo getShareInstance].address);
//
//    NSDictionary *parames = @{@"tx":[CurrentWalletInfo getShareInstance].wif,@"exchangeId":[WalletUtil getExChangeId],@"address":[CurrentWalletInfo getShareInstance].address,@"neo":neo};
//
//    [RequestService requestWithUrl:neoExchangeQlcV2_Url params:parames httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        [AppD.window hideHud];
//        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
//        if (dataDic) {
//           BOOL result = [[dataDic objectForKey:@"result"] boolValue];
//            if (result) { // 兑换成功
//                [self.view showWalletAlertViewWithTitle:@"PURCHASE SUCCESSFUL" msg:[[NSMutableAttributedString alloc] initWithString:@"Your withdrawal will arrive soon"] isShowTwoBtn:NO block:nil];
//                [self performSelector:@selector(reSendReqeuest) withObject:self afterDelay:WAIL_TIME];
//                [WalletUtil saveTranQLCRecordWithQlc:@"0" txtid:[dataDic objectForKey:@"txid"] neo:neo recordType:1 assetName:@"" friendNum:0 p2pID:@"" connectType:0 isReported:NO];
//            } else {
//                 [AppD.window showHint:NSStringLocalizable(@"buy_qlc")]; // 兑换失败
//            }
//        } else {
//            [AppD.window showHint:[responseObject objectForKey:@"msg"]];
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        [AppD.window hideHud];
//        [AppD.window showHint:NSStringLocalizable(@"request_error")];
//    }];
}

/**
 交易 qlc 请求
 @param address 交易地址
 @param qlc qlc
 */
- (void) sendFundsRequestWithAddressTo:(NSString *) address qlc:(NSString *) qlc
{
    NSString *tokenHash = AESSET_TEST_HASH;
    if ([WalletUtil checkServerIsMian]) {
        tokenHash = AESSET_MAIN_HASH;
    }
    [AppD.window showHudInView:self.view hint:NSStringLocalizable(@"loading")];
    @weakify_self
    [WalletManage.shareInstance3 sendQLCWithAddressWithIsQLC:true address:address tokeHash:tokenHash qlc:qlc completeBlock:^(NSString* complete) {
        
        if ([[NSStringUtil getNotNullValue:complete] isEmptyString]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [AppD.window hideHud];
                [AppD.window showHint:NSStringLocalizable(@"send_qlc")];
            });
        } else {
            
            // 发送交易请求
            NSString *recorid = [WalletUtil getExChangeId];
            NSDictionary *parames = @{@"recordId":recorid,@"type":@(1),@"addressFrom":[CurrentWalletInfo getShareInstance].address ,@"tx":complete,@"qlc":qlc,@"addressTo":address};
            [RequestService requestWithUrl:transTypeOperate_Url params:parames httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
                [AppD.window hideHud];
                if ([[responseObject objectForKey:Server_Code] integerValue] == 0){
                    NSDictionary *dataDic = [responseObject objectForKey:@"data"];
                    if (dataDic) {
                        BOOL result = [[dataDic objectForKey:@"operationResult"] boolValue];
                        if (result) { // 交易成功
                            [weakSelf.view showWalletAlertViewWithTitle:NSStringLocalizable(@"purchase_successful") msg:[[NSMutableAttributedString alloc] initWithString:NSStringLocalizable(@"transfer_processed")] isShowTwoBtn:NO block:nil];
                            [weakSelf performSelector:@selector(reSendReqeuest) withObject:self afterDelay:WAIL_TIME];
                            [WalletUtil saveTranQLCRecordWithQlc:qlc txtid:recorid neo:@"0" recordType:2 assetName:@"" friendNum:0 p2pID:@"" connectType:0 isReported:NO];
                        } else {
                            [AppD.window showHint:NSStringLocalizable(@"send_qlc")];
                        }
                    } else {
                        [AppD.window showHint:NSStringLocalizable(@"send_qlc")];
                    }
                } else {
                    [AppD.window showHint:NSStringLocalizable(@"send_qlc")];
                }
                
            } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
                [AppD.window hideHud];
                [AppD.window showHint:NSStringLocalizable(@"send_qlc")];
            }];
        }
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [AppD.window hideHud];
//            if (!complete) {
//                [AppD.window showHint:NSStringLocalizable(@"send_qlc")];
//            } else {
//                [weakSelf.view showWalletAlertViewWithTitle:NSStringLocalizable(@"purchase_successful") msg:[[NSMutableAttributedString alloc] initWithString:NSStringLocalizable(@"transfer_processed")] isShowTwoBtn:NO block:nil];
//                [weakSelf performSelector:@selector(reSendReqeuest) withObject:self afterDelay:WAIL_TIME];
//                [WalletUtil saveTranQLCRecordWithQlc:qlc txtid:@"" neo:@"0" recordType:2 assetName:@"" friendNum:0 p2pID:@"" connectType:0 isReported:NO];
//            }
//        });
    }];

    
//    [AppD.window showHudInView:self.view hint:@"Loading.."];
//   
//    NSDictionary *parames = @{@"wif":[CurrentWalletInfo getShareInstance].wif,@"address":address,@"qlc":qlc};
//    
//    [RequestService requestWithUrl:transfer_Url params:parames httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        [AppD.window hideHud];
//        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
//        if (dataDic) {
//            BOOL result = [[dataDic objectForKey:@"result"] boolValue];
//            if (result) { // 交易成功
//                [self.view showWalletAlertViewWithTitle:@"PURCHASE SUCCESSFUL" msg:[[NSMutableAttributedString alloc] initWithString:@"Your transfer request is being processed"] isShowTwoBtn:NO block:nil];
//                [self performSelector:@selector(reSendReqeuest) withObject:self afterDelay:WAIL_TIME];
//                [WalletUtil saveTranQLCRecordWithQlc:qlc txtid:[dataDic objectForKey:@"txid"] neo:@"0" recordType:2 assetName:@"" friendNum:0 p2pID:@"" connectType:0 isReported:NO];
//            } else {
//                [AppD.window showHint:NSStringLocalizable(@"send_qlc")]; // 交易失败
//            }
//        } else {
//            [AppD.window showHint:[responseObject objectForKey:@"msg"]];
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        [AppD.window hideHud];
//        [AppD.window showHint:NSStringLocalizable(@"request_error")];
//    }];
}

/**
 获取汇率
 */
- (void) sendGetRateRequest
{
    @weakify_self
    [RequestService requestWithUrl:raw_Url params:@{} httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        //[self hideHud];
         //[self endRefresh];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dataDic = [responseObject objectForKey:Server_Data];
            // 获取资产
            [weakSelf sendGetBalanceRequest];
            if(dataDic)  {
                dataDic = [dataDic objectForKey:@"rates"];
                RatesMode *ratesMode = [RatesMode mj_objectWithKeyValues:dataDic];
                weakSelf.ratesInfo = ratesMode;
                
                if (ratesMode) {
                    [weakSelf updateRateLableValueWithRate:ratesMode];
                }
            }
            
        } else {
            // 获取资产
            [weakSelf sendGetBalanceRequest];
            [AppD.window showHint:[responseObject objectForKey:@"msg"]];
        }
        
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
       //[self hideHud];
        [self endRefresh];
        [AppD.window showHint:NSStringLocalizable(@"request_error")];
    }];
}

/**
 更新汇率

 */
- (void) updateRateLableValueWithRate:(RatesMode *) rate
{
    _lblNeo.text = [NSString stringWithFormat:@"1 NEO = %.8f QLC",[rate.neoInfo.qlc floatValue]];
    _lblQlc.text = [NSString stringWithFormat:@"1 QLC = %.8f NEO",1.0/[rate.neoInfo.qlc floatValue]];
    _lblGas.text = [NSString stringWithFormat:@"1 GAS = %.8f NEO",(1.0/[rate.neoInfo.qlc floatValue])*[rate.gasInfo.qlc floatValue]];
    
}

/**
 获取资产
 */
- (void) sendGetBalanceRequest
{
    [RequestService requestWithUrl:getTokenBalance_Url params:@{@"address":[CurrentWalletInfo getShareInstance].address} httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        //[self hideHud];
        [self endRefresh];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dataDic = [responseObject objectForKey:Server_Data];
            if(dataDic)  {
                self.balanceInfo= [BalanceInfo mj_objectWithKeyValues:dataDic];
                AppD.balanceInfo = [BalanceInfo mj_objectWithKeyValues:dataDic];
                if (self.balanceInfo) {
                    
                    if ([self.balanceInfo.qlc floatValue] == 0) {
                        _lblmyQLC.text = @"0";
                        self.balanceInfo.qlc = @"0";
                    } else {
                        _lblmyQLC.text = [NSString stringWithFormat:@"%.2f",[self.balanceInfo.qlc floatValue]];
                    }
                    
                    if ([self.balanceInfo.neo floatValue] == 0) {
                        _lblmyNEO.text = @"0";
                        self.balanceInfo.neo = @"0";
                    } else {
                        _lblmyNEO.text = [NSString stringWithFormat:@"%.2f",[self.balanceInfo.neo floatValue]];
                    }
                    
                    if ([self.balanceInfo.gas floatValue] == 0) {
                        _lblmyGAS.text = @"0";
                        self.balanceInfo.gas = @"0";
                    } else {
                        _lblmyGAS.text = [NSString stringWithFormat:@"%.2f",[self.balanceInfo.gas floatValue]];
                    }
                }
            }
        } else {
            [AppD.window showHint:[responseObject objectForKey:@"msg"]];
        }
        
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        //[self hideHud];
        [self endRefresh];
        [AppD.window showHint:NSStringLocalizable(@"request_error")];
    }];
}

// ------------------------------NSNotificationCenter-----------------------------

- (void) walletDidChange:(NSNotificationCenter *) notification
{
    //NSLog(@"privatekey = %@",[CurrentWalletInfo getShareInstance].privateKey);
    // 获取汇率
    [self reSendReqeuest];
}

#pragma mark - Lazy
- (SRRefreshView *)slimeView {
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] initWithHeight:SRHeight width:_refreshScroll.width];
        _slimeView.upInset = 0;
        _slimeView.delegate = self;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = SRREFRESH_BACK_COLOR;
        _slimeView.slime.skinColor = SRREFRESH_BACK_COLOR;
//      _slimeView.slime.lineWith = 1;
//      _slimeView.slime.shadowBlur = 4;
//      _slimeView.slime.shadowColor = MAIN_PURPLE_COLOR;
    }
    
    return _slimeView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
