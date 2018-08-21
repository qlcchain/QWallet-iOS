//
//  VPNRegisterView2.h
//  Qlink
//
//  Created by Jelly Foo on 2018/4/8.
//  Copyright © 2018年 pan. All rights reserved.
//

#pragma mark - DEPRECATED(已废弃)***************

#import <UIKit/UIKit.h>
#import "VPNMode.h"

@class VpnOldAssetUpdateViewController;

@interface VPNRegisterView2 : UIView

@property (nonatomic, weak) VpnOldAssetUpdateViewController *registerVC;
@property (nonatomic, strong) NSString *profileName;

+ (VPNRegisterView2 *)getNibView;
- (BOOL)isEmptyOfProfile;
- (void) setVPNInfo:(VPNInfo *) mode;
- (void)verifyProfile;

@end
