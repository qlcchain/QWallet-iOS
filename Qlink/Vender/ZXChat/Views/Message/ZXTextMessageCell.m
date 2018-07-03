//
//  ZXTextMessageCell.m
//  ZXDNLLTest
//
//  Created by mxsm on 16/5/18.
//  Copyright © 2016年 mxsm. All rights reserved.
//

#import "ZXTextMessageCell.h"
#import "UIView+TL.h"
#import "NSDate+Category.h"
#import "UIDevice+TL.h"

#define OffsetOfLab 4

@implementation ZXTextMessageCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.backgroundColor = [UIColor RandomColor];
        
        [self addSubview:self.messageNameLabel];
        [self addSubview:self.messageTextLabel];
        [self addSubview:self.messageTimeLabel];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    float offsetOfAvatarAndBack = 10;
    float offsetOfBackAndText = 20;
    
    float y = self.avatarImageView.originY + 5;
    float w = MAX(MAX(self.messageTextLabel.frameWidth + offsetOfBackAndText*2, self.messageNameLabel.frameWidth + offsetOfBackAndText*2), self.messageTimeLabel.frameWidth + offsetOfBackAndText*2);
//    float x = self.avatarImageView.originX + (self.messageModel.ownerTyper == ZXMessageOwnerTypeSelf ? - self.messageTextLabel.frameWidth - 27 : self.avatarImageView.frameWidth + 23);
    float x = self.avatarImageView.originX + (self.messageModel.ownerTyper == ZXMessageOwnerTypeSelf ? - w - offsetOfAvatarAndBack + offsetOfBackAndText : self.avatarImageView.frameWidth + offsetOfBackAndText + offsetOfAvatarAndBack);
    
    // Name
//    float nameX = self.messageModel.ownerTyper == ZXMessageOwnerTypeSelf ? self.avatarImageView.originX - offsetOfAvatarAndBack - offsetOfBackAndText - self.messageNameLabel.frameWidth : x;
    self.messageNameLabel.origin = CGPointMake(x, y);

    // Text
    y = self.messageNameLabel.originY + self.messageNameLabel.frameHeight + OffsetOfLab;
    [self.messageTextLabel setOrigin:CGPointMake(x, y)];
    
    // Time
//    float timeX = self.messageModel.ownerTyper == ZXMessageOwnerTypeSelf ? self.avatarImageView.originX - offsetOfAvatarAndBack - offsetOfBackAndText - self.messageTimeLabel.frameWidth : x;
    y = self.messageTextLabel.originY + self.messageTextLabel.frameHeight + OffsetOfLab;
    self.messageTimeLabel.origin = CGPointMake(x, y);
    
    // 背景
//    x -= 18;                                    // 左边距离头像 5
    y = self.avatarImageView.originY - 5;       // 上边与头像对齐 (北京图像有5个像素偏差)
//    float h = MAX(self.messageTextLabel.frameHeight + 30, self.avatarImageView.frameHeight + 10);
    float h = MAX(self.messageNameLabel.frameHeight + OffsetOfLab + self.messageTextLabel.frameHeight + OffsetOfLab + self.messageTimeLabel.frameHeight + 20, self.avatarImageView.frameHeight + 10);
    x = x - offsetOfBackAndText;
    [self.messageBackgroundImageView setFrame:CGRectMake(x, y, w, h)];
}

+ (CGFloat)getCellHeight:(ZXMessageModel *)messageModel {
    CGFloat height = MAX(messageModel.messageNameSize.height + OffsetOfLab + messageModel.messageTextSize.height + OffsetOfLab + messageModel.messageTimeSize.height + 20, Avatar_Height + 10) + 5;
    return height;
}

#pragma mark - Getter and Setter
-(void)setMessageModel:(ZXMessageModel *)messageModel
{
    [super setMessageModel:messageModel];
    
//    [_messageTextLabel setAttributedText:messageModel.attrText];
    [_messageTextLabel setText:messageModel.text];
    _messageTextLabel.size = messageModel.messageTextSize;
    _messageTextLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
    if (messageModel.ownerTyper == ZXMessageOwnerTypeSelf) {
        _messageTextLabel.textColor = [UIColor whiteColor];
    } else {
        _messageTextLabel.textColor = UIColorFromRGB(0x333333);
    }
    
    _messageNameLabel.text = messageModel.senderDisplayName;
    _messageNameLabel.size = messageModel.messageNameSize;
    if (messageModel.ownerTyper == ZXMessageOwnerTypeSelf) {
        _messageNameLabel.textColor = [UIColor whiteColor];
    } else {
        _messageNameLabel.textColor = MAIN_PURPLE_COLOR;
    }
    
    NSDictionary *messageDic = messageModel.message.mj_JSONObject;
    NSString *messageTime = messageDic[@"messageTime"];
    NSString *timeStr = [NSDate getTimeWithTimestamp:messageTime format:MMddHHmm isMil:YES];
    _messageTimeLabel.text = timeStr;
    _messageTimeLabel.size = messageModel.messageTimeSize;
    if (messageModel.ownerTyper == ZXMessageOwnerTypeSelf) {
        _messageTimeLabel.textColor = UIColorFromRGB(0xdddddd);
    } else {
        _messageTimeLabel.textColor = UIColorFromRGB(0x555555);
    }
}

- (UILabel *) messageTextLabel
{
    if (_messageTextLabel == nil) {
        _messageTextLabel = [[UILabel alloc] init];
        [_messageTextLabel setFont:[UIFont systemFontOfSize:MessageTextLab_FontSize]];
        [_messageTextLabel setNumberOfLines:0];
    }
    return _messageTextLabel;
}

- (UILabel *)messageNameLabel {
    if (!_messageNameLabel) {
        _messageNameLabel = [UILabel new];
        _messageNameLabel.font = [UIFont systemFontOfSize:MessageNameLab_FontSize];
    }
    return _messageNameLabel;
}

- (UILabel *)messageTimeLabel {
    if (!_messageTimeLabel) {
        _messageTimeLabel = [UILabel new];
        _messageTimeLabel.font = [UIFont systemFontOfSize:MessageTimeLab_FontSize];
    }
    return _messageTimeLabel;
}


@end
