//
//  ShareFriendsViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "SheetMiningViewController.h"
#import "UserModel.h"
#import "NSDate+Category.h"
#import "RSAUtil.h"
#import "ShareFriendsCell.h"
//#import "ShareFriendsModel.h"
#import "InviteRankingModel.h"
#import "InviteRankingViewController.h"
//#import "GuangGaoView.h"
#import "InviteFriendNowViewController.h"
#import "UIColor+Random.h"
//#import "GlobalConstants.h"
#import "ClaimQLCViewController.h"
#import "ClaimConstants.h"
#import "RefreshHelper.h"
#import "WebViewController.h"
#import "MiningConstants.h"
#import "SheetMiningUtil.h"
#import "MiningDailyDetailViewController.h"
#import "MiningRewardIndexModel.h"
#import "RLArithmetic.h"
#import "FirebaseUtil.h"
#import "AppJumpHelper.h"

static NSInteger Mining_PageSize = 20;

@interface SheetMiningViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
//@property (weak, nonatomic) IBOutlet UILabel *invitationCodeLab;
//@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
//@property (weak, nonatomic) IBOutlet UIImageView *topImgV;
@property (weak, nonatomic) IBOutlet UILabel *canClaimAmountLab;
@property (weak, nonatomic) IBOutlet UIButton *claimBtn;
@property (weak, nonatomic) IBOutlet UILabel *invitedAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *claimedAmountLab;
@property (weak, nonatomic) IBOutlet UIView *horizontalLineV;
@property (weak, nonatomic) IBOutlet UIView *claimTipV;
@property (weak, nonatomic) IBOutlet UILabel *claimTipLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainTableHeight;
//@property (weak, nonatomic) IBOutlet UILabel *getQGASBy1Lab;
//@property (weak, nonatomic) IBOutlet UILabel *getQGASBy2Lab;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;

@property (weak, nonatomic) IBOutlet UILabel *qlcAmountLab;
@property (weak, nonatomic) IBOutlet UIButton *tradeBtn;

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) InviteRankingModel *myInfoM;
//@property (nonatomic, strong) NSString *invite_reward_amount;
//@property (nonatomic, strong) NSString *invite_user_amount;
@property (nonatomic, strong) NSString *no_award_amount;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) MiningRewardIndexModel *miningRewardIndexM;

@end

@implementation SheetMiningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    
//    [self requestTrade_mining_reward_rankings]; // 排行榜
    [self refreshClaimBtnStatus];
    
    [FirebaseUtil logEventWithItemID:Firebase_Event_Trades_Mining itemName:Firebase_Event_Trades_Mining contentType:Firebase_Event_Trades_Mining];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self getPullRequest];
    [self requestTrade_mining_index];
}

#pragma mark - Operation
- (void)configInit {
    
    _currentPage = 1;
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:ShareFriendsCellReuse bundle:nil] forCellReuseIdentifier:ShareFriendsCellReuse];
    _mainTableHeight.constant = 0;
    self.baseTable = _mainTable;
    
    _tradeBtn.layer.cornerRadius = 20;
    _tradeBtn.layer.masksToBounds = YES;
    
//    _invite_reward_amount = @"0";
//    _invite_user_amount = @"0";
    _no_award_amount = @"0";
    
    _horizontalLineV.layer.cornerRadius = 3;
    _horizontalLineV.layer.masksToBounds = YES;
    _claimTipV.layer.cornerRadius = 4;
    _claimTipV.layer.masksToBounds = YES;
    _claimBtn.layer.cornerRadius = 2;
    _claimBtn.layer.masksToBounds = YES;
    
    kWeakSelf(self)
    _mainScroll.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
//        [weakself getPullRequest];
        [weakself requestTrade_mining_index];
    } type:RefreshTypeColor];
    
//    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
//        weakself.currentPage = 1;
//        [weakself requestTrade_mining_reward_rankings];
//    }];
//    _mainTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
//        [weakself requestTrade_mining_reward_rankings];
//    }];
}

- (void)getPullRequest {
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [self getNOReward]; // 未领取
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself getRewarded]; // 已领取
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself getDone]; // 已成交
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself getQLCAmount];
    });
}

