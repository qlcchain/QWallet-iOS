//
//  GroupPeopleView.m
//  Qlink
//
//  Created by Jelly Foo on 2020/1/13.
//  Copyright © 2020 pan. All rights reserved.
//

#import "GroupPeopleView.h"
#import <UIImageView+WebCache.h>
#import "GlobalConstants.h"

@implementation GroupPeopleView

+ (instancetype)getInstance {
    GroupPeopleView *view = [[[NSBundle mainBundle] loadNibNamed:@"GroupPeopleView" owner:self options:nil] lastObject];
    return view;
}

- (void)config:(NSArray *)urlArr {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    NSInteger urlCount = urlArr.count;
    CGFloat imgW=34,imgH = 34;
    CGFloat imgOffsetX = urlCount>1?20.0/(urlCount-1):0;
    [urlArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imgV = [UIImageView new];
        imgV.frame = CGRectMake(imgOffsetX*idx, 0, imgW, imgH);
        NSString *urlStr = obj;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],urlStr]];
        [imgV sd_setImageWithURL:url placeholderImage:User_DefaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
        [self addSubview:imgV];
    }];
}

@end
