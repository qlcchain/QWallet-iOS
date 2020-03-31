//
//  TopupMobilePlanCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/12/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TopupProductModel;

//static CGFloat TopupMobilePlanCell_Width = 168;
static CGFloat TopupMobilePlanCell_Height = 220;
static NSString *TopupMobilePlanCell_Reuse = @"TopupMobilePlanCell";

@interface TopupMobilePlanCell : UICollectionViewCell

- (void)config:(TopupProductModel *)model;

@end

NS_ASSUME_NONNULL_END
