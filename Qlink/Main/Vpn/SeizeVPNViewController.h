//
//  SeizeVPNViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/4/8.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "QBaseViewController.h"
#import "VPNMode.h"

@interface SeizeVPNViewController : QBaseViewController

@property (nonatomic , strong) VPNInfo *vpnInfo;

- (instancetype) initWithVPNInfo:(VPNInfo *) mode;

@end
