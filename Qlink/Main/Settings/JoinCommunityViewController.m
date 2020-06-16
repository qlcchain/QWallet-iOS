//
//  JoinCommunityViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/16.
//  Copyright © 2018 pan. All rights reserved.
//

#import "JoinCommunityViewController.h"
#import "JoinCommunityCell.h"
#import "WebViewController.h"
#import "FirebaseUtil.h"

static NSString *const JoinCommunity_Twitter = @"Twitter";
static NSString *const JoinCommunity_Telegram = @"Telegram";
static NSString *const JoinCommunity_Facebook = @"Facebook";
static NSString *const JoinCommunity_QLCChain = @"QLC Chain";

@interface JoinCommunityViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation JoinCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    _sourceArr = [NSMutableArray array];
    [_sourceArr addObjectsFromArray:@[@[@"icon_twitter_url",JoinCommunity_Twitter,@"twitter.com/QLCchain"],@[@"icon_telegram_url",JoinCommunity_Telegram,@"t.me/myqwallet"],@[@"icon_facebook_url",JoinCommunity_Facebook,@"www.facebook.com/QLCchain/"],@[@"icon_qlcchain_url",JoinCommunity_QLCChain,@"qlcchain.org/"]]];
    [_mainTable registerNib:[UINib nibWithNibName:JoinCommunityCellReuse bundle:nil] forCellReuseIdentifier:JoinCommunityCellReuse];
    self.baseTable = _mainTable;
    
    [self renderView];
    [self configInit];
}

#pragma mark - Operation
- (void)renderView {
    
}

- (void)configInit {
    
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JoinCommunityCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *arr = _sourceArr[indexPath.row];
    NSString *icon = arr[0];
    NSString *name = arr[1];
    NSString *url = arr[2];
    [self jumpToWeb:url title:name];
    
    if ([name isEqualToString:JoinCommunity_Twitter]) {
        [FirebaseUtil logEventWithItemID:Community_Twitter itemName:Community_Twitter contentType:Community_Twitter];
    } else if ([name isEqualToString:JoinCommunity_Telegram]) {
        [FirebaseUtil logEventWithItemID:Community_Telegram itemName:Community_Telegram contentType:Community_Telegram];
    } else if ([name isEqualToString:JoinCommunity_Facebook]) {
       [FirebaseUtil logEventWithItemID:Community_Facebook itemName:Community_Facebook contentType:Community_Facebook];
   } else if ([name isEqualToString:JoinCommunity_QLCChain]) {
          [FirebaseUtil logEventWithItemID:Community_QLC_Chain itemName:Community_QLC_Chain contentType:Community_QLC_Chain];
      }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JoinCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:JoinCommunityCellReuse];
    
    NSArray *arr = _sourceArr[indexPath.row];
    NSString *icon = arr[0];
    NSString *name = arr[1];
    NSString *url = arr[2];
    [cell configCellWithIcon:icon name:name url:url];
    
    return cell;
}

#pragma mark - Transition
- (void)jumpToWeb:(NSString *)url title:(NSString *)title {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.inputUrl = url;
    vc.inputTitle = title;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
