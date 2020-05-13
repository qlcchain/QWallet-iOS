//
//  DeFiHistoricalstatsViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DeFiHistoricalstatsViewController.h"
#import "DeFiHistoricalstatsCell.h"
#import "DefiProjectListModel.h"
#import "RefreshHelper.h"
#import "DefiHistoricalStatsListModel.h"

static NSString *const NetworkSize = @"30";

@interface DeFiHistoricalstatsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *tvlLab;
@property (weak, nonatomic) IBOutlet UILabel *lockedLab;


@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic) NSInteger currentPage;

@end

@implementation DeFiHistoricalstatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self configInit];
    [self request_defi_stats_list];
}

#pragma mark - Operation
- (void)configInit {
    _currentPage = 1;
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:DeFiHistoricalstatsCell_Reuse bundle:nil] forCellReuseIdentifier:DeFiHistoricalstatsCell_Reuse];
    self.baseTable = _mainTable;
    
    _dateLab.text = kLang(@"defi_date");
    _tvlLab.text = kLang(@"defi_tvl_usd");
    _lockedLab.text = kLang(@"defi_total_eth_locked");
    
    kWeakSelf(self)
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = 1;
        [weakself request_defi_stats_list];
    } type:RefreshTypeColor];
    _mainTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself request_defi_stats_list];
    } type:RefreshTypeColor];
}

#pragma mark - Request
- (void)request_defi_stats_list {
    kWeakSelf(self);
     NSString *page = [NSString stringWithFormat:@"%li",_currentPage];
    NSString *size = NetworkSize;
    NSString *projectId = _inputProjectListM.ID?:@"";
    NSDictionary *params = @{@"page":page,@"size":size,@"projectId":projectId};
    [RequestService requestWithUrl5:defi_stats_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [DefiHistoricalStatsListModel mj_objectArrayWithKeyValuesArray:responseObject[@"historicalStatsList"]];
            if (weakself.currentPage == 1) {
                [weakself.sourceArr removeAllObjects];
            }
            
            [weakself.sourceArr addObjectsFromArray:arr];
            weakself.currentPage += 1;
            
            [weakself.mainTable reloadData];
            
            if (arr.count < [NetworkSize integerValue]) {
                [weakself.mainTable.mj_footer endRefreshingWithNoMoreData];
//                weakself.mainTable.mj_footer.hidden = arr.count<=0?YES:NO;
                weakself.mainTable.mj_footer.hidden = YES;
            } else {
                weakself.mainTable.mj_footer.hidden = NO;
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeFiHistoricalstatsCell *cell = [tableView dequeueReusableCellWithIdentifier:DeFiHistoricalstatsCell_Reuse];
    
    DefiHistoricalStatsListModel *model = _sourceArr[indexPath.row];
    [cell config:model];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DeFiHistoricalstatsCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
