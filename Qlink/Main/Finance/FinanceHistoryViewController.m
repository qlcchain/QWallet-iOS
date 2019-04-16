//
//  FinanceHistoryViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/16.
//  Copyright © 2019 pan. All rights reserved.
//

#import "FinanceHistoryViewController.h"
#import "FinanceOrderListModel.h"
#import "UserModel.h"
#import "FinanceHistoryCell.h"
#import "NSDate+Category.h"
#import "RSAUtil.h"
#import "Qlink-Swift.h"
#import "RefreshHelper.h"

@interface FinanceHistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) FinanceOrderListModel *orderListM;
@property (nonatomic) NSInteger currentPage;

@end

@implementation FinanceHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self configInit];
    [self requestOrder_list];
}

#pragma mark - Operation
- (void)configInit {
    _sourceArr = [NSMutableArray array];
    _currentPage = 1;
    [_mainTable registerNib:[UINib nibWithNibName:FinanceHistoryCellReuse bundle:nil] forCellReuseIdentifier:FinanceHistoryCellReuse];
    kWeakSelf(self)
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = 1;
        [weakself requestOrder_list];
    }];
    _mainTable.mj_footer = [RefreshHelper footerWithRefreshingBlock:^{
        [weakself requestOrder_list];
    }];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Request
// 订单列表
- (void)requestOrder_list {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [NSString stringWithFormat:@"%@",@([NSDate getTimestampFromDate:[NSDate date]])];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSString *address = [NEOWalletManage.sharedInstance getWalletAddress];
    NSString *page = [NSString stringWithFormat:@"%li",(long)_currentPage];
    NSString *size = @"20";
    NSDictionary *params = @{@"account":account,@"token":token,@"address":address,@"page":page,@"size":size};
//    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:order_list_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
//        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            weakself.orderListM = [FinanceOrderListModel getObjectWithKeyValues:responseObject];
            if (weakself.currentPage == 1) {
                [weakself.sourceArr removeAllObjects];
            }
            [weakself.sourceArr addObjectsFromArray:weakself.orderListM.orderList];
            [weakself.mainTable reloadData];
            weakself.currentPage += 1;
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        [kAppD.window hideToast];
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FinanceHistoryCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FinanceHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:FinanceHistoryCellReuse];
    
    FinanceOrderModel *model = _sourceArr[indexPath.row];
//    cell.row = indexPath.row;
    [cell configCell:model];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
