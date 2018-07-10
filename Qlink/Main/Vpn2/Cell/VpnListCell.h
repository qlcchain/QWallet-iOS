//
//  VpnListCell.h
//  Qlink
//
//  Created by Jelly Foo on 2018/7/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNMode.h"

static NSString *VpnListCellReuse = @"VpnListCell";
#define VpnListCell_Height 88

typedef void(^ConnectClickBlock)(void);

@interface VpnListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ownerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
//@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property (weak, nonatomic) IBOutlet UILabel *vpnNameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *priceUnitLab;
@property (weak, nonatomic) IBOutlet UILabel *connectNumLab;
@property (weak, nonatomic) IBOutlet UILabel *connectNumUnitLab;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
@property (nonatomic, copy) ConnectClickBlock connectClickB;

- (void)configCellWithModel:(VPNInfo *) vpnInfo;

@end
