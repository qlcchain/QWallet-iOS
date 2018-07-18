//
//  VPN2ViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/7/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VPN2ViewController.h"
#import "VpnListCell.h"
#import "UIView+Gradient.h"
#import "LocationManage.h"
#import "LocationMode.h"
#import "VPNMode.h"
#import "RefreshTableView.h"
#import "VPNRegisterViewController.h"
#import "ProfileViewController.h"
#import "ChooseContinentViewController.h"
#import "VPNConnectViewController.h"
#import "ChooseCountryUtil.h"
#import "WalletUtil.h"
#import "UIImage+RoundedCorner.h"
//#import "UIButton+UserHead.h"
#import "ContinentModel.h"
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
#import "ChooseCountryView.h"
#import "VpnConnectUtil.h"
#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"
#import "TransferUtil.h"
#import "VPNTranferMode.h"
#import "FreeConnectionViewController.h"

#define CELL_CONNECT_BTN_TAG 5788

@interface VPN2ViewController ()<UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate> {
}

@property (weak, nonatomic) IBOutlet UIButton *userHeadBtn;
@property (weak, nonatomic) IBOutlet UILabel *freeConnectionLab;
@property (weak, nonatomic) IBOutlet UIButton *registerVPNBtn;
@property (weak, nonatomic) IBOutlet UIView *tableBack;
@property (weak, nonatomic) IBOutlet UILabel *countryLab;
@property (weak, nonatomic) IBOutlet UIImageView *countryIcon;
@property (weak, nonatomic) IBOutlet UIView *sectionBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sectionBackHeight;
@property (strong, nonatomic) IBOutlet UIView *sectionTitleView;

@property (nonatomic ,strong) VPNMode *vpnMode;
@property (strong, nonatomic) RefreshTableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) CountryModel *selectCountryM;
@property (nonatomic, strong) VPNInfo *selectVPNInfo;
@property (nonatomic) BOOL isConnectVPN;
@property (nonatomic) BOOL joinGroupFlag;
@property (nonatomic , strong) ChooseCountryView *countryView;
@property (nonatomic, strong) NSString *currentConnectVPNName;

@end

@implementation VPN2ViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addObserve {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCountryNoti:) name:SELECT_COUNTRY_NOTI_VPNLIST object:nil];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectVpnTimeout:) name:Connect_Vpn_Timeout_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkConnectTimeout:) name:Check_Connect_Timeout_Noti object:nil];
    // 修改本地资产成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVPNSuccess:) name:UPDATE_ASSETS_TZ object:nil];
    // VPN连接时创建钱包跳转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkProcessVPNConnect:) name:CHECK_PROCESS_SUCCESS_VPN_CONNECT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savePreferenceFail:) name:SAVE_VPN_PREFERENCE_FAIL_NOTI object:nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showRegisterVPN];
    [self addObserve];
    [self configData];
    [self startLocation];
    // 获取当前选择的国家--发送获取vpn列表请求
    [self checkCurrentChooseCountry];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshVPNConnect];
    
    [self addNewGuideClickWallet];
}

#pragma mark - Operation
#pragma mark - 获取当前选择的国家--发送获取vpn列表请求
- (void) checkCurrentChooseCountry {
    CountryModel *currentCountry =  [CountryModel mj_objectWithKeyValues:[HWUserdefault getObjectWithKey:CURRENT_SELECT_COUNTRY]];
    if (currentCountry) {
        [self refreshCountry:currentCountry];
    } else {
        [self requestQueryVpn];
    }
    
}

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
    NEVPNStatus status = [VPNUtil.shareInstance getVpnConnectStatus];
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
//    @weakify_self
    [[LocationManage shareInstanceLocationManager] startLocation:^(NSString *country,BOOL success) {
        if (success) {
            [LocationMode getShareInstance].country = country;
//            SelectCountryModel *selectM = [[SelectCountryModel alloc] init];
//            selectM.country = country;
//            selectM.continent = [ChooseCountryUtil getContinentOfCountry:country];
//            [weakSelf refreshCountry:selectM];
//            [weakSelf sendVPNReqeustWithCountry];
        } else {
            DDLogDebug(@"定位失败");
        }
    }];
}

