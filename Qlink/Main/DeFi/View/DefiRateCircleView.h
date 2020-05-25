//
//  MnemonicTipView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DefiProjectModel;

static CGFloat rate_radius = 243/2.0;

@interface DefiRateCircleView : UIView

+ (instancetype)getInstance;
- (void)config:(DefiProjectModel *)model;
- (void)refreshRating:(NSString *)rating;
- (void)drawArc:(NSString *)weight;

@end

NS_ASSUME_NONNULL_END
