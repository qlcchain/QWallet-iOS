//
//  LocationManage.m
//  Qlink
//
//  Created by 旷自辉 on 2018/3/28.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "LocationManage.h"
#import "ChooseCountryUtil.h"

@implementation LocationManage
+ (instancetype) shareInstanceLocationManager
{
    __strong static LocationManage *shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
        [shareObject initializeLocationService];
    });
    return shareObject;
}

- (void)initializeLocationService {
    
    if ([CLLocationManager locationServicesEnabled]) {//判断定位操作是否被允许
        // 初始化定位管理器
        _locationManage = [[CLLocationManager alloc] init];
        // 设置代理
        _locationManage.delegate = self;
        
        //使用程序其间允许访问位置数据（iOS8以上版本定位需要）
        
        if ([_locationManage respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManage requestWhenInUseAuthorization];
        }
        
        // 设置定位精确度
        _locationManage.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        //10000.0米定位一次
        CLLocationDistance distance=1000*100.0;
        _locationManage.distanceFilter = distance;
        
    } else {
        // 如获取失败 默认为中国
        if (self.complete) {
            self.complete(nil,NO);
        }
    }
}

- (void)startLocation:(void (^)(NSString *, BOOL))complete
{
    self.complete = complete;
    // 开始定位
    if ([CLLocationManager locationServicesEnabled]) { // 判断是否打开了位置服务
        [_locationManage startUpdatingLocation];
    } else {
        if (self.complete) {
            self.complete(nil,NO);
        }
    }
}

- (void)stopLocation
{
    [_locationManage stopUpdatingLocation];
}

#pragma CLLocationManager delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [self stopLocation];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    CLLocation *newLocation = [locations lastObject];
    
    @weakify_self
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSString *country = [ChooseCountryUtil getConutryNameWithCode:placemark.ISOcountryCode];
            if (weakSelf.complete) {
                weakSelf.complete(country,YES);
            }
            DDLogDebug(@"country = %@",placemark.country);
           
        } else {
            weakSelf.complete(nil,NO);
        }
    }];
}

// 该方法在用户点击定位“允许”/“拒绝”的时候调用
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    // kCLAuthorizationStatusDenied  用户“拒绝”
    //kCLAuthorizationStatusAuthorizedAlways    用户允许“一直定位”
    //kCLAuthorizationStatusAuthorizedWhenInUse          用户允许“使用时定位”
    //kCLAuthorizationStatusAuthorized               用户“允许定位”
    BOOL success = YES;
    switch (status) {
        case kCLAuthorizationStatusDenied:
            if (self.complete) {
                success = NO;
                self.complete(nil,success);
            }
            break;
            
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (self.complete) {
        self.complete(nil,NO);
    }
}

@end