- (void)refreshCountry:(CountryModel *)selectM {
    self.selectCountryM = selectM;
    _countryLab.text = _selectCountryM.name.uppercaseString;
    _countryIcon.image = [UIImage imageNamed:_selectCountryM.countryImage];
    [self requestQueryVpn];
   
}

// 根据国家获取vpn资产列表
- (void)requestQueryVpn {
    
    BOOL isDefault = YES;
    if (_selectCountryM && ![_selectCountryM.name isEqualToString:OTHERS]) {
        isDefault = NO;
    }
    @weakify_self
    // 默认v2接口，选择国家用v3接口
    NSDictionary *params = isDefault?@{@"country":@"Others"}:@{@"country":self.selectCountryM.name};
    NSString *url = isDefault?queryVpnV2_Url:queryVpnV3_Url;
    
    [RequestService requestWithUrl:url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
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
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakSelf.mainTable.slimeView endRefresh];
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

// 查看源数据中是否有已连接的vpn，没有则添加（置顶）
- (void)handleSourceWithConnectVpn {
    if (!_isConnectVPN) { // 未连接vpn
        return;
    }
    __block BOOL connectIsExist = NO;
    [self.sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VPNInfo *vpnInfo = obj;
        if ([vpnInfo.vpnName isEqualToString:[TransferUtil currentVPNName]]) {
            connectIsExist = YES;
        }
    }];
    
    if (!connectIsExist) { // 没有则添加
        VPNInfo *connectInfo = [TransferUtil currentConnectVPNInfo];
        if (connectInfo) {
            [self.sourceArr addObject:connectInfo];
        }
    }
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
}

// 是否连接
- (void)handleIsConnect {
    __block NSInteger connectIndex = 0;
    [self.sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VPNInfo *vpnInfo = obj;
        vpnInfo.isConnected = NO;
//        vpnInfo.connectStatus = VpnConnectStatusNone;
        if (_isConnectVPN) {
            NSString *currentConnnectVPN = [TransferUtil currentVPNName];
            vpnInfo.isConnected = [currentConnnectVPN isEqualToString:vpnInfo.vpnName]?YES:NO;
            if ([currentConnnectVPN isEqualToString:vpnInfo.vpnName]) {
                vpnInfo.connectStatus = VpnConnectStatusConnected;
            }
//            vpnInfo.connectStatus = [currentConnnectVPN isEqualToString:vpnInfo.vpnName]?VpnConnectStatusConnected:VpnConnectStatusNone;
            if (vpnInfo.isConnected) {
                connectIndex = idx;
            } else {
            }
        }
    }];
    
    if (_isConnectVPN) {
        [self.sourceArr exchangeObjectAtIndex:0 withObjectAtIndex:connectIndex];
    }
}

