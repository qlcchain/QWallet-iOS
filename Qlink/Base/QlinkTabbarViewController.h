//
//  QlinkTabbarViewController.h
//  Qlink
//
//  Created by 旷自辉 on 2018/3/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TabbarIndexTopup,
    TabbarIndexFinance,
//    TabbarIndexMarkets,
    TabbarIndexWallet,
    TabbarIndexMy,
} TabbarIndex;

@class WalletsViewController;

@interface QlinkTabbarViewController : UITabBarController

@property (nonatomic, strong) WalletsViewController *walletsVC;

@end
