#import "UIButton+ANDYHighlighted.h"

@interface UIColor (ANDYHighlightedImage)

- (UIImage *)andy_image;

@end

@implementation UIColor (ANDYHighlightedImage)

- (UIImage *)andy_image {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end


@interface UIButton (ANDYHighlightedPrivate)

@end

@implementation UIButton (ANDYHighlighted)

- (void)setHighlightedBackgroundColor:(UIColor *)color {
    [self setBackgroundImage:[color andy_image] forState:UIControlStateHighlighted];
}

- (void)setTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (void)setHighlightedTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

@end
