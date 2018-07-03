//
//  ChatTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/5/10.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "ChatTipView.h"

@implementation ChatTipView

+ (ChatTipView *)getNibView {
    ChatTipView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"ChatTipView" owner:self options:nil] firstObject];
    
    return nibView;
}

@end
