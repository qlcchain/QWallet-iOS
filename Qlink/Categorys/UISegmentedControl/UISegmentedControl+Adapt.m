//
//  UISegmentedControl+Adapt.m
//  Qlink
//
//  Created by Jelly Foo on 2019/11/28.
//  Copyright © 2019 pan. All rights reserved.
//

#import "UISegmentedControl+Adapt.h"
#import "DeviceConstants.h"

@implementation UISegmentedControl (Adapt)

- (void)segmentedIOS13Style {
    if (@available(iOS 13, *)) {
        UIColor *tintColor = [self tintColor];
        UIImage *tintColorImage = [self imageWithColor:tintColor];
        // Must set the background image for normal to something (even clear) else the rest won't work
        [self setBackgroundImage:[self imageWithColor:self.backgroundColor ? self.backgroundColor : [UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:tintColorImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        //[self imageWithColor:[tintColor colorWithAlphaComponent:0.2]]
        [self setBackgroundImage:[self imageWithColor:tintColor] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:tintColorImage forState:UIControlStateSelected|UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName: tintColor, NSFontAttributeName: [UIFont systemFontOfSize:13]} forState:UIControlStateNormal];

        [self setTitleTextAttributes:@{NSForegroundColorAttributeName: self.backgroundColor ? UIColorFromRGB(0x4869EA) : [UIColor clearColor], NSFontAttributeName: [UIFont systemFontOfSize:13]} forState:UIControlStateSelected];

        [self setDividerImage:tintColorImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [tintColor CGColor];
        self.selectedSegmentTintColor = tintColor;
    }
}

- (UIImage *)imageWithColor: (UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
