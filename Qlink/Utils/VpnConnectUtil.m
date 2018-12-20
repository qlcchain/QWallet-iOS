//
//  VpnConnectUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2018/7/10.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VpnConnectUtil.h"
#import "VPNOperationUtil.h"
#import "Qlink-Swift.h"
#import "NeoTransferUtil.h"
#import "ToxRequestModel.h"
#import "P2pMessageManage.h"
#import "VPNFileUtil.h"
#import "VPNMode.h"
#import "NEOWalletUtil.h"
#import <MMWormhole/MMWormhole.h>
#import "DBManageUtil.h"
#import "ToxRequestModel1.h"
#import "VPNDataUtil.h"

#define P2P_Message_Timeout 15

typedef enum : NSUInteger {
    ConnectStepNone,
    ConnectStepCheckConnect,
    ConnectStepGetProfile,
    ConnectStepGetPrivateKey,
    ConnectStepGetUserPass,
    ConnectStepGetUserPassAndPrivateKey,
    ConnectStepGetConnecting,
} ConnectStep;

@interface VpnConnectUtil () {
    BOOL checkConnnectOK;
    BOOL connectVpnOK;
    BOOL connectVpnCancel;
    BOOL getUserPassOK;
    BOOL getPrivateKeyOK;
    BOOL getUserPassAndPrivateKeyOK;
    BOOL getProfileOK;
}

@property (nonatomic, strong) NSData *vpnData;
@property (nonatomic, strong) MMWormhole *wormhole;
@property (nonatomic) ConnectStep connectStep;
@property (nonatomic, strong) NSNumber *serverVersion;

@end

@implementation VpnConnectUtil

+ (instancetype)shareInstance {
    static id shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
        [shareObject addObserve];
        [shareObject dataInit];
    });
    return shareObject;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vpnStatusChange:) name:VPN_STATUS_CHANGE_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveVPNFile:) name:RECEIVE_VPN_FILE_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savePreferenceFail:) name:SAVE_VPN_PREFERENCE_FAIL_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkConnectRsp:) name:CheckConnectRsp_Connect_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePrivateKey:) name:Receive_PrivateKey_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveUserPass:) name:Receive_UserPass_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveUserPassAndPrivateKey:) name:Receive_UserPass_PrivateKey_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configVPNError:) name:CONFIG_VPN_ERROR_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendVpnFileNewRspSuccessNoti:) name:SendVpnFileNewRspOfConnect_Success_Noti object:nil];
}

#pragma mark - Config
- (void)dataInit {
    [self wormholeInit];
    _connectStep = ConnectStepNone;
}

