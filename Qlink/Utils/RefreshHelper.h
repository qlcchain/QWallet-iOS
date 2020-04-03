//
//  RefreshHelper.h
//  AutotollGPSProject
//
//  Created by Jelly Foo on 16/8/15.
//  Copyright © 2016年 Autotoll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJRefresh/MJRefresh.h>

typedef NS_ENUM(NSUInteger, RefreshType) {
    RefreshTypeWhite,
    RefreshTypeColor,
};

@interface RefreshHelper : NSObject

//+ (MJRefreshNormalHeader *)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)block;
//+ (MJRefreshAutoNormalFooter *)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)block;
//+ (MJRefreshBackNormalFooter *)footerBackNormalWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)block;

+ (MJRefreshGifHeader *)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)block type:(RefreshType)type;
+ (MJRefreshBackGifFooter *)footerBackNormalWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)block type:(RefreshType)type;

@end
