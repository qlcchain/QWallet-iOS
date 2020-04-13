//
//  ETHWalletDetailCell.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/26.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *ETHWalletDetailCellReuse = @"ETHWalletDetailCell";
#define ETHWalletDetailCell_Height 48

@interface ETHWalletDetailCell : QBaseTableCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

- (void)configCellWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
