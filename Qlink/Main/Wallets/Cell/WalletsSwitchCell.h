//
//  WalletsSwitchCell.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/7.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@class WalletCommonModel;

static NSString *WalletsSwitchCellReuse = @"WalletsSwitchCell";
#define WalletsSwitchCell_Height 72

@interface WalletsSwitchCell : QBaseTableCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectImg;

- (void)configCellWithModel:(WalletCommonModel *)model selectM:(WalletCommonModel *)selectM;

@end

NS_ASSUME_NONNULL_END
