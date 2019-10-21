//
//  InviteRankView.m
//  Qlink
//
//  Created by Jelly Foo on 2019/10/18.
//  Copyright © 2019 pan. All rights reserved.
//

#import "InviteRankView.h"
#import "ShareFriendsCell.h"
#import "ShareFriendsModel.h"
#import "GlobalConstants.h"
#import "InviteRankingModel.h"
#import "UserModel.h"
#import "NSDate+Category.h"
#import "RSAUtil.h"
#import "ClaimConstants.h"
#import "InviteFriendNowViewController.h"
#import "UIView+Visuals.h"
#import "AppDelegate.h"
#import "QlinkTabbarViewController.h"
#import "TopupViewController.h"

static CGFloat InviteRankTopHeight = 172;

@interface InviteRankView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topBack;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UILabel *myInvitationLab;
@property (weak, nonatomic) IBOutlet UILabel *invitationCodeLab;
@property (weak, nonatomic) IBOutlet UILabel *ranking30Lab;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainTableHeight;

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) InviteRankingModel *myInfoM;
@property (nonatomic, strong) NSString *invite_reward_amount;
@property (nonatomic, copy) InviteRankHeightBlock heightB;

@end

@implementation InviteRankView

+ (instancetype)getInstance {
    InviteRankView *view = [[[NSBundle mainBundle] loadNibNamed:@"InviteRankView" owner:self options:nil] lastObject];
    [view configInit];
    return view;
}

#pragma mark - Operation
- (void)config:(InviteRankHeightBlock)heightB {
    _heightB = heightB;
}

- (void)startRefresh {
    _myInvitationLab.text = kLang(@"my_invitation_code");
    _invitationCodeLab.text = kLang(@"00000000_Copy");
    _ranking30Lab.text = kLang(@"ranking_in_the_last_30_days");
    [_inviteBtn setTitle:kLang(@"immediately_invite") forState:UIControlStateNormal];
    
    [_sourceArr removeAllObjects];
    _mainTableHeight.constant = 0;
    
    [_mainTable reloadData];
    if ([UserModel haveLoginAccount]) {
        kWeakSelf(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
            [weakself requestWinq_invite_reward_amount]; // 邀请一个用户奖励QGAS数量
        });
    }
    
    if (_heightB) {
        _heightB(0);
    }
}

- (void)configInit {
    
    [_topBack addCornerWithType:UIRectCornerTopLeft|UIRectCornerTopRight size:CGSizeMake(6, 6)];
//    _topBack.layer.cornerRadius = 6.0;
//    _topBack.layer.masksToBounds = YES;
    _inviteBtn.layer.cornerRadius = 20.0;
    _inviteBtn.layer.masksToBounds = YES;
    
    _invite_reward_amount = @"0";
    
    _sourceArr = [NSMutableArray array];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    [_mainTable registerNib:[UINib nibWithNibName:ShareFriendsCellReuse bundle:nil] forCellReuseIdentifier:ShareFriendsCellReuse];
    _mainTableHeight.constant = 0;
}

- (void)refreshInvitationCodeView {
    _invitationCodeLab.text = [NSString stringWithFormat:@"%@（%@）",_myInfoM.number?:@"",kLang(@"copy")];
}

#pragma mark - Request
- (void)requestWinq_invite_reward_amount { // 邀请一个用户奖励QGAS数量
    kWeakSelf(self);
    NSDictionary *params = @{@"dictType":winq_invite_reward_amount};
    [RequestService requestWithUrl10:sys_dict_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSString *valueStr = responseObject[Server_Data][@"value"];
            
            weakself.invite_reward_amount = valueStr?:@"0";
            [weakself requestInvite];
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
            if (weakself.heightB) {
                weakself.heightB(InviteRankTopHeight+weakself.mainTableHeight.constant);
            }
            [weakself.mainTable reloadData];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
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
    [cell configCell:model qgasUnit:_invite_reward_amount?:@"0" color:[UIColor whiteColor]];
//    kWeakSelf(self)
//    cell.moreB = ^{
//        [weakself jumpToInviteRanking];
//    };
    
    return cell;
}

#pragma mark - Action

- (IBAction)copyAction:(id)sender {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:_myInfoM.number?:@""];
    [kAppD.window makeToastDisappearWithText:kLang(@"copied")];
}

- (IBAction)inviteAction:(id)sender {
    [self jumpToInviteFriendNow];
}

#pragma mark - Transition
- (void)jumpToInviteFriendNow {
    InviteFriendNowViewController *vc = [InviteFriendNowViewController new];
    [kAppD.tabbarC.topupVC.navigationController pushViewController:vc animated:YES];
}


@end
