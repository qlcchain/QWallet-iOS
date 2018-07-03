//
//  VpnTabCell.h
//  Qlink
//
//  Created by 旷自辉 on 2018/3/22.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNMode.h"

static NSString *VpnTabCellReuse = @"VpnTabCell";
#define VpnTabCell_Height 71

typedef void(^ClickSeizeBlock)(NSInteger row);
typedef void(^ConversationBlock)(void);

@interface VpnTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backImageVIew;
@property (weak, nonatomic) IBOutlet UIImageView *myVPNImgaeView;
@property (weak, nonatomic) IBOutlet UIImageView *actionImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ownerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceNum;
@property (weak, nonatomic) IBOutlet UILabel *lblUsersNum;
@property (weak, nonatomic) IBOutlet UILabel *lblQLC;
@property (weak, nonatomic) IBOutlet UILabel *lblUsers;
@property (weak, nonatomic) IBOutlet UIButton *seizeBtn;

@property (nonatomic , copy) ClickSeizeBlock seizeBlock;
@property (nonatomic , copy) ConversationBlock conversationB;

- (void)configCellWithModel:(VPNInfo *) vpnInfo;

@end
