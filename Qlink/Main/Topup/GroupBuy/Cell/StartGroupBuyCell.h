//
//  StartGroupBuyCell.h
//  Qlink
//
//  Created by Jelly Foo on 2020/1/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@class GroupKindModel;

static NSString *StartGroupBuyCell_Reuse = @"StartGroupBuyCell";
#define StartGroupBuyCell_Height 40

@interface StartGroupBuyCell : QBaseTableCell

@property (weak, nonatomic) IBOutlet UIButton *typeBtn;

- (void)config:(GroupKindModel *)model;

@end

NS_ASSUME_NONNULL_END
