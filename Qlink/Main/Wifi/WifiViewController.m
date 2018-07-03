//
//  WifiViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "WifiViewController.h"
#import "VpnTabCell.h"
#import "RefreshTableView.h"
#import "WalletAlertView.h"
#import "ProfileViewController.h"
#import "SystemUtil.h"
//#import "UIButton+UserHead.h"
#import "WalletUtil.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface WifiViewController ()<UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate>

@property (nonatomic ,strong) NSMutableArray *sourceArr;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *userHeadBtn;
@property (strong, nonatomic) RefreshTableView *mainTable;
@property (weak, nonatomic) IBOutlet UIView *tableBack;

@end

@implementation WifiViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)clickHead:(id)sender {
    ProfileViewController* profileVC = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //  设置setbtn圆角
    _setBtn.layer.cornerRadius = _setBtn.frame.size.height/2;
    _setBtn.layer.masksToBounds = YES;
    _messageBtn.layer.cornerRadius = _messageBtn.frame.size.height/2;
    _messageBtn.layer.masksToBounds = YES;
    
    _sourceArr = [NSMutableArray array];
    
    // 服务器切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshContent) name:CHANGE_SERVER_NOTI object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.mainTable reloadData];
}

#pragma mark - Config View
- (void)refreshContent {
    
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.mainTable.slimeView) {
        //[self.mainTable.slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.mainTable.slimeView) {
        //[self.mainTable.slimeView scrollViewDidEndDraging];
    }
}

#pragma mark - slimeRefresh delegate
//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
     [self sendWiFiReqeustWithSsids:@[@""]];
}

- (void) sendWiFiReqeustWithSsids:(NSArray *) ssids
{
    @weakify_self
    [RequestService requestWithUrl:ssIdquerys_Url params:ssids httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakSelf.mainTable.slimeView endRefresh];
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakSelf.mainTable.slimeView endRefresh];
    }];
}

#pragma uitableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sourceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell1 = @"onLineCell";
    VpnTabCell *onLineCell = [tableView dequeueReusableCellWithIdentifier:cell1];
    if (!onLineCell) {
        onLineCell = [[[NSBundle mainBundle] loadNibNamed:@"VpnTabCell" owner:self options:nil] lastObject];
        onLineCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return onLineCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![ToxManage getP2PConnectionStatus]) {
        [self showUserConnectStatus];
        return;
    }
   
}

- (IBAction)setBtnAction:(id)sender {
    
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (IBAction)messageBtnAction:(id)sender {
}

#pragma mark - Lazy
- (RefreshTableView *)mainTable {
    if (!_mainTable) {
        _mainTable = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, _tableBack.width, _tableBack.height) style:UITableViewStylePlain];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        //_mainTable.slimeView.delegate = self;
        _mainTable.showsVerticalScrollIndicator = NO;
        _mainTable.showsHorizontalScrollIndicator = NO;
        _mainTable.backgroundColor = [UIColor clearColor];
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableBack addSubview:_mainTable];
        [_mainTable registerNib:[UINib nibWithNibName:VpnTabCellReuse bundle:nil] forCellReuseIdentifier:VpnTabCellReuse];
        [_mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(_tableBack).offset(0);
        }];
    }
    
    return _mainTable;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
