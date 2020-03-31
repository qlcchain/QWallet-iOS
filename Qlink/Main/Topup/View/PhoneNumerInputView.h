//
//  MnemonicTipView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PhoneNumerInputBlock)(NSString *phoneNum);

@interface PhoneNumerInputView : UIView

@property (nonatomic, copy) PhoneNumerInputBlock confirmBlock;

+ (instancetype)getInstance;
- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
