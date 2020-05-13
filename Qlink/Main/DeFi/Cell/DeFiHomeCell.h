//
//  DeFiHomeCell.h
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DefiProjectListModel;

static NSString *DeFiHomeCell_Reuse = @"DeFiHomeCell";
#define DeFiHomeCell_Height 64

@interface DeFiHomeCell : UITableViewCell

- (void)config:(DefiProjectListModel *)model index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
