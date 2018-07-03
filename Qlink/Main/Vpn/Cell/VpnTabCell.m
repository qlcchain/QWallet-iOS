//
//  VpnTabCell.m
//  Qlink
//
//  Created by 旷自辉 on 2018/3/22.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VpnTabCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+RoundedCorner.h"
#import "ChatUtil.h"
#import "ChatModel.h"
#import "WalletUtil.h"

@interface VpnTabCell ()

@property (nonatomic, strong) VPNInfo *vpnInfo;

@end

@implementation VpnTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithModel:(VPNInfo *)vpnInfo {
    _vpnInfo = vpnInfo;
    @weakify_self
    _lblTitle.text = [NSStringUtil getNotNullValue:_vpnInfo.vpnName];
    //    _myVPNImgaeView.image
    //    _actionImageView.image = ;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[RequestService getPrefixUrl],_vpnInfo.imgUrl];
//    CGSize ownerImgVSize = _ownerImageView.size;
    [_ownerImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:User_PlaceholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
//            image = [image addBorderToSize:ownerImgVSize lineWidth:Photo_White_Circle_Length];
            image = [image roundedCornerImage:image.size.width/2.0 borderSize:0];
            weakSelf.ownerImageView.image = image;
        }
    }];
    //    _lblPriceNum.text = [NSString stringWithFormat:@"%.2f",[vpnInfo.qlc floatValue]];
    _lblPriceNum.text = _vpnInfo.cost;
    UIImage *offlineImg = [UIImage imageNamed:@"icon_offline"];
    UIImage *onlineImg = [UIImage imageNamed:@"icon_online"];
    _statusImageView.image = _vpnInfo.online>0?onlineImg:offlineImg;
    ChatModel *chatM = [ChatUtil.shareInstance getChat:_vpnInfo.vpnName];
    _messageImageView.image = _vpnInfo.online>0?chatM.isUnread?[UIImage imageNamed:@"icon_message_online"]:[UIImage imageNamed:@"icon_message"]:[UIImage imageNamed:@"icon_message_offline"];
    UIColor *blackC = UIColorFromRGB(0x333333);
    UIColor *grayC = UIColorFromRGB(0xa8a6ae);
    UIColor *whiteC = UIColorFromRGB(0xffffff);
    _lblTitle.textColor = _vpnInfo.online>0?_vpnInfo.isConnected?whiteC:blackC:grayC;
    _lblPriceNum.textColor = _vpnInfo.online>0?_vpnInfo.isConnected?whiteC:blackC:grayC;
    _lblUsersNum.textColor = _vpnInfo.online>0?_vpnInfo.isConnected?whiteC:blackC:grayC;
    _lblQLC.textColor = _vpnInfo.online>0?_vpnInfo.isConnected?whiteC:blackC:grayC;
    _lblUsers.text = _vpnInfo.online>0?@"Users:":@"Offline";
    _lblUsersNum.text = _vpnInfo.online>0?_vpnInfo.connectNum:nil;
    _backImageVIew.image = _vpnInfo.isConnected?[UIImage imageNamed:@"bg_purple_button"]:[UIImage imageNamed:@"bg_continue"];
    _myVPNImgaeView.image = _vpnInfo.online>0?[UIImage imageNamed:@"icon_my_vpn"]:[UIImage imageNamed:@"icon_offiline_vpn"];
    // 主网暂时不能抢注
    BOOL isOwner = NO;
    if ([WalletUtil checkServerIsMian]) {
        isOwner = YES;
    } else {
        isOwner = [_vpnInfo.p2pId isEqualToString:[ToxManage getOwnP2PId]];
    }
    _actionImageView.image = isOwner? [UIImage imageNamed:@"icon_seize"]:[UIImage imageNamed:@"icon_seize_two"];
    _seizeBtn.userInteractionEnabled = !isOwner;
    
}

- (IBAction)clickSeize:(UIButton *)sender {
    
    if (self.seizeBlock) {
        self.seizeBlock(sender.tag);
    }
}

- (IBAction)userConversationAction:(id)sender {
    if (!_vpnInfo.online) { // 离线状态不能触发
        return;
    }
    if (_conversationB) {
        _conversationB();
    }
}


- (void)prepareForReuse {
    [super prepareForReuse];
    
//    _myVPNImgaeView.image = nil;
//    _actionImageView.image = nil;
    _ownerImageView.image = nil;
    _statusImageView.image = nil;
    _lblTitle.text = nil;
    _lblPriceNum.text = nil;
    _lblUsersNum.text = nil;
    _messageImageView.image = nil;
//    _lblQLC.text = nil;
//    _lblUsers.text = nil;
}

@end