- (void)wormholeInit {
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:GROUP_WORMHOLE
                                                         optionalDirectory:DIRECTORY_WORMHOLE];
    kWeakSelf(self);
    [self.wormhole listenForMessageWithIdentifier:VPN_EVENT_IDENTIFIER
                                         listener:^(id messageObject) {
                                             NSNumber *eventNum = messageObject;
                                             switch ([eventNum integerValue]) {
                                                 case OpenVPNAdapterEventDisconnected:
                                                 {
                                                     NSLog(@"vpnevent---------------disconnected");
                                                 }
                                                     break;
                                                 case OpenVPNAdapterEventConnected:
                                                 {
                                                     NSLog(@"vpnevent---------------connected");
                                                 }
                                                     break;
                                                 case OpenVPNAdapterEventReconnecting:
                                                 {
                                                     NSLog(@"vpnevent---------------reconnecting");
                                                 }
                                                     break;
                                                 case OpenVPNAdapterEventResolve:
                                                 {
                                                     NSLog(@"vpnevent---------------resolve");
                                                 }
                                                     break;
                                                 case OpenVPNAdapterEventWait:
                                                 {
                                                     NSLog(@"vpnevent---------------wait");
                                                 }
                                                     break;
                                                 case OpenVPNAdapterEventWaitProxy:
                                                 {
                                                     NSLog(@"vpnevent---------------waitProxy");
                                                 }
                                                     break;
                                                 case OpenVPNAdapterEventConnecting:
                                                 {
                                                     NSLog(@"vpnevent---------------connecting");
                                                 }
                                                     break;
                                                 case OpenVPNAdapterEventGetConfig:
                                                 {
                                                     NSLog(@"vpnevent---------------getConfig");
                                                 }
                                                     break;
                                                 case OpenVPNAdapterEventAssignIP:
                                                 {
                                                     NSLog(@"vpnevent---------------assignIP");
                                                 }
                                                     break;
                                                 case OpenVPNAdapterEventAddRoutes:
                                                 {
                                                     NSLog(@"vpnevent---------------addRoutes");
                                                 }
                                                     break;
                                                 case OpenVPNAdapterEventEcho:
                                                 {
                                                     NSLog(@"vpnevent---------------echo");
                                                 }
                                                     break;
                                                 case OpenVPNAdapterEventInfo:
                                                 {
                                                     NSLog(@"vpnevent---------------info");
                                                 }
                                                     break;
                                                 case OpenVPNAdapterEventPause:
                                                 {
                                                     NSLog(@"vpnevent---------------pause");
                                                 }
                                                     break;
                                                 case OpenVPNAdapterEventResume:
                                                 {
                                                     NSLog(@"vpnevent---------------resume");
                                                 }
                                                     break;
                                                 case OpenVPNAdapterEventRelay:
                                                 {
                                                     NSLog(@"vpnevent---------------relay");
                                                 }
                                                     break;
                                                 case OpenVPNAdapterEventUnknown:
                                                 {
                                                     NSLog(@"vpnevent---------------unknown");
                                                 }
                                                     break;
                                                 default:
                                                     break;
                                             }
                                         }];
    [self.wormhole listenForMessageWithIdentifier:VPN_MESSAGE_IDENTIFIER
                                         listener:^(id messageObject) {
                                             NSLog(@"vpnmessage---------------%@",messageObject);
                                         }];
    [self.wormhole listenForMessageWithIdentifier:VPN_ERROR_REASON_IDENTIFIER
                                         listener:^(id messageObject) {
                                             DDLogDebug(@"vpn_error_reason---------------%@",messageObject);
                                             if (weakself.connectStep != ConnectStepGetConnecting) {
                                                 return;
                                             }
                                             VPNConnectOperationType operationType = [VPNOperationUtil shareInstance].operationType;
                                             if (operationType == normalConnect) { // 正常连接vpn
                                                 [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectVpnTimeout) object:nil];
                                                 [kAppD.window hideToast];
                                                 NSString *message = messageObject;
                                                 if ([message isEqualToString:@"Unknown error."]) {
                                                     message = @"Connect fail.";
                                                 }
                                                 [KEYWINDOW makeToastDisappearWithText:message];
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:Connect_Vpn_Timeout_Noti object:nil];
                                                 [weakself requestReportVpnInfo:messageObject status:0]; // 上报vpn连接问题
                                             }
                                         }];
}

#pragma mark - Noti
- (void)vpnStatusChange:(NSNotification *)noti {
    NEVPNStatus status = (NEVPNStatus)[noti.object integerValue];
    switch (status) {
        case NEVPNStatusInvalid:
            break;
        case NEVPNStatusDisconnected:
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectVpnTimeout) object:nil];
//            [kAppD.window hideHud];
            _connectStep = ConnectStepNone;
            [VPNUtil.shareInstance removeFromPreferences]; // 移除配置文件
        }
            break;
        case NEVPNStatusConnecting:
            break;
        case NEVPNStatusConnected:
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectVpnTimeout) object:nil];
            _connectStep = ConnectStepNone;
            connectVpnOK = YES;
            connectVpnCancel = NO;
            [kAppD.window hideToast];
            [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"connect_success")];
            [self performSelector:@selector(reportConnectSuccess) withObject:nil afterDelay:.8];
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

- (void)receiveVPNFile:(NSNotification *)noti {
    if (_connectStep != ConnectStepGetProfile) {
        return;
    }
    if (getProfileOK) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getProfileTimeout) object:nil];
    getProfileOK = YES;
    [kAppD.window hideToast];
    _vpnData = noti.object;
    [self startConnectVPNOfOther];
}

- (void)sendVpnFileNewRspSuccessNoti:(NSNotification *)noti {
    if (_connectStep != ConnectStepGetProfile) {
        return;
    }
    if (getProfileOK) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getProfileTimeout) object:nil];
    getProfileOK = YES;
    [kAppD.window hideToast];
    _vpnData = [(NSString *)noti.object dataUsingEncoding:NSUTF8StringEncoding];
