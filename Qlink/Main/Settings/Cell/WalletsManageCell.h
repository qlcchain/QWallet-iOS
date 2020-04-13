//
//  WalletsManageCell.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/16.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@class WalletCommonModel;

typedef void(^WalletsManageMoreBlock)(void);

static NSString *WalletsManageCellReuse = @"WalletsManageCell";
#define WalletsManageCell_Height 120

@interface WalletsManageCell : QBaseTableCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (nonatomic, copy) WalletsManageMoreBlock moreBlock;
@property (weak, nonatomic) IBOutlet UIView *shadowBack;

- (void)configCellWithModel:(WalletCommonModel *)model tokenPriceArr:(NSArray *)tokenPriceArr;

@end

NS_ASSUME_NONNULL_END
