//
//  QBaseTouchButton.m
//  Qlink
//
//  Created by Jelly Foo on 2020/4/9.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QBaseTouchButton.h"
#import "GlobalConstants.h"

@implementation QBaseTouchButton

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateHighlighted];
//        self.adjustsImageWhenHighlighted = YES;
        self.showsTouchWhenHighlighted = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
//        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateHighlighted];
//        self.adjustsImageWhenHighlighted = YES;
        self.showsTouchWhenHighlighted = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setBackgroundImage:kClickEffectBtnImage forState:UIControlStateHighlighted];
//        self.adjustsImageWhenHighlighted = YES;
        self.showsTouchWhenHighlighted = YES;
    }
    return self;
}

@end
