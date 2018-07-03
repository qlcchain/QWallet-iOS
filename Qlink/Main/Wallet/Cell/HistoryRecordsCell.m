//
//  HistoryRecordsCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/2.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "HistoryRecordsCell.h"

@implementation HistoryRecordsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)configCellWithModel:(HistoryRecrdInfo *)model {
    
    _lblTime.text = [model.timestamp getTimeStampTimeString];
    _jtouImgView.image = [UIImage imageNamed:@"icon_max_red"];
    if (model.recordType == 1) { // 兑换
        _headImgView.image = [UIImage imageNamed:@"icon_neo"];
        _lblCount.text = [NSString stringWithFormat:@"-%.0f",model.neoCount];
        _lblTitle.text = NSStringLocalizable(@"exchange");
        _lblType.text = @"NEO";
    } else if (model.recordType == 3 || model.recordType == 5) { // 3:vpn连接。5:vpn注册
        _headImgView.image = [UIImage imageNamed:@"icon_vpn_green"];
        if (model.connectType == 1) {
             _lblCount.text = [NSString stringWithFormat:@"+%.2f",model.qlcCount];
             _jtouImgView.image = [UIImage imageNamed:@"icon_max_green"];
        } else {
             _lblCount.text = [NSString stringWithFormat:@"-%.2f",model.qlcCount];
        }
       
        _lblTitle.text = model.assetName;
        _lblType.text = @"QLC";
    } else if (model.recordType == 4) { // 4 wifi注册扣费
        _headImgView.image = [UIImage imageNamed:@"icon_connected_wifi"];
        _lblCount.text = [NSString stringWithFormat:@"-%.2f",model.qlcCount];
        _lblTitle.text = model.assetName;
        _lblType.text = @"QLC";
    } else { // 转帐
         _headImgView.image = [UIImage imageNamed:@"icon_registered_assets"];
        _lblCount.text = [NSString stringWithFormat:@"-%.2f",model.qlcCount];
        _lblTitle.text = NSStringLocalizable(@"transfer");
        _lblType.text = @"QLC";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
