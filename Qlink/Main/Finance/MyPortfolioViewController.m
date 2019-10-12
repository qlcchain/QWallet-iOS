//
//  MyPortfolioViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/12.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MyPortfolioViewController.h"
#import "UIView+Gradient.h"
#import "MyPortfolioCell.h"
#import "UserModel.h"
#import "NSDate+Category.h"
#import "MD5Util.h"
#import "RSAUtil.h"
#import "Qlink-Swift.h"
#import "FinanceOrderListModel.h"
#import "FinanceRedeemConfirmView.h"
#import "FinanceHistoryViewController.h"
#import "RefreshHelper.h"
#import <SwiftTheme/SwiftTheme-Swift.h>

//#import "GlobalConstants.h"

@interface MyPortfolioViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topGradientBack;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayEarnLab;
@property (weak, nonatomic) IBOutlet UILabel *cumulativeEarnLab;

@property (weak, nonatomic) IBOutlet UITableView *mainTable;

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) FinanceOrderListModel *orderListM;
@property (nonatomic) NSInteger currentPage;

@end

@implementation MyPortfolioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.theme_backgroundColor = globalBackgroundColorPicker;
    [self configInit];
    _currentPage = 1;
    [self requestOrder_list];
}

#pragma mark - Operation
- (void)configInit {
    [_topGradientBack addQGradientWithStart:UIColorFromRGB(0x4986EE) end:UIColorFromRGB(0x4752E9) frame:CGRectMake(_topGradientBack.left, _topGradientBack.top, SCREEN_WIDTH, _topGradientBack.height)];
    
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:MyPortfolioCellReuse bundle:nil] forCellReuseIdentifier:MyPortfolioCellReuse];
    
    kWeakSelf(self)
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = 1;
        [weakself requestOrder_list];
    }];
    _mainTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestOrder_list];
    }];
}

- (void)refreshView {
    [_mainTable reloadData];
    
    _totalLab.text = _orderListM.totalQlc?[NSString stringWithFormat:@"%@",_orderListM.totalQlc]:@"0";
    _yesterdayEarnLab.text = [NSString stringWithFormat:@"+%@",_orderListM.yesterdayRevenue];
    _cumulativeEarnLab.text = [NSString stringWithFormat:@"+%@",_orderListM.totalRevenue];
}

- (void)showRedeemConfirmView:(FinanceOrderModel *)model {
    FinanceRedeemConfirmView *view = [FinanceRedeemConfirmView getInstance];
    
    kWeakSelf(self)
    view.confirmBlock = ^{
        [weakself requestRedeem:model.ID];
    };
    [view configWithModel:model];
    [view show];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)menuAction:(id)sender {
    [self jumpToFinanceHistory];
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
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSString *address = [NEOWalletManage.sharedInstance getWalletAddress];
//    NSString *page = @"1";
    NSString *page = [NSString stringWithFormat:@"%li",(long)_currentPage];
    NSString *size = @"20";
    NSDictionary *params = @{@"account":account,@"token":token,@"address":address,@"page":page,@"size":size};
//    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:order_list_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
//        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            weakself.orderListM = [FinanceOrderListModel getObjectWithKeyValues:responseObject];
            if (weakself.currentPage == 1) {
                [weakself.sourceArr removeAllObjects];
            }
            weakself.currentPage += 1;
//            [weakself.sourceArr removeAllObjects];
            [weakself.sourceArr addObjectsFromArray:weakself.orderListM.orderList];
            [weakself refreshView];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
//        [kAppD.window hideToast];
    }];
}

// 订单赎回
- (void)requestRedeem:(NSString *)orderId {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSDictionary *params = @{@"account":account,@"token":token,@"orderId":orderId};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:redeem_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:@"Redeem Success."];
            // 刷新UI
            [weakself.sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FinanceOrderModel *model = obj;
                if ([model.ID isEqualToString:orderId]) {
                    model.status = @"REDEEM";
                    *stop = YES;
                }
            }];
            [weakself.mainTable reloadData];
            
//            [weakself requestOrder_list];
        } else {
            [kAppD.window makeToastDisappearWithText:@"Redeem Fail."];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MyPortfolioCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyPortfolioCell *cell = [tableView dequeueReusableCellWithIdentifier:MyPortfolioCellReuse];
    
    FinanceOrderModel *model = _sourceArr[indexPath.row];
    cell.row = indexPath.row;
    [cell configCell:model];
    kWeakSelf(self)
    cell.redeemB = ^(NSInteger row) {
        FinanceOrderModel *tempM = weakself.sourceArr[row];
        [weakself showRedeemConfirmView:tempM];
    };
    
    return cell;
}

#pragma mark - Transition
- (void)jumpToFinanceHistory {
    FinanceHistoryViewController *vc = [FinanceHistoryViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
