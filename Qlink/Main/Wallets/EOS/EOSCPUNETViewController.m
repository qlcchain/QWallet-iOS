//
//  EOSCPUNETViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/12/5.
//  Copyright © 2018 pan. All rights reserved.
//

#import "EOSCPUNETViewController.h"
#import "EOSSymbolModel.h"
#import "EOSAccountResourceInfoModel.h"
#import "WalletCommonModel.h"
#import "TipOKView.h"
#import "PaymentDetailsView.h"
#import "ODRefreshControl.h"
#import "EOSResourcePriceModel.h"
#import "SuccessTipView.h"
#import "EOSWalletUtil.h"
#import "NSString+RemoveZero.h"

//#import "GlobalConstants.h"

@interface EOSCPUNETViewController () {
    NSString *stakeOrReclaimCpuAmount;
    NSString *stakeOrReclaimNetAmount;
    NSString *stakeOrReclaimFrom;
    NSString *stakeOrReclaimTo;
    EOSOperationType stakeOrReclaimOperationType;
}

@property (weak, nonatomic) IBOutlet UILabel *cpuBorrowLab;
@property (weak, nonatomic) IBOutlet UILabel *cpuAvailableLab;
@property (weak, nonatomic) IBOutlet UIImageView *stakeIcon;
@property (weak, nonatomic) IBOutlet UITextField *stakeAmountTF;
@property (weak, nonatomic) IBOutlet UILabel *stakeBalance;
@property (weak, nonatomic) IBOutlet UILabel *stakeRadioCpu;
@property (weak, nonatomic) IBOutlet UILabel *stakeRadioNet;
@property (weak, nonatomic) IBOutlet UISlider *stakeRadioSlider;


@property (weak, nonatomic) IBOutlet UILabel *netBorrowLab;
@property (weak, nonatomic) IBOutlet UILabel *netAvailableLab;
@property (weak, nonatomic) IBOutlet UIImageView *reclaimIcon;
@property (weak, nonatomic) IBOutlet UITextField *reclaimCpuAmountTF;
@property (weak, nonatomic) IBOutlet UILabel *reclaimCpuBalance;
@property (weak, nonatomic) IBOutlet UITextField *reclaimNetAmountTF;
@property (weak, nonatomic) IBOutlet UILabel *reclaimNetBalance;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reclaimInputHeight; // 200
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stakeInputHeight; // 192

@property (weak, nonatomic) IBOutlet UITextField *recipientAccountTF;
@property (weak, nonatomic) IBOutlet UIButton *doBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentHeight;

@property (nonatomic, strong) ODRefreshControl *refreshControl;
@property (nonatomic, strong) EOSAccountResourceInfoModel *resourceInfoM;
@property (nonatomic, strong) EOSResourcePriceModel *resourcePriceM;
@property (nonatomic) BOOL isStake;
@property (nonatomic, strong) NSArray *sliderNumbers;
@property (nonatomic, strong) NSNumber *sliderVal;

@end

@implementation EOSCPUNETViewController

#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stakeSuccess:) name:EOS_Approve_Success_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stakeFail:) name:EOS_Approve_Fail_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reclaimSuccess:) name:EOS_Unstake_Success_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reclaimFail:) name:EOS_Unstake_Fail_Noti object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self addObserve];
    [self renderView];
    [self configInit];
    
}

#pragma mark - Operation
- (void)renderView {
    [_doBtn cornerRadius:4];
}

