//
//  VPNRegisterView2.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/8.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VPNRegisterView2.h"
#import "VPNRegisterViewController.h"
#import "VPNFileUtil.h"
#import "Qlink-Swift.h"
#import <NetworkExtension/NetworkExtension.h>
#import "VPNOperationUtil.h"

@interface VPNRegisterView2 () {
    BOOL connectVpnDone;
}

@property (weak, nonatomic) IBOutlet UITextField *profileTF;
@property (weak, nonatomic) IBOutlet UITextField *privateKeyTF;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (nonatomic) BOOL isVerifyVPN; // 是否验证VPN操作中
@property (nonatomic, strong) NSString *selectName;

@end

@implementation VPNRegisterView2

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Noti

- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vpnStatusChange:) name:VPN_STATUS_CHANGE_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savePreferenceFail:) name:SAVE_VPN_PREFERENCE_FAIL_NOTI object:nil];
}

+ (VPNRegisterView2 *)getNibView {
    VPNRegisterView2 *nibView = [[[NSBundle mainBundle] loadNibNamed:@"VPNRegisterView2" owner:self options:nil] firstObject];
    [nibView addObserve];
    
    return nibView;
}

#pragma mark - Operation
- (void)verifyProfile {
    if (!self.selectName) {
        return;
    }
    
    // 验证VPN是否能连接
    _isVerifyVPN = YES;
    
    NSString *vpnPath = [VPNFileUtil getVPNPathWithFileName:self.selectName];
    NSData *vpnData = [NSData dataWithContentsOfFile:vpnPath];
    if (!vpnData) {
        [AppD.window showHint:[NSString stringWithFormat:@"%@ %@",self.selectName,NSStringLocalizable(@"not_found")]];
        return;
    }

    [AppD.window showHudInView:_registerVC.view hint:NSStringLocalizable(@"check")];
    
    connectVpnDone = NO;
    NSTimeInterval timeout = CONNECT_VPN_TIMEOUT;
    [self performSelector:@selector(connectVpnTimeout) withObject:nil afterDelay:timeout];
    // vpn连接操作
    [VPNOperationUtil shareInstance].operationType = registerConnect;
    [VPNUtil.shareInstance configVPNWithVpnData:vpnData];
}

- (void)connectVpnTimeout {
    if (!connectVpnDone) {
        [AppD.window hideHud];
        [VPNUtil.shareInstance stopVPN];
    }
}

#pragma mark - Noti

- (void)vpnStatusChange:(NSNotification *)noti {
    //    [MBProgressHUD hideHUDForView:self.view];
    NEVPNStatus status = (NEVPNStatus)[noti.object integerValue];
    switch (status) {
        case NEVPNStatusInvalid:
            break;
        case NEVPNStatusDisconnected:
            break;
        case NEVPNStatusConnecting:
            break;
        case NEVPNStatusConnected:
        {
            [AppD.window hideHud];
            if (_isVerifyVPN) { // 如果是验证操作的话，断开连接
                _isVerifyVPN = NO;
                connectVpnDone = YES;
                [_registerVC performSelector:@selector(requestRegisterVpnByFeeV3) withObject:nil afterDelay:0.6];
//                [VPNUtil.shareInstance stopVPN];
//                [_registerVC scrollToStepThree];
//                _profileTF.text = _selectName;
            }
        }
            break;
        case NEVPNStatusReasserting:
            break;
        case NEVPNStatusDisconnecting:
        {
            [AppD.window hideHud];
            if (_isVerifyVPN) { // 如果是验证操作的话
                _isVerifyVPN = NO;
                connectVpnDone = YES;
                [_registerVC.view showHint:NSStringLocalizable(@"check_profile")];
            }
        }
            break;
        default:
            break;
    }
}

- (void)savePreferenceFail:(NSNotification *)noti {
    [AppD.window hideHud];
}

- (BOOL)isEmptyOfProfile {
    BOOL empty = NO;
    if (self.profileTF.text == nil || self.profileTF.text.length <= 0) {
        empty = YES;
    }
    return empty;
}

#pragma mark - Action
- (IBAction)importProfileAction:(id)sender {
    @weakify_self
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *ovpnArr = [VPNFileUtil getAllVPNName]?:@[];
    [ovpnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *alert = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 验证ovpn是否有效
            weakSelf.selectName = obj;
            weakSelf.profileTF.text = _selectName;
//            [weakSelf verifyProfile];
        }];
        [alertC addAction:alert];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:NSStringLocalizable(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    
    [_registerVC presentViewController:alertC animated:YES completion:nil];
}

- (IBAction)praviteKeyEyeAction:(id)sender {
    
}

- (IBAction)passwordEyeAction:(id)sender {
    
}

- (void) setVPNInfo:(VPNInfo *) mode
{
    _profileTF.text = mode.profileLocalPath?:@"";
    _privateKeyTF.text = mode.privateKeyPassword?:@"";
    _userNameTF.text = mode.username?:@"";
    _passwordTF.text = mode.password?:@"";
}

#pragma mark - Lazy
- (NSString *)profileName {
    _profileName = _profileTF.text?:@"";
    return _profileName;
}

@end
