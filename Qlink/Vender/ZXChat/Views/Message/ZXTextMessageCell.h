//
//  ZXTextMessageCell.h
//  ZXDNLLTest
//
//  Created by mxsm on 16/5/18.
//  Copyright © 2016年 mxsm. All rights reserved.
//

#import "ZXMessageCell.h"

@class ZXMessageModel;

@interface ZXTextMessageCell : ZXMessageCell

@property (nonatomic, strong) UILabel *messageTextLabel;
@property (nonatomic, strong) UILabel *messageNameLabel;
@property (nonatomic, strong) UILabel *messageTimeLabel;

+ (CGFloat)getCellHeight:(ZXMessageModel *)messageModel;

@end