- (void)configInit {
    [self refreshControlInit];
    
    // These number values represent each slider position
    _sliderNumbers = @[@(0), @(0.05), @(0.1), @(0.15), @(0.2), @(0.25), @(0.3), @(0.35), @(0.4), @(0.45), @(0.5), @(0.55), @(0.6), @(0.65), @(0.7), @(0.75), @(0.8), @(0.85), @(0.9), @(0.95), @(1)];
    // slider values go from 0 to the number of values in your numbers array
    NSInteger numberOfSteps = ((float)[_sliderNumbers count] - 1);
    _stakeRadioSlider.maximumValue = numberOfSteps;
    _stakeRadioSlider.value = numberOfSteps/2.0;
    _stakeRadioSlider.minimumValue = 0;
    // As the slider moves it will continously call the -valueChanged:
    _stakeRadioSlider.continuous = YES; // NO makes it call only once you let go
    
    CGFloat currentContentHeight = 820-192;
    if (Height_View >= currentContentHeight) {
        _scrollContentHeight.constant = Height_View+1;
    } else {
        _scrollContentHeight.constant = currentContentHeight;
    }
    
    [self stakeAction:nil];
    
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    _recipientAccountTF.text = currentWalletM.account_name?:@"";
    
    _stakeBalance.text = [NSString stringWithFormat:@"%@:%@ EOS",kLang(@"balance"),_inputSymbolM.balance];
    
    [self requestRefresh];
}

- (void)requestRefresh {
    [self requestEOSGetAccountResourceInfo];
    
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself requestEosEos_resource_price]; // 刷新当前价格
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself requestEOSTokenBalance]; // 刷新当前余额
    });
}

- (void)refreshControlInit {
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:_scrollView];
    _refreshControl.tintColor = SRREFRESH_BACK_COLOR;
    //    _refreshControl.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    _refreshControl.activityIndicatorViewColor = SRREFRESH_BACK_COLOR;
    [_refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl {
    [self requestRefresh];
}

- (void)refreshCpuAndNetWithModel:(EOSAccountResourceInfoModel *)model {
    _cpuBorrowLab.text = model.staked.cpu_weight;
    _cpuAvailableLab.text = [NSString stringWithFormat:@"%@ ms / %@ ms",@([model.cpu.available doubleValue]/1000),@([model.cpu.max doubleValue]/1000)];
    
    _netBorrowLab.text = model.staked.net_weight;
    _netAvailableLab.text = [NSString stringWithFormat:@"%@ KB / %@ KB",@([model.net.available doubleValue]/1024),@([model.net.max doubleValue]/1024)];
    
    _reclaimCpuBalance.text = [NSString stringWithFormat:@"%@:%@ ms",kLang(@"balance"),@([model.cpu.available doubleValue]/1000)];
    _reclaimNetBalance.text = [NSString stringWithFormat:@"%@:%@ KB",kLang(@"balance"),@([model.net.available doubleValue]/1024)];
}

- (void)refreshCurrenPriceWithModel:(EOSResourcePriceModel *)model {
    _stakeRadioCpu.text = [NSString stringWithFormat:@"CPU ≈ %@ ms",@(([_sliderVal doubleValue]*[_stakeAmountTF.text doubleValue])/[_resourcePriceM.cpuPrice doubleValue])];
    _stakeRadioNet.text = [NSString stringWithFormat:@"NET ≈ %@ KB",@((fabs(1- [_sliderVal doubleValue])*[_stakeAmountTF.text doubleValue])/[_resourcePriceM.netPrice doubleValue])];
}

- (void)showInsufficientResources {
    TipOKView *view = [TipOKView getInstance];
    view.okBlock = ^{
    };
    [view showWithTitle:kLang(@"insufficient_resources")];
}

- (void)refreshEosBalance {
    if (_isStake) {
        _stakeBalance.text = [NSString stringWithFormat:@"%@:%@ EOS",kLang(@"balance"),_inputSymbolM.balance];
    }
}

- (void)showPayDetailsViewWithPayInfo:(NSString *)payInfo amount:(NSString *)amount key1:(NSString *)key1 val1:(NSString *)val1 key2:(NSString *)key2 val2:(NSString *)val2 {
    PaymentDetailsView *view = [PaymentDetailsView getInstance];
    kWeakSelf(self)
    view.nextBlock = ^{
        [weakself stakeOrReclaim];
    };
    [view configWithPayInfo:payInfo amount:amount key1:key1 val1:val1 key2:key2 val2:val2];
    [view show];
}

- (void)stakeOrReclaim {
    [EOSWalletUtil.shareInstance stakeWithCpuAmount:stakeOrReclaimCpuAmount?:@"" netAmount:stakeOrReclaimNetAmount?:@"" from:stakeOrReclaimFrom?:@"" to:stakeOrReclaimTo?:@"" operationType:stakeOrReclaimOperationType];
}

- (void)showSuccessView {
    SuccessTipView *tip = [SuccessTipView getInstance];
    [tip showWithTitle:kLang(@"success")];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Request
- (void)requestEOSGetAccountResourceInfo {
    kWeakSelf(self);
    [kAppD.window makeToastInView:kAppD.window];
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    NSDictionary *params = @{@"account":currentWalletM.account_name?:@""};
    [RequestService requestWithUrl5:eosGet_account_resource_info_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.refreshControl endRefreshing];
        [kAppD.window hideToast];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = responseObject[Server_Data][Server_Data];
            weakself.resourceInfoM = [EOSAccountResourceInfoModel getObjectWithKeyValues:dic];
            [weakself refreshCpuAndNetWithModel:weakself.resourceInfoM];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.refreshControl endRefreshing];
        [kAppD.window hideToast];
    }];
}

