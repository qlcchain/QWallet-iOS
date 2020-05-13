//
//  DeFiRecordCell.h
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DefiProjectListModel;

static NSString *DeFiRecordCell_Reuse = @"DeFiRecordCell";
#define DeFiRecordCell_Height 64

@interface DeFiRecordCell : UITableViewCell

- (void)config:(DefiProjectListModel *)model;

@end

NS_ASSUME_NONNULL_END
