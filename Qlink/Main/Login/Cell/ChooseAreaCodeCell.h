//
//  ChooseAreaCodeCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/9.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QBaseTableCell.h"

@class AreaCodeModel;

static NSString *ChooseAreaCodeCellReuse = @"ChooseAreaCodeCell";
#define ChooseAreaCodeCell_Height 44

@interface ChooseAreaCodeCell : QBaseTableCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *codeLab;

- (void)configCell:(AreaCodeModel *)model;

@end
