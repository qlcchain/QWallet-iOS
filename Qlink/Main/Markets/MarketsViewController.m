//
//  CoursesViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/19.
//  Copyright © 2018 pan. All rights reserved.
//

#import "MarketsViewController.h"
#import "MarketsCell.h"
#import "QlinkTabbarViewController.h"
#import "WalletsViewController.h"
#import "BinaTpcsModel.h"
#import "TokenPriceModel.h"
#import "MarketSortBtn.h"
#import "AddMarketsViewController.h"
#import "RefreshTableView.h"

@interface MarketsViewController () <UITableViewDelegate, UITableViewDataSource,SRRefreshDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet MarketSortBtn *assetsBtn;
@property (weak, nonatomic) IBOutlet MarketSortBtn *priceBtn;
@property (weak, nonatomic) IBOutlet MarketSortBtn *changeBtn;
@property (weak, nonatomic) IBOutlet UIView *tableBack;
@property (strong, nonatomic) RefreshTableView *mainTable;

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) NSMutableArray *tokenSymbolArr;
@property (nonatomic, strong) MarketSortBtn *selectBtn;

@end

@implementation MarketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self configInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tokenSymbolArr removeAllObjects];
    [_tokenSymbolArr addObjectsFromArray:[BinaTpcsModel getLocalMarketsSymbol]];
    [self requestBinaTpcs];
}

#pragma mark - Operation
- (void)configInit {
    _tokenSymbolArr = [NSMutableArray array];
    _sourceArr = [NSMutableArray array];
    
    _assetsBtn.sortType = MarketSortBtnTypeNormal;
//    _assetsBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _priceBtn.sortType = MarketSortBtnTypeNone;
//    _priceBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _changeBtn.sortType = MarketSortBtnTypeNone;
//    _changeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _selectBtn = _assetsBtn;
}

- (void)refreshBtnStatus:(MarketSortBtn *)sender {
    if (sender.sortType == MarketSortBtnTypeNone) {
        sender.sortType = MarketSortBtnTypeNormal;
    } else if (sender.sortType == MarketSortBtnTypeNormal) {
        sender.sortType = MarketSortBtnTypeUp;
    } else if (sender.sortType == MarketSortBtnTypeUp) {
        sender.sortType = MarketSortBtnTypeDown;
    } else if (sender.sortType == MarketSortBtnTypeDown) {
        sender.sortType = MarketSortBtnTypeNormal;
    }
    if (sender != _assetsBtn) {
        _assetsBtn.sortType = MarketSortBtnTypeNone;
    }
    if (sender != _priceBtn) {
        _priceBtn.sortType = MarketSortBtnTypeNone;
    }
    if (sender != _changeBtn) {
        _changeBtn.sortType = MarketSortBtnTypeNone;
    }
    
    [self sortAndRefresh];
}

- (void)sortAndRefresh {
    kWeakSelf(self);
    [_sourceArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        BinaTpcsModel *model1 = obj1;
        BinaTpcsModel *model2 = obj2;
        if (weakself.selectBtn == weakself.assetsBtn) { // 资产排序
            NSComparisonResult result = [model1.symbol compare:model2.symbol];
            if (weakself.selectBtn.sortType == MarketSortBtnTypeNone) {
                return result == NSOrderedDescending;
            } else if (weakself.selectBtn.sortType == MarketSortBtnTypeNormal) {
                return result == NSOrderedDescending;
            } else if (weakself.selectBtn.sortType == MarketSortBtnTypeUp) {
                return result == NSOrderedDescending;
            } else if (weakself.selectBtn.sortType == MarketSortBtnTypeDown) {
                return result == NSOrderedAscending;
            }
        } else if (weakself.selectBtn == weakself.priceBtn) { // 价格排序
            NSComparisonResult result = [model1.lastPrice compare:model2.lastPrice];
            if (weakself.selectBtn.sortType == MarketSortBtnTypeNone) {
                return result == NSOrderedDescending;
            } else if (weakself.selectBtn.sortType == MarketSortBtnTypeNormal) {
                return result == NSOrderedDescending;
            } else if (weakself.selectBtn.sortType == MarketSortBtnTypeUp) {
                return result == NSOrderedDescending;
            } else if (weakself.selectBtn.sortType == MarketSortBtnTypeDown) {
                return result == NSOrderedAscending;
            }
        } else if (weakself.selectBtn == weakself.changeBtn) { // 幅度排序
            NSComparisonResult result = [model1.priceChangePercent compare:model2.priceChangePercent];
            if (weakself.selectBtn.sortType == MarketSortBtnTypeNone) {
                return result == NSOrderedDescending;
            } else if (weakself.selectBtn.sortType == MarketSortBtnTypeNormal) {
                return result == NSOrderedDescending;
            } else if (weakself.selectBtn.sortType == MarketSortBtnTypeUp) {
                return result == NSOrderedDescending;
            } else if (weakself.selectBtn.sortType == MarketSortBtnTypeDown) {
                return result == NSOrderedAscending;
            }
        }
        
        NSComparisonResult result = [model1.symbol compare:model2.symbol];
        return result == NSOrderedDescending;
    }];
    
    [self.mainTable reloadData];
}

