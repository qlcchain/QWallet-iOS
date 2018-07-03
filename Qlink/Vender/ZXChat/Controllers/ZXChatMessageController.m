//
//  ZXChatMessageController.m
//  ZXDNLLTest
//
//  Created by mxsm on 16/5/18.
//  Copyright © 2016年 mxsm. All rights reserved.
//  https://segmentfault.com/a/1190000002412930

#import "ZXChatMessageController.h"
#import "ZXTextMessageCell.h"
#import "ZXImageMessageCell.h"
#import "ZXVoiceMessageCell.h"
#import "ZXSystemMessageCell.h"
#import "ZXMessageModel.h"
#import "ZXChatViewController.h"
#import "UIView+TL.h"
#import "ChatUtil.h"
#import "ChatModel.h"

@interface ZXChatMessageController ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGR;


@end

@implementation ZXChatMessageController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:DEFAULT_CHAT_BACKGROUND_COLOR];
    /**
     *  给tableView添加一个手势，点击手势回收 ChatBoxController 的键盘。。
     */
    [self.view addGestureRecognizer:self.tapGR];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /**
     *  注册四个 cell
     */
    [self.tableView registerClass:[ZXTextMessageCell class] forCellReuseIdentifier:@"ZXTextMessageCell"];
    [self.tableView registerClass:[ZXImageMessageCell class] forCellReuseIdentifier:@"ZXImageMessageCell"];
    [self.tableView registerClass:[ZXVoiceMessageCell class] forCellReuseIdentifier:@"ZXVoiceMessageCell"];
    [self.tableView registerClass:[ZXSystemMessageCell class] forCellReuseIdentifier:@"ZXSystemMessageCell"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self scrollToBottom:NO];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Public Methods
- (void)refreshNewMessage {
    NSInteger count = ChatUtil.shareInstance.currentChatM.messages.count;
    //解决刷新tableView  reloadData时闪屏的bug
    self.tableView.hidden = YES;
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    if (count > 1){
        // 动画之前先滚动到倒数第二个消息
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count - 2 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    self.tableView.hidden = NO;
    
    [self scrollToBottom:YES];
}

- (void)scrollToBottom:(BOOL)animate {
    NSInteger count = ChatUtil.shareInstance.currentChatM.messages.count;
    NSInteger rowCount = [self.tableView numberOfRowsInSection:0];
    if (count > 0 && count <= rowCount) {
        // 添加向上顶出最后一个消息的动画
        NSIndexPath *bottomIndexP = [NSIndexPath indexPathForRow:count - 1 inSection:0];
        UITableViewScrollPosition position = UITableViewScrollPositionBottom;
        [self.tableView scrollToRowAtIndexPath:bottomIndexP atScrollPosition:position animated:animate];
    }
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = ChatUtil.shareInstance.currentChatM.messages.count;
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *messageArr = ChatUtil.shareInstance.currentChatM.messages;
    ZXMessageModel *messageModel = messageArr[indexPath.row];
    /**
     *  id类型的cell 通过取出来Model的类型，判断要显示哪一种类型的cell
     */
    id cell = [tableView dequeueReusableCellWithIdentifier:messageModel.cellIndentify forIndexPath:indexPath];
    // 给cell赋值
    [cell setMessageModel:messageModel];
    return cell;
    
}

#pragma mark - UITableViewCellDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *messageArr = ChatUtil.shareInstance.currentChatM.messages;
    ZXMessageModel *message = messageArr[indexPath.row];
    if ([message.cellIndentify isEqualToString:@"ZXTextMessageCell"]) {
        return [ZXTextMessageCell getCellHeight:message];
    }
    return 0;
}

#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (_delegate && [_delegate respondsToSelector:@selector(didTapChatMessageView:)]) {
//        
//        [_delegate didTapChatMessageView:self];
//        
//    }
}

#pragma mark - Event Response
- (void) didTapView
{
    if (_delegate && [_delegate respondsToSelector:@selector(didTapChatMessageView:)]) {
       
        [_delegate didTapChatMessageView:self];
        
    }
    
}

#pragma mark - Getter
- (UITapGestureRecognizer *) tapGR
{
    if (_tapGR == nil) {
        _tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView)];
    }
    return _tapGR;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