- (void)configSourceAndRefresh:(BOOL)refreshFriend {
    [self handleSourceWithConnectVpn]; // 添加已连接的vpn
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

// 显示连接提示
- (void)showConnectAlert:(VPNInfo *)vpnInfo {
    
   NSString *countStr = [HWUserdefault getObjectWithKey:VPN_FREE_COUNT];
    // 判断免费连接次数
    if ([[NSStringUtil getNotNullValue:countStr] isEqualToString:@"0"]) {
        if (![WalletUtil isExistWalletPrivateKey]) {
            [WalletUtil checkWalletPassAndPrivateKey:self TransitionFrom:CheckProcess_VPN_CONNECT];
        } else {
            BOOL isShowAlert = YES;
            // 获取vpn上次连接时间
            NSDictionary *modeDic = [HWUserdefault getObjectWithKey:vpnInfo.vpnName];
            VPNTranferMode *tranferMode = [VPNTranferMode getObjectWithKeyValues:modeDic];
            if (tranferMode) {
                NSString *connectTime = tranferMode.vpnConnectTime;
                if (![[NSStringUtil getNotNullValue:connectTime] isEmptyString]) {
                    // 判断上次连接时间 超过一时间扣费
                    NSDateFormatter *dateFormatrer = [NSDateFormatter defaultDateFormatter];
                    NSDate *backDate = [dateFormatrer dateFromString:connectTime];
                    // 判断日期相隔时间
                    NSInteger hours = [[NSDate date] hoursAfterDate:backDate];
                    //超过一时间扣费
                    if (labs(hours) < 1) {
                        if (tranferMode.isTranferSuccess) {
                            isShowAlert = NO;
                        }
                    }
                }
            }
            
            if (isShowAlert) {
                NSString *content = [NSString stringWithFormat:NSStringLocalizable(@"just_const"),vpnInfo.cost];
                NSString *image = @"icon_even";
                @weakify_self
                [UIView showVPNToastAlertViewWithTopImageName:image content:content block:^{
                    vpnInfo.connectStatus = VpnConnectStatusConnecting;
                    [weakSelf refreshTable];
                    [weakSelf goConnectVpn:vpnInfo]; // 检查连通性---连接vpn
                }];
            } else {
                vpnInfo.connectStatus = VpnConnectStatusConnecting;
                [self refreshTable];
                [self goConnectVpn:vpnInfo]; // 检查连通性---连接vpn
            }
        }
    } else { // 免费连接
        vpnInfo.connectStatus = VpnConnectStatusConnecting;
        [self refreshTable];
        [self goConnectVpn:vpnInfo]; // 检查连通性---连接vpn
    }
}

// 显示断开连接提示
- (void)showDisconnectAlert {
    NSString *content = NSStringLocalizable(@"want_disconnect");
    NSString *image = @"icon_disconnect";
    @weakify_self
    [UIView showVPNToastAlertViewWithTopImageName:image content:content block:^{
        [weakSelf refreshVpnNormalStatus];
        [weakSelf refreshTable];
        [[VPNUtil shareInstance] stopVPN]; // 关掉vpn连接
    }];
}

// 显示连接另一个提示
- (void)showConnectOtherAlert:(VPNInfo *)vpnInfo {
    NSString *content = NSStringLocalizable(@"want_connect");
    NSString *image = @"icon_tips1";
    @weakify_self
    [UIView showVPNToastAlertViewWithTopImageName:image content:content block:^{
        [weakSelf refreshVpnNormalStatus];
        [weakSelf refreshTable];
        [[VPNUtil shareInstance] stopVPN]; // 关掉vpn连接
        [weakSelf showConnectAlert:vpnInfo];
    }];
}

- (void)goConnectVpn:(VPNInfo *)vpnInfo {
    VpnConnectUtil *connectUtil = [[VpnConnectUtil alloc] initWithVpn:vpnInfo];
    [connectUtil checkConnect];
}

- (void)refreshDisconnectStatus {
    @weakify_self
    [self.sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VPNInfo *vpnInfo = obj;
        if ([vpnInfo.vpnName isEqualToString:weakSelf.currentConnectVPNName]) {
            vpnInfo.connectStatus = VpnConnectStatusNone;
        }
    }];
}

- (void)refreshVpnNormalStatus {
    [self.sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VPNInfo *vpnInfo = obj;
        vpnInfo.connectStatus = VpnConnectStatusNone;
    }];
}

#pragma mark - Noti
//- (void)selectCountryNoti:(NSNotification *)noti {
//    SelectCountryModel *selectM = noti.object;
//    [self refreshCountry:selectM];
//    [self requestQueryVpn:NO];
//}

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

- (void) checkProcessVPNConnect:(NSNotification *) noti
{
    
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
    [self configSourceAndRefresh:NO];
}

- (void)joinGroupSuccess:(NSNotification *)noti {
    [AppD.window hideHud];
    _joinGroupFlag = YES;
    [self getChatGroupToJump:_selectVPNInfo];
}

