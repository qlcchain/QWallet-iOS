//
//  MarketsCell.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/14.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@class BinaTpcsModel;

static NSString *MarketsCellReuse = @"MarketsCell";
#define MarketsCell_Height 64

@interface MarketsCell : QBaseTableCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *price1Lab;
@property (weak, nonatomic) IBOutlet UILabel *price2Lab;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

- (void)configCellWithModel:(BinaTpcsModel *)model;

@end

NS_ASSUME_NONNULL_END
