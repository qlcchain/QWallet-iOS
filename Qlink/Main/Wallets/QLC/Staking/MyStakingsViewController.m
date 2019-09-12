//
//  MyStakingsViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/8/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MyStakingsViewController.h"
#import "UIView+Gradient.h"
#import "NewStakingViewController.h"
#import "MyStakingsCell.h"
#import "StakingDetailViewController.h"
#import "AFJSONRPCClient.h"
#import "ConfigUtil.h"
#import "WalletCommonModel.h"
#import "RefreshHelper.h"
#import "PledgeInfoByBeneficialModel.h"
#import "NSString+RandomStr.h"

static NSInteger const PledgeInfo_PageCount = 10;
static NSInteger const PledgeInfo_PageFirst = 0;

@interface MyStakingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UIButton *invokeBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalStakingVolumeLab;
@property (weak, nonatomic) IBOutlet UILabel *stakingAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *earningsLab;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) __block NSNumber *totalStakingVolume;
@property (nonatomic) __block NSNumber *stakingAmount;
@property (nonatomic) __block NSNumber *earnings;

@end

@implementation MyStakingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.theme_backgroundColor = globalBackgroundColorPicker;
    
    [self configInit];
    
    [self requestPledgeInfoByPledge:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshView];
}

#pragma mark - Operation
- (void)configInit {
    [self.view addQGradientWithStart:UIColorFromRGB(0x4986EE) end:UIColorFromRGB(0x4752E9) frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _invokeBtn.layer.cornerRadius = 4.0f;
    _invokeBtn.layer.masksToBounds = YES;
    [_mainTable registerNib:[UINib nibWithNibName:MyStakingsCellReuse bundle:nil] forCellReuseIdentifier:MyStakingsCellReuse];
    _sourceArr = [NSMutableArray array];
    _currentPage = PledgeInfo_PageFirst;
    _totalStakingVolume = @(0);
    _stakingAmount = @(0);
    _earnings = @(0);
    
    kWeakSelf(self)
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = PledgeInfo_PageFirst;
        [weakself requestPledgeInfoByPledge:NO];
    }];
    _mainTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestPledgeInfoByPledge:NO];
    }];
}

- (void)refreshView {
    [_mainTable reloadData];
    
    [self refreshAmountView];
}

- (void)refreshAmountView {
    _totalStakingVolume = @(0);
    _stakingAmount = @(0);
    _earnings = @(0);
    kWeakSelf(self);
    [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PledgeInfoByBeneficialModel *model = obj;
        weakself.totalStakingVolume = @([weakself.totalStakingVolume doubleValue]+[model.amount doubleValue]);
        weakself.stakingAmount = @([weakself.stakingAmount doubleValue]+[model.amount doubleValue]);
        weakself.earnings = @([weakself.earnings doubleValue]+[model.qgas doubleValue]);
    }];
    
    _totalStakingVolumeLab.text = [NSString stringWithFormat:@"%@",@([_totalStakingVolume doubleValue]/QLC_UnitNum)];
    _stakingAmountLab.text = [NSString stringWithFormat:@"%@",@([_stakingAmount doubleValue]/QLC_UnitNum)];
    _earningsLab.text = [NSString stringWithFormat:@"%@",@([_earnings doubleValue]/QLC_UnitNum)];
}

#pragma mark - Request
- (void)requestPledgeInfoByPledge:(BOOL)showLoad {
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_staking_node]]];
    // Invocation with Parameters and Request ID
    NSString *requestId = [NSString randomOf32];
    //qlc_178gc7sgefmfbmn1fi8uqhecwyewt6wu1y9rko1fb9snu89uupm1moc65gxu
    kWeakSelf(self);
    if (showLoad) {
        [kAppD.window makeToastInView:kAppD.window];
    }
    NSArray *params = @[_inputAddress?:@"", @(PledgeInfo_PageCount), @(_currentPage*PledgeInfo_PageCount)];
    // ledger_pledgeInfoByBeneficial   ledger_pledgeInfoByPledge
    DDLogDebug(@"ledger_pledgeInfoByBeneficial params = %@",params);
    [client invokeMethod:@"ledger_pledgeInfoByBeneficial" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        NSLog(@"ledger_pledgeInfoByBeneficial result=%@",responseObject);
        NSArray *arr = [PledgeInfoByBeneficialModel mj_objectArrayWithKeyValuesArray:responseObject] ;
        
        if (weakself.currentPage == PledgeInfo_PageFirst) {
            [weakself.sourceArr removeAllObjects];
        }
        [weakself.sourceArr addObjectsFromArray:arr];
        [weakself refreshView];
        // 最后加1
        weakself.currentPage += 1;
        
        if (arr.count < PledgeInfo_PageCount) {
            [weakself.mainTable.mj_footer endRefreshingWithNoMoreData];
//            weakself.mainTable.mj_footer.hidden = arr.count<=0?YES:NO;
            weakself.mainTable.mj_footer.hidden = YES;
        } else {
            weakself.mainTable.mj_footer.hidden = NO;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        NSLog(@"error=%@",error);
    }];
//    [client invokeMethod:@"nep5_prePareBenefitPledge" withParameters:@[@{@"beneficial":@"qlc_3fn7dsybngcf3ieoynyqox1xo8rx8haxh97tuq6f96erne7h844z7jt3x3h1",@"amount":@"100000000",@"pType":@"vote"}, @{@"multiSigAddress":@"APJL237LMQvP7E5c2BXnVe9wA1FsradG64",@"publicKey":@"0259c03e13f70ff2ff9e0da1a6200f071ee31938e1f2a6b5eee9bbabb95d6d722d",@"lockTxId":@"c4c767bb9852a443767fb8a64ef1d1112ed4d2e9c97ec86b56a39d70bbcb4db6"}] requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"result=%@",responseObject);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"error=%@",error);
//    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MyStakingsCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PledgeInfoByBeneficialModel *model = _sourceArr[indexPath.row];
    [self jumpToStakingDetail:model];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyStakingsCell *cell = [tableView dequeueReusableCellWithIdentifier:MyStakingsCellReuse];
    
    PledgeInfoByBeneficialModel *model = _sourceArr[indexPath.row];
    [cell config:model];
    
    return cell;
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)invokeNewStakingAction:(id)sender {
    [self jumpToNewStaking];
}

#pragma mark - Transition
- (void)jumpToNewStaking {
    NewStakingViewController *vc = [NewStakingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToStakingDetail:(PledgeInfoByBeneficialModel *)model {
    StakingDetailViewController *vc = [StakingDetailViewController new];
    vc.inputPledgeM = model;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
