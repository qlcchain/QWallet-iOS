//
//  ETHWalletAddressViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PayReceiveAddressTypeQGAS,
    PayReceiveAddressTypeUSDT,
} PayReceiveAddressType;

@interface PayReceiveAddressViewController : QBaseViewController

@property (nonatomic, strong) NSString *inputAddress;
@property (nonatomic, strong) NSString *inputAmount;
@property (nonatomic) PayReceiveAddressType inputAddressType;
//@property (nonatomic) BOOL showSubmitTip;
@property (nonatomic) BOOL backToRoot;

@end

NS_ASSUME_NONNULL_END