- (void)getDone {
    kWeakSelf(self);
    [self requestTrade_mining_reward_totalWithStatus:nil completeBlock:^(NSString *reward) {
        NSString *str = [NSString stringWithFormat:kLang(@"___qgas_traded"),reward];
//        NSString *language = [Language currentLanguageCode];
//        if ([language isEqualToString:LanguageCode[0]]) { // 英文
//            str = [NSString stringWithFormat:kLang(@"___qgas_traded"),reward];
//        } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
//            str = [NSString stringWithFormat:kLang(@"___qgas_traded"),reward];
//        }
        weakself.invitedAmountLab.text = str;
    }];
}

- (void)getRewarded {
    kWeakSelf(self);
    [self requestTrade_mining_reward_totalWithStatus:Mining_STATUS_AWARDED completeBlock:^(NSString *reward) {
        NSString *claimedStr = [NSString stringWithFormat:kLang(@"i_have_claimed__qlc"),reward];
//        NSString *language = [Language currentLanguageCode];
//        if ([language isEqualToString:LanguageCode[0]]) { // 英文
//            claimedStr = [NSString stringWithFormat:kLang(@"i_have_claimed__qlc"),reward];
//        } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
//            claimedStr = [NSString stringWithFormat:kLang(@"i_have_claimed__qlc"),reward];
//        }
        weakself.claimedAmountLab.text = claimedStr;
    }];
}

- (void)getNOReward {
    kWeakSelf(self);
    [self requestTrade_mining_reward_totalWithStatus:Mining_STATUS_NO_AWARD completeBlock:^(NSString *reward) {
        weakself.no_award_amount = reward;
        weakself.canClaimAmountLab.text = reward;
        
        [weakself refreshClaimBtnStatus];
    }];
}

- (void)getQLCAmount {
    kWeakSelf(self);
    [SheetMiningUtil requestTrade_mining_list:^(NSArray<MiningActivityModel *> * _Nonnull arr) {
        if (arr.count > 0) {
            MiningActivityModel *model = arr.firstObject;
            weakself.qlcAmountLab.text = [NSString stringWithFormat:@"%@ QLC",model.totalRewardAmount];
        }
    }]; // 交易挖矿活动列表
}

- (void)refreshClaimBtnStatus {
    BOOL btnEnable = NO;
    if (_miningRewardIndexM && [_miningRewardIndexM.noAwardTotal doubleValue] > 0) {
        btnEnable = YES;
    }
    
    if (btnEnable) {
        [_claimBtn setTitleColor:UIColorFromRGB(0x07C2B9) forState:UIControlStateNormal];
        _claimBtn.userInteractionEnabled = YES;
    } else {
        [_claimBtn setTitleColor:[UIColorFromRGB(0x07C2B9) colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        _claimBtn.userInteractionEnabled = NO;
    }
}

- (void)refreshView {
    if (!_miningRewardIndexM) {
        return;
    }
    // qlc amount
    _qlcAmountLab.text = [NSString stringWithFormat:@"%@ QLC",_miningRewardIndexM.totalRewardAmount.mul(@"1")];
    // 未领取
    _canClaimAmountLab.text = _miningRewardIndexM.noAwardTotal.mul(@"1");
    // 已领取
    NSString *claimedStr = [NSString stringWithFormat:kLang(@"i_have_claimed__qlc"),_miningRewardIndexM.awardedTotal.mul(@"1")];
//    NSString *language = [Language currentLanguageCode];
//    if ([language isEqualToString:LanguageCode[0]]) { // 英文
//        claimedStr = [NSString stringWithFormat:kLang(@"i_have_claimed__qlc"),_miningRewardIndexM.awardedTotal.mul(@"1")];
//    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
//        claimedStr = [NSString stringWithFormat:kLang(@"i_have_claimed__qlc"),_miningRewardIndexM.awardedTotal.mul(@"1")];
//    }
    _claimedAmountLab.text = claimedStr;
    // 已成交
    NSString *dealStr = [NSString stringWithFormat:kLang(@"___qgas_traded"),_miningRewardIndexM.totalFinish.mul(@"1")];
//    if ([language isEqualToString:LanguageCode[0]]) { // 英文
//        dealStr = [NSString stringWithFormat:kLang(@"___qgas_traded"),_miningRewardIndexM.totalFinish.mul(@"1")];
//    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
//        dealStr = [NSString stringWithFormat:kLang(@"___qgas_traded"),_miningRewardIndexM.totalFinish.mul(@"1")];
//    }
    _invitedAmountLab.text = dealStr;
    
    
    [_sourceArr removeAllObjects];
    [_sourceArr addObjectsFromArray:_miningRewardIndexM.rewardRankings];
    [_mainTable reloadData];
    _mainTableHeight.constant = ShareFriendsCell_Height*_sourceArr.count;
    
    [self refreshClaimBtnStatus];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)claimAction:(id)sender {
    if ([_canClaimAmountLab.text doubleValue] <= 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"no_qlc_can_claim")];
        return;
    }
    
    [self jumpToClaimQLC];
    [FirebaseUtil logEventWithItemID:Firebase_Event_Claim_QLC itemName:Firebase_Event_Claim_QLC contentType:Firebase_Event_Claim_QLC];
}

