//
//  PushJumpHelper.m
//  Qlink
//
//  Created by Jelly Foo on 2019/11/26.
//  Copyright © 2019 pan. All rights reserved.
//

#import "AppJumpHelper.h"
#import "TradeOrderDetailViewController.h"
#import "GlobalConstants.h"
#import "QlinkTabbarViewController.h"
#import "QNavigationController.h"
#import "UserModel.h"
#import "ClaimQGASTipView.h"
#import "DailyEarningsViewController.h"
#import "RecordListViewController.h"

@implementation AppJumpHelper

+ (void)jumpToWallet {
    if (kAppD.needFingerprintVerification) {
        [kAppD presentFingerprintVerify:^{
            kAppD.tabbarC.selectedIndex = TabbarIndexWallet;
        }];
    } else {
        kAppD.tabbarC.selectedIndex = TabbarIndexWallet;
    }
}

+ (void)jumpToOTC {
    kAppD.tabbarC.selectedIndex = TabbarIndexFinance;
}

+ (void)jumpToTopup {
    kAppD.tabbarC.selectedIndex = TabbarIndexTopup;
}

+ (void)jumpToDailyEarnings {
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
    
    if (![UserModel isBind]) {
        [ClaimQGASTipView show:^{
        }];
        return;
    }
    
    DailyEarningsViewController *vc = [DailyEarningsViewController new];
    [((QNavigationController *)kAppD.tabbarC.selectedViewController) pushViewController:vc animated:YES];
}

+ (void)jumpToMyOrderList:(OTCRecordListType)listType {
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
    
    RecordListViewController *vc = [RecordListViewController new];
    vc.inputType = listType;
    [((QNavigationController *)kAppD.tabbarC.selectedViewController) pushViewController:vc animated:YES];
}

@end
