//
//  ChooseCurrencyCell.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/31.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *ChooseCurrencyCellReuse = @"ChooseCurrencyCell";
#define ChooseCurrencyCell_Height 48

@interface ChooseCurrencyCell : QBaseTableCell

@property (weak, nonatomic) IBOutlet UILabel *currentcyLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectIcon;

- (void)configCellWithCurrency:(NSString *)currency;

@end

NS_ASSUME_NONNULL_END
