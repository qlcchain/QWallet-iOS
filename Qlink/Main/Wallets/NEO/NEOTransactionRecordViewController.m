//
//  ETHTransactionRecordViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/26.
//  Copyright © 2018 pan. All rights reserved.
//

#import "NEOTransactionRecordViewController.h"
#import "ETHTransactionRecordCell.h"
#import "NEOWalletAddressViewController.h"
#import "NEOAddressInfoModel.h"
#import "WalletCommonModel.h"
#import "NEOAddressHistoryModel.h"
#import "NEOTransferViewController.h"
#import "TokenPriceModel.h"
#import "NSString+RemoveZero.h"
#import "HistoryChartView.h"


@interface NEOTransactionRecordViewController () <UITableViewDataSource, UITableViewDelegate>

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

@implementation NEOTransactionRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:ETHTransactionRecordCellReuse bundle:nil] forCellReuseIdentifier:ETHTransactionRecordCellReuse];
    self.baseTable = _mainTable;
    
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
    _titleLab.text = _inputAsset.asset_symbol;
    _balanceLab.text = [_inputAsset getTokenNum];
    
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    [self requestNEOAddressInfo:currentWalletM.address?:@""];
    
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself requestTokenPrice];
    });
    
    [self refreshPrice];
    [self addChart];
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
    NSString *price = [_inputAsset getPrice:_tokenPriceArr];
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
    
    [_chartV updateWithSymbol:_inputAsset.asset_symbol noDataBlock:^{
        weakself.chartBackHeight.constant = 219-144;
    } haveDataBlock:^{
        weakself.chartBackHeight.constant = 219;
    }];
}

#pragma mark - Request
- (void)requestNEOAddressInfo:(NSString *)address {
    kWeakSelf(self);
    NSDictionary *params = @{@"address":address,@"page":@(0)};
    [RequestService requestWithUrl10:neoGetAllTransferByAddress_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeRelease successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSMutableArray *getArr = [NSMutableArray array];
            NSArray *arr = [responseObject objectForKey:Server_Data];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NEOAddressHistoryModel *model = [NEOAddressHistoryModel getObjectWithKeyValues:obj];
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
    NSDictionary *params = @{@"symbols":@[_inputAsset.asset_symbol],@"coin":coin};
    [RequestService requestWithUrl5:tokenPrice_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
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
    
    NEOAddressHistoryModel *model = _sourceArr[indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NEO_Transaction_Url,model.txid]] options:@{} completionHandler:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETHTransactionRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ETHTransactionRecordCellReuse];
    
    NEOAddressHistoryModel *model = _sourceArr[indexPath.row];
    [cell configCellWithNEOModel:model];
    
    return cell;
}

#pragma mark - Action
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//
- (IBAction)sendAction:(id)sender {
    [self jumpToNEOTransfer];
}

- (IBAction)receiveAction:(id)sender {
    [self jumpToNEOWalletAddress];
}

#pragma mark - Transition
- (void)jumpToNEOWalletAddress {
    NEOWalletAddressViewController *vc = [[NEOWalletAddressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToNEOTransfer {
    NEOTransferViewController *vc = [[NEOTransferViewController alloc] init];
    vc.inputAsset = _inputAsset;
    vc.inputSourceArr = _inputSourceArr;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
