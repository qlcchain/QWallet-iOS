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
#import "GuangGaoView.h"
#import "InviteFriendNowViewController.h"

@interface ShareFriendsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIView *invitationCodeBack;
@property (weak, nonatomic) IBOutlet UILabel *invitationCodeLab;
@property (weak, nonatomic) IBOutlet UIView *guangGaoBack;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) NSMutableArray *guanggaoListArr;
@property (nonatomic, strong) InviteRankingModel *myInfoM;
@property (nonatomic, strong) GuangGaoView *guangGaoView;

@end

@implementation ShareFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self requestInvite];
}

#pragma mark - Operation
- (void)configInit {
    _inviteBtn.layer.cornerRadius = 4.0;
    _inviteBtn.layer.masksToBounds = YES;
    
    _sourceArr = [NSMutableArray array];
    _guanggaoListArr = [NSMutableArray array];
    _mainTable.tableHeaderView = _headView;
    [_mainTable registerNib:[UINib nibWithNibName:ShareFriendsCellReuse bundle:nil] forCellReuseIdentifier:ShareFriendsCellReuse];
    
    _invitationCodeBack.layer.cornerRadius = 20;
    _invitationCodeBack.layer.masksToBounds = YES;
    _invitationCodeBack.layer.borderColor = [UIColor mainColor].CGColor;
    _invitationCodeBack.layer.borderWidth = 1;
    
    [self addGuanggaoView];
}

- (void)addGuanggaoView {
    _guangGaoView = [GuangGaoView getInstance];
    [_guangGaoBack addSubview:_guangGaoView];
    kWeakSelf(self)
    [_guangGaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(weakself.guangGaoBack).offset(0);
    }];
}

- (void)refreshInvitationCodeView {
    _invitationCodeLab.text = _myInfoM.number?:@"";
}

- (void)refreshGuanggaoView {
    [_guangGaoView configData:_guanggaoListArr];
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

#pragma mark - Request
- (void)requestInvite {
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
    NSDictionary *params = @{@"account":account,@"token":token};
    [RequestService requestWithUrl:invite_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            ShareFriendsModel *model = [ShareFriendsModel getObjectWithKeyValues:responseObject];
            weakself.myInfoM = model.myInfo;
            [weakself refreshInvitationCodeView];
            [weakself.sourceArr removeAllObjects];
            [weakself.sourceArr addObject:model.myInfo];
            [weakself.sourceArr addObjectsFromArray:model.top5];
            [weakself.mainTable reloadData];
            [weakself.guanggaoListArr removeAllObjects];
            [weakself.guanggaoListArr addObjectsFromArray:model.guanggaoList];
            [weakself refreshGuanggaoView];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = ShareFriendsCell_Height;
    if (indexPath.row == 1) {
        height += 30;
    }
    if (indexPath.row == _sourceArr.count - 1) {
        height += 30;
    }
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
    BOOL isFirst = indexPath.row == 0?YES:NO;
    BOOL isSecond = indexPath.row == 1?YES:NO;
    BOOL isLast = indexPath.row == _sourceArr.count-1?YES:NO;
    [cell configCell:model isFirst:isFirst isSecond:isSecond isLast:isLast];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
