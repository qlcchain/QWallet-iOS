//
//  RefreshHelper.m
//  AutotollGPSProject
//
//  Created by Jelly Foo on 16/8/15.
//  Copyright © 2016年 Autotoll. All rights reserved.
//

#import "RefreshHelper.h"

@implementation RefreshHelper

+ (MJRefreshNormalHeader *)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)block {
    MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingBlock:block];
//    [header setTitle:@"下拉加载更多" forState:MJRefreshStateIdle];
//    [header setTitle:@"松开立即更新" forState:MJRefreshStatePulling];
//    [header setTitle:@"加载更多数据中..." forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    //    header.pullingPercent = 0.5;
    
    return header;
}

+ (MJRefreshAutoNormalFooter *)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)block {
    MJRefreshAutoNormalFooter *footer =  [MJRefreshAutoNormalFooter footerWithRefreshingBlock:block];
//    [footer setTitle:@"上拉可以刷新" forState:MJRefreshStateIdle];
//    [footer setTitle:@"松开立即更新" forState:MJRefreshStatePulling];
//    [footer setTitle:@"努力刷新中..." forState:MJRefreshStateRefreshing];
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
    //    footer.pullingPercent = 0;
    
    return footer;
}

@end
