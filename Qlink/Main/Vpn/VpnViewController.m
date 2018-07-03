//
//  VpnViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VpnViewController.h"
#import "VpnTabCell.h"
#import "UIView+Gradient.h"
#import "LocationManage.h"
#import "LocationMode.h"
#import "VPNMode.h"
#import "VpnTabCell.h"
#import "RefreshTableView.h"
#import "VPNRegisterViewController.h"
#import "ProfileViewController.h"
#import "ChooseContinentViewController.h"
#import "VPNConnectViewController.h"
#import "ChooseCountryUtil.h"
#import "WalletUtil.h"
#import "UIImage+RoundedCorner.h"
//#import "UIButton+UserHead.h"
#import "SelectCountryModel.h"
#import "ChooseCountryUtil.h"
#import "DebugLogViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "FriendStatusModel.h"
#import "ToxRequestModel.h"
#import "SeizeVPNViewController.h"
#import <NetworkExtension/NetworkExtension.h>
#import "Qlink-Swift.h"
#import "VPNConnectedViewController.h"
#import "HeartbeatUtil.h"
#import "VPNFileUtil.h"
#import "ChatUtil.h"
#import "ChatModel.h"
#import "P2pMessageManage.h"
#import "VPNOperationUtil.h"
#import "ZXChatViewController.h"
#import "TransferUtil.h"
#import "GuideVpnAddView.h"
#import "GuideClickWalletView.h"
#import "GuideVpnCountryView.h"
#import "GuideVpnListView.h"
#import "GuideVpnListConnectView.h"

@interface VpnViewController ()<UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate> {
}

@property (weak, nonatomic) IBOutlet UIButton *userHeadBtn;
@property (nonatomic ,strong) VPNMode *vpnMode;
//@property (nonatomic ,strong) NSMutableArray *dataArray;
//@property (weak, nonatomic) IBOutlet RefreshTableView *tableV;
@property (weak, nonatomic) IBOutlet UIButton *registerVPNBtn;
@property (strong, nonatomic) RefreshTableView *mainTable;
@property (weak, nonatomic) IBOutlet UIView *tableBack;
@property (weak, nonatomic) IBOutlet UILabel *countryLab;
@property (weak, nonatomic) IBOutlet UIView *sectionBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sectionBackHeight;
@property (strong, nonatomic) IBOutlet UIView *sectionTitleView;

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) SelectCountryModel *selectCountryM;
@property (nonatomic, strong) VPNInfo *selectVPNInfo;
//@property (nonatomic, strong) NSLock *vpnqueryLock;
@property (nonatomic) BOOL isConnectVPN;
@property (nonatomic) BOOL joinGroupFlag;

@end

@implementation VpnViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCountryNoti:) name:SELECT_COUNTRY_NOTI_VPNLIST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkProcessSuccessOfVPNAdd:) name:CHECK_PROCESS_SUCCESS_VPN_ADD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkProcessSuccessOfVPNList:) name:CHECK_PROCESS_SUCCESS_VPN_LIST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkProcessSuccessOfVPNSeize:) name:CHECK_PROCESS_SUCCESS_VPN_SEIZE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p2pOnline:) name:P2P_ONLINE_NOTI object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p2pOffline:) name:P2P_OFFLINE_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendStatusChange:) name:FRIEND_STATUS_CHANGE_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinGroupSuccess:) name:P2P_JOINGROUP_SUCCESS_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addGroupChatMessage:) name:ADD_GROUP_CHAT_MESSAGE_COMPLETE_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vpnStatusChange:) name:VPN_STATUS_CHANGE_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 服务器切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeServer:) name:CHANGE_SERVER_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(seizeVpnSuccess:) name:SEIZE_VPN_SUCCESS_NOTI object:nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showRegisterVPN];
    [self addObserve];
    [self configData];
    [self startLocation];
    
//    NSLog(@"原始私钥 = %@",[CurrentWalletInfo getShareInstance].privateKey);
//   NSString *privateEntry = [ToxManage encrypt:[CurrentWalletInfo getShareInstance].privateKey];
//    NSLog(@"加密后私钥 = %@",privateEntry);
//   NSString *privateDentry = [ToxManage dencrypt:privateEntry];
//   NSLog(@"解密后私钥 = %@",privateDentry);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshVPNConnect];
    [self addNewGuideClickWallet];
}

