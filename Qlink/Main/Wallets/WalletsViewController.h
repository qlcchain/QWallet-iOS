//
//  WalletsViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/25.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class QLCTokenModel,Token,NEOAssetModel;

@interface WalletsViewController : QBaseViewController

//- (NEOAssetModel *)getNEOAsset:(NSString *)tokenName;
//- (QLCTokenModel *)getQLCAsset:(NSString *)tokenName;
//- (Token *)getETHAsset:(NSString *)tokenName;
//- (NSArray *)getETHSource;
//- (NSArray *)getQLCSource;
//- (NSArray *)getNEOSource;
//- (NSArray *)getEOSSource;
//- (NEOAssetModel *)getNEOAsset;
//- (Token *)getETHAsset;
//- (QLCTokenModel *)getQLCAsset;
- (NSNumber *)getGasAssetBalanceOfNeo;

@end

NS_ASSUME_NONNULL_END
