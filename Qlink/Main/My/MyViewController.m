//
//  MyViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/10.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MyViewController.h"
#import "MyCell.h"
#import "WalletsManageViewController.h"
#import "JoinCommunityViewController.h"
#import "SettingsViewController.h"
#import "UserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PersonalInfoViewController.h"
#import "ShareFriendsViewController.h"
//#import "GlobalConstants.h"
#import "WalletTransferUtil.h"
#import "MD5Util.h"
#import "RSAUtil.h"
#import "NSDate+Category.h"
#import "ClaimConstants.h"
#import "DailyEarningsViewController.h"
#import "ClaimQGASTipView.h"
#import "SheetMiningViewController.h"
#import "MiningConstants.h"
#import "SheetMiningUtil.h"
#import "WZLBadgeImport.h"
#import "QlinkTabbarViewController.h"
#import "TabbarHelper.h"
#import "AppJumpHelper.h"
#import "JoinTelegramTipView.h"
#import "WebViewController.h"

@interface MyViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) NSString *invite_user_amount;
@property (nonatomic, strong) NSString *no_award_amount;
@property (nonatomic, strong) NSString *no_award_miningReward_amount;
@property (nonatomic) BOOL haveTrade_mining_list;

@end

@implementation MyViewController

//NSString *my_title0 = @"Crypto Wallet";
//NSString *my_title1 = @"Share with Friends";
//NSString *my_title2 = @"Join the Community";
//NSString *my_title3 = @"Contact Us";
//NSString *my_title4 = @"Settings";

#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccessNoti:) name:User_Logout_Success_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNoti:) name:User_Login_Success_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeNoti:) name:kLanguageChangeNoti object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addObserve];
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    _userIcon.layer.cornerRadius = _userIcon.width/2.0;
    _userIcon.layer.masksToBounds = YES;
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:MyCellReuse bundle:nil] forCellReuseIdentifier:MyCellReuse];
    
    _haveTrade_mining_list = NO;
    _invite_user_amount = @"0";
    _no_award_amount = @"0";
    _no_award_miningReward_amount = @"0";
    
    [self configInit];
    
    kWeakSelf(self);
    [self getRedDot];
//    [self getDailyEarnings];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
//        [weakself getRecommandEarnings];
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
//        [weakself getNOReward_MiningReward];
//    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself getTrade_mining_list];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshUserInfoView];
    
    [self checkJoinTelegram];
    
}

#pragma mark - Operation
- (void)configInit {
    _titleLab.text = kLang(@"me");
    //@"icon_my_contact"
    
    [_sourceArr removeAllObjects];
    NSArray *titleArr = @[kLang(@"crypto_wallet"),kLang(@"daily_earnings"),kLang(@"share_with_friends"),kLang(@"join_the_community"),kLang(@"settings")];
    NSArray *iconArr = @[@"icon_my_wallet",@"icon_my_claim",@"icon_my_share",@"icon_my_community",@"icon_my_settings"];
    if (_haveTrade_mining_list) { // 有挂单挖矿活动
        titleArr = @[kLang(@"crypto_wallet"),kLang(@"daily_earnings"),kLang(@"share_with_friends"),kLang(@"sheet_mining"),kLang(@"join_the_community"),kLang(@"settings")];
        iconArr = @[@"icon_my_wallet",@"icon_my_claim",@"icon_my_share",@"icon_my_mining",@"icon_my_community",@"icon_my_settings"];
    }
    kWeakSelf(self);
    [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MyShowModel *model = [MyShowModel new];
        model.title = obj;
        model.icon = iconArr[idx];
        model.showRed = NO;
        [weakself.sourceArr addObject:model];
    }];
    [_mainTable reloadData];
    [self refreshTabbarRedOfMe];
}

- (void)checkJoinTelegram {
    NSNumber *join = [HWUserdefault getObjectWithKey:Join_Telegram_Key];
    if (join && [join boolValue] == YES) {
        [HWUserdefault insertObj:@(NO) withkey:Join_Telegram_Key];
        kWeakSelf(self);
        [JoinTelegramTipView show:^{
            NSString *title = @"Telegram";
            NSString *url = @"t.me/qlinkmobile";
            [weakself jumpToWeb:url title:title];
        }];
    }
}

