//
//  MainTabBarViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2020/4/2.
//  Copyright © 2020 pan. All rights reserved.
//

#import <CYLTabBarController/CYLTabBarController.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MainTabbarIndexTopup,
    MainTabbarIndexFinance,
//    MainTabbarIndexMarkets,
    MainTabbarIndexWallet,
    MainTabbarIndexMy,
} MainTabbarIndex;

@class WalletsViewController,Topup3ViewController,Topup4ViewController, HomeBuySellViewController;

@interface MainTabBarViewController : CYLTabBarController

@property (nonatomic, strong) WalletsViewController *walletsVC;
@property (nonatomic, strong) Topup4ViewController *topupVC;
@property (nonatomic, strong) HomeBuySellViewController *homeBuySellVC;

- (instancetype)initWithContext:(NSString *)context;

@end

NS_ASSUME_NONNULL_END