- (void)addGroupChatMessage:(NSNotification *)noti {
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
                [self refreshDisconnectStatus];
                [self refreshVPNConnect];
                // 删除vpn本地配置
                [VPNUtil.shareInstance removeFromPreferences];
                [TransferUtil updateUserDefaultVPNListCurrentVPNConnectStatus];
            }
        }
            break;
        case NEVPNStatusConnecting:
            break;
        case NEVPNStatusConnected:
        {
            if (![[CurrentWalletInfo getShareInstance].address isEqualToString:_selectVPNInfo.address]) {
                [TransferUtil udpateTransferModel:_selectVPNInfo];
            }
            [HWUserdefault insertObj:[_selectVPNInfo mj_keyValues] withkey:Current_Connenct_VPN]; // 保存当前连接的vpn对象
            _currentConnectVPNName = _selectVPNInfo.vpnName;
            [self refreshVPNConnect];
            if (_isConnectVPN) {
                [self addNewGuideVpnListConnect];
            }
            // vpn连接记录写入数据库
            if (![self selectVpnIsMine]) {
                // vpn连接成功进行转账
                // [TransferUtil sendFundsRequestWithType:3 withVPNInfo:_selectVPNInfo];
            }
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
    [self requestQueryVpn];
}

- (void)seizeVpnSuccess:(NSNotification *)noti {
    [self requestQueryVpn];
}

- (void)connectVpnTimeout:(NSNotification *)noti {
    _selectVPNInfo.connectStatus = VpnConnectStatusNone;
    [self refreshTable];
}

- (void)checkConnectTimeout:(NSNotification *)noti {
    _selectVPNInfo.connectStatus = VpnConnectStatusNone;
    [self refreshTable];
}

- (void) updateVPNSuccess:(NSNotification *) noti {
    [self requestQueryVpn];
}

