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

@interface MyViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation MyViewController

NSString *my_title0 = @"Crypto Wallet";
NSString *my_title1 = @"Share with Friends";
NSString *my_title2 = @"Join the Community";
NSString *my_title3 = @"Contact Us";
NSString *my_title4 = @"Settings";

#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccessNoti:) name:User_Logout_Success_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNoti:) name:User_Login_Success_Noti object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addObserve];
    
    _userIcon.layer.cornerRadius = _userIcon.width/2.0;
    _userIcon.layer.masksToBounds = YES;
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:MyCellReuse bundle:nil] forCellReuseIdentifier:MyCellReuse];
    
    [self configInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshUserInfoView];
}

#pragma mark - Operation
- (void)configInit {
    NSArray *titleArr = @[my_title0,my_title1,my_title2,my_title3,my_title4];
    NSArray *iconArr = @[@"icon_my_wallet",@"icon_my_share",@"icon_my_community",@"icon_my_contact",@"icon_my_settings"];
    kWeakSelf(self);
    [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MyShowModel *model = [MyShowModel new];
        model.title = obj;
        model.icon = iconArr[idx];
        [weakself.sourceArr addObject:model];
    }];
    [_mainTable reloadData];
}

- (void)refreshUserInfoView {
    if ([UserModel haveLoginAccount]) {
        UserModel *userM = [UserModel fetchUserOfLogin];
        [_userIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],userM.head]] placeholderImage:User_DefaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
        _userNameLab.text = userM.nickname?:@"未设置昵称";
    } else {
        _userIcon.image = User_DefaultImage;
        _userNameLab.text = @"登录/注册";
    }
}

#pragma mark - Action

- (IBAction)clickUserAction:(id)sender {
    if ([UserModel haveLoginAccount]) {
        [self jumpToPersonalInfo];
    } else {
        [kAppD presentLoginNew];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MyCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyShowModel *model = _sourceArr[indexPath.row];
    if ([model.title isEqualToString:my_title0]) {
        [self jumpToWalletsManage];
    } else if ([model.title isEqualToString:my_title1]) {
        
    } else if ([model.title isEqualToString:my_title2]) {
        [self jumpToJoinCommunity];
    } else if ([model.title isEqualToString:my_title3]) {
        
    } else if ([model.title isEqualToString:my_title4]) {
        [self jumpToSettings];
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

#pragma mark - Noti
- (void)logoutSuccessNoti:(NSNotification *)noti {
    [self refreshUserInfoView];
}

- (void)loginSuccessNoti:(NSNotification *)noti {
    [self refreshUserInfoView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
