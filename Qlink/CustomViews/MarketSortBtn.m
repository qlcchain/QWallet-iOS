//
//  MarketSortBtn.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/28.
//  Copyright © 2018 pan. All rights reserved.
//

#import "MarketSortBtn.h"

@implementation MarketSortBtn

- (void)setSortType:(MarketSortBtnType)sortType {
    _sortType = sortType;
    UIColor *textColor = UIColorFromRGB(0xAAAAAB);
    UIImage *image = nil;
    CGFloat titleLeft = -40;
//    CGFloat imageLeft = -40;
    if (sortType == MarketSortBtnTypeNone) {
        titleLeft = 0;
    } else if (sortType == MarketSortBtnTypeNormal) {
        image = [UIImage imageNamed:@"icon_sort_normal"];
        textColor = MAIN_BLUE_COLOR;
    } else if (sortType == MarketSortBtnTypeDown) {
        image = [UIImage imageNamed:@"icon_sort_down"];
        textColor = MAIN_BLUE_COLOR;
    } else if (sortType == MarketSortBtnTypeUp) {
        image = [UIImage imageNamed:@"icon_sort_up"];
        textColor = MAIN_BLUE_COLOR;
    } else {
        titleLeft = 0;
    }
    self.titleEdgeInsets = UIEdgeInsetsMake(0, titleLeft, 0, 0);
    [self setImage:image forState:UIControlStateNormal];
//    self.titleLabel.theme_textColor = globalBackgroundColorPicker;
    [self setTitleColor:textColor forState:UIControlStateNormal];
}

@end
