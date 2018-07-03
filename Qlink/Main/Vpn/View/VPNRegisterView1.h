//
//  VPNRegisterView1.h
//  Qlink
//
//  Created by Jelly Foo on 2018/4/8.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNMode.h"

@class VPNRegisterViewController,SelectCountryModel;

@interface VPNRegisterView1 : UIView

@property (nonatomic, weak) VPNRegisterViewController *registerVC;
@property (nonatomic, strong) SelectCountryModel *selectCountryM;
@property (nonatomic, strong) NSString *vpnName;
@property (nonatomic, readonly) NSString *deposit;
@property (nonatomic, readonly) NSString *claim;
@property (nonatomic, strong) NSString *selectCountry;

+ (VPNRegisterView1 *)getNibView;
- (BOOL)isEmptyOfCountry;
- (BOOL)isEmptyOfDeposit;
- (BOOL)isEmptyOfClaim;
- (BOOL)isEmptyOfVPNName;
- (void)enableClaim;
- (void)unableClaim;
- (void) configView;
- (void) setVPNName:(NSString *) name deposit:(NSString *) seizePrice oldPrice:(NSString *) oldPrice;
- (void)setClaimText:(NSString *)text;
- (void) setVPNInfo:(VPNInfo *) mode;

@end