//    _vpnData = noti.object;
    [self startConnectVPNOfOther];
}

- (void)savePreferenceFail:(NSNotification *)noti {
    _connectStep = ConnectStepNone;
    [kAppD.window hideToast];
    [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"save_failed")];
    connectVpnCancel = YES;
}

- (void)checkConnectRsp:(NSNotification *)noti {
    if (_connectStep != ConnectStepCheckConnect) {
        return;
    }
    if (checkConnnectOK) {
        return;
    }
    _serverVersion = noti.object;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkConnectTimeout) object:nil];
    checkConnnectOK = YES;
    [kAppD.window hideToast];
    
    [self connectAction];
}

- (void)receivePrivateKey:(NSNotification *)noti {
    if (_connectStep != ConnectStepGetPrivateKey) {
        return;
    }
    if (getPrivateKeyOK) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getPrivateKeyTimeout) object:nil];
    getPrivateKeyOK = YES;
    [kAppD.window hideToast];
    [self goConnect];
}

- (void)receiveUserPass:(NSNotification *)noti {
    if (_connectStep != ConnectStepGetUserPass) {
        return;
    }
    if (getUserPassOK) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getUserPassTimeout) object:nil];
    getUserPassOK = YES;
    [kAppD.window hideToast];
    [self goConnect];
}

- (void)receiveUserPassAndPrivateKey:(NSNotification *)noti {
    if (_connectStep != ConnectStepGetUserPassAndPrivateKey) {
        return;
    }
    if (getUserPassAndPrivateKeyOK) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getUserPassAndPrivateKeyTimeout) object:nil];
    getUserPassAndPrivateKeyOK = YES;
    [kAppD.window hideToast];
    [self goConnect];
}

- (void)configVPNError:(NSNotification *)noti {
    _connectStep = ConnectStepNone;
    NSString *errorDes = noti.object;
    DDLogDebug(@"Config VPN Error:%@",errorDes);
    [kAppD.window hideToast];
    [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"configuration_faield")];
    [[NSNotificationCenter defaultCenter] postNotificationName:VPN_CONNECT_CANCEL_LOADING object:nil];
}

#pragma mark - Operation
- (void)reportConnectSuccess {
    [self requestReportVpnInfo:@"connect success" status:1]; // 上报vpn连接成功
}

- (void)startConnectVPNOfMine {
    // vpn连接操作
    [VPNOperationUtil shareInstance].operationType = normalConnect;
    VPNUtil.shareInstance.connectData = _vpnData;
    kWeakSelf(self);
    [VPNUtil.shareInstance applyConfigurationWithVpnData:_vpnData completionHandler:^(NSInteger type) {
        NSString *isMainNet = [NSString stringWithFormat:@"%@",@([ConfigUtil isMainNetOfServerNetwork])];
        VPNInfo *tempInfo = [DBManageUtil getVpnInfo:weakself.vpnInfo.vpnName isMainNet:isMainNet];
        if (!tempInfo) {
            return;
        }
        if (type == 0) { // 自动
            
        } else if (type == 1) { // 私钥
            VPNUtil.shareInstance.vpnPrivateKey = tempInfo.privateKeyPassword;
        } else if (type == 2) { // 用户名密码
            VPNUtil.shareInstance.vpnUserName = tempInfo.username;
            VPNUtil.shareInstance.vpnPassword = tempInfo.password;
        } else if (type == 3) { // 私钥和用户名密码
            VPNUtil.shareInstance.vpnPrivateKey = tempInfo.privateKeyPassword;
            VPNUtil.shareInstance.vpnUserName = tempInfo.username;
            VPNUtil.shareInstance.vpnPassword = tempInfo.password;
        }
        [weakself goConnect];
    }];
}

