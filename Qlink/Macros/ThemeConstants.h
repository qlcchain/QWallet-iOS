//
//  ThemeConstants.h
//  Qlink
//
//  Created by Jelly Foo on 2019/8/20.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define MAIN_BLUE_COLOR UIColorFromRGB(0x108EE9)
#define globalBackgroundColorPicker [ThemeColorPicker pickerWithColors:MAIN_COLOR_ARR]
#define MAIN_COLOR_ARR @[MAIN_BLUE_COLOR_STR, @"#4A0081"]

@interface ThemeConstants : NSObject

extern NSString *const MAIN_BLUE_COLOR_STR;

@end

NS_ASSUME_NONNULL_END
