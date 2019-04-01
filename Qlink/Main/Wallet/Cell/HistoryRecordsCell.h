//
//  HistoryRecordsCell.h
//  Qlink
//
//  Created by Jelly Foo on 2018/4/2.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryRecrdInfo.h"

static NSString *HistoryRecordsCellReuse = @"HistoryRecordsCell";
#define HistoryRecordsCell_Height 64

@interface HistoryRecordsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *jtouImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

- (void)configCellWithModel:(HistoryRecrdInfo *) model;

@end