- (void)startConnectVPNOfOther {
    // vpn连接操作
    [VPNOperationUtil shareInstance].operationType = normalConnect;
    VPNUtil.shareInstance.connectData = _vpnData;
    kWeakSelf(self);
    [VPNUtil.shareInstance applyConfigurationWithVpnData:_vpnData completionHandler:^(NSInteger type) {
        if (type == 0) { // 自动
            [weakself goConnect];
        } else if (type == 1) { // 私钥
            getUserPassOK = YES;
            [weakself getVpnPriveteKey];
        } else if (type == 2) { // 用户名密码
            getPrivateKeyOK = YES;
            [weakself getVpnUserAndPassword];
        } else if (type == 3) { // 私钥和用户名密码
            getUserPassAndPrivateKeyOK = YES;
            [weakself getVpnUserPassAndPrivateKey];
        }
    }];
}

- (void)goConnect {
    [kAppD.window makeToastInView:kAppD.window text:NSStringLocalizable(@"connecting")];
    
    _connectStep = ConnectStepGetConnecting;
    connectVpnOK = NO;
    connectVpnCancel = NO;
    
    NSTimeInterval timeout = CONNECT_VPN_TIMEOUT;
    [self performSelector:@selector(connectVpnTimeout) withObject:nil afterDelay:timeout];
    
    [VPNUtil.shareInstance configVPN];
}

- (void)checkConnect {
    if (![self vpnIsMine]) { // 连接别人的vpn
        [self addSendCheckConnect];
    } else { // 连接自己的vpn
        checkConnnectOK = YES;
        [self connectAction];
    }
}

- (BOOL)vpnIsMine {
    NSString *myP2pId = [ToxManage getOwnP2PId];
    return [_vpnInfo.p2pId isEqualToString:myP2pId]?YES:NO;
}

- (void)getVpnPriveteKey {
    [kAppD.window makeToastInView:KEYWINDOW text:NSStringLocalizable(@"Get_PrivateKey")];
    DDLogDebug(@"==============================Getting Private Key Password");
    _connectStep = ConnectStepGetPrivateKey;
    getPrivateKeyOK = NO;
    ToxRequestModel *model = [[ToxRequestModel alloc] init];
    model.type = vpnPrivateKeyReq;
    NSString *isMainNet = [NSString stringWithFormat:@"%@",@([ConfigUtil isMainNetOfServerNetwork])];
    NSDictionary *dataDic = @{VPN_NAME:_vpnInfo.vpnName?:@"",IS_MAINNET:isMainNet};
    model.data = dataDic.mj_JSONString;
    NSString *str = model.mj_JSONString;
    [ToxManage sendMessageWithMessage:str withP2pid:_vpnInfo.p2pId];
    [self performSelector:@selector(getPrivateKeyTimeout) withObject:nil afterDelay:P2P_Message_Timeout];
}

- (void)getPrivateKeyTimeout {
    if (!getPrivateKeyOK) {
        _connectStep = ConnectStepNone;
        [kAppD.window hideToast];
        [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"Fail_Get_PrivateKey")];
        [[NSNotificationCenter defaultCenter] postNotificationName:Get_Vpn_Key_Timeout_Noti object:nil];
    }
}

- (void)getVpnUserAndPassword {
    [kAppD.window makeToastInView:KEYWINDOW text:NSStringLocalizable(@"Get_UserPass")];
    DDLogDebug(@"==============================Getting Username and Password");
    _connectStep = ConnectStepGetUserPass;
    getUserPassOK = NO;
    ToxRequestModel *model = [[ToxRequestModel alloc] init];
    model.type = vpnUserAndPasswordReq;
    NSString *isMainNet = [NSString stringWithFormat:@"%@",@([ConfigUtil isMainNetOfServerNetwork])];
    NSDictionary *dataDic = @{VPN_NAME:_vpnInfo.vpnName?:@"", IS_MAINNET:isMainNet};
    model.data = dataDic.mj_JSONString;
    NSString *str = model.mj_JSONString;
    NSString *p2pId = _vpnInfo.p2pId;
    [ToxManage sendMessageWithMessage:str withP2pid:p2pId];
    [self performSelector:@selector(getUserPassTimeout) withObject:nil afterDelay:P2P_Message_Timeout];
}

- (void)getUserPassTimeout {
    if (!getUserPassOK) {
        _connectStep = ConnectStepNone;
        [kAppD.window hideToast];
        [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"Fail_Get_UserPass")];
        [[NSNotificationCenter defaultCenter] postNotificationName:Get_Vpn_Pass_Timeout_Noti object:nil];
    }
}

