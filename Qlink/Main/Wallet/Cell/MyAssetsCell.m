//
//  MyAssetsCell.m
//  Qlink
//
//  Created by 旷自辉 on 2018/5/2.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "MyAssetsCell.h"
#import "VPNOperationUtil.h"

@implementation MyAssetsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)clickSetting:(UIButton *)sender {
    if (self.setBlock) {
        self.setBlock(self.vpnInfo);
    }
}

- (void) setMode:(id) mode
{
    if ([mode isKindOfClass:[VPNInfo class]]) {
        self.vpnInfo = mode;
        _lblName.text = self.vpnInfo.vpnName;
        
        _lblQLC2.text = [NSString stringWithFormat:@"%.2f",([self.vpnInfo.qlc floatValue] - [self.vpnInfo.registerQlc floatValue])];
        _lblQLC1.text = self.vpnInfo.registerQlc;
        _headImgV.image = [UIImage imageNamed:@"icon_vpn_green"];
        _lblConnectCount.text = [NSString stringWithFormat:@"0/%@",self.vpnInfo.connectNum];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