- (IBAction)miningQLCAction:(id)sender {
    [self jumpToGetQLC];
}

- (IBAction)tradeAction:(id)sender {
    [AppJumpHelper jumpToOTC];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [FirebaseUtil logEventWithItemID:Firebase_Event_Trade_NOW itemName:Firebase_Event_Trade_NOW contentType:Firebase_Event_Trade_NOW];
}

- (IBAction)dailyDetailAction:(id)sender {
    [self jumpToMiningDailyDetail];
}


#pragma mark - Request
- (void)requestTrade_mining_index {
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
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"account":account,@"token":token}];
    [RequestService requestWithUrl11:trade_mining_index_Url params:params timestamp:timestamp httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainScroll.mj_header endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            weakself.miningRewardIndexM = [MiningRewardIndexModel mj_objectWithKeyValues:responseObject];
            [weakself refreshView];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.mainScroll.mj_header endRefreshing];
    }];
}

- (void)requestTrade_mining_reward_totalWithStatus:(NSString *)status completeBlock:(void(^)(NSString *reward))completeBlock {
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
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"account":account,@"token":token}];
    if (status) {
        [params setObject:status forKey:@"status"];
    }
    [RequestService requestWithUrl11:trade_mining_reward_total_Url params:params timestamp:timestamp httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            if (completeBlock) {
                NSString *result = [NSString stringWithFormat:@"%@",responseObject[@"rewardTotal"]];
                completeBlock(result);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestTrade_mining_reward_rankings {

    kWeakSelf(self);

    NSDictionary *params = @{@"page":@(_currentPage),@"size":@(Mining_PageSize)};
    [RequestService requestWithUrl5:trade_mining_reward_rankings_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [InviteRankingModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            if (weakself.currentPage == 1) {
                [weakself.sourceArr removeAllObjects];
            }
            
            [weakself.sourceArr addObjectsFromArray:arr];
            weakself.currentPage += 1;
            
            [weakself.mainTable reloadData];
            
            if (arr.count < Mining_PageSize) {
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = ShareFriendsCell_Height;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:ShareFriendsCellReuse];
    
    InviteRankingModel *model = _sourceArr[indexPath.row];
    [cell configCell_MiningReward:model color:[UIColor whiteColor]];
    
    return cell;
}

#pragma mark - Transition
- (void)jumpToInviteRanking {
    InviteRankingViewController *vc = [InviteRankingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToInviteFriendNow {
    InviteFriendNowViewController *vc = [InviteFriendNowViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToClaimQLC {
    ClaimQLCViewController *vc = [ClaimQLCViewController new];
    vc.inputCanClaimAmount = _canClaimAmountLab.text?:@"0";
    vc.claimQLCType = ClaimQLCTypeMiningRewards;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToGetQLC {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.inputUrl = @"https://medium.com/@QLC_team/qgas-buyback-campaign-kicking-off-in-q-wallet-otc-join-to-trade-qgas-for-qlc-rewards-39c7241e72d4";
    vc.inputTitle = @"QLC";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToMiningDailyDetail {
    MiningDailyDetailViewController *vc = [MiningDailyDetailViewController new];
    vc.inputBackToRoot = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