- (void)getVpnUserPassAndPrivateKey {
    [kAppD.window makeToastInView:KEYWINDOW text:NSStringLocalizable(@"Get_UserPass_PrivateKey")];
    DDLogDebug(@"==============================Getting Username and Password and Private Key Password");
    _connectStep = ConnectStepGetUserPassAndPrivateKey;
    getUserPassAndPrivateKeyOK = NO;
    ToxRequestModel *model = [[ToxRequestModel alloc] init];
    model.type = vpnUserPassAndPrivateKeyReq;
    NSString *isMainNet = [NSString stringWithFormat:@"%@",@([ConfigUtil isMainNetOfServerNetwork])];
    NSDictionary *dataDic = @{VPN_NAME:_vpnInfo.vpnName?:@"", IS_MAINNET:isMainNet};
    model.data = dataDic.mj_JSONString;
    NSString *str = model.mj_JSONString;
    NSString *p2pId = _vpnInfo.p2pId;
    [ToxManage sendMessageWithMessage:str withP2pid:p2pId];
    [self performSelector:@selector(getUserPassAndPrivateKeyTimeout) withObject:nil afterDelay:P2P_Message_Timeout];
}

- (void)getUserPassAndPrivateKeyTimeout {
    if (!getUserPassAndPrivateKeyOK) {
        _connectStep = ConnectStepNone;
        [kAppD.window hideToast];
        [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"Fail_Get_UserPass_PrivateKey")];
        [[NSNotificationCenter defaultCenter] postNotificationName:Get_Vpn_Pass_Timeout_Noti object:nil];
    }
}

- (void)addSendCheckConnect {
    [kAppD.window makeToastInView:KEYWINDOW text:NSStringLocalizable(@"checking")];
    _connectStep = ConnectStepCheckConnect;
    checkConnnectOK = NO;
    _serverVersion = nil;
    // 发送获取配置文件消息
    ToxRequestModel *model = [[ToxRequestModel alloc] init];
    model.type = checkConnectReq;
    NSString *p2pid = [ToxManage getOwnP2PId];
    NSDictionary *dataDic = @{APPVERSION:APP_Build,P2P_ID:p2pid,@"type":@(1)}; // type:0-注册  1-连接 2-vpn上报服务器
    model.data = dataDic.mj_JSONString;
    NSString *str = model.mj_JSONString;
    [ToxManage sendMessageWithMessage:str withP2pid:_vpnInfo.p2pId];
    [self performSelector:@selector(checkConnectTimeout) withObject:nil afterDelay:P2P_Message_Timeout];
}

- (void)checkConnectTimeout {
    if (!checkConnnectOK) {
        _connectStep = ConnectStepNone;
        [kAppD.window hideToast];
        [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"connect_timeout")];
        [[NSNotificationCenter defaultCenter] postNotificationName:Check_Connect_Timeout_Noti object:nil];
    }
}

- (void)connectVpnTimeout {
    if (_connectStep != ConnectStepGetConnecting) {
        return;
    }
    if (connectVpnOK) { // 连接成功
        return;
    }
    if (connectVpnCancel) { // 用户取消
        return;
    }
    [VPNUtil.shareInstance stopVPN];
    [kAppD.window hideToast];
    [KEYWINDOW makeToastDisappearWithText:NSStringLocalizable(@"vpn_timeout")];
    [[NSNotificationCenter defaultCenter] postNotificationName:Connect_Vpn_Timeout_Noti object:nil];
    [self requestReportVpnInfo:@"connect timeout" status:0]; // 上报vpn连接问题
}

