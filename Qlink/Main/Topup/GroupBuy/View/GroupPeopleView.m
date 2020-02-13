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
#import "GroupBuyListModel.h"

@implementation GroupPeopleView

+ (instancetype)getInstance {
    GroupPeopleView *view = [[[NSBundle mainBundle] loadNibNamed:@"GroupPeopleView" owner:self options:nil] lastObject];
    return view;
}

- (void)configGroupBuy:(NSArray *)urlArr {
    kWeakSelf(self);
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    NSInteger urlCount = urlArr.count;
    CGFloat imgW=34,imgH = 34;
    CGFloat imgOffsetX = urlCount>1?20.0/(urlCount-1):0;
    [urlArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GroupBuyListItemModel *model = obj;
        UIImageView *imgV = [UIImageView new];
        imgV.frame = CGRectMake(imgOffsetX*idx, 0, imgW, imgH);
        imgV.layer.cornerRadius = imgW/2.0;
        imgV.layer.masksToBounds = YES;
        imgV.layer.borderColor = [UIColor whiteColor].CGColor;
        imgV.layer.borderWidth = .5;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.head]];
        [imgV sd_setImageWithURL:url placeholderImage:User_DefaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
        [weakself addSubview:imgV];
        
        UIImageView *commanderImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"label_regimental"]];
        commanderImgV.right = imgV.right;
        commanderImgV.bottom = imgV.bottom;
        commanderImgV.size = CGSizeMake(12, 12);
        commanderImgV.hidden = !model.isCommander;
        [weakself addSubview:commanderImgV];
    }];
}

- (void)configAssemble:(NSArray *)urlArr {
    kWeakSelf(self);
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    NSInteger urlCount = urlArr.count;
    CGFloat imgW=34,imgH = 34;
    CGFloat imgOffsetX = urlCount>1?20.0/(urlCount-1):0;
    [urlArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GroupBuyListItemModel *model = obj;
        UIImageView *imgV = [UIImageView new];
        imgV.frame = CGRectMake(imgOffsetX*idx, 0, imgW, imgH);
        imgV.layer.cornerRadius = imgW/2.0;
        imgV.layer.masksToBounds = YES;
        imgV.layer.borderColor = [UIColor whiteColor].CGColor;
        imgV.layer.borderWidth = .5;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.head]];
        [imgV sd_setImageWithURL:url placeholderImage:User_DefaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
        [weakself addSubview:imgV];
    }];
}

@end
