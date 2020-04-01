//
//  ChooseDeductionTokenViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/2/11.
//  Copyright © 2020 pan. All rights reserved.
//

#import "ChooseDeductionTokenViewController.h"
#import "TopupDeductionTokenModel.h"
#import "ChooseTokenCell.h"

@interface ChooseDeductionTokenViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation ChooseDeductionTokenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self requestTopup_pay_token];
}

#pragma mark - Operation
- (void)configInit {
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:ChooseTokenCell_Reuse bundle:nil] forCellReuseIdentifier:ChooseTokenCell_Reuse];
    self.baseTable = _mainTable;
}

#pragma mark - Request
- (void)requestTopup_pay_token {
    kWeakSelf(self);
    NSDictionary *params = @{};
    [RequestService requestWithUrl10:topup_pay_token_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [weakself.sourceArr removeAllObjects];
            NSArray *arr = [TopupDeductionTokenModel mj_objectArrayWithKeyValuesArray:responseObject[@"payTokenList"]];
            [weakself.sourceArr addObjectsFromArray:arr];
            [weakself.mainTable reloadData];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ChooseTokenCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TopupDeductionTokenModel *model = _sourceArr[indexPath.row];
    if (_completeBlock) {
        _completeBlock(model);
    }
    [self backAction:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseTokenCell *cell = [tableView dequeueReusableCellWithIdentifier:ChooseTokenCell_Reuse];
    
    TopupDeductionTokenModel *model = _sourceArr[indexPath.row];
    [cell config:model];
    
    return cell;
}

@end
