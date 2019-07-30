//
//  InviteRankingViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "InviteRankingViewController.h"
#import "InviteRankingCell.h"
#import "InviteRankingModel.h"

@interface InviteRankingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation InviteRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self requestInvite_rankings];
}

#pragma mark - Operation
- (void)configInit {
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:InviteRankingCellReuse bundle:nil] forCellReuseIdentifier:InviteRankingCellReuse];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Request
// 邀请排行
- (void)requestInvite_rankings {
    kWeakSelf(self)
    NSString *page = @"1";
    NSString *size = @"20";
    NSDictionary *params = @{@"page":page,@"size":size};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:invite_rankings_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [InviteRankingModel mj_objectArrayWithKeyValuesArray:responseObject[Server_Data]];
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
    return InviteRankingCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InviteRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:InviteRankingCellReuse];
    
    InviteRankingModel *model = _sourceArr[indexPath.row];
    [cell configCell:model];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
