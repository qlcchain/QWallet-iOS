//
//  EarningsRankingViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "EarningsRankingViewController.h"
#import "EarningRankingCell.h"
#import "EarningsRankingModel.h"

@interface EarningsRankingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation EarningsRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self configInit];
    [self requestRich_list];
}

#pragma mark - Operation
- (void)configInit {
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:EarningRankingCellReuse bundle:nil] forCellReuseIdentifier:EarningRankingCellReuse];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)viewMyEarningsAction:(id)sender {
    
}

#pragma mark - Request
// 财富排行
- (void)requestRich_list {
    kWeakSelf(self)
    NSString *page = @"1";
    NSString *size = @"20";
    NSDictionary *params = @{@"page":page,@"size":size};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:rich_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [EarningsRankingModel mj_objectArrayWithKeyValuesArray:responseObject[Server_Data]];
            [weakself.sourceArr removeAllObjects];
            [weakself.sourceArr addObjectsFromArray:arr];
            [weakself.mainTable reloadData];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return EarningRankingCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EarningRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:EarningRankingCellReuse];
    
    EarningsRankingModel *model = _sourceArr[indexPath.row];
    [cell configCell:model];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end