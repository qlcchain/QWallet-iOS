//
//  ShadowImageView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/13.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "ShadowImageView.h"

@implementation ShadowImageView

//- (void)setShadowColor:(UIColor *)shadowColor {
//    _shadowColor = shadowColor;
//    self.layer.shadowColor = _shadowColor.CGColor;
//}
//
//- (void)setShadowOffset:(CGSize)shadowOffset {
//    _shadowOffset = shadowOffset;
//    self.layer.shadowOffset = _shadowOffset;
//}
//
//- (void)setShadowOpacity:(CGFloat)shadowOpacity {
//    _shadowOpacity = shadowOpacity;
//    self.layer.shadowOpacity = _shadowOpacity;
//}
//
//- (void)setShadowRadius:(NSUInteger)shadowRadius {
//    _shadowRadius = shadowRadius;
//    self.layer.shadowRadius = _shadowRadius;
//}

- (void)setShowShadow:(BOOL)showShadow {
    _showShadow = showShadow;
    if (_showShadow) {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.05;
        self.layer.shadowRadius = 6;
    }
}

@end