- (void)refreshMining {
    NSArray *titleArr = @[];
    NSArray *iconArr = @[];
    if (_haveTrade_mining_list) { // 有挂单挖矿活动
        titleArr = @[kLang(@"crypto_wallet"),kLang(@"daily_earnings"),kLang(@"share_with_friends"),kLang(@"sheet_mining"),kLang(@"join_the_community"),kLang(@"settings")];
        iconArr = @[@"icon_my_wallet",@"icon_my_claim",@"icon_my_share",@"icon_my_mining",@"icon_my_community",@"icon_my_settings"];
        if (![self containMining]) {
            [self addMining];
        }
    } else {
        titleArr = @[kLang(@"crypto_wallet"),kLang(@"daily_earnings"),kLang(@"share_with_friends"),kLang(@"join_the_community"),kLang(@"settings")];
        iconArr = @[@"icon_my_wallet",@"icon_my_claim",@"icon_my_share",@"icon_my_community",@"icon_my_settings"];
        if ([self containMining]) {
            [self removeMining];
        }
    }
    [_mainTable reloadData];
    [self refreshTabbarRedOfMe];
    
//    [self getNOReward_MiningReward];
    [self getRedDot];
}

- (BOOL)containMining {
    __block BOOL containB = NO;
    [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MyShowModel *model = obj;
        if ([model.title isEqualToString:kLang(@"sheet_mining")]) {
            containB = YES;
            *stop = YES;
        }
    }];
    
    return containB;
}

- (void)removeMining {
    kWeakSelf(self);
    [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MyShowModel *model = obj;
        if ([model.title isEqualToString:kLang(@"sheet_mining")]) {
            [weakself.sourceArr removeObject:obj];
            *stop = YES;
        }
    }];
}

- (void)addMining {
    MyShowModel *model = [MyShowModel new];
    model.title = kLang(@"sheet_mining");
    model.icon = @"icon_my_mining";
    model.showRed = NO;
    [_sourceArr insertObject:model atIndex:3];
}

- (void)refreshUserInfoView {
    if ([UserModel haveLoginAccount]) {
        UserModel *userM = [UserModel fetchUserOfLogin];
        [_userIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],userM.head]] placeholderImage:User_DefaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
        _userNameLab.text = [userM.nickname isEmptyString]?userM.account:userM.nickname;
    } else {
        _userIcon.image = User_DefaultImage;
        _userNameLab.text = kLang(@"login_signup");
    }
}

#pragma mark - 获取挂单挖矿活动列表
- (void)getTrade_mining_list {
    kWeakSelf(self);
    [SheetMiningUtil requestTrade_mining_list:^(NSArray<MiningActivityModel *> * _Nonnull arr) {
        if (arr.count > 0) {
            weakself.haveTrade_mining_list = YES;
        } else {
            weakself.haveTrade_mining_list = NO;
        }
        [self refreshMining];
    }]; // 交易挖矿活动列表
}

