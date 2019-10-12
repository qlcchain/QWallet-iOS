//
//  ShareFriendsViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ShareFriendsViewController.h"
#import "UserModel.h"
#import "NSDate+Category.h"
#import "RSAUtil.h"
#import "ShareFriendsCell.h"
#import "ShareFriendsModel.h"
#import "InviteRankingModel.h"
#import "InviteRankingViewController.h"
//#import "GuangGaoView.h"
#import "InviteFriendNowViewController.h"
#import "UIColor+Random.h"
//#import "GlobalConstants.h"
#import "ClaimQGASViewController.h"
#import "ClaimConstants.h"
#import "RefreshHelper.h"

@interface ShareFriendsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UILabel *invitationCodeLab;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *topImgV;
@property (weak, nonatomic) IBOutlet UILabel *canClaimAmountLab;
@property (weak, nonatomic) IBOutlet UIButton *claimBtn;
@property (weak, nonatomic) IBOutlet UILabel *invitedAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *claimedAmountLab;
@property (weak, nonatomic) IBOutlet UIView *horizontalLineV;
@property (weak, nonatomic) IBOutlet UIView *claimTipV;
@property (weak, nonatomic) IBOutlet UILabel *claimTipLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainTableHeight;
@property (weak, nonatomic) IBOutlet UILabel *getQGASBy1Lab;
@property (weak, nonatomic) IBOutlet UILabel *getQGASBy2Lab;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;


@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) InviteRankingModel *myInfoM;
//@property (nonatomic, strong) GuangGaoView *guangGaoView;
@property (nonatomic, strong) NSString *invite_reward_amount;
@property (nonatomic, strong) NSString *invite_user_amount;
//@property (nonatomic, strong) NSString *invite_all_amount;
@property (nonatomic, strong) NSString *no_award_amount;

@end

@implementation ShareFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self requestWinq_invite_user_amount]; // 邀请多少个用户可以领取QGAS奖励
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself requestWinq_invite_reward_amount]; // 邀请一个用户奖励QGAS数量
    });
    [self refreshClaimBtnStatus];
}

#pragma mark - Operation
- (void)configInit {
    _inviteBtn.layer.cornerRadius = 20.0;
    _inviteBtn.layer.masksToBounds = YES;
    
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:ShareFriendsCellReuse bundle:nil] forCellReuseIdentifier:ShareFriendsCellReuse];
    _mainTableHeight.constant = 0;
    
    _invite_reward_amount = @"0";
    _invite_user_amount = @"0";
//    _invite_all_amount = @"0";
    _no_award_amount = @"0";
    
    _horizontalLineV.layer.cornerRadius = 3;
    _horizontalLineV.layer.masksToBounds = YES;
    _claimTipV.layer.cornerRadius = 4;
    _claimTipV.layer.masksToBounds = YES;
    _claimBtn.layer.cornerRadius = 2;
    _claimBtn.layer.masksToBounds = YES;
    NSString *topImgStr = @"";
    NSString *language = [Language currentLanguageCode];
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        topImgStr = @"claim_ad_share_en";
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        topImgStr = @"claim_ad_share_ch";
    }
    _topImgV.image = [UIImage imageNamed:topImgStr];
    
    kWeakSelf(self)
    _mainScroll.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        [weakself requestWinq_invite_reward_amount]; // 邀请一个用户奖励QGAS数量
    }];
}

- (void)refreshInvitationCodeView {
    _invitationCodeLab.text = [NSString stringWithFormat:@"%@（%@）",_myInfoM.number?:@"",kLang(@"copy")];
}

- (void)refreshClaimBtnStatus {
    BOOL btnEnable = NO;
    if ([_invite_user_amount doubleValue] > 0) {
        if ([_no_award_amount doubleValue] >= [_invite_user_amount doubleValue]) {
            btnEnable = YES;
        }
    }
    
    if (btnEnable) {
        [_claimBtn setTitleColor:UIColorFromRGB(0xFB5340) forState:UIControlStateNormal];
        _claimBtn.userInteractionEnabled = YES;
    } else {
        [_claimBtn setTitleColor:[UIColorFromRGB(0xFB5340) colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        _claimBtn.userInteractionEnabled = NO;
    }
}

- (void)getNoAward { // 未领取的
    kWeakSelf(self);
    [self requestUser_invite_amount:Invite_Status_NO_AWARD completeBlock:^(NSString *amount) {
        NSNumber *num = @([amount doubleValue]*[weakself.invite_reward_amount doubleValue]);
        NSString *canClaimStr = [NSString stringWithFormat:@"%@",num];
        weakself.canClaimAmountLab.text = canClaimStr;
        
        weakself.no_award_amount = amount?:@"0";
        [weakself refreshClaimBtnStatus];
    }];
}

- (void)getAward { // 已领取的
    kWeakSelf(self);
    [self requestUser_invite_amount:Invite_Status_AWARDED completeBlock:^(NSString *amount) {
        NSNumber *num = @([amount doubleValue]*[weakself.invite_reward_amount doubleValue]);
        NSString *claimedStr = @"";
        NSString *language = [Language currentLanguageCode];
        if ([language isEqualToString:LanguageCode[0]]) { // 英文
            claimedStr = [NSString stringWithFormat:@"I have claimed %@ QGAS",num];
        } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
            claimedStr = [NSString stringWithFormat:@"已领取奖励：%@ QGAS",num];
        }
        weakself.claimedAmountLab.text = claimedStr;
    }];
}

- (void)getAllInvite { // 所有邀请的人数
    kWeakSelf(self);
    [self requestUser_invite_amount:nil completeBlock:^(NSString *amount) {
        
        NSString *invitedStr = @"";
        NSString *language = [Language currentLanguageCode];
        if ([language isEqualToString:LanguageCode[0]]) { // 英文
            invitedStr = [NSString stringWithFormat:@"%@ friends referred ",amount];
        } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
            invitedStr = [NSString stringWithFormat:@"已邀请%@人",amount];
        }
        weakself.invitedAmountLab.text = invitedStr;
    }];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)inviteNowAction:(id)sender {
    [self jumpToInviteFriendNow];
}