#pragma mark - Operation
- (BOOL)selectVpnIsMine {
    NSString *myP2pId = [ToxManage getOwnP2PId];
    return [_selectVPNInfo.p2pId isEqualToString:myP2pId]?YES:NO;
}

- (void)configData {
    [self addSectionTitle];
}

// 刷新vpn连接状态
- (void)refreshVPNConnect {
    _isConnectVPN = NO;
    NEVPNStatus status = [VPNUtil.shareInstance vpnConnectStatus];
    switch (status) {
        case NEVPNStatusConnected:
        {
            _isConnectVPN = YES;
        }
            break;
            
        default:
            break;
    }
    if (!_isConnectVPN) { // 更新本地保存的vpn
        [HWUserdefault deleteObjectWithKey:Current_Connenct_VPN];
    }
    [self configSourceAndRefresh:NO];
}

- (void)startLocation {
    //系统语言为英文时返回中文编码
  //  NSString *appleLanguages = @"AppleLanguages";
   // NSMutableArray *defaultLanguages = [HWUserdefault getObjectWithKey:appleLanguages];
   // [HWUserdefault insertObj:[NSArray arrayWithObjects:@"en",nil] withkey:appleLanguages];
    @weakify_self
    [[LocationManage shareInstanceLocationManager] startLocation:^(NSString *country,BOOL success) {
        if (success) {
            // 还原系统语言
            [LocationMode getShareInstance].country = country;
            SelectCountryModel *selectM = [[SelectCountryModel alloc] init];
            selectM.country = country;
            selectM.continent = [ChooseCountryUtil getContinentOfCountry:country];
            [weakSelf refreshCountry:selectM];
            // 根据国家获取vpn资产列表
            [weakSelf sendVPNReqeustWithCountry];
        } else {
        
            DDLogDebug(@"定位失败");
            [weakSelf sendVPNReqeustWithCountry];
        }
//        [weakSelf sendVPNReqeustWithCountry];
    }];
}

- (void)refreshCountry:(SelectCountryModel *)selectM {
    _selectCountryM = selectM;
    _countryLab.text = _selectCountryM.country.uppercaseString;
}

/**
 根据国家获取vpn资产列表
 */
- (void)sendVPNReqeustWithCountry {
    @weakify_self
//    [self.vpnqueryLock lock];
    NSDictionary *params = @{@"country":self.selectCountryM.country};

    [RequestService requestWithUrl:vpnqueryVpnV2_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {

        [weakSelf.mainTable.slimeView endRefresh];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            [weakSelf.sourceArr removeAllObjects]; // 移除旧数据
            [weakSelf.mainTable reloadData];
            
            NSArray *arr = [responseObject objectForKey:Server_Data];
            if (arr && arr.count > 0) {
                NSArray *tempArr = [VPNMode mj_objectArrayWithKeyValuesArray:arr];
                // 拿到所有vpn model
                NSMutableArray *allVpnArr = [NSMutableArray array];
                [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    VPNMode *vpnM = obj;
                    [allVpnArr addObjectsFromArray:vpnM.vpnList];
                }];
                [weakSelf.sourceArr addObjectsFromArray:allVpnArr];
                [weakSelf configSourceAndRefresh:YES];
            } else {
//                [weakSelf showHint:@"当前没有可用的VPN"];
            }
        }
//        [weakSelf.vpnqueryLock unlock];
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        [weakSelf hideHud];
        [weakSelf.mainTable.slimeView endRefresh];
//        [AppD.window showHint:error.description];
//        [weakSelf.vpnqueryLock unlock];
    }];
}

// 是否是好友
- (NSArray *)handleIsFriend:(NSArray *)arr {
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VPNInfo *vpnInfo = obj;
        if (![vpnInfo.p2pId isEqualToString:[ToxManage getOwnP2PId]]) { // 不是自己
//            NSInteger friendNum = [ToxManage getFriendNumInFriendlist:vpnInfo.p2pId];
//            if (friendNum < 0) { // 非好友 添加好友
                NSInteger friendNum = [ToxManage addFriend:vpnInfo.p2pId];
//            }
            vpnInfo.friendNum = friendNum;
        } else { // 自己先赋值为-3
            vpnInfo.friendNum = -3;
        }
    }];
    return arr;
}

