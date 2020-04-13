//
//  AddMarketsCell.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/28.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *AddMarketsCellReuse = @"AddMarketsCell";
#define AddMarketsCell_Height 48

@interface AddMarketsCell : QBaseTableCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

- (void)configCellWithTitle:(NSString *)title isSelect:(BOOL)isSelect;

@end

NS_ASSUME_NONNULL_END
