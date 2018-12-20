//
//  UserHeadBtn.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/18.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "UserHeadBtn.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation UserHeadBtn

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userHeadChange) name:USER_HEAD_CHANGE_NOTI object:nil];
        [self userHeadChange];
    }
    return self;
}

- (void)userHeadChange {
    NSString *headUrlStr = [UserManage getWholeHeadUrl];
    NSURL *headUrl = [NSURL URLWithString:headUrlStr];
   // [self sd_setImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:User_PlaceholderImage];
    
    kWeakSelf(self);
    [self sd_setImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:User_PlaceholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            weakself.imageView.layer.cornerRadius = weakself.imageView.frame.size.width/2;
            weakself.imageView.layer.masksToBounds = YES;
            weakself.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            weakself.imageView.layer.borderWidth = Photo_White_Circle_Length;
        }
    }];
}

@end
