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

@interface MyViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) NSString *invite_user_amount;
@property (nonatomic, strong) NSString *no_award_amount;

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
    
    _invite_user_amount = @"0";
    _no_award_amount = @"0";
    
    [self configInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshUserInfoView];
    [self getDailyEarnings];
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself getRecommandEarnings];
    });
    
}

#pragma mark - Operation
- (void)configInit {
    _titleLab.text = kLang(@"me");
    //@"icon_my_contact"
    [_sourceArr removeAllObjects];
    NSArray *titleArr = @[kLang(@"crypto_wallet"),kLang(@"daily_earnings"),kLang(@"share_with_friends"),kLang(@"join_the_community"),kLang(@"settings")];
    NSArray *iconArr = @[@"icon_my_wallet",@"icon_my_claim",@"icon_my_share",@"icon_my_community",@"icon_my_settings"];
    kWeakSelf(self);
    [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MyShowModel *model = [MyShowModel new];
        model.title = obj;
        model.icon = iconArr[idx];
        model.showRed = NO;
        [weakself.sourceArr addObject:model];
    }];
    [_mainTable reloadData];
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

- (void)getDailyEarnings {
    kWeakSelf(self);
    [self requestReward_reward_total:Claim_Type_Register status:Claim_Status_New completeBlock:^(NSString *reward) {
        [weakself.sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MyShowModel *model = obj;
            if ([model.title isEqualToString:kLang(@"daily_earnings")]) {
                model.showRed = [reward doubleValue]>0?YES:NO;
                *stop = YES;
            }
        }];
        [weakself.mainTable reloadData];
    }];
}

- (void)getRecommandEarnings {
    kWeakSelf(self);
    [self requestUser_invite_amount:Invite_Status_NO_AWARD completeBlock:^(NSString *amount) {
        weakself.no_award_amount = amount?:@"0";
        [weakself getWinq_invite_user_amount];
    }];
}

- (void)getWinq_invite_user_amount { // 邀请多少个用户可以领取QGAS奖励
    kWeakSelf(self);
    NSDictionary *params = @{@"dictType":winq_invite_user_amount};
    [RequestService requestWithUrl10:sys_dict_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSString *valueStr = responseObject[Server_Data][@"value"];
            
            weakself.invite_user_amount = valueStr?:@"0";
            [weakself refreshRecommandEarningsStatus];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)refreshRecommandEarningsStatus {
    BOOL showRed = NO;
    if ([_invite_user_amount doubleValue] > 0) {
        if ([_no_award_amount doubleValue] >= [_invite_user_amount doubleValue]) {
            showRed = YES;
        }
    }
    
    [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MyShowModel *model = obj;
        if ([model.title isEqualToString:kLang(@"share_with_friends")]) {
            model.showRed = showRed;
            *stop = YES;
        }
    }];
    [_mainTable reloadData];
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
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"QLC Chain****DApp" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"wrpc.qlcchain.org:9735****dapp-t.qlink.mobi" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HWUserdefault insertObj:@"1" withkey:QLCChain_Environment];
        // 获取主地址
        [WalletTransferUtil requestServerMainAddress];
    }];
    [alertVC addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"47.103.40.20:19735****DApp测试服务器" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HWUserdefault insertObj:@"0" withkey:QLCChain_Environment];
        // 获取主地址
        [WalletTransferUtil requestServerMainAddress];
    }];
    [alertVC addAction:action2];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:action3];
    [self presentViewController:alertVC animated:YES completion:nil];
#else
    [HWUserdefault insertObj:@"1" withkey:QLCChain_Environment];
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


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MyCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyShowModel *model = _sourceArr[indexPath.row];
    if ([model.title isEqualToString:kLang(@"crypto_wallet")]) {
        [kAppD jumpToWallet];
//        [self jumpToWalletsManage];
    } else if ([model.title isEqualToString:kLang(@"share_with_friends")]) {
        [self jumpToShareFriends];
    } else if ([model.title isEqualToString:kLang(@"join_the_community")]) {
        [self jumpToJoinCommunity];
    } else if ([model.title isEqualToString:kLang(@"contact_us")]) {
        
    } else if ([model.title isEqualToString:kLang(@"settings")]) {
        [self jumpToSettings];
    } else if ([model.title isEqualToString:kLang(@"daily_earnings")]) {
        [self jumpToDailyEarnings];
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
        [ClaimQGASTipView show];
        return;
    }
    
    DailyEarningsViewController *vc = [DailyEarningsViewController new];
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
