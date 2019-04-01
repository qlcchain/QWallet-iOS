//
//  MarketSortBtn.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/28.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MarketSortBtnTypeNone,
    MarketSortBtnTypeNormal,
    MarketSortBtnTypeDown,
    MarketSortBtnTypeUp,
} MarketSortBtnType;

@interface MarketSortBtn : UIButton

@property (nonatomic) MarketSortBtnType sortType;

@end

NS_ASSUME_NONNULL_END
