//
//  ConfirmTranserView.h
//  Qlink
//
//  Created by 旷自辉 on 2020/10/28.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ConfirmTransactionBlock)(BOOL isConfirm,NSString *gasPrice);

@interface ConfirmTranserView : UIView

@property (nonatomic, copy) ConfirmTransactionBlock confirmBlock;

+ (instancetype)getInstance;

- (void)configWithFromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress gasLimit:(NSString *)gasLimit;

- (void) show;
- (void) hide;
@end

NS_ASSUME_NONNULL_END