- (IBAction)copyAction:(id)sender {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:_myInfoM.number?:@""];
    [kAppD.window makeToastDisappearWithText:@"Copied"];
}

- (IBAction)claimAction:(id)sender {
    if ([_canClaimAmountLab.text doubleValue] <= 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"no_qgas_can_claim")];
        return;
    }
    
    [self jumpToClaimQGAS];
}

#pragma mark - Request
- (void)requestWinq_invite_user_amount { // 邀请多少个用户可以领取QGAS奖励
    kWeakSelf(self);
    NSDictionary *params = @{@"dictType":winq_invite_user_amount};
    [RequestService requestWithUrl10:sys_dict_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSString *valueStr = responseObject[Server_Data][@"value"];
            
            NSString *claimTipStr = @"";
            NSString *language = [Language currentLanguageCode];
            if ([language isEqualToString:LanguageCode[0]]) { // 英文
                claimTipStr = [NSString stringWithFormat:@"You can claim the reward when successfully invited more than %@ friends.",valueStr];
            } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
                claimTipStr = [NSString stringWithFormat:@"邀请好友满%@位可立即领取",valueStr];
            }
            weakself.claimTipLab.text = claimTipStr;
            
            weakself.invite_user_amount = valueStr?:@"0";
            [weakself refreshClaimBtnStatus];
            
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestWinq_invite_reward_amount { // 邀请一个用户奖励QGAS数量
    kWeakSelf(self);
    NSDictionary *params = @{@"dictType":winq_invite_reward_amount};
    [RequestService requestWithUrl10:sys_dict_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainScroll.mj_header endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSString *valueStr = responseObject[Server_Data][@"value"];
        
            weakself.invite_reward_amount = valueStr?:@"0";
            
            NSString *getQGASBy1Str = @"";
            NSString *getQGASBy2Str = @"";
            NSString *language = [Language currentLanguageCode];
            if ([language isEqualToString:LanguageCode[0]]) { // 英文
                getQGASBy1Str = [NSString stringWithFormat:@"Get %@ QGAS",@([valueStr doubleValue]*1)];
                getQGASBy2Str = [NSString stringWithFormat:@"Get %@ QGAS",@([valueStr doubleValue]*2)];
            } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
                getQGASBy1Str = [NSString stringWithFormat:@"获得%@QGAS",@([valueStr doubleValue]*1)];
                getQGASBy2Str = [NSString stringWithFormat:@"获得%@QGAS",@([valueStr doubleValue]*2)];
            }
            weakself.getQGASBy1Lab.text = getQGASBy1Str;
            weakself.getQGASBy2Lab.text = getQGASBy2Str;
            
            [weakself getNoAward];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
                [weakself getAward];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
                [weakself getAllInvite];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
                [weakself requestInvite];
            });
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.mainScroll.mj_header endRefreshing];
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


- (void)requestInvite {
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
    NSDictionary *params = @{@"account":account,@"token":token};
    [RequestService requestWithUrl6:invite_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            ShareFriendsModel *model = [ShareFriendsModel getObjectWithKeyValues:responseObject];
            weakself.myInfoM = model.myInfo;
            [weakself refreshInvitationCodeView];
            [weakself.sourceArr removeAllObjects];
//            [weakself.sourceArr addObject:model.myInfo];
            [weakself.sourceArr addObjectsFromArray:model.top5];
            weakself.mainTableHeight.constant = weakself.sourceArr.count*ShareFriendsCell_Height;
            [weakself.mainTable reloadData];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = ShareFriendsCell_Height;
//    if (indexPath.row == 1) {
//        height += 30;
//    }
//    if (indexPath.row == _sourceArr.count - 1) {
//        height += 30;
//    }
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
//    BOOL isFirst = indexPath.row == 0?YES:NO;
//    BOOL isSecond = indexPath.row == 1?YES:NO;
//    BOOL isLast = indexPath.row == _sourceArr.count-1?YES:NO;
//    [cell configCell:model isFirst:isFirst isSecond:isSecond isLast:isLast];
    [cell configCell:model qgasUnit:_invite_reward_amount?:@"0"];
    kWeakSelf(self)
    cell.moreB = ^{
        [weakself jumpToInviteRanking];
    };
    
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

- (void)jumpToClaimQGAS {
    ClaimQGASViewController *vc = [ClaimQGASViewController new];
    vc.inputCanClaimAmount = _canClaimAmountLab.text?:@"0";
    vc.claimQGASType = ClaimQGASTypeReferralRewards;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