// 是否在线
- (void)handleIsOnline:(BOOL)refreshFriend {
    NSMutableArray *onlineArr = [NSMutableArray array];
    NSMutableArray *offlineArr = [NSMutableArray array];
    [self.sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VPNInfo *vpnInfo = obj;
        if ([vpnInfo.p2pId isEqualToString:[ToxManage getOwnP2PId]]) {
            vpnInfo.online = [ToxManage getP2PConnectionStatus];
        } else {
             vpnInfo.online = [ToxManage getFriendConnectionStatus:vpnInfo.p2pId];
        }
        
        if (vpnInfo.online > 0) {
            [onlineArr addObject:vpnInfo];
        } else {
            [offlineArr addObject:vpnInfo];
        }
    }];
    
    if (refreshFriend) {
        offlineArr = [NSMutableArray arrayWithArray:[self handleIsFriend:offlineArr]]; // 是否是好友(添加好友)
    }
    
    [self handleQlcDescend:onlineArr];
    [self handleQlcDescend:offlineArr];
    [self.sourceArr removeAllObjects];
    [self.sourceArr addObjectsFromArray:onlineArr];
    [self.sourceArr addObjectsFromArray:offlineArr];
}

// 资产总额
- (void)handleQlcDescend:(NSMutableArray *)arr {
    [arr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        VPNInfo *vpnInfo1 = obj1;
        VPNInfo *vpnInfo2 = obj2;
        CGFloat qlc1 = [vpnInfo1.qlc floatValue];
        CGFloat qlc2 = [vpnInfo2.qlc floatValue];
        return qlc1 < qlc2;
    }];
    
//    return arr;
}

// 是否连接
- (void)handleIsConnect {
//    NSMutableArray *connectArr = [NSMutableArray array];
//    NSMutableArray *disconnectArr = [NSMutableArray array];
    __block NSInteger connectIndex = 0;
    [self.sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VPNInfo *vpnInfo = obj;
        vpnInfo.isConnected = NO;
        if (_isConnectVPN) {
            
            NSString *currentConnnectVPN = [TransferUtil currentVPNName];
            vpnInfo.isConnected = [currentConnnectVPN isEqualToString:vpnInfo.vpnName]?YES:NO;
            if (vpnInfo.isConnected) {
                connectIndex = idx;
//                [connectArr addObject:vpnInfo];
            } else {
//                [disconnectArr addObject:vpnInfo];
            }
        }
    }];
    
    if (_isConnectVPN) {
        [self.sourceArr exchangeObjectAtIndex:0 withObjectAtIndex:connectIndex];
    }
    
//    [self.sourceArr removeAllObjects];
//    [self.sourceArr addObjectsFromArray:connectArr];
//    [self.sourceArr addObjectsFromArray:disconnectArr];
}

- (void)configSourceAndRefresh:(BOOL)refreshFriend {
    [self handleIsOnline:refreshFriend]; // 是否在线--不在线的加好友--资产总额
    [self handleIsConnect]; // 是否连接
    [self refreshTable];
}

static BOOL refreshAnimate = YES;
- (void)refreshTable {
    if (refreshAnimate) {
        [self.mainTable beginUpdates];
        [self.mainTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.mainTable endUpdates];
    } else {
        [self.mainTable reloadData];
    }
    refreshAnimate = NO;
}

- (BOOL)vpnIsMine:(NSString *)p2pId {
    NSString *myP2pId = [ToxManage getOwnP2PId];
    return [p2pId isEqualToString:myP2pId]?YES:NO;
}

- (void)sendJoinGroupMessage:(NSString *)toP2pId assetName:(NSString *)assetName {
    // 发送申请加入群聊的请求
    ToxRequestModel *model = [[ToxRequestModel alloc] init];
    model.type = joinGroupChatReq;
    NSDictionary *dataDic = @{@"appVersion":APP_Build,ASSETNAME:assetName,@"assetType":@"3"};
    model.data = dataDic.mj_JSONString;
    NSString *str = model.mj_JSONString;
    [ToxManage sendMessageWithMessage:str withP2pid:toP2pId];
}

