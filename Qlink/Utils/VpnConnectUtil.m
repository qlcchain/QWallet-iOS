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
#import "TransferUtil.h"
#import "ToxRequestModel.h"
#import "P2pMessageManage.h"
#import "VPNFileUtil.h"
#import "VPNMode.h"
#import "WalletUtil.h"
#import <MMWormhole/MMWormhole.h>
#import "DBManageUtil.h"

@interface VpnConnectUtil () {
    BOOL checkConnnectOK;
    BOOL connectVpnOK;
    BOOL connectVpnCancel;
    BOOL getUserPassOK;
    BOOL getPrivateKeyOK;
    BOOL getUserPassAndPrivateKeyOK;
    BOOL getProfileOK;
}

//@property (nonatomic, strong) VPNInfo *vpnInfo;
@property (nonatomic, strong) NSData *vpnData;
@property (nonatomic, strong) MMWormhole *wormhole;

@end

@implementation VpnConnectUtil

+ (instancetype)shareInstance {
    static id shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
        [shareObject addObserve];
        [shareObject wormholeInit];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkConnectRsp:) name:CHECK_CONNECT_RSP_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePrivateKey:) name:Receive_PrivateKey_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveUserPass:) name:Receive_UserPass_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveUserPassAndPrivateKey:) name:Receive_UserPass_PrivateKey_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configVPNError:) name:CONFIG_VPN_ERROR_NOTI object:nil];
}

#pragma mark - Config
- (void)wormholeInit {
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:GROUP_WORMHOLE
                                                         optionalDirectory:DIRECTORY_WORMHOLE];
    @weakify_self
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
                                             VPNConnectOperationType operationType = [VPNOperationUtil shareInstance].operationType;
                                             if (operationType == normalConnect) { // 正常连接vpn
                                                 [AppD.window hideHud];
                                                 [KEYWINDOW showHint:messageObject];
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:Connect_Vpn_Timeout_Noti object:nil];
                                                 [weakSelf requestReportVpnInfo:messageObject status:0]; // 上报vpn连接问题
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
            [AppD.window hideHud];
        }
            break;
        case NEVPNStatusConnecting:
            break;
        case NEVPNStatusConnected:
        {
            connectVpnOK = YES;
            connectVpnCancel = NO;
            [AppD.window hideHud];
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
    getProfileOK = YES;
    [AppD.window hideHud];
    _vpnData = noti.object;
    [self startConnectVPNOfOther];
}

- (void)savePreferenceFail:(NSNotification *)noti {
    [AppD.window hideHud];
    [AppD.window showHint:NSStringLocalizable(@"save_failed")];
    connectVpnCancel = YES;
}

- (void)checkConnectRsp:(NSNotification *)noti {
    checkConnnectOK = YES;
    [AppD.window hideHud];
    
    [self connectAction];
}

- (void)receivePrivateKey:(NSNotification *)noti {
    getPrivateKeyOK = YES;
    [AppD.window hideHud];
    [self goConnect];
}

- (void)receiveUserPass:(NSNotification *)noti {
    getUserPassOK = YES;
    [AppD.window hideHud];
    [self goConnect];
}

- (void)receiveUserPassAndPrivateKey:(NSNotification *)noti {
    getUserPassAndPrivateKeyOK = YES;
    [AppD.window hideHud];
    [self goConnect];
}

- (void)configVPNError:(NSNotification *)noti {
    NSString *errorDes = noti.object;
    DDLogDebug(@"Config VPN Error:%@",errorDes);
    [AppD.window hideHud];
    [AppD.window showHint:NSStringLocalizable(@"configuration_faield")];
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
    @weakify_self
    [VPNUtil.shareInstance applyConfigurationWithVpnData:_vpnData completionHandler:^(NSInteger type) {
        NSString *isMainNet = [NSString stringWithFormat:@"%@",@([WalletUtil checkServerIsMian])];
        VPNInfo *tempInfo = [DBManageUtil getVpnInfo:weakSelf.vpnInfo.vpnName isMainNet:isMainNet];
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
        [weakSelf goConnect];
    }];
}

