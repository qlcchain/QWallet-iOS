//
//  GuangGaoCollectionCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/16.
//  Copyright © 2019 pan. All rights reserved.
//

#import "GuangGaoCollectionCell.h"
#import "ShareFriendsModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation GuangGaoCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _imgV.image = nil;
}

- (void)configCell:(GuanggaoListModel *)model {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.imgPathEn]];
    [_imgV sd_setImageWithURL:url placeholderImage:[UIImage imageWithColor:[UIColor RandomColor]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
}

@end
