//
//  VPNRegisterView3.h
//  Qlink
//
//  Created by Jelly Foo on 2018/4/8.
//  Copyright © 2018年 pan. All rights reserved.
//

#pragma mark - DEPRECATED(已废弃)***************

#import <UIKit/UIKit.h>
#import "VPNMode.h"

@class VpnOldAssetUpdateViewController;

@interface VPNRegisterView3 : UIView

@property (nonatomic, weak) VpnOldAssetUpdateViewController *registerVC;
@property (nonatomic, strong) NSString *hourlyFee;
@property (nonatomic, strong) NSString *connectNum;

+ (VPNRegisterView3 *)getNibView;
- (void) setVPNInfo:(VPNInfo *) mode;
@end