- (void)startConnectVPNOfOther {
    // vpn连接操作
    [VPNOperationUtil shareInstance].operationType = normalConnect;
    VPNUtil.shareInstance.connectData = _vpnData;
    @weakify_self
    [VPNUtil.shareInstance applyConfigurationWithVpnData:_vpnData completionHandler:^(NSInteger type) {
        if (type == 0) { // 自动
            [weakSelf goConnect];
        } else if (type == 1) { // 私钥
            getUserPassOK = YES;
            [weakSelf getVpnPriveteKey];
        } else if (type == 2) { // 用户名密码
            getPrivateKeyOK = YES;
            [weakSelf getVpnUserAndPassword];
        } else if (type == 3) { // 私钥和用户名密码
            getUserPassAndPrivateKeyOK = YES;
            [weakSelf getVpnUserPassAndPrivateKey];
        }
    }];
}

- (void)goConnect {
    [AppD.window showHudInView:AppD.window hint:NSStringLocalizable(@"connecting")];
    
    connectVpnOK = NO;
    connectVpnCancel = NO;
    
//    NSTimeInterval timeout = CONNECT_VPN_TIMEOUT;
//    [self performSelector:@selector(connectVpnTimeout) withObject:nil afterDelay:timeout];
    
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
    NSTimeInterval timeout = 15;
    [AppD.window showHudInView:KEYWINDOW hint:@""];
    getPrivateKeyOK = NO;
    ToxRequestModel *model = [[ToxRequestModel alloc] init];
    model.type = vpnPrivateKeyReq;
    NSString *isMainNet = [NSString stringWithFormat:@"%@",@([WalletUtil checkServerIsMian])];
    NSDictionary *dataDic = @{VPN_NAME:_vpnInfo.vpnName?:@"",IS_MAINNET:isMainNet};
    model.data = dataDic.mj_JSONString;
    NSString *str = model.mj_JSONString;
    [ToxManage sendMessageWithMessage:str withP2pid:_vpnInfo.p2pId];
    [self performSelector:@selector(getPrivateKeyTimeout) withObject:nil afterDelay:timeout];
}

- (void)getPrivateKeyTimeout {
    if (!getPrivateKeyOK) {
        [AppD.window hideHud];
        [AppD.window showHint:NSStringLocalizable(@"Fail_Get_PrivateKey")];
        [[NSNotificationCenter defaultCenter] postNotificationName:Get_Vpn_Key_Timeout_Noti object:nil];
    }
}

- (void)getVpnUserAndPassword {
    NSTimeInterval timeout = 15;
    [AppD.window showHudInView:KEYWINDOW hint:@""];
    getUserPassOK = NO;
    ToxRequestModel *model = [[ToxRequestModel alloc] init];
    model.type = vpnUserAndPasswordReq;
    NSString *isMainNet = [NSString stringWithFormat:@"%@",@([WalletUtil checkServerIsMian])];
    NSDictionary *dataDic = @{VPN_NAME:_vpnInfo.vpnName?:@"", IS_MAINNET:isMainNet};
    model.data = dataDic.mj_JSONString;
    NSString *str = model.mj_JSONString;
    NSString *p2pId = _vpnInfo.p2pId;
    [ToxManage sendMessageWithMessage:str withP2pid:p2pId];
    [self performSelector:@selector(getUserPassTimeout) withObject:nil afterDelay:timeout];
}

- (void)getUserPassTimeout {
    if (!getUserPassOK) {
        [AppD.window hideHud];
        [AppD.window showHint:NSStringLocalizable(@"Fail_Get_UserPass")];
        [[NSNotificationCenter defaultCenter] postNotificationName:Get_Vpn_Pass_Timeout_Noti object:nil];
    }
}

- (void)getVpnUserPassAndPrivateKey {
    NSTimeInterval timeout = 15;
    [AppD.window showHudInView:KEYWINDOW hint:@""];
    getUserPassAndPrivateKeyOK = NO;
    ToxRequestModel *model = [[ToxRequestModel alloc] init];
    model.type = vpnUserPassAndPrivateKeyReq;
    NSString *isMainNet = [NSString stringWithFormat:@"%@",@([WalletUtil checkServerIsMian])];
    NSDictionary *dataDic = @{VPN_NAME:_vpnInfo.vpnName?:@"", IS_MAINNET:isMainNet};
    model.data = dataDic.mj_JSONString;
    NSString *str = model.mj_JSONString;
    NSString *p2pId = _vpnInfo.p2pId;
    [ToxManage sendMessageWithMessage:str withP2pid:p2pId];
    [self performSelector:@selector(getUserPassAndPrivateKeyTimeout) withObject:nil afterDelay:timeout];
}

