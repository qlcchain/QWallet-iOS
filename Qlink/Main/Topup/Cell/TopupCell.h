//
//  FinanceCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/11.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopupProductModel;

static NSString *TopupCellReuse = @"TopupCell";
#define TopupCell_Height 196

@interface TopupCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *discountBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *checkDiscountLab;
@property (weak, nonatomic) IBOutlet UILabel *discountLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UIView *contentBack;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UIView *soldoutBack;
@property (weak, nonatomic) IBOutlet UIView *soldout_topTipBack;
@property (weak, nonatomic) IBOutlet UIView *soldout_tipBack;
@property (weak, nonatomic) IBOutlet UILabel *soldout_topTipLab;
@property (weak, nonatomic) IBOutlet UILabel *soldout_tipLab;


- (void)config:(TopupProductModel *)model;

@end