#pragma mark - 发送获取配置文件消息
- (void)sendGetProfile {
    [kAppD.window makeToastInView:KEYWINDOW text:NSStringLocalizable(@"get_profile")];
    _connectStep = ConnectStepGetProfile;
    getProfileOK = NO;
    
    if (!_serverVersion || [_serverVersion integerValue] < 1) { // 旧server
        ToxRequestModel *model = [[ToxRequestModel alloc] init];
        model.type = sendVpnFileRequest;
        NSString *p2pid = [ToxManage getOwnP2PId];
        NSString *isMainNet = [NSString stringWithFormat:@"%@",@([ConfigUtil isMainNetOfServerNetwork])];
        NSDictionary *dataDic = @{APPVERSION:APP_Build,VPN_NAME:_vpnInfo.vpnName,@"filePath":_vpnInfo.profileLocalPath,P2P_ID:p2pid, IS_MAINNET:isMainNet};
        model.data = dataDic.mj_JSONString;
        NSString *str = model.mj_JSONString;
        str = [str stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"]; // 替换转义字符
        [ToxManage sendMessageWithMessage:str withP2pid:_vpnInfo.p2pId];
    } else { // 新server
        ToxRequestModel1 *model = [[ToxRequestModel1 alloc] init];
        model.type = sendVpnFileNewReq;
        NSDictionary *tempDic = @{@"vpnName":_vpnInfo.vpnName, APPVERSION:APP_Build, @"register":@(0)};
        model.data = tempDic;
        NSString *str = model.mj_JSONString;
        [VPNDataUtil shareInstance].sendVpnFileNewRspMsgid = nil;
        [[VPNDataUtil shareInstance].sendVpnFileNewRspArr removeAllObjects];
        [VPNDataUtil shareInstance].sendVpnFileNewRspMsg = nil;
        [ToxManage sendMessageWithMessage:str withP2pid:_vpnInfo.p2pId];
    }

    [self performSelector:@selector(getProfileTimeout) withObject:nil afterDelay:P2P_Message_Timeout];
}

- (void)getProfileTimeout {
    if (!getProfileOK) {
        _connectStep = ConnectStepNone;
        [kAppD.window hideToast];
        [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"get_profile_timeout")];
        [[NSNotificationCenter defaultCenter] postNotificationName:Get_Profile_Timeout_Noti object:nil];
    }
}

#pragma mark - Request
- (void)requestReportVpnInfo:(NSString *)mark status:(NSInteger)status {
    if ([VPNOperationUtil shareInstance].operationType == registerConnect) { // 注册暂不上报
        return;
    }
//    kWeakSelf(self);
    NSDictionary *params = @{@"vpnName":_vpnInfo.vpnName?:@"", @"status":@(status), @"mark":mark};
    [RequestService requestWithUrl:reportVpnInfo_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
    }];
}

#pragma mark - Action
- (void)connectAction {
    if (_vpnInfo.profileLocalPath.length <= 0) {
        [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"profile_empty")];
        DDLogDebug(@"没有profileLocalPath,无法连接vpn");
        [[NSNotificationCenter defaultCenter] postNotificationName:VPN_CONNECT_CANCEL_LOADING object:nil];
        return;
    }
    
    // 判断免费连接次数
    NSString *freeKey = [ConfigUtil isMainNetOfServerNetwork] ? VPN_FREE_MAIN_COUNT : VPN_FREE_COUNT;
    NSString *countStr = [HWUserdefault getObjectWithKey:freeKey];
    if ((![self vpnIsMine] && [[NSStringUtil getNotNullValue:countStr] isEqualToString:@"0"])) {
        
        if (![NeoTransferUtil isConnectionAssetsAllowedWithCost:_vpnInfo.cost]) {
            [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"insufficient_assets")];
            [[NSNotificationCenter defaultCenter] postNotificationName:VPN_CONNECT_CANCEL_LOADING object:nil];
            return;
        }
    }
    
    
    if (!checkConnnectOK) {
        [[NSNotificationCenter defaultCenter] postNotificationName:VPN_CONNECT_CANCEL_LOADING object:nil];
        return;
    }
    
    if ([self vpnIsMine]) { // 连自己
        NSString *fileName = [[_vpnInfo.profileLocalPath componentsSeparatedByString:@"/"] lastObject];
        NSString *vpnPath = [VPNFileUtil getVPNPathWithFileName:fileName];
        _vpnData = [NSData dataWithContentsOfFile:vpnPath];
        [self startConnectVPNOfMine];
        return;
    }
    
    // 给c层传文件名
    ToxManage.shareMange.vpnSourceName = _vpnInfo.profileLocalPath;
    // 开始连接vpn
//    if (_vpnData) { // 如果配置文件data已存在
//        [self startConnectVPNOfOther];
//    } else {
        getProfileOK = YES;
        [self sendGetProfile];
//    }
}



@end
