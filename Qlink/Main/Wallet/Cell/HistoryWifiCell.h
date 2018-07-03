//
//  HistoryWifiCell.h
//  Qlink
//
//  Created by 旷自辉 on 2018/4/24.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryRecrdInfo.h"

static NSString *HistoryWifiCellReuse = @"HistoryWifiCell";

@interface HistoryWifiCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgVIew;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

- (void)configCellWithModel:(HistoryRecrdInfo *) model;
@end
