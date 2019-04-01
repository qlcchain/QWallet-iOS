//
//  UIView+DottedBox.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/8.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (DottedBox)

- (void)addDottedBox:(UIColor *)strokeColor fillColor:(UIColor *)fillColor cornerRadius:(CGFloat)cornerRadius lineWidth:(CGFloat)lineWidth;

@end

NS_ASSUME_NONNULL_END
