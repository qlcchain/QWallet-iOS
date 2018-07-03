//
//  NewWalletViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/3/29.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "QBaseViewController.h"

typedef enum : NSUInteger {
    PassJump,
    WalletJump
} JumpStyle;

@interface NewWalletViewController : QBaseViewController

@property (nonatomic , assign) JumpStyle jumpStyle;

- (instancetype) initWithJump:(JumpStyle) style;

@end
