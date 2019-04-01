//
//  MnemonicTipView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PaymentDetailsNextBlock)(void);

@interface PaymentDetailsView : UIView

@property (nonatomic, copy) PaymentDetailsNextBlock nextBlock;

+ (instancetype)getInstance;
- (void)configWithPayInfo:(NSString *)payInfo amount:(NSString *)amount key1:(NSString *)key1 val1:(NSString *)val1 key2:(NSString *)key2 val2:(NSString *)val2;
- (void)show;

@end

NS_ASSUME_NONNULL_END
