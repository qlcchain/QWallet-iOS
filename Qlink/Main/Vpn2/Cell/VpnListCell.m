//
//  VpnListCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/7/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VpnListCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+RoundedCorner.h"
#import "ChatUtil.h"
#import "ChatModel.h"
#import "WalletUtil.h"

@interface VpnListCell ()

@property (nonatomic, strong) VPNInfo *vpnInfo;

@end

@implementation VpnListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _ownerImageView.layer.cornerRadius = _ownerImageView.width/2.0;
    _ownerImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithModel:(VPNInfo *)vpnInfo {
    _vpnInfo = vpnInfo;
//    @weakify_self
    _vpnNameLab.text = [NSStringUtil getNotNullValue:_vpnInfo.vpnName];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[RequestService getPrefixUrl],_vpnInfo.imgUrl];
    [_ownerImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:User_PlaceholderImage1 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        if (image) {
//            image = [image roundedCornerImage:image.size.width/2.0 borderSize:0];
//            weakSelf.ownerImageView.image = image;
//        }
    }];
    _priceLab.text = _vpnInfo.cost;
    _connectNumLab.text = _vpnInfo.connsuccessNum;
//    UIImage *offlineImg = [UIImage imageNamed:@"icon_offline"];
//    UIImage *onlineImg = [UIImage imageNamed:@"icon_online"];
//    _statusImageView.image = _vpnInfo.online>0?onlineImg:offlineImg;
//    ChatModel *chatM = [ChatUtil.shareInstance getChat:_vpnInfo.vpnName];
//    _messageImageView.image = _vpnInfo.online>0?chatM.isUnread?[UIImage imageNamed:@"icon_message_online"]:[UIImage imageNamed:@"icon_message"]:[UIImage imageNamed:@"icon_message_offline"];
    UIColor *blackC = UIColorFromRGB(0x333333);
    UIColor *grayC = UIColorFromRGB(0xa8a6ae);
    UIColor *whiteC = UIColorFromRGB(0xffffff);
    _vpnNameLab.textColor = _vpnInfo.online>0?_vpnInfo.isConnected?whiteC:blackC:grayC;
    _priceLab.textColor = _vpnInfo.online>0?_vpnInfo.isConnected?whiteC:blackC:grayC;
    _connectNumLab.textColor = _vpnInfo.online>0?_vpnInfo.isConnected?whiteC:blackC:grayC;
    _priceUnitLab.textColor = _vpnInfo.online>0?_vpnInfo.isConnected?whiteC:blackC:grayC;
    _connectNumUnitLab.textColor = _vpnInfo.online>0?_vpnInfo.isConnected?whiteC:blackC:grayC;
//    _lblUsersNum.textColor = _vpnInfo.online>0?_vpnInfo.isConnected?whiteC:blackC:grayC;
//    _lblQLC.textColor = _vpnInfo.online>0?_vpnInfo.isConnected?whiteC:blackC:grayC;
//    _lblUsers.text = _vpnInfo.online>0?@"Users:":@"Offline";
//    _lblUsersNum.text = _vpnInfo.online>0?_vpnInfo.connectNum:nil;
//    _backImageVIew.image = _vpnInfo.isConnected?[UIImage imageNamed:@"bg_purple_button"]:[UIImage imageNamed:@"bg_continue"];
//    _myVPNImgaeView.image = _vpnInfo.online>0?[UIImage imageNamed:@"icon_my_vpn"]:[UIImage imageNamed:@"icon_offiline_vpn"];
    // 主网暂时不能抢注
    BOOL isOwner = NO;
    if ([WalletUtil checkServerIsMian]) {
        isOwner = YES;
    } else {
        isOwner = [_vpnInfo.p2pId isEqualToString:[ToxManage getOwnP2PId]];
    }
//    _actionImageView.image = isOwner? [UIImage imageNamed:@"icon_seize"]:[UIImage imageNamed:@"icon_seize_two"];
//    _seizeBtn.userInteractionEnabled = !isOwner;
    UIImage *connectingImage = [UIImage imageNamed:@"icon_connection"];
    UIImage *notConnectImage = [UIImage imageNamed:@"icon_not_connected"];
    UIImage *connectedImage = [UIImage imageNamed:@"icon_complete"];
    [_connectBtn setImage:_vpnInfo.connectStatus==VpnConnectStatusNone?notConnectImage:_vpnInfo.connectStatus==VpnConnectStatusConnecting?connectingImage:connectedImage forState:UIControlStateNormal];
}

- (IBAction)connectAction:(UIButton *)sender {
    if (_connectClickB) {
        _connectClickB();
    }
}

//- (IBAction)clickSeize:(UIButton *)sender {
//
//    if (self.seizeBlock) {
//        self.seizeBlock(sender.tag);
//    }
//}

//- (IBAction)userConversationAction:(id)sender {
//    if (!_vpnInfo.online) { // 离线状态不能触发
//        return;
//    }
//    if (_conversationB) {
//        _conversationB();
//    }
//}


- (void)prepareForReuse {
    [super prepareForReuse];
    
    _ownerImageView.image = nil;
//    _statusImageView.image = nil;
    _vpnNameLab.text = nil;
    _priceLab.text = nil;
    _connectNumLab.text = nil;
    [_connectBtn setImage:nil forState:UIControlStateNormal];
}

@end
