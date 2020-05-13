//
//  ETHTransactionRecordCell.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@class OutbreakFocusModel;

static NSString *OutbreakRedRecordCellReuse = @"OutbreakRedRecordCell";
#define OutbreakRedRecordCell_Height 64

@interface OutbreakRedRecordCell : QBaseTableCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

- (void)config:(OutbreakFocusModel *)model;

@end

NS_ASSUME_NONNULL_END