- (void)savePreferenceFail:(NSNotification *)noti {
    _selectVPNInfo.connectStatus = VpnConnectStatusNone;
    [self refreshTable];
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

// 添加浮层
- (void)addNewGuideClickWallet {
    CGFloat x = 0;
    CGFloat width = 49;
    CGFloat height = 49;
    CGFloat y = SCREEN_HEIGHT - height;
    if (IS_iPhone_5) {
        x = SCREEN_WIDTH - width - 30;
    } else if (IS_iPhone_6) {
        x = SCREEN_WIDTH - width - 40;
    } else if (IS_iPhone6_Plus) {
        x = SCREEN_WIDTH - width - 44;
    } else if (IS_iPhoneX) {
        x = SCREEN_WIDTH - width - 38;
        y = y - 34;
    }
    CGRect hollowOutFrame = CGRectMake(x, y, width, height);
    @weakify_self
    [[GuideClickWalletView getNibView] showGuideTo:hollowOutFrame tapBlock:^{
//        [weakSelf addNewGuideClickAdd];
        [weakSelf addNewGuideVpnList];
    }];
}

- (void)addNewGuideCountry {
    CGFloat y = IS_iPhoneX?96 + 24:96;
    CGRect hollowOutFrame = CGRectMake((SCREEN_WIDTH - 55)/2.0, y, 55, 24);
    @weakify_self
    [[GuideVpnCountryView getNibView] showGuideTo:hollowOutFrame tapBlock:^{
        [weakSelf addNewGuideVpnList];
    }];
}

- (void)addNewGuideVpnList {
    CGFloat y = IS_iPhoneX?139 + 24:139;
    CGRect hollowOutFrame = CGRectMake(17, y, SCREEN_WIDTH - 17*2, 68);
    [[GuideVpnListView getNibView] showGuideTo:hollowOutFrame tapBlock:^{
        
    }];
}

- (void)addNewGuideVpnListConnect {
    CGFloat y = IS_iPhoneX?139 + 24:139;
    CGRect hollowOutFrame = CGRectMake(17, y, SCREEN_WIDTH - 17*2, 68);
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

#pragma mark - SRRefreshDelegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView {
    [self requestQueryVpn];
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return VpnListCell_Height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VpnListCell *cell = [tableView dequeueReusableCellWithIdentifier:VpnListCellReuse];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.seizeBtn.tag = indexPath.row;
    cell.connectBtn.tag = CELL_CONNECT_BTN_TAG + indexPath.row;
    VPNInfo *vpnInfo = _sourceArr[indexPath.row];
    [cell configCellWithModel:vpnInfo];
    
    @weakify_self
    [cell setConnectClickB:^{
        weakSelf.selectVPNInfo = vpnInfo;
        
        if (vpnInfo.connectStatus == VpnConnectStatusNone) { // 选中cell未连接
            if (vpnInfo.online <= 0) { // offline 不能点击
                [AppD.window showHint:NSStringLocalizable(@"friend_unline_p2p")];
                return;
            }
            
            if (_isConnectVPN) { // 当前app已连接vpn
                [weakSelf showConnectOtherAlert:vpnInfo];
            } else { // 当前app未连接vpn
                [weakSelf showConnectAlert:vpnInfo];
            }
        } else if (vpnInfo.connectStatus == VpnConnectStatusConnecting) { // 选中cell正在连接中
            
        } else if (vpnInfo.connectStatus == VpnConnectStatusConnected) { // 选中cell已连接
            [weakSelf showDisconnectAlert];
        }
    }];
    
//    [cell setSeizeBlock:^(NSInteger row) {
//        if ([ToxManage getP2PConnectionStatus]) {
//            weakSelf.selectVPNInfo = weakSelf.sourceArr[row];
//            [WalletUtil checkWalletPassAndPrivateKey:self TransitionFrom:CheckProcess_VPN_SEIZE];
//        } else {
//            [weakSelf showUserConnectStatus];
//        }
//    }];
    
    // 跳转聊天页
    cell.conversationB = ^{
        weakSelf.selectVPNInfo = vpnInfo;
        [weakSelf clickConversation:vpnInfo];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    VPNInfo *vpnInfo = _sourceArr[indexPath.row];
//    if (vpnInfo.online <= 0) { // offline 不能点击
//        [AppD.window showHint:NSStringLocalizable(@"friend_unline_p2p")];
//        return;
//    }
//    _selectVPNInfo = vpnInfo;
//    [WalletUtil checkWalletPassAndPrivateKey:self TransitionFrom:CheckProcess_VPN_LIST];
}

#pragma mark - Action
- (IBAction)clickAdd:(id)sender {
    [WalletUtil checkWalletPassAndPrivateKey:self TransitionFrom:CheckProcess_VPN_ADD];
}

- (IBAction)clickHead:(id)sender {
    [self jumpToProfile];
}

- (IBAction)countryAction:(id)sender {
    [self selectCountry];
}

- (IBAction)debugLogAction:(id)sender {
#ifdef DEBUG
    [self jumpToDebugLog];
#endif
}

- (IBAction)freeConnectionAction:(id)sender {
    [self jumpToFreeConnection];
}

#pragma mark -选择国家
- (void) selectCountry {
    // 显示
    [self.countryView showChooseCountryView];
    // 选择国家回调
    @weakify_self
    [self.countryView setSelectCountryBlock:^(id selectCountry) {
          [weakSelf refreshCountry:selectCountry];
    }];
}

- (ChooseCountryView *)countryView
{
    if (!_countryView) {
        _countryView = [ChooseCountryView loadChooseCountryView];
        _countryView.tabContraintH.constant = 265;
        _countryView.bgContraintTop.constant = 67;
         _countryView.topContraintH.constant = 0;
        _countryView.isSave = YES;
        if (!IS_iPhoneX) {
             _countryView.bgContraintTop.constant = 67+20;
        }
        _countryView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _countryView;
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

- (void)jumpToFreeConnection {
    FreeConnectionViewController *vc = [[FreeConnectionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Lazy
- (NSMutableArray *)sourceArr {
    if (!_sourceArr) {
        _sourceArr = [NSMutableArray array];
    }
    
    return _sourceArr;
}

//- (SelectCountryModel *)selectCountryM {
//    if (!_selectCountryM) {
//        _selectCountryM = [[SelectCountryModel alloc] init];
//        _selectCountryM.continent = ASIA_CONTINENT;
//        _selectCountryM.country = [LocationMode getShareInstance].country;
//    }
//
//    return _selectCountryM;
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
        [_mainTable registerNib:[UINib nibWithNibName:VpnListCellReuse bundle:nil] forCellReuseIdentifier:VpnListCellReuse];
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