//#pragma mark - 每日收益红点
//- (void)getDailyEarnings {
//    kWeakSelf(self);
//    [self requestReward_reward_total:Claim_Type_Register status:Claim_Status_New completeBlock:^(NSString *reward) {
//        [weakself.sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            MyShowModel *model = obj;
//            if ([model.title isEqualToString:kLang(@"daily_earnings")]) {
//                model.showRed = [reward doubleValue]>0?YES:NO;
//                *stop = YES;
//            }
//        }];
//        [weakself.mainTable reloadData];
//        [weakself refreshTabbarRedOfMe];
//    }];
//}
//
//#pragma mark - 推荐奖励红点
//- (void)getRecommandEarnings {
//    kWeakSelf(self);
//    [self requestUser_invite_amount:Invite_Status_NO_AWARD completeBlock:^(NSString *amount) {
//        weakself.no_award_amount = amount?:@"0";
//        [weakself getWinq_invite_user_amount];
//    }];
//}
//
//- (void)getWinq_invite_user_amount { // 邀请多少个用户可以领取QGAS奖励
//    kWeakSelf(self);
//    NSDictionary *params = @{@"dictType":winq_invite_user_amount};
//    [RequestService requestWithUrl10:sys_dict_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        if ([responseObject[Server_Code] integerValue] == 0) {
//            NSString *valueStr = responseObject[Server_Data][@"value"];
//
//            weakself.invite_user_amount = valueStr?:@"0";
//            [weakself refreshRecommandEarningsStatus];
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//    }];
//}
//
//- (void)refreshRecommandEarningsStatus {
//    BOOL showRed = NO;
//    if ([_invite_user_amount doubleValue] > 0) {
//        if ([_no_award_amount doubleValue] >= [_invite_user_amount doubleValue]) {
//            showRed = YES;
//        }
//    }
//
//    [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        MyShowModel *model = obj;
//        if ([model.title isEqualToString:kLang(@"share_with_friends")]) {
//            model.showRed = showRed;
//            *stop = YES;
//        }
//    }];
//    [_mainTable reloadData];
//    [self refreshTabbarRedOfMe];
//}
//
//#pragma mark - 挂单挖矿红点
//- (void)getNOReward_MiningReward {
//    if (!_haveTrade_mining_list) { // 有挂单挖矿活动
//        return;
//    }
//    kWeakSelf(self);
//    [self requestTrade_mining_reward_totalWithStatus:Mining_STATUS_NO_AWARD completeBlock:^(NSString *reward) {
//        weakself.no_award_miningReward_amount = reward?:@"0";
//        [weakself refreshMiningRewardStatus];
//    }];
//}
//
//- (void)refreshMiningRewardStatus {
//    BOOL showRed = NO;
//    if ([_no_award_miningReward_amount doubleValue] > 0) {
//        showRed = YES;
//    }
//
//    [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        MyShowModel *model = obj;
//        if ([model.title isEqualToString:kLang(@"sheet_mining")]) {
//            model.showRed = showRed;
//            *stop = YES;
//        }
//    }];
//    [_mainTable reloadData];
//    [self refreshTabbarRedOfMe];
//}

#pragma mark - Tabbar(我的)红点
- (void)refreshTabbarRedOfMe {
    __block BOOL showRed = NO;
    [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MyShowModel *model = obj;
        if (model.showRed) {
            showRed = YES;
            *stop = YES;
        }
    }];
    UITabBarItem *item = kAppD.tabbarC.tabBar.items[TabbarIndexMy];
    if (showRed) {
        [item setBadgeCenterOffset:CGPointMake(0, 5)];
        [item setBadgeColor:UIColorFromRGB(0xD0021B)];
        [item showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
    } else {
        [item clearBadge];
    }
}

#pragma mark - 获取红点数据
- (void)getRedDot {
    kWeakSelf(self);
    [TabbarHelper requestUser_red_pointWithCompleteBlock:^(RedPointModel *redPointM) {
        // 每日收益
        BOOL showRed1 = [redPointM.dailyIncomePoint integerValue]==1?YES:NO;
        [weakself.sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MyShowModel *model = obj;
            if ([model.title isEqualToString:kLang(@"daily_earnings")]) {
                model.showRed = showRed1;
                *stop = YES;
            }
        }];
        
        // 推荐奖励
        BOOL showRed2 = [redPointM.invitePoint integerValue]==1?YES:NO;
        [weakself.sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MyShowModel *model = obj;
            if ([model.title isEqualToString:kLang(@"share_with_friends")]) {
                model.showRed = showRed2;
                *stop = YES;
            }
        }];
        
        // 挂单挖矿
        BOOL showRed3 = [redPointM.rewardTotal integerValue]==1?YES:NO;
        [weakself.sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MyShowModel *model = obj;
            if ([model.title isEqualToString:kLang(@"sheet_mining")]) {
                model.showRed = showRed3;
                *stop = YES;
            }
        }];
        
        [weakself.mainTable reloadData];
        [weakself refreshTabbarRedOfMe];
    }];
}

#pragma mark - Action

- (IBAction)clickUserAction:(id)sender {
    if ([UserModel haveLoginAccount]) {
        [self jumpToPersonalInfo];
    } else {
        [kAppD presentLoginNew];
    }
}

- (IBAction)switchQLCChainEnvironmentAction:(id)sender {
#ifdef DEBUG
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"DApp" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"DApp正式服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HWUserdefault insertObj:@"1" withkey:QLCChain_Environment];
        [HWUserdefault insertObj:@"1" withkey:QLCServer_Environment];
        // 获取主地址
        [WalletTransferUtil requestServerMainAddress];
    }];
    [alertVC addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"DApp测试服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HWUserdefault insertObj:@"1" withkey:QLCChain_Environment];
        [HWUserdefault insertObj:@"0" withkey:QLCServer_Environment];
        // 获取主地址
        [WalletTransferUtil requestServerMainAddress];
    }];
    [alertVC addAction:action2];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:action3];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
