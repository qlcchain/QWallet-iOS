//
//  XYDJViewController.m
//  StoryboardTest
//
//  Created by mxsm on 16/4/18.
//  Copyright © 2016年 mxsm. All rights reserved.
//

#import "ZXChatViewController.h"
#import "ZXChatBoxController.h"
#import "ZXChatMessageController.h"
#import "ZXMessageModel.h"
#import "TLUserHelper.h"
#import "UIView+TL.h"
#import "UIDevice+TL.h"
#import "ChatHeadView.h"
#import "ChatModel.h"
#import "UserManage.h"
#import "NSDate+Category.h"
#import "ChatUtil.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "ChatTipView.h"

#define SenderName @"Jim"

@interface ZXChatViewController ()<ZXChatMessageControllerDelegate,ZXChatBoxViewControllerDelegate>
{
    CGFloat viewHeight;
}

@property(nonatomic,strong)ZXChatMessageController * chatMessageVC;
@property(nonatomic,strong)ZXChatBoxController * chatBoxVC;

@end

@implementation ZXChatViewController

#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addGroupChatMessage:) name:ADD_GROUP_CHAT_MESSAGE_COMPLETE_NOTI object:nil];
}

#pragma mark - Life Cycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserve];
    
    // Do any additional setup after loading the view.
//    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.view.backgroundColor = MAIN_PURPLE_COLOR;
    
    // 主屏幕的高度减去导航的高度，减去状态栏的高度。在PCH头文件
//    viewHeight = HEIGHT_SCREEN - HEIGHT_NAVBAR - HEIGHT_STATUSBAR;
    viewHeight = HEIGHT_SCREEN - ChatHeadViewHeight - HEIGHT_STATUSBAR - HEIGHT_BOTTOM;

    [self.view addSubview:self.chatMessageVC.view];
    [self addChildViewController:self.chatMessageVC];
   
    [self.view addSubview:self.chatBoxVC.view];
    [self addChildViewController:self.chatBoxVC];
    
    [self showTipView];
    
    [self addHeadView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
}

#pragma mark - Config

- (void)addHeadView {
    @weakify_self
    ChatHeadView *chatHeadV = [ChatHeadView getNibView];
//    chatHeadV.backgroundColor = [UIColor clearColor];
    chatHeadV.backgroundColor = MAIN_PURPLE_COLOR;
    chatHeadV.title = ChatUtil.shareInstance.currentChatM.groupName.uppercaseString;
    chatHeadV.backB = ^{
        [weakSelf back];
    };
    [self.view addSubview:chatHeadV];
    [chatHeadV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view).offset(0);
        make.top.mas_equalTo(weakSelf.view).offset(HEIGHT_STATUSBAR);
        make.height.mas_equalTo(ChatHeadViewHeight);
    }];
}

- (void)showTipView {
    CGRect startFrame = CGRectMake(0, HEIGHT_STATUSBAR + ChatHeadViewHeight - ChatTipView_Height, SCREEN_WIDTH, ChatTipView_Height);
    CGRect endFrame = CGRectMake(0, HEIGHT_STATUSBAR + ChatHeadViewHeight, SCREEN_WIDTH, ChatTipView_Height);
    ChatTipView *tipV = [ChatTipView getNibView];
    tipV.frame = startFrame;
    [self.view addSubview:tipV];
    @weakify_self
    __weak typeof(tipV) weakTipV = tipV;
    [UIView animateWithDuration:.6 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakTipV.frame = endFrame;
    } completion:^(BOOL finished) {
        [weakSelf hideTipView:weakTipV frame:startFrame];
    }];
}

- (void)hideTipView:(ChatTipView *)tipV frame:(CGRect)frame {
    __weak typeof(tipV) weakTipV = tipV;
    [UIView animateWithDuration:.6 delay:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakTipV.frame = frame;
    } completion:^(BOOL finished) {
        [weakTipV removeFromSuperview];
    }];
}

#pragma mark - Operation

