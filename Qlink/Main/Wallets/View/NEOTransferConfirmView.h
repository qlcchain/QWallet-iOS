//
//  MnemonicTipView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^NEOTransferConfirmBlock)(void);

@interface NEOTransferConfirmView : UIView

@property (nonatomic, copy) NEOTransferConfirmBlock confirmBlock;

+ (instancetype)getInstance;
- (void)configWithAddress:(NSString *)sendto amount:(NSString *)amount;
- (void)show;

@end

NS_ASSUME_NONNULL_END
