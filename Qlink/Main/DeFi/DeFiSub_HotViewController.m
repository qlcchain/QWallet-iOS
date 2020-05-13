//
//  DeFISub_HotViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DeFiSub_HotViewController.h"
#import "DeFiHotCell.h"
#import "RefreshHelper.h"
#import "WebViewController.h"
#import "DefiNewsListModel.h"

static NSString *const NetworkSize = @"20";

@interface DeFiSub_HotViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@property (nonatomic) NSInteger currentPage;


@end

@implementation DeFiSub_HotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self request_defi_news_list];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Operation
- (void)configInit {
    _currentPage = 1;
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:DeFiHotCell_Reuse bundle:nil] forCellReuseIdentifier:DeFiHotCell_Reuse];
    self.baseTable = _mainTable;
    
    kWeakSelf(self)
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = 1;
        [weakself request_defi_news_list];
    } type:RefreshTypeColor];
    _mainTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself request_defi_news_list];
    } type:RefreshTypeColor];
}

#pragma mark - Request
- (void)request_defi_news_list {
    kWeakSelf(self);
     NSString *page = [NSString stringWithFormat:@"%li",_currentPage];
    NSString *size = NetworkSize;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"page":page,@"size":size}];
    [RequestService requestWithUrl5:defi_news_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [DefiNewsListModel mj_objectArrayWithKeyValuesArray:responseObject[@"newsList"]];
            if (weakself.currentPage == 1) {
                [weakself.sourceArr removeAllObjects];
            }

            [weakself.sourceArr addObjectsFromArray:arr];

            weakself.currentPage = weakself.currentPage + 1;

            [weakself.mainTable reloadData];

            if (arr.count < [NetworkSize integerValue]) {
                [weakself.mainTable.mj_footer endRefreshingWithNoMoreData];
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
    DeFiHotCell *cell = [tableView dequeueReusableCellWithIdentifier:DeFiHotCell_Reuse];
    
    DefiNewsListModel *model = _sourceArr[indexPath.row];
    kWeakSelf(self);
    [cell config:model index:indexPath.row contentB:^(DefiNewsListModel * _Nonnull newsM, NSInteger index) {
//        if (newsM.content && newsM.content.length > 0) {
//            [weakself.mainTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0] ] withRowAnimation:UITableViewRowAnimationNone];
            [weakself.mainTable reloadData];
//        }
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DefiNewsListModel *model = _sourceArr[indexPath.row];
    return [DeFiHotCell cellHeight:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
//    https://www.chainnews.com/articles/360764508535.htm
    NSString *url = @"https://www.chainnews.com/articles/360764508535.htm";
//    NSString *url = @"https://cointelegraph.com/tags/defi";
    [self jumpToWeb:url];
}

#pragma mark - Transition
- (void)jumpToWeb:(NSString *)url {
    WebViewController *vc = [WebViewController new];
    vc.inputTitle = kLang(@"hot");
    vc.inputUrl = url;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
