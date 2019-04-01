//
//  MnemonicTipView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ETHTransferConfirmBlock)(void);

@interface ETHTransferConfirmView : UIView

@property (nonatomic, copy) ETHTransferConfirmBlock confirmBlock;

+ (instancetype)getInstance;
- (void)configWithAddress:(NSString *)sendto amount:(NSString *)amount gasfee:(NSString *)gasfee;
- (void)configWithName:(NSString *)nameFrom sendFrom:(NSString *)sendFrom sendTo:(NSString *)sendTo amount:(NSString *)amount gasfee:(NSString *)gasfee;
- (void)show;

@end

NS_ASSUME_NONNULL_END
