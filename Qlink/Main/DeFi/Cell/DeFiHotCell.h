//
//  DeFiHotCell.h
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DefiNewsListModel;

static NSString *DeFiHotCell_Reuse = @"DeFiHotCell";
//#define DeFiHotCell_Height 190

typedef void(^DefiNewsListContentBlock)(DefiNewsListModel *newsM, NSInteger index);

@interface DeFiHotCell : UITableViewCell

- (void)config:(DefiNewsListModel *)model index:(NSInteger)index contentB:(DefiNewsListContentBlock)contentB;
+ (CGFloat)cellHeight:(DefiNewsListModel *)model;

@end

NS_ASSUME_NONNULL_END
