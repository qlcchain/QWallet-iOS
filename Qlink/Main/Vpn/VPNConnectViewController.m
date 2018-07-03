//
//  VPNConnectViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VPNConnectViewController.h"
#import "Qlink-Swift.h"
#import "VPNConnectedViewController.h"
#import "VPNMode.h"
#import <NetworkExtension/NetworkExtension.h>
#import "ToxRequestModel.h"
#import "VPNFileUtil.h"
#import "WalletUtil.h"
#import "P2pMessageManage.h"
#import "TransferUtil.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "VPNOperationUtil.h"
#import "GuideVpnConnectView.h"

@interface VPNConnectViewController () {
    BOOL checkConnnectOK;
    BOOL connectVpnOK;
}

@property (weak, nonatomic) IBOutlet UILabel *userIDLab;
@property (weak, nonatomic) IBOutlet UILabel *countryLab;
@property (weak, nonatomic) IBOutlet UILabel *continentLab;
@property (weak, nonatomic) IBOutlet UILabel *ipAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *bandWidthLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *devicesConnectLab;
@property (weak, nonatomic) IBOutlet UILabel *spendTipLab;
@property (weak, nonatomic) IBOutlet UIButton *vpnUserBtn;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;

@property (nonatomic, strong) NSData *vpnData;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation VPNConnectViewController
- (void)viewDidAppear:(BOOL)animated
{
    [self addNewGuide];
    [super viewDidAppear:animated];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addNewGuide {
    if (IS_iPhone_5) {
        CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
        [self.scrollView setContentOffset:bottomOffset animated:NO];
    }
    CGRect hollowOutFrame = [_connectBtn.superview convertRect:_connectBtn.frame toView:[UIApplication sharedApplication].keyWindow];
    [[GuideVpnConnectView getNibView] showGuideTo:hollowOutFrame tapBlock:nil];
}

#pragma mark - Noti

- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vpnStatusChange:) name:VPN_STATUS_CHANGE_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveVPNFile:) name:RECEIVE_VPN_FILE_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savePreferenceFail:) name:SAVE_VPN_PREFERENCE_FAIL_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkConnectRsp:) name:CHECK_CONNECT_RSP_NOTI object:nil];
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self addObserve];
    
    if (_vpnInfo) {
        _userIDLab.text = _vpnInfo.vpnName;
        _countryLab.text = _vpnInfo.country;
        _continentLab.text = _vpnInfo.continent;
        _ipAddressLab.text = _vpnInfo.ipV4Address;
        _bandWidthLab.text = _vpnInfo.bandwidth;
        _priceLab.text = _vpnInfo.cost;
        _devicesConnectLab.text = _vpnInfo.connectNum;
        _spendTipLab.text = [NSString stringWithFormat:@"%@ %@ %@",NSStringLocalizable(@"want_spend"),_vpnInfo.cost,NSStringLocalizable(@"qlc_to_connnect")];
    }
    [self updateVpnUserBtn];

    if (![self vpnIsMine]) { // 连接别人的vpn
        [self addSendCheckConnect];
    } else { // 连接自己的vpn
        checkConnnectOK = YES;
    }
}

