//
//  MyStakingsViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/8/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "DailyEarningsViewController.h"
#import "UIView+Gradient.h"
#import "ConfigUtil.h"
#import "WalletCommonModel.h"
#import "RefreshHelper.h"
#import "NSString+RandomStr.h"
#import <SwiftTheme/SwiftTheme-Swift.h>
#import "NEOWalletInfo.h"
#import "QLCWalletInfo.h"
#import "DailyEarningsCell.h"
#import "UserModel.h"
#import "MD5Util.h"
#import "RSAUtil.h"
#import "NSDate+Category.h"
#import "ClaimConstants.h"
#import "RewardListModel.h"
#import "ClaimQGASViewController.h"
#import "WebViewController.h"

static NSInteger const DailyEarnings_PageCount = 20;
static NSInteger const DailyEarnings_PageFirst = 1;

@interface DailyEarningsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UIButton *claimBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalStakeAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *canClaimAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *claimedAmountLab;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic) NSInteger currentPage;
//@property (nonatomic) __block NSNumber *totalStakingVolume;
//@property (nonatomic) __block NSNumber *stakingAmount;
//@property (nonatomic) __block NSNumber *earnings;

@end

@implementation DailyEarningsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.theme_backgroundColor = globalBackgroundColorPicker;
    
    [self configInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_mainTable.mj_header beginRefreshing];

    [self refreshView];
}

#pragma mark - Operation
- (void)configInit {
    [self.view addQGradientWithStart:UIColorFromRGB(0x4986EE) end:UIColorFromRGB(0x4752E9) frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _claimBtn.layer.cornerRadius = 4.0f;
    _claimBtn.layer.masksToBounds = YES;
    [_mainTable registerNib:[UINib nibWithNibName:DailyEarningsCellReuse bundle:nil] forCellReuseIdentifier:DailyEarningsCellReuse];
    _sourceArr = [NSMutableArray array];
    _currentPage = DailyEarnings_PageFirst;
//    _totalStakingVolume = @(0);
//    _stakingAmount = @(0);
//    _earnings = @(0);
    
    kWeakSelf(self)
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = DailyEarnings_PageFirst;
        [weakself getCanClaimAmount];
        kWeakSelf(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
            [weakself getClaimedAmount];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
            [weakself getFreeStakeAmount];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
            [weakself requestReward_reward_list:NO];
        });
    }];
    _mainTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestReward_reward_list:NO];
    }];
}

- (void)getCanClaimAmount {
    kWeakSelf(self);
    [self requestReward_reward_total:Claim_Type_Register status:Claim_Status_New completeBlock:^(NSString *reward) {
        weakself.canClaimAmountLab.text = reward;
    }];
}

- (void)getClaimedAmount {
    kWeakSelf(self);
    [self requestReward_reward_total:Claim_Type_Register status:Claim_Status_Success completeBlock:^(NSString *reward) {
        weakself.claimedAmountLab.text = reward;
    }];
}

- (void)getFreeStakeAmount {
    kWeakSelf(self);
    [self requestWinq_reward_qlc_amountWithCompleteBlock:^(NSString *amount) {
        weakself.totalStakeAmountLab.text = amount;
    }];
}

- (void)refreshView {
    [_mainTable reloadData];
    
}

#pragma mark - Request
- (void)requestReward_reward_list:(BOOL)showLoad {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    //    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSDictionary *params = @{@"account":account,@"token":token,@"page":@(_currentPage),@"size":@(DailyEarnings_PageCount),@"type":Claim_Type_Register,@"status":Claim_Status_New};
    kWeakSelf(self);
    if (showLoad) {
        [kAppD.window makeToastInView:kAppD.window];
    }
    [RequestService requestWithUrl11:reward_reward_list_Url params:params timestamp:timestamp httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [RewardListModel mj_objectArrayWithKeyValuesArray:responseObject[@"rewardList"]] ;
            
            if (weakself.currentPage == DailyEarnings_PageFirst) {
                [weakself.sourceArr removeAllObjects];
            }
            [weakself.sourceArr addObjectsFromArray:arr];
            [weakself refreshView];
            // 最后加1
            weakself.currentPage += 1;
            
            if (arr.count < DailyEarnings_PageCount) {
                [weakself.mainTable.mj_footer endRefreshingWithNoMoreData];
                //            weakself.mainTable.mj_footer.hidden = arr.count<=0?YES:NO;
                weakself.mainTable.mj_footer.hidden = YES;
            } else {
                weakself.mainTable.mj_footer.hidden = NO;
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        NSLog(@"error=%@",error);
    }];
}

- (void)requestReward_reward_total:(NSString *)type status:(NSString *)status completeBlock:(void(^)(NSString *reward))completeBlock {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    //    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSDictionary *params = @{@"account":account,@"token":token,@"type":type,@"status":status};
    [RequestService requestWithUrl11:reward_reward_total_Url params:params timestamp:timestamp httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            if (completeBlock) {
                NSString *result = [NSString stringWithFormat:@"%@",responseObject[@"rewardTotal"]];
                completeBlock(result);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestWinq_reward_qlc_amountWithCompleteBlock:(void(^)(NSString *amount))completeBlock {
//    kWeakSelf(self);
    NSDictionary *params = @{@"dictType":winq_reward_qlc_amount};
    [RequestService requestWithUrl10:sys_dict_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSString *valueStr = responseObject[Server_Data][@"value"];
            
            if (completeBlock) {
                completeBlock(valueStr);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DailyEarningsCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DailyEarningsCell *cell = [tableView dequeueReusableCellWithIdentifier:DailyEarningsCellReuse];
    
    RewardListModel *model = _sourceArr[indexPath.row];
    [cell config:model];
    
    return cell;
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)claimAction:(id)sender {
    if ([_canClaimAmountLab.text doubleValue] <= 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"no_qgas_can_claim")];
        return;
    }
    
    [self jumpToClaimQGAS];
}

- (IBAction)networkAction:(id)sender {
    [self jumpToQLCChain];
}


#pragma mark - Transition
- (void)jumpToClaimQGAS {
    ClaimQGASViewController *vc = [ClaimQGASViewController new];
    vc.inputCanClaimAmount = _canClaimAmountLab.text?:@"0";
    vc.claimQGASType = ClaimQGASTypeDailyEarnings;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToQLCChain {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.inputUrl = Explorer_QLCChain_Org_Url;
    vc.inputTitle = QLCChainOfTitle;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
