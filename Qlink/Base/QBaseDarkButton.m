//
//  QBaseDarkButton.m
//  Qlink
//
//  Created by Jelly Foo on 2020/4/9.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QBaseDarkButton.h"
#import "GlobalConstants.h"

@implementation QBaseDarkButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateHighlighted];
//        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateSelected];
//        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateDisabled];
//        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateFocused];
//        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateApplication];
//        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateReserved];
//        UIControlStateSelected
//        UIControlStateDisabled
//        UIControlStateFocused
//        UIControlStateApplication
//        UIControlStateReserved
//        [self setImage:kClickEffectBtnImage forState:UIControlStateHighlighted];
//        self.adjustsImageWhenHighlighted = YES;
//        self.showsTouchWhenHighlighted = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateHighlighted];
//        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateSelected];
//        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateDisabled];
//        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateFocused];
//        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateApplication];
//        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateReserved];
//        [self setImage:kClickEffectBtnImage forState:UIControlStateHighlighted];
//        self.adjustsImageWhenHighlighted = YES;
//        self.showsTouchWhenHighlighted = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateHighlighted];
//        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateSelected];
//        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateDisabled];
//        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateFocused];
//        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateApplication];
//        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateReserved];
//        [self setImage:kClickEffectBtnImage forState:UIControlStateHighlighted];
//        self.adjustsImageWhenHighlighted = YES;
//        self.showsTouchWhenHighlighted = YES;
    }
    return self;
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self setBackgroundColor:kEffectBtnColor];
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self setBackgroundColor:nil];
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self setBackgroundColor:nil];
//}

@end
