//
//  ETHTransactionRecordViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/26.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ETHTransactionRecordViewController.h"
#import "ETHTransactionRecordCell.h"
#import "ETHWalletAddressViewController.h"
#import "ETHAddressInfoModel.h"
#import "WalletCommonModel.h"
#import "ETHAddressHistoryModel.h"
#import "ETHTransferViewController.h"
#import "TokenPriceModel.h"
#import "NSString+RemoveZero.h"
#import "ETHAddressTransactionsModel.h"
#import "HistoryChartView.h"

#define ETH_SYMBOL @"ETH"

@interface ETHTransactionRecordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UIView *bottomBack;
@property (weak, nonatomic) IBOutlet UIView *chartBack;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight; // 48

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) NSMutableArray *tokenPriceArr;
@property (nonatomic, strong) HistoryChartView *chartV;

@end

@implementation ETHTransactionRecordViewController

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
    _titleLab.text = _inputToken.tokenInfo.name;
    _balanceLab.text = [_inputToken getTokenNum];
    
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.isWatch == YES) {
        _bottomHeight.constant = 0;
    } else {
        _bottomHeight.constant = 48;
    }
    
    [self requestETHAddressInfo:currentWalletM.address?:@"" token:_inputToken.tokenInfo.address?:@""];
    
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself requestTokenPrice];
    });
    
    [self refreshPrice];
    [self addChart];
}

- (void)addChart {
    _chartV = [HistoryChartView getInstance];
    [_chartBack addSubview:_chartV];
    kWeakSelf(self);
    [_chartV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(weakself.chartBack).offset(0);
    }];
    
    [_chartV updateWithSymbol:_inputToken.tokenInfo.symbol];
}

- (void)refreshPrice {
//    NSString *num = [_inputToken getTokenNum];
//    __block NSString *usd = @"";
//    [_tokenPriceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        TokenPriceModel *model = obj;
//        if ([model.symbol isEqualToString:_inputToken.tokenInfo.symbol]) {
//            long double usdFloat = [num doubleValue]*[model.price doubleValue];
//            usd = [[NSString stringWithFormat:@"%Lf",usdFloat] removeFloatAllZero];
//            *stop = YES;
//        }
//    }];
    NSString *price = [_inputToken getPrice:_tokenPriceArr];
    _priceLab.text = [NSString stringWithFormat:@"≈%@%@",[ConfigUtil getLocalUsingCurrencySymbol],price];
}

- (void)refreshView:(NSArray *)arr {
    [_sourceArr removeAllObjects];
    [_sourceArr addObjectsFromArray:arr];
    [_mainTable reloadData];
}

#pragma mark - Request
- (void)requestETHAddressInfo:(NSString *)address token:(NSString *)token {
    kWeakSelf(self);
    NSDictionary *params = [_inputToken.tokenInfo.symbol isEqualToString:ETH_SYMBOL]?@{@"address":address}:@{@"address":address,@"token":token};
    NSString *url = [_inputToken.tokenInfo.symbol isEqualToString:ETH_SYMBOL]?ethAddress_transactions_Url:ethAddressHistory_Url;
    [RequestService requestWithUrl:url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSString *str = [responseObject objectForKey:Server_Data];
            if ([_inputToken.tokenInfo.symbol isEqualToString:ETH_SYMBOL]) {
                NSArray *arr = [str mj_JSONObject];
                NSArray *ethTransactionsArr = [ETHAddressTransactionsModel mj_objectArrayWithKeyValuesArray:arr];
                [weakself refreshView:ethTransactionsArr];
            } else {
                NSDictionary *dic = [str mj_JSONObject];
                ETHAddressHistoryModel *model = [ETHAddressHistoryModel getObjectWithKeyValues:dic];
                [weakself refreshView:model.operations];
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestTokenPrice {
    kWeakSelf(self);
    NSString *coin = [ConfigUtil getLocalUsingCurrency];
    NSDictionary *params = @{@"symbols":@[_inputToken.tokenInfo.symbol],@"coin":coin};
    [RequestService requestWithUrl:tokenPrice_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            [weakself.tokenPriceArr removeAllObjects];
            NSArray *arr = [responseObject objectForKey:Server_Data];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TokenPriceModel *model = [TokenPriceModel getObjectWithKeyValues:obj];
                model.coin = coin;
                [weakself.tokenPriceArr addObject:model];
            }];
            [weakself refreshPrice];
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
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETHTransactionRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ETHTransactionRecordCellReuse];
    
    if ([_inputToken.tokenInfo.symbol isEqualToString:ETH_SYMBOL]) {
        ETHAddressTransactionsModel *model = _sourceArr[indexPath.row];
        [cell configCellWithETHModel:model];
    } else {
        Operation *model = _sourceArr[indexPath.row];
        [cell configCellWithETHOtherModel:model];
    }
    
    return cell;
}

#pragma mark - Action
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//
- (IBAction)sendAction:(id)sender {
    [self jumpToETHTransfer];
}

- (IBAction)receiveAction:(id)sender {
    [self jumpToETHWalletAddress];
}

#pragma mark - Transition
- (void)jumpToETHWalletAddress {
    ETHWalletAddressViewController *vc = [[ETHWalletAddressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToETHTransfer {
    ETHTransferViewController *vc = [[ETHTransferViewController alloc] init];
    vc.inputToken = _inputToken;
    vc.inputSourceArr = _inputSourceArr;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
