//
//  VPNAddViewController.h
//  Qlink
//
//  Created by 旷自辉 on 2018/3/30.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "QBaseViewController.h"
#import "VPNMode.h"

typedef NS_ENUM(NSUInteger, RegisterType) {
    RegisterVPN,
    SeizeVPNWhenRegister,
    SeizeVPN,
    UpdateVPN
};

@interface VPNRegisterViewController : QBaseViewController
@property (nonatomic , assign) RegisterType registerType;

@property (nonatomic ,strong) NSString *vpnName;
@property (nonatomic ,strong) NSString *vpnAddress;
@property (nonatomic ,strong) NSString *vpnP2pid;
@property (nonatomic ,strong) NSString *seizePrice;
@property (nonatomic ,strong) NSString *oldPrice;
@property (nonatomic ,strong) VPNInfo *vpnInfo;

- (instancetype) initWithRegisterType:(RegisterType) type;
- (instancetype) initWithRegisterType:(RegisterType) type withVPNName:(NSString *) name withSeizePrice:(NSString *) seize_price withOldPrice:(NSString *) old_price vpnAddress:(NSString *) address vpnP2pid:(NSString *) toP2pid;

- (void)jumpToChooseContinent;
- (void)validateAssetIsexist;
- (void)scrollToStepThree;
- (void)requestRegisterVpnByFeeV3;

@end
