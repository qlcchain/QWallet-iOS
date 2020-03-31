//
//  ChooseTokenCell.h
//  Qlink
//
//  Created by Jelly Foo on 2020/2/11.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TopupDeductionTokenModel;

static NSString *ChooseTokenCell_Reuse = @"ChooseTokenCell";
#define ChooseTokenCell_Height 44

@interface ChooseTokenCell : UITableViewCell

- (void)config:(TopupDeductionTokenModel *)model;

@end

NS_ASSUME_NONNULL_END
