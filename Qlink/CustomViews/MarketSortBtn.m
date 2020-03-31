//
//  MarketSortBtn.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/28.
//  Copyright © 2018 pan. All rights reserved.
//

#import "MarketSortBtn.h"
#import "GlobalConstants.h"
#import <SwiftTheme/SwiftTheme-Swift.h>

@implementation MarketSortBtn

- (void)setSortType:(MarketSortBtnType)sortType {
    _sortType = sortType;
//    UIColor *textColor = UIColorFromRGB(0xAAAAAB);
    ThemeColorPicker *colorPicker = [ThemeColorPicker pickerWithColors:@[@"#AAAAAB", @"#AAAAAB"]];
    UIImage *image = nil;
    CGFloat titleLeft = -40;
//    CGFloat imageLeft = -40;
    if (sortType == MarketSortBtnTypeNone) {
        titleLeft = 0;
    } else if (sortType == MarketSortBtnTypeNormal) {
        image = [UIImage imageNamed:@"icon_sort_normal"];
        colorPicker = globalBackgroundColorPicker;
    } else if (sortType == MarketSortBtnTypeDown) {
        image = [UIImage imageNamed:@"icon_sort_down"];
        colorPicker = globalBackgroundColorPicker;
    } else if (sortType == MarketSortBtnTypeUp) {
        image = [UIImage imageNamed:@"icon_sort_up"];
        colorPicker = globalBackgroundColorPicker;
    } else {
        titleLeft = 0;
    }
    self.titleEdgeInsets = UIEdgeInsetsMake(0, titleLeft, 0, 0);
    [self setImage:image forState:UIControlStateNormal];
    self.titleLabel.theme_textColor = colorPicker;
//    [self setTitleColor:textColor forState:UIControlStateNormal];
}

@end
