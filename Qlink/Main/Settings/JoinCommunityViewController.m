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
    [_sourceArr addObjectsFromArray:@[@[@"icon_twitter_url",@"Twitter",@"twitter.com/QLCchain"],@[@"icon_telegram_url",@"Telegram",@"t.me/qlinkmobile"],@[@"icon_facebook_url",@"Facebook",@"www.facebook.com/QLCchain/"],@[@"icon_qlcchain_url",@"QLC Chain",@"qlcchain.org/"]]];
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
