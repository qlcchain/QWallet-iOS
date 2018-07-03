//
//  QShadowView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/19.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "QShadowView.h"

@implementation QShadowView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.layer.cornerRadius = self.width/2.0;
//        self.layer.masksToBounds = YES;
//        self.layer.borderColor = [UIColor whiteColor].CGColor;
//        self.layer.borderWidth = Photo_White_Circle_Length;
        self.layer.shadowColor = SHADOW_COLOR.CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0.2);
        self.layer.shadowOpacity = 0.25;
//        self.layer.shadowRadius = self.width/2.0;
    }
    return self;
}

@end
