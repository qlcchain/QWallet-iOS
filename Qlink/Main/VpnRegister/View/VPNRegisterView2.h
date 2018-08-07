//
//  VPNRegisterView2.h
//  Qlink
//
//  Created by Jelly Foo on 2018/4/8.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNMode.h"

@class VPNRegisterViewController;

@interface VPNRegisterView2 : UIView

@property (nonatomic, weak) VPNRegisterViewController *registerVC;
@property (nonatomic, strong) NSString *profileName;

+ (VPNRegisterView2 *)getNibView;
- (BOOL)isEmptyOfProfile;
- (void) setVPNInfo:(VPNInfo *) mode;
- (void)verifyProfile;

@end
