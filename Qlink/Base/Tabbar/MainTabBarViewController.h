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
    MainTabbarIndexTopup = 0,
    MainTabbarIndexFinance = 1,
//    MainTabbarIndexMarkets,
    MainTabbarIndexDefi = 2,
    MainTabbarIndexWallet = 3,
    MainTabbarIndexMy = 4,
} MainTabbarIndex;

@class WalletsViewController,Topup3ViewController,Topup4ViewController, HomeBuySellViewController,DeFiHomeViewController;

@interface MainTabBarViewController : CYLTabBarController

@property (nonatomic, strong) WalletsViewController *walletsVC;
@property (nonatomic, strong) Topup4ViewController *topupVC;
@property (nonatomic, strong) HomeBuySellViewController *homeBuySellVC;
//@property (nonatomic, strong) DeFiHomeViewController *defiVC;

- (instancetype)initWithContext:(NSString *)context;

@end

NS_ASSUME_NONNULL_END
