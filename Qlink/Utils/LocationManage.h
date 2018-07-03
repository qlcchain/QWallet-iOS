//
//  LocationManage.h
//  Qlink
//
//  Created by 旷自辉 on 2018/3/28.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManage : NSObject<CLLocationManagerDelegate>

@property (nonatomic ,strong) CLLocationManager *locationManage;
@property (nonatomic ,copy) void (^complete) (NSString *country,BOOL success);

+ (instancetype) shareInstanceLocationManager;

/**
 开始定位

 @param complete 定位结果
 */
- (void) startLocation:(void(^)(NSString *country,BOOL success)) complete;

/**
 停止定位
 */
- (void) stopLocation;

@end
