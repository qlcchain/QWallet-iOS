//
//  MyOrderListCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/10.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EntrustOrderListModel;

static NSString *MyOrderListEntrustCellReuse = @"MyOrderListEntrustCell";
#define MyOrderListEntrustCell_Height 168

@interface MyOrderListEntrustCell : UITableViewCell

- (void)config:(EntrustOrderListModel *)model;

@end

NS_ASSUME_NONNULL_END
