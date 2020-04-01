//
//  MyTopupOrderViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MiningDailyDetailViewController.h"
#import "MiningDailyDetailCell.h"
#import "RefreshHelper.h"
#import "UserModel.h"
#import "TopupOrderModel.h"
#import "TopupConstants.h"
#import "TopupWebViewController.h"
#import "TopupCredentialViewController.h"
#import "RSAUtil.h"
#import "MiningConstants.h"
#import "MiningRewardListModel.h"
#import "AppJumpHelper.h"

static NSString *const MiningDailyDetailNetworkSize = @"20";

@interface MiningDailyDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UIView *emptyBack;

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic) NSInteger currentPage;

@end

@implementation MiningDailyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self requestTrade_mining_reward_list];
}

#pragma mark - Operation
- (void)configInit {
    _currentPage = 1;
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:MiningDailyDetailCell_Reuse bundle:nil] forCellReuseIdentifier:MiningDailyDetailCell_Reuse];
    self.baseTable = _mainTable;
    
    kWeakSelf(self)
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = 1;
        [weakself requestTrade_mining_reward_list];
    }];
    _mainTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestTrade_mining_reward_list];
    }];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Request
- (void)requestTrade_mining_reward_list {
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
    NSString *page = [NSString stringWithFormat:@"%li",_currentPage];
    NSString *size = MiningDailyDetailNetworkSize;
//    NSString *status = Mining_STATUS_AWARDED;
//    NSDictionary *params = @{@"page":page,@"size":size,@"account":account,@"token":token,@"status":status};
    NSDictionary *params = @{@"page":page,@"size":size,@"account":account,@"token":token};
     [RequestService requestWithUrl6:trade_mining_reward_list_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [MiningRewardListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            if (weakself.currentPage == 1) {
                [weakself.sourceArr removeAllObjects];
            }
            
            [weakself.sourceArr addObjectsFromArray:arr];
            weakself.currentPage += 1;
            
            [weakself.mainTable reloadData];
            
            if (arr.count < [MiningDailyDetailNetworkSize integerValue]) {
                [weakself.mainTable.mj_footer endRefreshingWithNoMoreData];
                weakself.mainTable.mj_footer.hidden = arr.count<=0?YES:NO;
            } else {
                weakself.mainTable.mj_footer.hidden = NO;
            }
            
            weakself.emptyBack.hidden = weakself.sourceArr.count <= 0?NO:YES;
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MiningDailyDetailCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MiningDailyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:MiningDailyDetailCell_Reuse];
    
//    kWeakSelf(self);
    MiningRewardListModel *model = _sourceArr[indexPath.row];
    [cell config:model];
    
    return cell;
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    if (_inputBackToRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)tradeAction:(id)sender {
    [AppJumpHelper jumpToOTC];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Transition


@end
