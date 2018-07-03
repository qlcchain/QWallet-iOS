//
//  MyAssetsCell.h
//  Qlink
//
//  Created by 旷自辉 on 2018/5/2.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNMode.h"

static NSString *MyAssetsCellReuse = @"MyAssetsCell";
#define MyAssetsCell_Height 71

typedef void(^ClickSettingBlock)(id mode);

@interface MyAssetsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblConnectCount;
@property (weak, nonatomic) IBOutlet UILabel *lblQLC1;
@property (weak, nonatomic) IBOutlet UILabel *lblQLC2;
@property (nonatomic ,strong) VPNInfo *vpnInfo;
@property (nonatomic , copy) ClickSettingBlock setBlock;

- (void) setMode:(id) mode;
@end
