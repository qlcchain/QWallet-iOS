//
//  WalletPublicAddressViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/3/28.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "QBaseViewController.h"

typedef enum : NSUInteger {
    AddressStyle,
    WifStyle,
    PrivateKeyStyle
} EnterCodeType;

@interface WalletPublicAddressViewController : QBaseViewController

- (instancetype) initWithCodeType:(EnterCodeType) codeType;

@end
