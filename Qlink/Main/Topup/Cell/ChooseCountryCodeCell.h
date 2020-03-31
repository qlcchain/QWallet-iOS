//
//  ChooseCountryCodeCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/12/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TopupCountryModel;

static NSString *ChooseCountryCodeCellReuse = @"ChooseCountryCodeCell";
#define ChooseCountryCodeCell_Height 48

@interface ChooseCountryCodeCell : UITableViewCell

- (void)config:(TopupCountryModel *)model isSelect:(BOOL)isSelect;

@end

NS_ASSUME_NONNULL_END