-(void)back {
    [self.chatBoxVC resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)getSenderId {
    NSString *p2pId = [ToxManage getOwnP2PId];
    return p2pId;
}

#pragma mark - Noti
- (void)addGroupChatMessage:(NSNotification *)noti {
    NSUInteger groupNum = [noti.object integerValue];
    if (ChatUtil.shareInstance.currentChatM.groupNum == groupNum) {
        [ChatUtil.shareInstance setChatRead:ChatUtil.shareInstance.currentChatM.assetName]; // 置为已读
        [self.chatMessageVC refreshNewMessage];
    }
}

/**
 * TLChatMessageViewControllerDelegate 的代理方法
 */
#pragma mark - TLChatMessageViewControllerDelegate
- (void) didTapChatMessageView:(ZXChatMessageController *)chatMessageViewController {
    [self.chatBoxVC resignFirstResponder];
}

/**
 * TLChatBoxViewControllerDelegate 的代理方法
 */
#pragma mark - TLChatBoxViewControllerDelegate
- (void)chatBoxViewController:(ZXChatBoxController *)chatboxViewController sendMessage:(ZXMessageModel *)message
{
    // TLMessage 发送的消息数据模型
//    message.from = [TLUserHelper sharedUserHelper].user;
    /**
     *  这个控制器添加了 chatMessageVC 这个控制器作为子控制器。在这个子控制器上面添加聊天消息的cell
     TLChatBox 的代理 TLChatBoxViewController 实现了它的代理方法
     TLChatBoxViewController 的代理 TLChatViewController 实现代理方法，去在其中的是子控制器更新消息
     */
//    [self.chatMessageVC addNewMessage:message];

    // 发送群聊消息
    NSString *messageTime = [NSString stringWithFormat:@"%@",@([NSDate getMillisecondTimestampFromDate:message.date])];
    NSString *assetName = ChatUtil.shareInstance.currentChatM.assetName?:@"";
    NSString *nickName = [UserManage.shareInstance getRandomName];
    NSDictionary *messageDic = @{@"assetName":assetName,@"p2pId":[self getSenderId],@"appVersion":APP_Build,@"avatar":[UserManage getHeadUrl],@"content":message.text,@"messageTime":messageTime,@"assetType":@"3",@"avatarUpdateTime":@"",@"nickName":nickName,@"messageType":@(ZXMessageTypeText)};
    NSString *sendMessage = messageDic.mj_JSONString;
    NSUInteger groupNum = ChatUtil.shareInstance.currentChatM.groupNum;
    DDLogDebug(@"发送聊天消息：%@  groupNum:%lu",sendMessage,(unsigned long)groupNum);
    
    // 添加本地消息
    message.senderId = [self getSenderId];
    message.senderDisplayName = nickName;
    message.message = sendMessage;
    message.groupnum = groupNum;
    [ChatUtil.shareInstance.currentChatM.messages addObject:message];
    [self.chatMessageVC refreshNewMessage];
    
    // 发送p2p消息
    [ToxManage sendMessageToGroupChat:groupNum message:sendMessage];
}

-(void)chatBoxViewController:(ZXChatBoxController *)chatboxViewController didChangeChatBoxHeight:(CGFloat)height
{
    /**
     *   改变BoxController .view 的高度 ，这采取的是重新设置 Frame 值！！
     */
    self.chatMessageVC.view.frameHeight = viewHeight - height;
    self.chatBoxVC.view.originY = self.chatMessageVC.view.originY + self.chatMessageVC.view.frameHeight;
    [self.chatMessageVC scrollToBottom:YES];
    
}

// 进set方法设置导航名字
#pragma mark - Getter and Setter
//-(void)setUser:(ZXUser *)user {
//    _user = user;
//    [self.navigationItem setTitle:user.username];
//}

/**
 *  两个聊天界面控制器
 */
-(ZXChatMessageController *)chatMessageVC {
    if (_chatMessageVC == nil) {
        _chatMessageVC = [[ZXChatMessageController  alloc] init];
        [_chatMessageVC.view setFrame:CGRectMake(0, ChatHeadViewHeight + HEIGHT_STATUSBAR, WIDTH_SCREEN, viewHeight - HEIGHT_CHATBOX)];// 0  状态 + 导航 宽 viweH - tabbarH
//        [_chatMessageVC.view setFrame:CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, WIDTH_SCREEN, viewHeight - HEIGHT_CHATBOX)];// 0  状态 + 导航 宽 viweH - tabbarH
        [_chatMessageVC setDelegate:self];// 代理
    }
    
    return _chatMessageVC;
}

-(ZXChatBoxController *) chatBoxVC
{
    if (_chatBoxVC == nil) {
        _chatBoxVC = [[ZXChatBoxController alloc] init];
//        [_chatBoxVC.view setFrame:CGRectMake(0, viewHeight - HEIGHT_CHATBOX, WIDTH_SCREEN, viewHeight)];
        [_chatBoxVC.view setFrame:CGRectMake(0, HEIGHT_SCREEN - HEIGHT_CHATBOX - HEIGHT_BOTTOM, WIDTH_SCREEN, HEIGHT_SCREEN)];
        [_chatBoxVC setDelegate:self];
    }
    
    return _chatBoxVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
