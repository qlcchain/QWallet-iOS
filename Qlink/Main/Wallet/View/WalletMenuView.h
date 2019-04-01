//
//  ManageFundsView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/3/29.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RegisteredAssets,
    SendFunds,
    ViewHistory,
    BuyQlc,
} WalletType;

typedef void(^WalletMenuBlock)(WalletType type);

@interface WalletMenuView : UIView

+ (WalletMenuView *)getNibView;
- (void)configWalletMenu:(WalletMenuBlock)block;

@end
