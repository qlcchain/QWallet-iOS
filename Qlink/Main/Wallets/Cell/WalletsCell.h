//
//  WalletsCell.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/25.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Token,NEOAssetModel,EOSSymbolModel;

static NSString *WalletsCellReuse = @"WalletsCell";
#define WalletsCell_Height 64

@interface WalletsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

- (void)configCellWithToken:(Token *)model tokenPriceArr:(NSArray *)tokenPriceArr;
- (void)configCellWithAsset:(NEOAssetModel *)model tokenPriceArr:(NSArray *)tokenPriceArr;
- (void)configCellWithSymbol:(EOSSymbolModel *)model tokenPriceArr:(NSArray *)tokenPriceArr;


@end

NS_ASSUME_NONNULL_END
