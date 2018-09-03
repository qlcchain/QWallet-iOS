//
//  VpnRegisterServerViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/8/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "QBaseViewController.h"
#import "VPNMode.h"

typedef NS_ENUM(NSUInteger, RegisterServerType) {
    RegisterServerVPN,
    UpdateServerVPN
};

@interface VpnRegisterServerViewController : QBaseViewController

@property (nonatomic , assign) RegisterServerType registerType;
@property (nonatomic ,strong) NSString *vpnName;
@property (nonatomic ,strong) NSString *vpnAddress;
@property (nonatomic ,strong) NSString *vpnP2pid;
@property (nonatomic ,strong) NSString *seizePrice;
@property (nonatomic ,strong) NSString *oldPrice;
@property (nonatomic ,strong) VPNInfo *vpnInfo;

- (instancetype) initWithRegisterType:(RegisterServerType) type;
- (instancetype) initWithRegisterType:(RegisterServerType) type withVPNName:(NSString *) name withSeizePrice:(NSString *) seize_price withOldPrice:(NSString *) old_price vpnAddress:(NSString *) address vpnP2pid:(NSString *) toP2pid;

- (void)jumpToChooseContinent;
- (void)validateAssetIsexist;
- (void)requestRegisterVpnByFeeV3;

@end
