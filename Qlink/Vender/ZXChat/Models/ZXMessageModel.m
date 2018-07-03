//
//  ZXMessageModel.m
//  ZXDNLLTest
//
//  Created by mxsm on 16/5/18.
//  Copyright © 2016年 mxsm. All rights reserved.
//

#import "ZXMessageModel.h"
#import "ZXChatHelper.h"
#import "UIDevice+TL.h"
#import "NSDate+Category.h"

static UILabel *messageTextLab = nil;
static UILabel *messageNameLab = nil;
static UILabel *messageTimeLab = nil;

@implementation ZXMessageModel


-(id)init
{
    if (self = [super init]) {
        
        if (messageTextLab == nil) {
            messageTextLab = [[UILabel alloc] init];
            [messageTextLab setNumberOfLines:0];
            [messageTextLab setFont:[UIFont systemFontOfSize:MessageTextLab_FontSize]];
        }
        
        if (messageNameLab == nil) {
            messageNameLab = [[UILabel alloc] init];
            [messageNameLab setFont:[UIFont systemFontOfSize:MessageNameLab_FontSize]];
        }
        
        if (messageTimeLab == nil) {
            messageTimeLab = [[UILabel alloc] init];
            [messageTimeLab setFont:[UIFont systemFontOfSize:MessageTimeLab_FontSize]];
        }
    }
    
    return self;
}

#pragma mark - Setter
-(void) setText:(NSString *)text
{
    _text = text;
    if (text.length > 0) {
        
        _attrText = [ZXChatHelper formatMessageString:text];
        
    }
}

#pragma mark - Getter
- (void) setMessageType:(ZXMessageType)messageType
{
    
    _messageType = messageType;
    switch (messageType) {
        case ZXMessageTypeText:
            self.cellIndentify = @"ZXTextMessageCell";
            break;
        case ZXMessageTypeImage:
            self.cellIndentify = @"ZXImageMessageCell";
            break;
        case ZXMessageTypeVoice:
            self.cellIndentify = @"ZXVoiceMessageCell";
            break;
        case ZXMessageTypeSystem:
            self.cellIndentify = @"ZXSystemMessageCell";
            break;
        default:
            break;
    }
}


-(CGSize) messageTextSize
{
    switch (self.messageType) {
            
        case ZXMessageTypeText:
        {
            [messageTextLab setAttributedText:self.attrText];
            [messageNameLab setText:self.senderDisplayName];
            NSDictionary *messageDic = self.message.mj_JSONObject;
            NSString *messageTime = messageDic[@"messageTime"];
            NSString *timeStr = [NSDate getTimeWithTimestamp:messageTime format:MMddHHmm isMil:YES];
            [messageTimeLab setText:timeStr];
            _messageTextSize = [messageTextLab sizeThatFits:CGSizeMake(WIDTH_SCREEN * 0.58, MAXFLOAT)];
            _messageNameSize = [messageNameLab sizeThatFits:CGSizeMake(WIDTH_SCREEN * 0.58, 18)];
//            if (self.ownerTyper == ZXMessageOwnerTypeSelf) {
//                _messageNameSize.height = 0;
//            }
            _messageTimeSize = [messageTimeLab sizeThatFits:CGSizeMake(WIDTH_SCREEN * 0.58, 18)];
        }
            break;
            
        case ZXMessageTypeImage:
        {
            NSString *path = [NSString stringWithFormat:@"%@/%@", PATH_CHATREC_IMAGE, self.imagePath];
            _image = [UIImage imageNamed:path];
            if (_image != nil) {
                _messageTextSize = (_image.size.width > WIDTH_SCREEN * 0.5 ? CGSizeMake(WIDTH_SCREEN * 0.5, WIDTH_SCREEN * 0.5 / _image.size.width * _image.size.height) : _image.size);
                _messageTextSize = (_messageTextSize.height > 60 ? (_messageTextSize.height < 200 ? _messageTextSize : CGSizeMake(_messageTextSize.width, 200)) : CGSizeMake(60.0 / _messageTextSize.height * _messageTextSize.width, 60));
            }
            else {
                _messageTextSize = CGSizeMake(0, 0);
            }
            break;
        }
        case ZXMessageTypeVoice:
            break;
            
        case ZXMessageTypeSystem:
            break;
            
        default:
            break;
    }
    
    return _messageTextSize;
}

- (NSString *)cellIndentify {
    if (!_cellIndentify) {
        _cellIndentify = @"ZXTextMessageCell";
    }
    return _cellIndentify;
}

//-(CGFloat) cellHeight
//{
//    
//    switch (self.messageType){
//            // cell 上下间隔为10
//        case ZXMessageTypeText:
//            
//            return self.messageSize.height + 40 > 60 ? self.messageSize.height + 40 : 60;
//            break;
//            
//        case ZXMessageTypeImage:
//            
//            return self.messageSize.height + 20;
//            break;
//            
//        default:
//            
//            break;
//    }
//    
//    return 0;
//}

@end