#else
    [HWUserdefault insertObj:@"1" withkey:QLCChain_Environment];
    [HWUserdefault insertObj:@"1" withkey:QLCServer_Environment];
    // 获取主地址
    [WalletTransferUtil requestServerMainAddress];
#endif
}

#pragma mark - Request
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

- (void)requestUser_invite_amount:(nullable NSString *)status completeBlock:(void(^)(NSString *amount))completeBlock { // 邀请人数
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
    NSDictionary *params = @{@"account":account,@"token":token};
    if (status != nil) {
        params = @{@"account":account,@"token":token,@"status":status};
    }
    
    [RequestService requestWithUrl11:user_invite_amount_Url params:params timestamp:timestamp httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            if (completeBlock) {
                NSString *result = [NSString stringWithFormat:@"%@",responseObject[@"inviteTotal"]];
                completeBlock(result);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
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


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MyCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyShowModel *model = _sourceArr[indexPath.row];
    if ([model.title isEqualToString:kLang(@"crypto_wallet")]) {
        [AppJumpHelper jumpToWallet];
//        [self jumpToWalletsManage];
    } else if ([model.title isEqualToString:kLang(@"share_with_friends")]) {
        [self jumpToShareFriends];
        // 刷新红点
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MyShowModel *model = obj;
            if ([model.title isEqualToString:kLang(@"share_with_friends")]) {
                model.showRed = NO;
                *stop = YES;
            }
        }];
        [_mainTable reloadData];
        [self refreshTabbarRedOfMe];
    } else if ([model.title isEqualToString:kLang(@"join_the_community")]) {
        [self jumpToJoinCommunity];
    } else if ([model.title isEqualToString:kLang(@"contact_us")]) {
        
    } else if ([model.title isEqualToString:kLang(@"settings")]) {
        [self jumpToSettings];
    } else if ([model.title isEqualToString:kLang(@"daily_earnings")]) {
        [self jumpToDailyEarnings];
        // 刷新红点
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MyShowModel *model = obj;
            if ([model.title isEqualToString:kLang(@"daily_earnings")]) {
                model.showRed = NO;
                *stop = YES;
            }
        }];
        [_mainTable reloadData];
        [self refreshTabbarRedOfMe];
    } else if ([model.title isEqualToString:kLang(@"sheet_mining")]) {
        [self jumpToSheetMining];
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MyShowModel *model = obj;
            if ([model.title isEqualToString:kLang(@"sheet_mining")]) {
                model.showRed = NO;
                *stop = YES;
            }
        }];
        [_mainTable reloadData];
        [self refreshTabbarRedOfMe];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCellReuse];
    
    MyShowModel *model = _sourceArr[indexPath.row];
    [cell configCellWithModel:model];
    
    return cell;
}

#pragma mark - Transition
- (void)jumpToWalletsManage {
    WalletsManageViewController *vc = [[WalletsManageViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToJoinCommunity {
    JoinCommunityViewController *vc = [[JoinCommunityViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToSettings {
    SettingsViewController *vc = [[SettingsViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToPersonalInfo {
    PersonalInfoViewController *vc = [[PersonalInfoViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToShareFriends {
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
    
    ShareFriendsViewController *vc = [ShareFriendsViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToDailyEarnings {
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
    
    if (![UserModel isBind]) {
        [ClaimQGASTipView show:^{
        }];
        return;
    }
    
    DailyEarningsViewController *vc = [DailyEarningsViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToSheetMining {
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
    
    SheetMiningViewController *vc = [SheetMiningViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToWeb:(NSString *)url title:(NSString *)title {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.inputUrl = url;
    vc.inputTitle = title;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Noti
- (void)logoutSuccessNoti:(NSNotification *)noti {
    [self refreshUserInfoView];
}

- (void)loginSuccessNoti:(NSNotification *)noti {
    [self refreshUserInfoView];
}
    
- (void)languageChangeNoti:(NSNotification *)noti {
    [self configInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