- (void)getUserPassAndPrivateKeyTimeout {
    if (!getUserPassAndPrivateKeyOK) {
        [AppD.window hideHud];
        [AppD.window showHint:NSStringLocalizable(@"Fail_Get_UserPass_PrivateKey")];
        [[NSNotificationCenter defaultCenter] postNotificationName:Get_Vpn_Pass_Timeout_Noti object:nil];
    }
}

- (void)addSendCheckConnect {
    NSTimeInterval timeout = 15;
    [AppD.window showHudInView:KEYWINDOW hint:NSStringLocalizable(@"checking")];
    checkConnnectOK = NO;
    // 发送获取配置文件消息
    ToxRequestModel *model = [[ToxRequestModel alloc] init];
    model.type = checkConnectReq;
    NSString *p2pid = [ToxManage getOwnP2PId];
    NSDictionary *dataDic = @{APPVERSION:APP_Build,P2P_ID:p2pid};
    model.data = dataDic.mj_JSONString;
    NSString *str = model.mj_JSONString;
    [ToxManage sendMessageWithMessage:str withP2pid:_vpnInfo.p2pId];
    [self performSelector:@selector(checkConnectTimeout) withObject:nil afterDelay:timeout];
}

- (void)checkConnectTimeout {
    if (!checkConnnectOK) {
        [AppD.window hideHud];
        [AppD.window showHint:NSStringLocalizable(@"connect_timeout")];
        [[NSNotificationCenter defaultCenter] postNotificationName:Check_Connect_Timeout_Noti object:nil];
    }
}

- (void)connectVpnTimeout {
    if (connectVpnOK) { // 连接成功
        return;
    }
    if (connectVpnCancel) { // 用户取消
        return;
    }
    [VPNUtil.shareInstance stopVPN];
    [AppD.window hideHud];
    [KEYWINDOW showHint:NSStringLocalizable(@"vpn_timeout")];
    [[NSNotificationCenter defaultCenter] postNotificationName:Connect_Vpn_Timeout_Noti object:nil];
    [self requestReportVpnInfo:@"connect timeout" status:0]; // 上报vpn连接问题
}

#pragma mark - Request
- (void)requestReportVpnInfo:(NSString *)mark status:(NSInteger)status {
//    @weakify_self
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
        [AppD.window showHint:NSStringLocalizable(@"profile_empty")];
        DDLogDebug(@"没有profileLocalPath,无法连接vpn");
        [[NSNotificationCenter defaultCenter] postNotificationName:VPN_CONNECT_CANCEL_LOADING object:nil];
        return;
    }
    
    if (![TransferUtil isConnectionAssetsAllowedWithCost:_vpnInfo.cost]) {
        [AppD.window showView:KEYWINDOW hint:NSStringLocalizable(@"insufficient_assets")];
        [[NSNotificationCenter defaultCenter] postNotificationName:VPN_CONNECT_CANCEL_LOADING object:nil];
        return;
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
    if (_vpnData) { // 如果配置文件data已存在
        [self startConnectVPNOfOther];
    } else {
        getProfileOK = YES;
        [self sendGetProfile];
    }
}

#pragma mark - 发送获取配置文件消息
- (void)sendGetProfile {
    NSTimeInterval timeout = 15;
    [AppD.window showHudInView:KEYWINDOW hint:@""];
    getProfileOK = NO;
    ToxRequestModel *model = [[ToxRequestModel alloc] init];
    model.type = sendVpnFileRequest;
    NSString *p2pid = [ToxManage getOwnP2PId];
    NSString *isMainNet = [NSString stringWithFormat:@"%@",@([WalletUtil checkServerIsMian])];
    NSDictionary *dataDic = @{APPVERSION:APP_Build,VPN_NAME:_vpnInfo.vpnName,@"filePath":_vpnInfo.profileLocalPath,P2P_ID:p2pid, IS_MAINNET:isMainNet};
    model.data = dataDic.mj_JSONString;
    NSString *str = model.mj_JSONString;
    [ToxManage sendMessageWithMessage:str withP2pid:_vpnInfo.p2pId];
    [self performSelector:@selector(getProfileTimeout) withObject:nil afterDelay:timeout];
}

- (void)getProfileTimeout {
    if (!getProfileOK) {
        [AppD.window hideHud];
        [AppD.window showHint:NSStringLocalizable(@"get_profile_timeout")];
        [[NSNotificationCenter defaultCenter] postNotificationName:Get_Profile_Timeout_Noti object:nil];
    }
}

@end
