//
//  SettingCell.h
//  Qlink
//
//  Created by 旷自辉 on 2018/5/29.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "QBaseTableCell.h"

static NSString *SettingCellReuse = @"SettingCell";
#define SettingCellHeight 56

@interface SettingCell : QBaseTableCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContraintTopV;

@end