- (void)clickConversation:(VPNInfo *)vpnInfo {
    if ([self vpnIsMine:vpnInfo.p2pId]) { // 自己的vpn资产
        [self getChatGroupToJump:vpnInfo];
    } else { // 别人的vpn资产
        _joinGroupFlag = NO;
        [AppD.window showHudInView:self.view hint:@""];
        [self performSelector:@selector(joinGroupTimeout) withObject:nil afterDelay:8];
        NSString *assetName = vpnInfo.vpnName?:@"";
        ChatUtil.shareInstance.joinAssetName = assetName;
        ChatUtil.shareInstance.joinGroupName = assetName;
        [self sendJoinGroupMessage:vpnInfo.p2pId assetName:assetName]; // 发送申请加入群聊的消息
    }
}

- (void)getChatGroupToJump:(VPNInfo *)vpnInfo {
    ChatModel *chatM = [ChatUtil.shareInstance getChat:_selectVPNInfo.vpnName];
    if (chatM) {
        [ChatUtil.shareInstance setChatRead:_selectVPNInfo.vpnName]; // 置为已读
        [self jumpToChat:chatM];
    } else {
        [AppD.window showHudInView:self.view hint:NSStringLocalizable(@"group_invalid") userInteractionEnabled:YES hideTime:2];
        DDLogDebug(@"没有找到聊天群(部分无聊天群，旧版本未保存资产到本地)");
    }
}

- (void)joinGroupTimeout {
    if (!_joinGroupFlag) {
        [AppD.window hideHud];
        [AppD.window showHint:NSStringLocalizable(@"timeout")];
    }
}

#pragma mark - Noti
- (void)selectCountryNoti:(NSNotification *)noti {
    SelectCountryModel *selectM = noti.object;
    [self refreshCountry:selectM];
    [self sendVPNReqeustWithCountry];
}

- (void)checkProcessSuccessOfVPNAdd:(NSNotification *)noti {
    CGFloat delay = 0.0f;
    if ([WalletUtil shareInstance].isDelay) {
        delay = 0.6f;
    }
    [self performSelector:@selector(jumpToVPNRegister) withObject:self afterDelay:delay];
    //[self jumpToVPNRegister];
}

- (void)checkProcessSuccessOfVPNList:(NSNotification *)noti {
    if (![ToxManage getP2PConnectionStatus]) {
        [self showUserConnectStatus];
        return;
    }
    if (_selectVPNInfo.isConnected) {
        [self jumpToVPNConnected];
    } else {
        CGFloat delay = 0.0f;
        if ([WalletUtil shareInstance].isDelay) {
            delay = 0.6f;
        }
        [self performSelector:@selector(jumpToVPNConnect) withObject:nil afterDelay:delay];
    }
}
- (void)checkProcessSuccessOfVPNSeize:(NSNotification *)noti {
    CGFloat delay = 0.0f;
    if ([WalletUtil shareInstance].isDelay) {
        delay = 0.6f;
    }
    [self performSelector:@selector(jumpToSeizeVPN) withObject:self afterDelay:delay];
}

- (void)p2pOnline:(NSNotification *)noti {
    // 发送心跳
    [[HeartbeatUtil shareInstance] sendTimedHeartbeat];
    [self configSourceAndRefresh:NO];
}

- (void) p2pOffline:(NSNotification *) noti {
    [self configSourceAndRefresh:NO];
}

- (void)friendStatusChange:(NSNotification *)noti {
//    FriendStatusModel *friendStatusM = noti.object;
//    [self refreshFriendStatus:friendStatusM];
    [self configSourceAndRefresh:NO];
}

- (void)joinGroupSuccess:(NSNotification *)noti {
    [AppD.window hideHud];
    _joinGroupFlag = YES;
    [self getChatGroupToJump:_selectVPNInfo];
}

- (void)addGroupChatMessage:(NSNotification *)noti {
//    NSUInteger groupNum = [noti.object integerValue];
    [self refreshTable];
}

