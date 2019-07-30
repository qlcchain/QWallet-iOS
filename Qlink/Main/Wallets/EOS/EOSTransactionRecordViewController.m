//
//  ETHTransactionRecordViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/26.
//  Copyright © 2018 pan. All rights reserved.
//

#import "EOSTransactionRecordViewController.h"
#import "ETHTransactionRecordCell.h"
#import "EOSAccountQRViewController.h"
#import "EOSSymbolModel.h"
#import "WalletCommonModel.h"
#import "EOSTraceModel.h"
#import "EOSTransferViewController.h"
#import "TokenPriceModel.h"
#import "NSString+RemoveZero.h"
#import "HistoryChartView.h"

@interface EOSTransactionRecordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UIView *bottomBack;
@property (weak, nonatomic) IBOutlet UIView *chartBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chartBackHeight;

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) NSMutableArray *tokenPriceArr;
@property (weak, nonatomic) HistoryChartView *chartV;

@end

@implementation EOSTransactionRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:ETHTransactionRecordCellReuse bundle:nil] forCellReuseIdentifier:ETHTransactionRecordCellReuse];
    [self renderView];
    [self configInit];
}

#pragma mark - Operation
- (void)renderView {
    UIColor *shadowColor = [UIColorFromRGB(0x34547A) colorWithAlphaComponent:0.11];
    [_bottomBack addShadowWithOpacity:1 shadowColor:shadowColor shadowOffset:CGSizeMake(0,-1) shadowRadius:22 andCornerRadius:0];
}

- (void)configInit {
    _tokenPriceArr = [NSMutableArray array];
    _titleLab.text = _inputSymbol.symbol;
    _balanceLab.text = [_inputSymbol getTokenNum];
    
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    [self requestEOSGetAccountRelatedTrxInfo:currentWalletM.account_name?:@""];
    
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself requestTokenPrice];
    });
    
    [self refreshPrice];
    [self addChart];
}

- (void)refreshPrice {
    NSString *price = [_inputSymbol getPrice:_tokenPriceArr];
    _priceLab.text = [NSString stringWithFormat:@"≈%@%@",[ConfigUtil getLocalUsingCurrencySymbol],price];
}

- (void)refreshView:(NSArray *)arr {
    [_sourceArr removeAllObjects];
    [_sourceArr addObjectsFromArray:arr];
    [_mainTable reloadData];
}

- (void)addChart {
    _chartV = [HistoryChartView getInstance];
    [_chartBack addSubview:_chartV];
    kWeakSelf(self);
    [_chartV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(weakself.chartBack).offset(0);
    }];
    
    [_chartV updateWithSymbol:_inputSymbol.symbol noDataBlock:^{
        weakself.chartBackHeight.constant = 219-144;
    }];
}

#pragma mark - Request
- (void)requestEOSGetAccountRelatedTrxInfo:(NSString *)account_name {
    kWeakSelf(self);
    NSDictionary *params = @{@"account":account_name, @"symbol":_inputSymbol.symbol?:@"", @"code":_inputSymbol.code?:@"" , @"page":@(1), @"size":@(15)};
    [RequestService requestWithUrl:eosGet_account_related_trx_info_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSMutableArray *getArr = [NSMutableArray array];
            NSDictionary *dic = responseObject[Server_Data][Server_Data];
            NSArray *trace_list = dic[@"trace_list"];
            [trace_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EOSTraceModel *model = [EOSTraceModel getObjectWithKeyValues:obj];
                [getArr addObject:model];
            }];
            [weakself refreshView:getArr];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestTokenPrice {
    kWeakSelf(self);
    NSString *coin = [ConfigUtil getLocalUsingCurrency];
    NSDictionary *params = @{@"symbols":@[_inputSymbol.symbol],@"coin":coin};
    [RequestService requestWithUrl:tokenPrice_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            [weakself.tokenPriceArr removeAllObjects];
            NSArray *arr = [responseObject objectForKey:Server_Data];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TokenPriceModel *model = [TokenPriceModel getObjectWithKeyValues:obj];
                model.coin = coin;
                [weakself.tokenPriceArr addObject:model];
            }];
            [self refreshPrice];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ETHTransactionRecordCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EOSTraceModel *model = _sourceArr[indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",EOS_Transaction_Url,model.trx_id]] options:@{} completionHandler:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETHTransactionRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ETHTransactionRecordCellReuse];
    
    EOSTraceModel *model = _sourceArr[indexPath.row];
    [cell configCellWithEOSModel:model];
    
    return cell;
}

#pragma mark - Action
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//
- (IBAction)sendAction:(id)sender {
    [self jumpToEOSTransfer];
}

- (IBAction)receiveAction:(id)sender {
    [self jumpToEOSAccountQR];
}

#pragma mark - Transition
- (void)jumpToEOSAccountQR {
    EOSAccountQRViewController *vc = [[EOSAccountQRViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToEOSTransfer {
    EOSTransferViewController *vc = [[EOSTransferViewController alloc] init];
    vc.inputSymbol = _inputSymbol;
    vc.inputSourceArr = _inputSourceArr;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
