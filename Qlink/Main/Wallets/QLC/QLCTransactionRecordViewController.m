//
//  ETHTransactionRecordViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/26.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QLCTransactionRecordViewController.h"
#import "ETHTransactionRecordCell.h"
#import "QLCWalletAddressViewController.h"
#import "QLCAddressInfoModel.h"
#import "WalletCommonModel.h"
#import "QLCAddressHistoryModel.h"
#import "QLCTransferViewController.h"
#import "TokenPriceModel.h"
#import "NSString+RemoveZero.h"
#import "HistoryChartView.h"
#import "Qlink-Swift.h"
#import "QLCTokenInfoModel.h"

@interface QLCTransactionRecordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UIView *bottomBack;
@property (weak, nonatomic) IBOutlet UIView *chartBack;

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) NSMutableArray *tokenPriceArr;
@property (weak, nonatomic) HistoryChartView *chartV;
@property (nonatomic, strong) NSMutableArray *addressHistoryArr;

@end

@implementation QLCTransactionRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:ETHTransactionRecordCellReuse bundle:nil] forCellReuseIdentifier:ETHTransactionRecordCellReuse];
    _addressHistoryArr = [NSMutableArray array];
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
    _titleLab.text = _inputAsset.tokenName;
    _balanceLab.text = [_inputAsset getTokenNum];
    
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    [self requestQLCAddressInfo:currentWalletM.address?:@""];
    
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
    
    [_chartV updateWithSymbol:_inputAsset.tokenName];
}

#pragma mark - Request
- (void)requestQLCAddressInfo:(NSString *)address {
    kWeakSelf(self);
//    NSString *address1 = @"qlc_3wpp343n1kfsd4r6zyhz3byx4x74hi98r6f1es4dw5xkyq8qdxcxodia4zbb";
    [LedgerRpc accountHistoryTopnWithAddress:address successHandler:^(id _Nonnull responseObject) {
        if (responseObject != nil) {
            [weakself.addressHistoryArr removeAllObjects];
            [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                QLCAddressHistoryModel *model = [QLCAddressHistoryModel getObjectWithKeyValues:obj];
                [weakself.addressHistoryArr addObject:model];
            }];
            [weakself requestQLCTokensWithShowLoad:NO];
            
        }
    } failureHandler:^(NSError * _Nullable error, NSString * _Nullable message) {
    }];
}

- (void)requestQLCTokensWithShowLoad:(BOOL)showLoad {
    kWeakSelf(self);
    if (showLoad) {
        [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:0];
    }
    [LedgerRpc tokensWithSuccessHandler:^(id _Nullable responseObject) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        
        if (responseObject != nil) {
            NSArray *tokenArr = [QLCTokenInfoModel mj_objectArrayWithKeyValuesArray:responseObject];
            [weakself.addressHistoryArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                QLCAddressHistoryModel *historyM = obj;
                [tokenArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    QLCTokenInfoModel *tokenInfoM = obj;
                    if ([historyM.tokenName isEqualToString:tokenInfoM.tokenName]) {
                        historyM.tokenInfoM = tokenInfoM;
                        *stop = YES;
                    }
                }];
            }];
            [weakself refreshView:weakself.addressHistoryArr];
        }
        
    } failureHandler:^(NSError * _Nullable error, NSString * _Nullable message) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        [kAppD.window makeToastDisappearWithText:message];
    }];
}

- (void)requestTokenPrice {
    kWeakSelf(self);
    NSString *coin = [ConfigUtil getLocalUsingCurrency];
    NSDictionary *params = @{@"symbols":@[_inputAsset.tokenName],@"coin":coin};
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
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETHTransactionRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ETHTransactionRecordCellReuse];
    
    QLCAddressHistoryModel *model = _sourceArr[indexPath.row];
    [cell configCellWithQLCModel:model];
    
    return cell;
}

#pragma mark - Action
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//
- (IBAction)sendAction:(id)sender {
    [self jumpToQLCTransfer];
}

- (IBAction)receiveAction:(id)sender {
    [self jumpToQLCWalletAddress];
}

#pragma mark - Transition
- (void)jumpToQLCWalletAddress {
    QLCWalletAddressViewController *vc = [[QLCWalletAddressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToQLCTransfer {
    QLCTransferViewController *vc = [[QLCTransferViewController alloc] init];
    vc.inputAsset = _inputAsset;
    vc.inputSourceArr = _inputSourceArr;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