- (void)vpnStatusChange:(NSNotification *)noti {
    
    VPNConnectOperationType operationType = [VPNOperationUtil shareInstance].operationType;
    if (operationType == registerConnect) { // 注册连接vpn不用管
        return;
    }
    
    NEVPNStatus status = (NEVPNStatus)[noti.object integerValue];
    switch (status) {
        case NEVPNStatusInvalid:
            break;
        case NEVPNStatusDisconnected:
        {
            NSInteger operationStatus = [VPNUtil.shareInstance getOperationStatus];
            if (operationStatus != 1) { // 连接操作中不进行下面操作
//                [HWUserdefault deleteObjectWithKey:Current_Connenct_VPN]; // 删除当前连接的vpn对象
                [self refreshVPNConnect];
                // 删除vpn本地配置
                [VPNUtil.shareInstance removeFromPreferences];
            }
        }
            break;
        case NEVPNStatusConnecting:
            break;
        case NEVPNStatusConnected:
        {
            [HWUserdefault insertObj:[_selectVPNInfo mj_keyValues] withkey:Current_Connenct_VPN]; // 保存当前连接的vpn对象
            [self refreshVPNConnect];
            // vpn连接记录写入数据库
            if (![self selectVpnIsMine]) {
                // vpn连接成功进行转账
               // [TransferUtil sendFundsRequestWithType:3 withVPNInfo:_selectVPNInfo];
            }
//            [self addNewGuideVPNConnect];
            [self addNewGuideVpnListConnect];
        }
            break;
        case NEVPNStatusReasserting:
            break;
        case NEVPNStatusDisconnecting:
        {
        }
            break;
        default:
            break;
    }
}

- (void)applicationBecomeActive {
    [self refreshVPNConnect];
}

- (void)changeServer:(NSNotification *)noti {
    [self showRegisterVPN]; // 主网隐藏VPN注册
    [self.sourceArr removeAllObjects]; // 移除旧数据
    [self.mainTable reloadData];
    [self sendVPNReqeustWithCountry];
}

- (void)seizeVpnSuccess:(NSNotification *)noti {
    [self sendVPNReqeustWithCountry];
}

#pragma mark - Config View
- (void)refreshContent {
    
}

- (void)addSectionTitle {
    _sectionBackHeight.constant = 45;
    [_sectionBack addSubview:_sectionTitleView];
    [_sectionTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(_sectionBack).offset(0);
    }];
}

- (void)addNewGuideClickAdd {
    CGRect hollowOutFrame = [_registerVPNBtn.superview convertRect:_registerVPNBtn.frame toView:[UIApplication sharedApplication].keyWindow];
    @weakify_self
    [[GuideVpnAddView getNibView] showGuideTo:hollowOutFrame tapBlock:^{
        [weakSelf addNewGuideCountry];
    }];
}

- (void)addNewGuideClickWallet {
    CGRect hollowOutFrame = CGRectMake((3.0*(2.0+1.0)-2.0)*SCREEN_WIDTH/(3.0*3.0), SCREEN_HEIGHT - 49, 49, 49);
    @weakify_self
    [[GuideClickWalletView getNibView] showGuideTo:hollowOutFrame tapBlock:^{
        [weakSelf addNewGuideClickAdd];
    }];
}

- (void)addNewGuideCountry {
    CGRect hollowOutFrame = CGRectMake((SCREEN_WIDTH - 55)/2.0, 96, 55, 24);
    @weakify_self
    [[GuideVpnCountryView getNibView] showGuideTo:hollowOutFrame tapBlock:^{
        [weakSelf addNewGuideVpnList];
    }];
}

- (void)addNewGuideVpnList {
    CGRect hollowOutFrame = CGRectMake(17, 177, SCREEN_WIDTH - 17*2, 64);
    [[GuideVpnListView getNibView] showGuideTo:hollowOutFrame tapBlock:^{
        
    }];
}

- (void)addNewGuideVpnListConnect {
    CGRect hollowOutFrame = CGRectMake(17, 177, SCREEN_WIDTH - 17*2, 64);
    [[GuideVpnListConnectView getNibView] showGuideTo:hollowOutFrame tapBlock:^{
        
    }];
}

#pragma mark - 如果是主网。隐藏注册资产铵钮
- (void) showRegisterVPN
{
    // 如果是主网。隐藏注册资产铵钮
    if ([WalletUtil checkServerIsMian]) {
        _registerVPNBtn.hidden = YES;
        _registerVPNBtn.enabled = NO;
    } else {
        _registerVPNBtn.hidden = NO;
        _registerVPNBtn.enabled = YES;
    }
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_mainTable.slimeView) {
        [_mainTable.slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_mainTable.slimeView) {
        [_mainTable.slimeView scrollViewDidEndDraging];
    }
}

