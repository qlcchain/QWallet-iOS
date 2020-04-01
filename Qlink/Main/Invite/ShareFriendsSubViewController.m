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
#import "ShareRewardCell.h"
#import "RefreshHelper.h"
#import "InviteeListModel.h"
#import "InviteRankingModel.h"

static NSString *const NetworkSize = @"20";

@interface ShareFriendsSubViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic) NSInteger mainTableHeight;

@property (nonatomic) NSInteger currentPage;


@end

@implementation ShareFriendsSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;

    [self configInit];
    
    if (_inputType == InviteAwardTypeInvite) {
        [self requestInviteRanking];
    } else if (_inputType == InviteAwardTypeFriend) {
        [self requestInviteFriend];
    } else if (_inputType == InviteAwardTypeDelegate) {
        [self requestInviteDelegate];
    }
    
}

#pragma mark - Operation
- (void)configInit {
    _currentPage = 1;
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:ShareFriendsCellReuse bundle:nil] forCellReuseIdentifier:ShareFriendsCellReuse];
    [_mainTable registerNib:[UINib nibWithNibName:ShareRewardCell_Reuse bundle:nil] forCellReuseIdentifier:ShareRewardCell_Reuse];
    _mainTableHeight = 0;
    self.baseTable = _mainTable;
    
//    _invite_reward_amount = @"0";
    kWeakSelf(self)
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = 1;
        if (weakself.inputType == InviteAwardTypeInvite) {
            [weakself requestInviteRanking];
        } else if (weakself.inputType == InviteAwardTypeFriend) {
            [weakself requestInviteFriend];
        } else if (weakself.inputType == InviteAwardTypeDelegate) {
            [weakself requestInviteDelegate];
        }
    }];
    _mainTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        if (weakself.inputType == InviteAwardTypeInvite) {
            [weakself requestInviteRanking];
        } else if (weakself.inputType == InviteAwardTypeFriend) {
            [weakself requestInviteFriend];
        } else if (weakself.inputType == InviteAwardTypeDelegate) {
            [weakself requestInviteDelegate];
        }
    }];
}

#pragma mark - Request
//- (void)requestInvite {
//    UserModel *userM = [UserModel fetchUserOfLogin];
//    if (!userM.md5PW || userM.md5PW.length <= 0) {
//        return;
//    }
//    kWeakSelf(self);
//    NSString *account = userM.account?:@"";
//    NSString *md5PW = userM.md5PW?:@"";
//    NSString *timestamp = [RequestService getRequestTimestamp];
//    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
//    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
//    NSDictionary *params = @{@"account":account,@"token":token};
//    [RequestService requestWithUrl6:invite_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        if ([responseObject[Server_Code] integerValue] == 0) {
//            ShareFriendsModel *model = [ShareFriendsModel getObjectWithKeyValues:responseObject];
////            weakself.myInfoM = model.myInfo;
////            [weakself refreshInvitationCodeView];
//            [weakself.sourceArr removeAllObjects];
//            [weakself.sourceArr addObjectsFromArray:model.top5];
//            weakself.mainTableHeight = weakself.sourceArr.count*ShareFriendsCell_Height;
//            [weakself.mainTable reloadData];
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//    }];
//}

- (void)requestInviteRanking {
    kWeakSelf(self);
     NSString *page = [NSString stringWithFormat:@"%li",_currentPage];
    NSString *size = NetworkSize;
    NSDictionary *params = @{@"page":page,@"size":size};
    [RequestService requestWithUrl5:invite_rankings_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [InviteRankingModel mj_objectArrayWithKeyValuesArray:responseObject[Server_Data]];
            if (weakself.currentPage == 1) {
                [weakself.sourceArr removeAllObjects];
            }
            
            [weakself.sourceArr addObjectsFromArray:arr];
            weakself.currentPage += 1;
            
            [weakself.mainTable reloadData];
            
            if (arr.count < [NetworkSize integerValue]) {
                [weakself.mainTable.mj_footer endRefreshingWithNoMoreData];
//                weakself.mainTable.mj_footer.hidden = arr.count<=0?YES:NO;
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

- (void)requestInviteFriend {
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
    NSString *size = NetworkSize;
    NSDictionary *params = @{@"page":page,@"size":size,@"account":account,@"token":token};
    [RequestService requestWithUrl6:user_invite_list_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [InviteeListModel mj_objectArrayWithKeyValuesArray:responseObject[@"inviteeList"]];
            if (weakself.currentPage == 1) {
                [weakself.sourceArr removeAllObjects];
            }
            
            [weakself.sourceArr addObjectsFromArray:arr];
            weakself.currentPage += 1;
            
            [weakself.mainTable reloadData];
            
            if (arr.count < [NetworkSize integerValue]) {
                [weakself.mainTable.mj_footer endRefreshingWithNoMoreData];
//                weakself.mainTable.mj_footer.hidden = arr.count<=0?YES:NO;
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

- (void)requestInviteDelegate {
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
    NSString *size = NetworkSize;
    NSDictionary *params = @{@"page":page,@"size":size,@"account":account,@"token":token};
    [RequestService requestWithUrl5:topup_dedicate_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [InviteRankingModel mj_objectArrayWithKeyValuesArray:responseObject[@"userList"]];
            if (weakself.currentPage == 1) {
                [weakself.sourceArr removeAllObjects];
            }
            
            [weakself.sourceArr addObjectsFromArray:arr];
            weakself.currentPage += 1;
            
            [weakself.mainTable reloadData];
            
            if (arr.count < [NetworkSize integerValue]) {
                [weakself.mainTable.mj_footer endRefreshingWithNoMoreData];
//                weakself.mainTable.mj_footer.hidden = arr.count<=0?YES:NO;
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
    CGFloat height = 0;
    if (_inputType == InviteAwardTypeInvite) {
        height = ShareFriendsCell_Height;
    } else if (_inputType == InviteAwardTypeFriend) {
        height = ShareRewardCell_Height;
    } else if (_inputType == InviteAwardTypeDelegate) {
        height = ShareRewardCell_Height;
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
    
    if (_inputType == InviteAwardTypeInvite) {
        ShareFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:ShareFriendsCellReuse];
        InviteRankingModel *model = _sourceArr[indexPath.row];
        [cell configCell:model qgasUnit:_input_invite_reward_amount?:@"0" color:UIColorFromRGB(0xFEFCF2)];
        
        return cell;
    } else if (_inputType == InviteAwardTypeFriend) {
        ShareRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:ShareRewardCell_Reuse];
        
        InviteeListModel *model = _sourceArr[indexPath.row];
        [cell config_friend:model];
        
        return cell;
    } else if (_inputType == InviteAwardTypeDelegate) {
       ShareRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:ShareRewardCell_Reuse];
       
        InviteRankingModel *model = _sourceArr[indexPath.row];
        [cell config_delegate:model];
        
       return cell;
    }
    
    return [UITableViewCell new];
}

@end
