//
//  HomeBuySellCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/9.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EntrustOrderListModel;

static NSString *HomeBuySellCellReuse = @"HomeBuySellCell";
#define HomeBuySellCell_Height 161

@interface HomeBuySellCell : UITableViewCell

- (void)config:(EntrustOrderListModel *)model;

@end

NS_ASSUME_NONNULL_END