- (void)requestEosEos_resource_price {
    kWeakSelf(self);
    NSDictionary *params = @{};
    [RequestService requestWithUrl5:eosEos_resource_price_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = responseObject[Server_Data];
            weakself.resourcePriceM = [EOSResourcePriceModel getObjectWithKeyValues:dic];
            [weakself refreshCurrenPriceWithModel:weakself.resourcePriceM];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestEOSTokenBalance {
    kWeakSelf(self);
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    NSDictionary *params = @{@"account":currentWalletM.account_name?:@"", @"symbol":@"EOS"};
    [RequestService requestWithUrl5:eosGet_token_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = responseObject[Server_Data][Server_Data];
            NSArray *symbol_list = dic[@"symbol_list"];
            __block NSNumber *eosBalance = @(0);
            NSMutableArray *symbolListArr = [NSMutableArray array];
            [symbol_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EOSSymbolModel *model = [EOSSymbolModel getObjectWithKeyValues:obj];
                [symbolListArr addObject:model];
                if ([model.symbol isEqualToString:@"EOS"]) { // 赋值EOS余额
                    eosBalance = model.balance;
                }
            }];
            weakself.inputSymbolM.balance = eosBalance;
            [weakself refreshEosBalance];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)stakeAction:(id)sender {
    _isStake = YES;
    _stakeInputHeight.constant = 192;
    _reclaimInputHeight.constant = 0;
    [_doBtn setTitle:@"Stake" forState:UIControlStateNormal];
    _stakeIcon.image = [UIImage imageNamed:@"icon_selected_purple"];
    _reclaimIcon.image = [UIImage imageNamed:@"icon_unselected_purple"];
}

- (IBAction)reclaimAction:(id)sender {
    _isStake = NO;
    _stakeInputHeight.constant = 0;
    _reclaimInputHeight.constant = 200;
    [_doBtn setTitle:@"Reclaim" forState:UIControlStateNormal];
    _stakeIcon.image = [UIImage imageNamed:@"icon_unselected_purple"];
    _reclaimIcon.image = [UIImage imageNamed:@"icon_selected_purple"];
}

- (IBAction)stakeRadioSliderAction:(UISlider *)slider {
    NSUInteger index = (NSUInteger)(slider.value + 0.5);
    [slider setValue:index animated:NO];
    _sliderVal = @([_sliderNumbers[index] doubleValue]);
    
    if (_stakeAmountTF.text && _stakeAmountTF.text.length > 0) {
        _stakeRadioCpu.text = [NSString stringWithFormat:@"CPU ≈ %@ ms",@(([_sliderVal doubleValue]*[_stakeAmountTF.text doubleValue])/[_resourcePriceM.cpuPrice doubleValue])];
        _stakeRadioNet.text = [NSString stringWithFormat:@"NET ≈ %@ KB",@((fabs(1- [_sliderVal doubleValue])*[_stakeAmountTF.text doubleValue])/[_resourcePriceM.netPrice doubleValue])];
    }

}

- (IBAction)doAction:(id)sender {
    NSString *payInfo = nil;
    NSString *showAmount = nil;
    if (_isStake == YES) { // 抵押
        if (!_stakeAmountTF.text || _stakeAmountTF.text.length <= 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"input_eos_amount")];
            return;
        }
        if ([_stakeAmountTF.text doubleValue] > [_inputSymbolM.balance doubleValue]) { // 余额不足
            [kAppD.window makeToastDisappearWithText:kLang(@"insufficient_balance")];
            return;
        }
        if (!_recipientAccountTF.text || _recipientAccountTF.text.length <= 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"input_recipient_account")];
            return;
        }
        
        payInfo = @"Stake";
        stakeOrReclaimTo = _recipientAccountTF.text?:@"";
        stakeOrReclaimOperationType = EOSOperationTypeStake;
        showAmount = [NSString stringWithFormat:@"%@ EOS",_stakeAmountTF.text?:@""];
        stakeOrReclaimCpuAmount = [[NSString stringWithFormat:@"%@",@([_stakeAmountTF.text doubleValue]*[_sliderVal doubleValue])] removeFloatAllZero];
        stakeOrReclaimNetAmount = [[NSString stringWithFormat:@"%@",@([_stakeAmountTF.text doubleValue]*(1-[_sliderVal doubleValue]))] removeFloatAllZero];
    } else { // 赎回
        if (!_reclaimCpuAmountTF.text || _reclaimCpuAmountTF.text.length <= 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"input_cpu_amount")];
            return;
        }
        if ([_reclaimCpuAmountTF.text doubleValue] > [_resourceInfoM.cpu.available doubleValue]/1000) { // 余额不足
            [kAppD.window makeToastDisappearWithText:kLang(@"insufficient_cpu_balance")];
            return;
        }
        if (!_reclaimNetAmountTF.text || _reclaimNetAmountTF.text.length <= 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"input_net_amount")];
            return;
        }
        if ([_reclaimNetAmountTF.text doubleValue] > [_resourceInfoM.net.available doubleValue]/1024) { // 余额不足
            [kAppD.window makeToastDisappearWithText:kLang(@"insufficient_net_balance")];
            return;
        }
        
        payInfo = @"Sell RAM";
        stakeOrReclaimTo = _recipientAccountTF.text?:@"";
        stakeOrReclaimOperationType = EOSOperationTypeReclaim;
        NSNumber *cpuEOSNum = @([_reclaimCpuAmountTF.text doubleValue]*[_resourcePriceM.cpuPrice doubleValue]);
        NSNumber *netEOSNum = @([_reclaimNetAmountTF.text doubleValue]*[_resourcePriceM.netPrice doubleValue]);
        showAmount = [NSString stringWithFormat:@"%@ EOS",@([cpuEOSNum doubleValue]+[netEOSNum doubleValue])];
        stakeOrReclaimCpuAmount = [[NSString stringWithFormat:@"%@",cpuEOSNum] removeFloatAllZero];
        stakeOrReclaimNetAmount = [[NSString stringWithFormat:@"%@",netEOSNum] removeFloatAllZero];
    }
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    stakeOrReclaimFrom = currentWalletM.account_name?:@"";
    
    [self showPayDetailsViewWithPayInfo:payInfo amount:showAmount key1:@"To" val1:stakeOrReclaimTo key2:@"From" val2:stakeOrReclaimFrom];
}

#pragma mark - Noti
- (void)stakeSuccess:(NSNotification *)noti {
    [self showSuccessView];
    
    [self performSelector:@selector(backToRoot) withObject:nil afterDelay:2];
}

- (void)stakeFail:(NSNotification *)noti {
    
}

- (void)reclaimSuccess:(NSNotification *)noti {
    [self showSuccessView];
    
    [self performSelector:@selector(backToRoot) withObject:nil afterDelay:2];
}

- (void)reclaimFail:(NSNotification *)noti {
    
}


@end
