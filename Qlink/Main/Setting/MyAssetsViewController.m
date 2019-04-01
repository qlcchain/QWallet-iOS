//
//  MyAssetsViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2018/5/30.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "MyAssetsViewController.h"
#import "MyAssetsView.h"
#import "NEOWalletUtil.h"
#import "VpnRegisterServerViewController.h"
#import "NeoQueryWGasModel.h"
#import "WalletCommonModel.h"
#import "VpnOldAssetUpdateViewController.h"
#import "Qlink-Swift.h"

@interface MyAssetsViewController ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic , strong) MyAssetsView *assetsView;

@end

@implementation MyAssetsViewController

- (IBAction)clickBack:(id)sender {
    [self leftNavBarItemPressedWithPop:YES];
}

- (IBAction)addAsset:(id)sender {
    
    BOOL haveDefaultNEOWallet = [NEOWalletManage.sharedInstance haveDefaultWallet];
    if (!haveDefaultNEOWallet) {
        [kAppD.window makeToastDisappearWithText:@"Please choose a NEO wallet first"];
        return;
    }
//    [NEOWalletUtil checkWalletPassAndPrivateKey:self TransitionFrom:CheckProcess_VPN_ADD];
//    [self performSelector:@selector(jumpToVPNRegister) withObject:self afterDelay:0.6];
    [self jumpToVPNRegister];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkProcessSuccessOfVPNAdd:) name:CHECK_PROCESS_SUCCESS_VPN_ADD object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self addObserve];
    
    [_backView addSubview:self.assetsView];
}

#pragma mark - Operation
- (MyAssetsView *)assetsView
{
    if (!_assetsView) {
        _assetsView = [MyAssetsView getNibView];
        _assetsView.frame = _backView.bounds;
        kWeakSelf(self);
        _assetsView.setBlock = ^(VPNInfo *vpnInfo) {
            [weakself jumpRegisterVPNWithMode:vpnInfo];
        };
//        _assetsView.cancelContraintH.constant = 0;
//        _assetsView.cancelContraintTop.constant = 0;
//        _assetsView.cancelContraintBottom = 0;
    }
    return _assetsView;
}

#pragma mark - Transition

- (void)jumpToVPNRegister {
    VpnRegisterServerViewController *vc = [[VpnRegisterServerViewController alloc] initWithRegisterType:RegisterServerVPN];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) jumpRegisterVPNWithMode:(VPNInfo *)vpnInfo {
    if (vpnInfo.isServerVPN) {
        VpnRegisterServerViewController *vc = [[VpnRegisterServerViewController alloc] initWithRegisterType:UpdateServerVPN];
        vc.vpnInfo = vpnInfo;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        VpnOldAssetUpdateViewController *vc = [[VpnOldAssetUpdateViewController alloc] initWithRegisterType:UpdateVPN];
        vc.vpnInfo = vpnInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Noti
- (void)checkProcessSuccessOfVPNAdd:(NSNotification *)noti {
    CGFloat delay = 0.0f;
    if ([NEOWalletUtil shareInstance].isDelay) {
        delay = 0.6f;
    }
    [self performSelector:@selector(jumpToVPNRegister) withObject:self afterDelay:delay];
    //[self jumpToVPNRegister];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
