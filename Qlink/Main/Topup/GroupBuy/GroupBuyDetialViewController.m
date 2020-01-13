//
//  GroupBuyDetialViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/1/13.
//  Copyright © 2020 pan. All rights reserved.
//

#import "GroupBuyDetialViewController.h"
#import "OngoingGroupCell.h"
#import "OngoingGroupViewController.h"

@interface GroupBuyDetialViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (weak, nonatomic) IBOutlet UITableView *groupTable;


@end

@implementation GroupBuyDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
    _sourceArr = [NSMutableArray array];
    [_groupTable registerNib:[UINib nibWithNibName:OngoingGroupCell_Reuse bundle:nil] forCellReuseIdentifier:OngoingGroupCell_Reuse];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return OngoingGroupCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
//    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OngoingGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:OngoingGroupCell_Reuse];
    
    [cell config];
    
    return cell;
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ongoingCheckAllAction:(id)sender {
    [self jumpToOngoingGroup];
}


#pragma mark - Transition
- (void)jumpToOngoingGroup {
    OngoingGroupViewController *vc = [OngoingGroupViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
