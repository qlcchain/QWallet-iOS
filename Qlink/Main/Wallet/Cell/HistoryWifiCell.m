//
//  HistoryWifiCell.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/24.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "HistoryWifiCell.h"

@implementation HistoryWifiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configCellWithModel:(HistoryRecrdInfo *) model
{
    _lblTime.text = [model.timestamp getTimeStampTimeString];
    _lblName.text = model.assetName;
    if (model.recordType == 0 || model.recordType == 4) { // wifi
        _headImgView.image = [UIImage imageNamed:@"icon_connected_wifi"];
    } else {
        _headImgView.image = [UIImage imageNamed:@"icon_myvpn"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
