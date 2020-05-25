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
#import "DeFiNewsWebViewController.h"

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
    _mainTable.estimatedRowHeight = 60;
    _mainTable.rowHeight = UITableViewAutomaticDimension;
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

//- (void)request_defi_news:(DefiNewsListModel *)model {
//    kWeakSelf(self);
//    NSDictionary *params = @{@"newsId":model.ID};
//    [kAppD.window makeToastInView:kAppD.window];
//    [RequestService requestWithUrl5:defi_news_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        [kAppD.window hideToast];
//        if ([responseObject[Server_Code] integerValue] == 0) {
//            DefiNewsListModel *resultM = [DefiNewsListModel mj_objectWithKeyValues:responseObject[@"news"]];
//            
//            NSString *inputJson = resultM.content;
//            [weakself jumpToDeFiNewsWeb:inputJson title:resultM.title];
//            return;
//            
//            resultM.requestContentSuccess = YES;
//            resultM.isShowDetail = YES;
//            
//            NSArray *tempArr = [NSArray arrayWithArray:weakself.sourceArr];
//            [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                DefiNewsListModel *tempM = obj;
//                if ([tempM.ID isEqualToString:resultM.ID]) {
//                    [weakself.sourceArr replaceObjectAtIndex:idx withObject:resultM];
//                    *stop = YES;
//                }
//            }];
//
//            [weakself.mainTable reloadData];
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        [kAppD.window hideToast];
//    }];
//}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeFiHotCell *cell = [tableView dequeueReusableCellWithIdentifier:DeFiHotCell_Reuse];
    
    DefiNewsListModel *model = _sourceArr[indexPath.row];
//    kWeakSelf(self);
    [cell config:model index:indexPath.row contentB:^(DefiNewsListModel * _Nonnull newsM, NSInteger index) {
//        if (newsM.content && newsM.content.length > 0) {
//            [weakself.mainTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0] ] withRowAnimation:UITableViewRowAnimationNone];
        
//        if (newsM.requestContentSuccess) {
//            [weakself.mainTable reloadData];
//        } else {
//            [weakself request_defi_news:newsM];
//        }
            
//        }
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    DefiNewsListModel *model = _sourceArr[indexPath.row];
//    return [DeFiHotCell cellHeight:model];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
//    NSString *url = @"https://www.chainnews.com/articles/360764508535.htm"; // 中文
//    NSString *url = @"https://cointelegraph.com/tags/defi"; // 英文
//    [self jumpToWeb:url];
    DefiNewsListModel *model = _sourceArr[indexPath.row];
    [self jumpToDeFiNewsWeb:model.title newsID:model.ID];
}

#pragma mark - Transition
- (void)jumpToWeb:(NSString *)url {
    WebViewController *vc = [WebViewController new];
    vc.inputTitle = kLang(@"defi_hot");
    vc.inputUrl = url;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToDeFiNewsWeb:(NSString *)title newsID:(NSString *)newsID {
    DeFiNewsWebViewController *vc = [DeFiNewsWebViewController new];
//    vc.inputTitle = title;
    vc.projectID = newsID;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