#pragma mark - slimeRefresh delegate
//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView {
    [self sendVPNReqeustWithCountry];
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return VpnTabCell_Height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VpnTabCell *cell = [tableView dequeueReusableCellWithIdentifier:VpnTabCellReuse];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.seizeBtn.tag = indexPath.row;
    VPNInfo *vpnInfo = _sourceArr[indexPath.row];
    [cell configCellWithModel:vpnInfo];
    
    @weakify_self
    [cell setSeizeBlock:^(NSInteger row) {
        if ([ToxManage getP2PConnectionStatus]) {
            weakSelf.selectVPNInfo = weakSelf.sourceArr[row];
            [WalletUtil checkWalletPassAndPrivateKey:self TransitionFrom:CheckProcess_VPN_SEIZE];
        } else {
            [weakSelf showUserConnectStatus];
        }
    }];
    
    // 跳转聊天页
    cell.conversationB = ^{
        weakSelf.selectVPNInfo = vpnInfo;
        [weakSelf clickConversation:vpnInfo];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VPNInfo *vpnInfo = _sourceArr[indexPath.row];

    if (vpnInfo.online <= 0) { // offline 不能点击
        [AppD.window showHint:NSStringLocalizable(@"friend_unline_p2p")];
        return;
    }
    _selectVPNInfo = vpnInfo;
    [WalletUtil checkWalletPassAndPrivateKey:self TransitionFrom:CheckProcess_VPN_LIST];
}

#pragma mark - Action
- (IBAction)clickAdd:(id)sender {
    
    [WalletUtil checkWalletPassAndPrivateKey:self TransitionFrom:CheckProcess_VPN_ADD];
}

- (IBAction)clickHead:(id)sender {
   [self jumpToProfile];
}

- (IBAction)countryAction:(id)sender {
    [self jumpToChooseContinent];
}

- (IBAction)debugLogAction:(id)sender {
#ifdef DEBUG
    [self jumpToDebugLog];
#endif
}

#pragma mark - Transition

- (void)jumpToVPNRegister {
    VPNRegisterViewController *addVC = [[VPNRegisterViewController alloc] initWithRegisterType:RegisterVPN];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)jumpToProfile {
    ProfileViewController* profileVC = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)jumpToChooseContinent {
    [ChooseCountryUtil shareInstance].entry = VPNList;
    ChooseContinentViewController *vc = [[ChooseContinentViewController alloc] init];
    if (_selectCountryM) {
        vc.inputContinent = _selectCountryM.continent;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToVPNConnect {
    VPNConnectViewController *vc = [[VPNConnectViewController alloc] init];
    vc.vpnInfo = _selectVPNInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToVPNConnected {
    VPNConnectedViewController *vc = [[VPNConnectedViewController alloc] init];
    vc.vpnInfo = _selectVPNInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToDebugLog {
    DebugLogViewController *vc = [[DebugLogViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) jumpToSeizeVPN {
    SeizeVPNViewController *vc = [[SeizeVPNViewController alloc] initWithVPNInfo:_selectVPNInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToChat:(ChatModel *)chatM {
    ZXChatViewController *vc = [[ZXChatViewController alloc] init];
    ChatUtil.shareInstance.currentChatM = chatM;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Lazy
//- (NSMutableArray *)dataArray {
//    if (!_dataArray) {
//        _dataArray = [NSMutableArray array];
//    }
//
//    return _dataArray;
//}

- (NSMutableArray *)sourceArr {
    if (!_sourceArr) {
        _sourceArr = [NSMutableArray array];
    }
    
    return _sourceArr;
}

- (SelectCountryModel *)selectCountryM {
    if (!_selectCountryM) {
        _selectCountryM = [[SelectCountryModel alloc] init];
        _selectCountryM.continent = ASIA_CONTINENT;
        _selectCountryM.country = [LocationMode getShareInstance].country;
    }
    
    return _selectCountryM;
}

//- (NSLock *)vpnqueryLock {
//    if (!_vpnqueryLock) {
//        _vpnqueryLock = [NSLock new];
//    }
//    
//    return _vpnqueryLock;
//}

- (RefreshTableView *)mainTable {

    if (!_mainTable) {
        _mainTable = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, _tableBack.width, _tableBack.height) style:UITableViewStylePlain];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.slimeView.delegate = self;
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
