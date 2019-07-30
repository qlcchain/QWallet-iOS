//
//  WalletsSwitchViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/7.
//  Copyright © 2018 pan. All rights reserved.
//

#import "WalletsManageViewController.h"
#import "WalletCommonModel.h"
#import "WalletsManageCell.h"
#import "ChooseWalletViewController.h"
#import <ETHFramework/ETHFramework.h>
#import "TokenPriceModel.h"
#import "ETHWalletDetailViewController.h"
#import "NEOWalletDetailViewController.h"
#import "QLCWalletDetailViewController.h"
#import "EOSWalletDetailViewController.h"

@interface WalletsManageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) NSMutableArray *tokenPriceArr;

@end

@implementation WalletsManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:WalletsManageCellReuse bundle:nil] forCellReuseIdentifier:WalletsManageCellReuse];
    [self renderView];
    [self configInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshData];
}

#pragma mark - Operation
- (void)renderView {
//    UIColor *shadowColor = [UIColorFromRGB(0x34547A) colorWithAlphaComponent:0.11];
//    [_bottomBack addShadowWithOpacity:1 shadowColor:shadowColor shadowOffset:CGSizeMake(0,-1) shadowRadius:22 andCornerRadius:0];
}

- (void)configInit {
    _tokenPriceArr = [NSMutableArray array];
    [self refreshData];
}

- (void)refreshData {
    [_sourceArr removeAllObjects];
    [_sourceArr addObjectsFromArray:[WalletCommonModel getAllWalletModel]];
    [self requestTokenPrice];
}

#pragma mark - Request
- (void)requestTokenPrice {
    NSArray *tokenSymbolArr = @[@"ETH",@"NEO",@"EOS"];
    NSString *coin = [ConfigUtil getLocalUsingCurrency];
    NSDictionary *params = @{@"symbols":tokenSymbolArr,@"coin":coin};
    kWeakSelf(self);
    [RequestService requestWithUrl:tokenPrice_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            [weakself.tokenPriceArr removeAllObjects];
            NSArray *arr = [responseObject objectForKey:Server_Data];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TokenPriceModel *model = [TokenPriceModel getObjectWithKeyValues:obj];
                model.coin = coin;
                [weakself.tokenPriceArr addObject:model];
            }];
            [weakself.mainTable reloadData];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - Action

- (IBAction)closeAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addAction:(id)sender {
    [self jumpToChooseWallet];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WalletsManageCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletsManageCell *cell = [tableView dequeueReusableCellWithIdentifier:WalletsManageCellReuse];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WalletCommonModel *commonM = _sourceArr[indexPath.row];
    [cell configCellWithModel:commonM tokenPriceArr:_tokenPriceArr];
    cell.moreBlock = ^{
        if (commonM.walletType == WalletTypeETH) {
            [self jumpToETHWalletDetail:commonM];
        } else if (commonM.walletType == WalletTypeNEO) {
            [self jumpToNEOWalletDetail:commonM];
        } else if (commonM.walletType == WalletTypeEOS) {
            [self jumpToEOSWalletDetail:commonM];
        } else if (commonM.walletType == WalletTypeQLC) {
            [self jumpToQLCWalletDetail:commonM];
        }
    };
    
    return cell;
}

#pragma mark - Transition
- (void)jumpToChooseWallet {
    ChooseWalletViewController *vc = [[ChooseWalletViewController alloc] init];
    vc.showBack = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToETHWalletDetail:(WalletCommonModel *)model {
    if (model.isWatch == YES) {
        return;
    }
    ETHWalletDetailViewController *vc = [[ETHWalletDetailViewController alloc] init];
    vc.inputWalletCommonM = model;
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    vc.isDeleteCurrentWallet = [model.address isEqualToString:currentWalletM.address]?YES:NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToNEOWalletDetail:(WalletCommonModel *)model {
    NEOWalletDetailViewController *vc = [[NEOWalletDetailViewController alloc] init];
    vc.inputWalletCommonM = model;
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    vc.isDeleteCurrentWallet = [model.address isEqualToString:currentWalletM.address]?YES:NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToEOSWalletDetail:(WalletCommonModel *)model {
    EOSWalletDetailViewController *vc = [[EOSWalletDetailViewController alloc] init];
    vc.inputWalletCommonM = model;
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    vc.isDeleteCurrentWallet = [model.address isEqualToString:currentWalletM.address]?YES:NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToQLCWalletDetail:(WalletCommonModel *)model {
    QLCWalletDetailViewController *vc = [[QLCWalletDetailViewController alloc] init];
    vc.inputWalletCommonM = model;
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    vc.isDeleteCurrentWallet = [model.address isEqualToString:currentWalletM.address]?YES:NO;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
