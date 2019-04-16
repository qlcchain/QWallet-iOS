//
//  RefreshHelper.h
//  AutotollGPSProject
//
//  Created by Jelly Foo on 16/8/15.
//  Copyright © 2016年 Autotoll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"

@interface RefreshHelper : NSObject

+ (MJRefreshNormalHeader *)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)block;
+ (MJRefreshAutoNormalFooter *)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)block;

@end
