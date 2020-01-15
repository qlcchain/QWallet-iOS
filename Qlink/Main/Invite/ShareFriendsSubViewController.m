//
//  ShareFriendsSubViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/1/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import "ShareFriendsSubViewController.h"
#import "UserModel.h"
#import "NSDate+Category.h"
#import "RSAUtil.h"
#import "ShareFriendsCell.h"
#import "ShareFriendsModel.h"

@interface ShareFriendsSubViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic) NSInteger mainTableHeight;

@end

@implementation ShareFriendsSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self configInit];
    
    [self requestInvite];
}

#pragma mark - Operation
- (void)configInit {
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:ShareFriendsCellReuse bundle:nil] forCellReuseIdentifier:ShareFriendsCellReuse];
    _mainTableHeight = 0;
    
//    _invite_reward_amount = @"0";
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
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSDictionary *params = @{@"account":account,@"token":token};
    [RequestService requestWithUrl6:invite_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            ShareFriendsModel *model = [ShareFriendsModel getObjectWithKeyValues:responseObject];
//            weakself.myInfoM = model.myInfo;
//            [weakself refreshInvitationCodeView];
            [weakself.sourceArr removeAllObjects];
            [weakself.sourceArr addObjectsFromArray:model.top5];
            weakself.mainTableHeight = weakself.sourceArr.count*ShareFriendsCell_Height;
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
    [cell configCell:model qgasUnit:_input_invite_reward_amount?:@"0" color:UIColorFromRGB(0xFEFCF2)];
//    kWeakSelf(self)
//    cell.moreB = ^{
//        [weakself jumpToInviteRanking];
//    };
    
    return cell;
}

@end
