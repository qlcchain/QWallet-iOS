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

@interface MyPortfolioViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topGradientBack;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayEarnLab;
@property (weak, nonatomic) IBOutlet UILabel *cumulativeEarnLab;

@property (weak, nonatomic) IBOutlet UITableView *mainTable;

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) FinanceOrderListModel *orderListM;

@end

@implementation MyPortfolioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:MyPortfolioCellReuse bundle:nil] forCellReuseIdentifier:MyPortfolioCellReuse];
    
    [self configInit];
    [self requestOrder_list];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_topGradientBack addQGradientWithStart:UIColorFromRGB(0x4986EE) end:UIColorFromRGB(0x4752E9)];
}

#pragma mark - Operation
- (void)configInit {
    
}

- (void)refreshView {
    [_mainTable reloadData];
    _totalLab.text = _orderListM.balance?:@"0";
    _yesterdayEarnLab.text = [NSString stringWithFormat:@"+%@",_orderListM.yesterdayRevenue];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)menuAction:(id)sender {
    
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
    NSString *page = @"1";
    NSString *size = @"20";
    NSDictionary *params = @{@"account":account,@"token":token,@"address":address,@"page":page,@"size":size};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:order_list_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            weakself.orderListM = [FinanceOrderListModel getObjectWithKeyValues:responseObject];
            [weakself.sourceArr removeAllObjects];
            [weakself.sourceArr addObjectsFromArray:weakself.orderListM.orderList];
            [weakself refreshView];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
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
    NSString *timestamp = [NSString stringWithFormat:@"%@",@([NSDate getTimestampFromDate:[NSDate date]])];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSDictionary *params = @{@"account":account,@"token":token,@"orderId":orderId};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:redeem_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:@"Redeem Successful."];
            [weakself requestOrder_list];
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
    [cell configCell:model];
    kWeakSelf(self)
    cell.redeemB = ^(NSString *orderId) {
//        [weakself requestRedeem:orderId];
    };
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
