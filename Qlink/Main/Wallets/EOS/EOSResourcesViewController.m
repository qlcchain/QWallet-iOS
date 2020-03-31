//
//  EOSResourcesViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/12/5.
//  Copyright © 2018 pan. All rights reserved.
//

#import "EOSResourcesViewController.h"
#import "WalletCommonModel.h"
#import "EOSAccountResourceInfoModel.h"
#import "EOSCPUNETViewController.h"
#import "EOSRAMViewController.h"
#import "EOSSymbolModel.h"
#import "ODRefreshControl.h"
#import "NSString+RemoveZero.h"

//#import "GlobalConstants.h"

@interface EOSResourcesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *totalAssetsLab;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *reclaimLab;
@property (weak, nonatomic) IBOutlet UILabel *stakedLab;
@property (weak, nonatomic) IBOutlet UILabel *availableRamLab;
@property (weak, nonatomic) IBOutlet UILabel *availableCpuLab;
@property (weak, nonatomic) IBOutlet UILabel *availableNetLab;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentHeight;

@property (nonatomic, strong) EOSAccountResourceInfoModel *resourceInfoM;

@property (nonatomic, strong) ODRefreshControl *refreshControl;

@end

@implementation EOSResourcesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self configInit];
    [self requestEOSGetAccountResourceInfo];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    if (!_slimeView) {
//        [_scrollView addSubview:self.slimeView];
//    }
}

#pragma mark - Operation
- (void)configInit {
    [self refreshControlInit];
    
    if (Height_View >= 603) {
        _scrollContentHeight.constant = Height_View+1;
    } else {
        _scrollContentHeight.constant = 603;
    }
}

- (void)refreshControlInit {
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:_scrollView];
    _refreshControl.tintColor = SRREFRESH_BACK_COLOR;
    //    _refreshControl.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    _refreshControl.activityIndicatorViewColor = SRREFRESH_BACK_COLOR;
    [_refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl {
    [self requestEOSGetAccountResourceInfo];
}

- (void)refreshView {
    NSNumber *cpuStakedNum = @([[_resourceInfoM.staked.cpu_weight stringByReplacingOccurrencesOfString:@" EOS" withString:@""] doubleValue]);
    NSNumber *netStakedNum = @([[_resourceInfoM.staked.net_weight stringByReplacingOccurrencesOfString:@" EOS" withString:@""] doubleValue]);
    _stakedLab.text = [NSString stringWithFormat:@"%@ EOS",@([cpuStakedNum doubleValue]+[netStakedNum doubleValue]).show4floatStr];
    
    _totalAssetsLab.text = [NSString stringWithFormat:@"%@ %@ EOS",kLang(@"total_assets"),@([netStakedNum doubleValue]+[cpuStakedNum doubleValue]+[_inputSymbolM.balance doubleValue]).show4floatStr];
    _balanceLab.text = [NSString stringWithFormat:@"%@ EOS",(_inputSymbolM.balance?:@(0)).show4floatStr];
//    _reclaimLab.text = ;
    
//    _availableRamLab.text = [NSString stringWithFormat:@"%@ Bytes / %@ KB",@([_resourceInfoM.ram.available doubleValue]-[_resourceInfoM.ram.used doubleValue]).show4floatStr,@([_resourceInfoM.ram.available doubleValue]/1024).show4floatStr];
    _availableRamLab.text = [NSString stringWithFormat:@"%@ KB / %@ KB",@(([_resourceInfoM.ram.available doubleValue]-[_resourceInfoM.ram.used doubleValue])/1024).show4floatStr,@([_resourceInfoM.ram.available doubleValue]/1024).show4floatStr];
    _availableCpuLab.text = [NSString stringWithFormat:@"%@ ms / %@ ms",@([_resourceInfoM.cpu.available doubleValue]/1000).show4floatStr,@([_resourceInfoM.cpu.max doubleValue]/1000).show4floatStr];
    _availableNetLab.text = [NSString stringWithFormat:@"%@ KB / %@ KB",@([_resourceInfoM.net.available doubleValue]/1024).show4floatStr,@([_resourceInfoM.net.max doubleValue]/1024).show4floatStr];
}

#pragma mark - Request
- (void)requestEOSGetAccountResourceInfo {
    kWeakSelf(self);
    [kAppD.window makeToastInView:kAppD.window];
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    NSDictionary *params = @{@"account":currentWalletM.account_name?:@""};
    [RequestService requestWithUrl5:eosGet_account_resource_info_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        [weakself.slimeView endRefresh];
        [weakself.refreshControl endRefreshing];
        [kAppD.window hideToast];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = responseObject[Server_Data][Server_Data];
            weakself.resourceInfoM = [EOSAccountResourceInfoModel getObjectWithKeyValues:dic];
            [weakself refreshView];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        [weakself.slimeView endRefresh];
        [weakself.refreshControl endRefreshing];
        [kAppD.window hideToast];
    }];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ramAction:(id)sender {
    [self jumpToRAM];
}

- (IBAction)cpunetAction:(id)sender {
    [self jumpToCPUNET];
}

#pragma mark - Transition
- (void)jumpToCPUNET {
    EOSCPUNETViewController *vc = [[EOSCPUNETViewController alloc] init];
    vc.inputSymbolM = _inputSymbolM;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToRAM {
    EOSRAMViewController *vc = [[EOSRAMViewController alloc] init];
    vc.inputSymbolM = _inputSymbolM;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