#pragma mark - Request
- (void)requestBinaTpcs {
    if (_tokenSymbolArr.count <= 0) {
        [_sourceArr removeAllObjects];
        [self.mainTable reloadData];
        return;
    }
    kWeakSelf(self);
    NSString *coin = [ConfigUtil getLocalUsingCurrency];
    NSDictionary *params = @{@"symbols":_tokenSymbolArr,@"coin":coin};
    [RequestService requestWithUrl:binaTpcs_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainTable.slimeView endRefresh];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            [weakself.sourceArr removeAllObjects];
            NSArray *arr = [responseObject objectForKey:Server_Data];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BinaTpcsModel *model = [BinaTpcsModel getObjectWithKeyValues:obj];
                [weakself.sourceArr addObject:model];
            }];
            [weakself.mainTable reloadData];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.mainTable.slimeView endRefresh];
    }];
}

//- (void)requestTokenPrice {
//    if (_tokenSymbolArr.count <= 0) {
//        return;
//    }
//    kWeakSelf(self);
//    NSString *coin = [ConfigUtil getLocalUsingCurrency];
//    NSDictionary *params = @{@"symbols":_tokenSymbolArr,@"coin":coin};
//    [RequestService requestWithUrl:tokenPrice_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
//            [weakself.tokenPriceArr removeAllObjects];
//            NSArray *arr = [responseObject objectForKey:Server_Data];
//            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                TokenPriceModel *model = [TokenPriceModel getObjectWithKeyValues:obj];
//                model.coin = coin;
//                [weakself.tokenPriceArr addObject:model];
//            }];
//            [weakself.mainTable reloadData];
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//    }];
//}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MarketsCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MarketsCell *cell = [tableView dequeueReusableCellWithIdentifier:MarketsCellReuse];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BinaTpcsModel *model = _sourceArr[indexPath.row];
    [cell configCellWithModel:model];
    
    return cell;
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_mainTable.slimeView) {
        [_mainTable.slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_mainTable.slimeView) {
        [_mainTable.slimeView scrollViewDidEndDraging];
    }
}

#pragma mark - SRRefreshDelegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView {
    [self requestBinaTpcs];
}

#pragma mark - Action

- (IBAction)addAction:(id)sender {
    [self jumpToAddMarkets];
}

- (IBAction)assetsSortAction:(MarketSortBtn *)sender {
    _selectBtn = sender;
    [self refreshBtnStatus:sender];
}

- (IBAction)priceSortAction:(MarketSortBtn *)sender {
    _selectBtn = sender;
    [self refreshBtnStatus:sender];
}

- (IBAction)changeSortAction:(MarketSortBtn *)sender {
    _selectBtn = sender;
    [self refreshBtnStatus:sender];
}

#pragma mark - Transition
- (void)jumpToAddMarkets {
    AddMarketsViewController *vc = [[AddMarketsViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Lazy
- (RefreshTableView *)mainTable {
    if (!_mainTable) {
        _mainTable = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, _tableBack.width, _tableBack.height) style:UITableViewStylePlain];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.slimeView.delegate = self;
        _mainTable.showsVerticalScrollIndicator = NO;
        _mainTable.showsHorizontalScrollIndicator = NO;
        _mainTable.backgroundColor = [UIColor clearColor];
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableBack addSubview:_mainTable];
        [_mainTable registerNib:[UINib nibWithNibName:MarketsCellReuse bundle:nil] forCellReuseIdentifier:MarketsCellReuse];
        [_mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(_tableBack).offset(0);
        }];
    }
    return _mainTable;
}

@end
