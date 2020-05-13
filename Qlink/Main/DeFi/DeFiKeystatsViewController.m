//
//  DeFiKeystatsViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DeFiKeystatsViewController.h"
#import "DeFiKeystatsCell.h"
#import "RefreshHelper.h"
#import "DefiProjectListModel.h"
#import "DefiHistoricalStatsListModel.h"
#import "DefiProjectModel.h"

static NSString *const NetworkSize = @"30";

@interface DeFiKeystatsViewController () <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UILabel *lockedLab;

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic) NSInteger currentPage;

@end

@implementation DeFiKeystatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
    _currentPage = 1;
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:DeFiKeystatsCell_Reuse bundle:nil] forCellReuseIdentifier:DeFiKeystatsCell_Reuse];
    self.baseTable = _mainTable;
    
    _lockedLab.text = kLang(@"defi_total_value_locked");

}

- (void)refreshView:(NSArray *)arr {
    [_sourceArr removeAllObjects];
    [_sourceArr addObjectsFromArray:arr];
    [_mainTable reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeFiKeystatsCell *cell = [tableView dequeueReusableCellWithIdentifier:DeFiKeystatsCell_Reuse];
    
    DefiProject_KeyModel *model = _sourceArr[indexPath.row];
    [cell config:model];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DeFiKeystatsCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