#pragma mark - ConfigView
- (void)updateVpnUserBtn {
    __weak typeof(_vpnUserBtn) weakVpnUserBtn = _vpnUserBtn;
    NSString *head = [NSString stringWithFormat:@"%@%@",[RequestService getPrefixUrl],_vpnInfo.imgUrl];
    [_vpnUserBtn sd_setImageWithURL:[NSURL URLWithString:head] forState:UIControlStateNormal placeholderImage:User_PlaceholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            weakVpnUserBtn.imageView.layer.cornerRadius = weakVpnUserBtn.imageView.frame.size.width/2;
            weakVpnUserBtn.imageView.layer.masksToBounds = YES;
            weakVpnUserBtn.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            weakVpnUserBtn.imageView.layer.borderWidth = Photo_White_Circle_Length;
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
            [AppD.window hideHud];
            [self jumpToVPNConnected];
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


#pragma mark - Operation
- (BOOL)vpnIsMine {
    NSString *myP2pId = [ToxManage getOwnP2PId];
    return [_vpnInfo.p2pId isEqualToString:myP2pId]?YES:NO;
}

- (void)receiveVPNFile:(NSNotification *)noti {
    _vpnData = noti.object;
    [self startConnectVPN];
}

- (void)startConnectVPN {
    // vpn连接操作
    [VPNOperationUtil shareInstance].operationType = normalConnect;
    [VPNUtil.shareInstance configVPNWithVpnData:_vpnData];
}

- (void)savePreferenceFail:(NSNotification *)noti {
    [AppD.window hideHud];
    [AppD.window showHint:NSStringLocalizable(@"save_failed")];
}

- (void)addSendCheckConnect {
    NSTimeInterval timeout = 15;
    [AppD.window showHudInView:self.view hint:NSStringLocalizable(@"checking")];
    checkConnnectOK = NO;
    // 发送获取配置文件消息
    ToxRequestModel *model = [[ToxRequestModel alloc] init];
    model.type = checkConnectReq;
    NSString *p2pid = [ToxManage getOwnP2PId];
    NSDictionary *dataDic = @{@"appVersion":APP_Build,@"p2pId":p2pid};
    model.data = dataDic.mj_JSONString;
    NSString *str = model.mj_JSONString;
    [ToxManage sendMessageWithMessage:str withP2pid:_vpnInfo.p2pId];
    [self performSelector:@selector(checkConnectTimeout) withObject:nil afterDelay:timeout];
}

- (void)checkConnectTimeout {
    if (!checkConnnectOK) {
        [AppD.window hideHud];
        [AppD.window showHint:NSStringLocalizable(@"connect_timeout")];
    }
}

- (void)checkConnectRsp:(NSNotification *)noti {
    checkConnnectOK = YES;
    [AppD.window hideHud];
}

- (void)connectVpnTimeout {
    if (!connectVpnOK) {
        [VPNUtil.shareInstance stopVPN];
        [AppD.window hideHud];
        [self.view showHint:NSStringLocalizable(@"vpn_timeout")];
    }
}

#pragma mark - Action
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelAction:(id)sender {
    [self back];
}

- (IBAction)connectAction:(id)sender {
    if (_vpnInfo.profileLocalPath.length <= 0) {
        [AppD.window showHint:NSStringLocalizable(@"profile_empty")];
        DDLogDebug(@"没有profileLocalPath,无法连接vpn");
        return;
    }
    
    if (![TransferUtil isConnectionAssetsAllowedWithCost:_vpnInfo.cost]) {
        [self.view showView:self.view hint:NSStringLocalizable(@"insufficient_assets")];
        return;
    }
    
    if (!checkConnnectOK) {
        return;
    }
    
    connectVpnOK = NO;

    NSTimeInterval timeout = CONNECT_VPN_TIMEOUT;
    [AppD.window showHudInView:AppD.window hint:NSStringLocalizable(@"connecting")];

    [self performSelector:@selector(connectVpnTimeout) withObject:nil afterDelay:timeout];
    
    if ([self vpnIsMine]) { // 连自己
        NSString *fileName = [[_vpnInfo.profileLocalPath componentsSeparatedByString:@"/"] lastObject];
        NSString *vpnPath = [VPNFileUtil getVPNPathWithFileName:fileName];
        _vpnData = [NSData dataWithContentsOfFile:vpnPath];
        [self startConnectVPN];
        return;
    }
    
    // 给c层传文件名
    ToxManage.shareMange.vpnSourceName = _vpnInfo.profileLocalPath;
    // 开始连接vpn
    if (_vpnData) { // 如果配置文件data已存在
        [self startConnectVPN];
    } else {
        // 发送获取配置文件消息
        ToxRequestModel *model = [[ToxRequestModel alloc] init];
        model.type = sendVpnFileRequest;
        NSString *p2pid = [ToxManage getOwnP2PId];
        NSDictionary *dataDic = @{@"appVersion":APP_Build,@"vpnName":_vpnInfo.vpnName,@"filePath":_vpnInfo.profileLocalPath,@"p2pId":p2pid};
        model.data = dataDic.mj_JSONString;
        NSString *str = model.mj_JSONString;
        
        [ToxManage sendMessageWithMessage:str withP2pid:_vpnInfo.p2pId];
    }
}

#pragma mark - Transition
- (void)jumpToVPNConnected {
    VPNConnectedViewController *vc = [[VPNConnectedViewController alloc] init];
    vc.vpnInfo = _vpnInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
