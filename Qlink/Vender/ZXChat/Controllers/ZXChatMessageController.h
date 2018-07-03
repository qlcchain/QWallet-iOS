//
//  ZXChatMessageController.h
//  ZXDNLLTest
//
//  Created by mxsm on 16/5/18.
//  Copyright © 2016年 mxsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXMessageModel.h"
///
@class ZXChatMessageController;
@protocol ZXChatMessageControllerDelegate <NSObject>

- (void) didTapChatMessageView:(ZXChatMessageController *)chatMessageViewController;

@end

@interface ZXChatMessageController : UITableViewController

@property (nonatomic, weak) id <ZXChatMessageControllerDelegate> delegate;

- (void)refreshNewMessage;

/**
 *   添加一条消息就让tableView滑动
 */
//- (void) scrollToBottom;
- (void)scrollToBottom:(BOOL)animate;


@end
