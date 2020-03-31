//
//  NavWhiteShadowView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "NavWhiteShadowView.h"
#import "GlobalConstants.h"

@implementation NavWhiteShadowView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UIColor *navShadowColor = [UIColorFromRGB(0x34547A) colorWithAlphaComponent:0.1];
        [self shadowWithColor:navShadowColor offset:CGSizeMake(0, 1) opacity:1 radius:10];
    }
    return self;
}

@end
