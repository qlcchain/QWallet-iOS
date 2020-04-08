//
//  RefreshHelper.m
//  AutotollGPSProject
//
//  Created by Jelly Foo on 16/8/15.
//  Copyright © 2016年 Autotoll. All rights reserved.
//

#import "RefreshHelper.h"
#import "GlobalConstants.h"
#import "UIImage+Resize.h"
#import <UIImageView+WebCache.h>

@implementation RefreshHelper

//+ (MJRefreshNormalHeader *)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)block {
//    MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingBlock:block];
////    [header setTitle:@"下拉加载更多" forState:MJRefreshStateIdle];
////    [header setTitle:@"松开立即更新" forState:MJRefreshStatePulling];
////    [header setTitle:@"加载更多数据中..." forState:MJRefreshStateRefreshing];
//    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
//    header.stateLabel.textColor = SRREFRESH_BACK_COLOR;
//    //    header.pullingPercent = 0.5;
//
//    return header;
//}
//
//+ (MJRefreshAutoNormalFooter *)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)block {
//    MJRefreshAutoNormalFooter *footer =  [MJRefreshAutoNormalFooter footerWithRefreshingBlock:block];
////    [footer setTitle:@"上拉可以刷新" forState:MJRefreshStateIdle];
////    [footer setTitle:@"松开立即更新" forState:MJRefreshStatePulling];
////    [footer setTitle:@"努力刷新中..." forState:MJRefreshStateRefreshing];
//    footer.refreshingTitleHidden = YES;
//    footer.stateLabel.hidden = YES;
//    //    footer.pullingPercent = 0;
//
//    return footer;
//}
//
//+ (MJRefreshBackNormalFooter *)footerBackNormalWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)block {
//    MJRefreshBackNormalFooter *footer =  [MJRefreshBackNormalFooter footerWithRefreshingBlock:block];
//    //    [footer setTitle:@"上拉可以刷新" forState:MJRefreshStateIdle];
//    //    [footer setTitle:@"松开立即更新" forState:MJRefreshStatePulling];
//    //    [footer setTitle:@"努力刷新中..." forState:MJRefreshStateRefreshing];
////    footer.refreshingTitleHidden = YES;
//    footer.stateLabel.hidden = YES;
//    footer.stateLabel.textColor = SRREFRESH_BACK_COLOR;
//    //    footer.pullingPercent = 0;
//
//    return footer;
//}




+ (MJRefreshGifHeader *)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)block type:(RefreshType)type {
//    UIImage *logoImage = [UIImage imageNamed:@"icon_login_logo"];
//    logoImage = [[logoImage sd_resizedImageWithSize:CGSizeMake(30, 30) scaleMode:SDImageScaleModeAspectFit] sd_roundedCornerImageWithRadius:4 corners:UIRectCornerAllCorners borderWidth:0 borderColor:[UIColor whiteColor]];
    NSMutableArray *logoImages = [NSMutableArray array];
    NSArray *images = @[];
    NSMutableArray *refreshingImages = [NSMutableArray array];
    if (type == RefreshTypeWhite) {
        images = @[[UIImage imageNamed:@"loading_white_2"]];
        for (int i = 2; i <= 17; i++) {
            UIImage *loadingImg = [UIImage imageNamed:[NSString stringWithFormat:@"loading_white_%@",@(i)]];
            [refreshingImages addObject:loadingImg];
        }
        for (int i = 4; i>=1; i--) {
            UIImage *logoImage = [UIImage imageNamed:[NSString stringWithFormat:@"loading_white_logo_%@",@(i)]];
            [logoImages addObject:logoImage];
        }
    } else if (type == RefreshTypeColor) {
        images = @[[UIImage imageNamed:@"loading_color_2"]];
        for (int i = 2; i <= 17; i++) {
            UIImage *loadingImg = [UIImage imageNamed:[NSString stringWithFormat:@"loading_color_%@",@(i)]];
            [refreshingImages addObject:loadingImg];
        }
        for (int i = 4; i>=1; i--) {
            UIImage *logoImage = [UIImage imageNamed:[NSString stringWithFormat:@"loading_colour_logo_%@",@(i)]];
            [logoImages addObject:logoImage];
        }
    }
   
    
    MJRefreshGifHeader *header =  [MJRefreshGifHeader headerWithRefreshingBlock:block];
//    [header setTitle:@"下拉加载更多" forState:MJRefreshStateIdle];
//    [header setTitle:@"松开立即更新" forState:MJRefreshStatePulling];
//    [header setTitle:@"加载更多数据中..." forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    // 设置普通状态的动画图片
    [header setImages:logoImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    [header setImages:logoImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:refreshingImages duration:1.4 forState:MJRefreshStateRefreshing];
//    [header setImages:logoImages1 forState:MJRefreshStateWillRefresh];
    
    
//    header.pullingPercent = 0.5;
    
    return header;
}

+ (MJRefreshBackGifFooter *)footerBackNormalWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)block type:(RefreshType)type {
    NSMutableArray *logoImages = [NSMutableArray array];
    NSArray *images = @[];
    NSMutableArray *refreshingImages = [NSMutableArray array];
    if (type == RefreshTypeWhite) {
        images = @[[UIImage imageNamed:@"loading_white_2"]];
        for (int i = 2; i <= 17; i++) {
            UIImage *loadingImg = [UIImage imageNamed:[NSString stringWithFormat:@"loading_white_%@",@(i)]];
            [refreshingImages addObject:loadingImg];
        }
        for (int i = 4; i>=1; i--) {
            UIImage *logoImage = [UIImage imageNamed:[NSString stringWithFormat:@"loading_white_logo_%@",@(i)]];
            [logoImages addObject:logoImage];
        }
    } else if (type == RefreshTypeColor) {
        images = @[[UIImage imageNamed:@"loading_color_2"]];
        for (int i = 2; i <= 17; i++) {
            UIImage *loadingImg = [UIImage imageNamed:[NSString stringWithFormat:@"loading_color_%@",@(i)]];
            [refreshingImages addObject:loadingImg];
        }
        for (int i = 4; i>=1; i--) {
            UIImage *logoImage = [UIImage imageNamed:[NSString stringWithFormat:@"loading_colour_logo_%@",@(i)]];
            [logoImages addObject:logoImage];
        }
    }
    
    MJRefreshBackGifFooter *footer =  [MJRefreshBackGifFooter footerWithRefreshingBlock:block];
//    [footer setTitle:@"上拉可以刷新" forState:MJRefreshStateIdle];
//    [footer setTitle:@"松开立即更新" forState:MJRefreshStatePulling];
//    [footer setTitle:@"努力刷新中..." forState:MJRefreshStateRefreshing];
//    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
    // 设置普通状态的动画图片
    [footer setImages:logoImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    [footer setImages:images forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [footer setImages:refreshingImages duration:1.4 forState:MJRefreshStateRefreshing];
    
//    footer.pullingPercent = 0;
    
    return footer;
}

@end
