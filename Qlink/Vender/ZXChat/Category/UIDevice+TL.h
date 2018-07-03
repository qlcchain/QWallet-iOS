//
//  UIDevice+PVZ.h
//  PlantsVsZombies
//
//  Created by h1r0 on 15/8/29.
//  Copyright (c) 2015年 lbk. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WIDTH_SCREEN        [UIScreen mainScreen].bounds.size.width
#define HEIGHT_SCREEN       [UIScreen mainScreen].bounds.size.height
//#define HEIGHT_STATUSBAR    20 // 状态栏
#define HEIGHT_STATUSBAR (IS_iPhoneX ? 44.f : 20.f)
#define HEIGHT_BOTTOM (IS_iPhoneX ? 34.f : 0.f)
#define HEIGHT_TABBAR       49 // 标签
#define HEIGHT_NAVBAR       44 // 导航
#define HEIGHT_CHATBOXVIEW  215// 更多 view
#define HEIGHT_CHATBOX       50 // 输入框

typedef NS_ENUM(NSInteger, DeviceVerType){
    DeviceVer4,
    DeviceVer5,
    DeviceVer6,
    DeviceVer6P,
};

@interface UIDevice (TL)

+ (DeviceVerType)deviceVerType;

@end
