//
//  HistoryRecordsViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/2.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "HistoryRecordsViewController.h"
#import "HistoryRecordsCell.h"
#import "HistoryWifiCell.h"
#import "RefreshTableView.h"
#import <MJExtension/MJExtension.h>
#import "HistoryRecrdInfo.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "WalletUtil.h"
#import "HistoryRecrdInfo.h"

@interface HistoryRecordsViewController () <UITableViewDelegate, UITableViewDataSource,SRRefreshDelegate>

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (weak, nonatomic) IBOutlet UIView *tabBackView;
@property (nonatomic , strong) RefreshTableView *mainTable;

@end

@implementation HistoryRecordsViewController

- (IBAction)clickBack:(id)sender {
    [self leftNavBarItemPressedWithPop:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 获取交易记录请求
    //[self sendHistoryRecordRequest];
    
    /**
     同步查询所有数据.
     */
    NSArray* finfAlls = nil;
    if ([WalletUtil checkServerIsMian]) {
        finfAlls = [HistoryRecrdInfo bg_find:HISTORYRECRD_TABNAME where:[NSString stringWithFormat:@"where %@=%d",bg_sqlKey(@"isMainNet"),1]];
    } else {
        finfAlls = [HistoryRecrdInfo bg_find:HISTORYRECRD_TABNAME where:[NSString stringWithFormat:@"where %@=%d or %@ isnull",bg_sqlKey(@"isMainNet"),0,bg_sqlKey(@"isMainNet")]];
    }
    if (finfAlls && finfAlls.count > 0) {
        [self.sourceArr addObjectsFromArray:finfAlls];
    } else {
        [AppD.window showHint:NSStringLocalizable(@"no_records")];
    }
    
    [_tabBackView addSubview:self.mainTable];
    [_mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(_tabBackView).offset(0);
    }];
}

#pragma mark - Config View
- (void)refreshContent {

}

#pragma mark 懒加载
- (NSMutableArray *) sourceArr
{
    if (!_sourceArr) {
        _sourceArr = [NSMutableArray array];
    }
    return _sourceArr;
}





#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return  _sourceArr ? _sourceArr.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HistoryRecordsCell_Height;
}

#pragma mark - UITableViewDataSource -
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryRecrdInfo *model = _sourceArr[(_sourceArr.count -1) - indexPath.row];
    if (model.recordType == 0) {
         HistoryWifiCell *cell = [tableView dequeueReusableCellWithIdentifier:HistoryWifiCellReuse];
        [cell configCellWithModel:model];
        return cell;
    } else {
        HistoryRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:HistoryRecordsCellReuse];
        [cell configCellWithModel:model];
          return cell;
    }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


- (RefreshTableView *)mainTable {
    if (!_mainTable) {
        _mainTable = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, _tabBackView.width, _tabBackView.height) style:UITableViewStylePlain];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.slimeView.delegate = self;
        _mainTable.backgroundColor = [UIColor clearColor];
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_mainTable registerNib:[UINib nibWithNibName:HistoryRecordsCellReuse bundle:nil] forCellReuseIdentifier:HistoryRecordsCellReuse];
        [_mainTable registerNib:[UINib nibWithNibName:HistoryWifiCellReuse bundle:nil] forCellReuseIdentifier:HistoryWifiCellReuse];
    }
    return _mainTable;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (_mainTable.slimeView) {
//        [_mainTable.slimeView scrollViewDidScroll];
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    if (_mainTable.slimeView) {
//        [_mainTable.slimeView scrollViewDidEndDraging];
//    }
}

#pragma mark - slimeRefresh delegate
//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView {
    //[self sendHistoryRecordRequest];
}

/**
 结束刷新
 */
- (void) endRefresh
{
    [_mainTable.slimeView endRefresh];
}


/**
 获取历史交易记录
 */
- (void) sendHistoryRecordRequest
{
//    [RequestService requestWithUrl:getTranRecord_Url params:@{@"address":[CurrentWalletInfo getShareInstance].address} httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        [self endRefresh];
//        if ([[responseObject objectForKey:@"code"] isEqualToString:@"0"]) {
//            
//            NSArray *arr = [responseObject objectForKey:@"data"];
//            if (arr && arr.count > 0) {
//                NSArray *array = [HistoryRecrdInfo mj_objectArrayWithKeyValuesArray:arr];
//                if (self.sourceArr.count>0) {
//                    [self.sourceArr removeAllObjects];
//                }
//                [self.sourceArr addObjectsFromArray:array];
//                [self.mainTable reloadData];
//            } else {
//                [self showHint:[responseObject objectForKey:@"msg"]];
//            }
//            
//        } else {
//            [self showHint:[responseObject objectForKey:@"msg"]];
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        [self endRefresh];
//        [self showHint:NSStringLocalizable(@"request_error")];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
