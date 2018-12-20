//
//  QNavigationController.h
//  QlinkTest
//
//  Created by JellyFoo on 2017/5/18.
//  Copyright © 2017年 JellyFoo. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 导航控制器基类
 */
@interface QNavigationController : UINavigationController

/*!
 *  返回到指定的类视图
 *
 *  @param ClassName 类名
 *  @param animated  是否动画
 */
-(BOOL)popToAppointViewController:(NSString *)ClassName animated:(BOOL)animated;


@end
