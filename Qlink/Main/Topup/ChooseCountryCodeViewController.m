//
//  ChooseCountryCodeViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/12/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ChooseCountryCodeViewController.h"
#import "TopupCountryModel.h"
#import "ChooseCountryCodeCell.h"
#import "RefreshHelper.h"

static NSString * const NetworkSize = @"20";

@interface ChooseCountryCodeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger selectIndex;

@end

@implementation ChooseCountryCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self requestTopup_country_list];
}

#pragma mark - Operation
- (void)configInit {
    _selectIndex = -1;
    _currentPage = 1;
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:ChooseCountryCodeCellReuse bundle:nil] forCellReuseIdentifier:ChooseCountryCodeCellReuse];
    self.baseTable = _mainTable;
    
    [self configRefresh];
    
}

- (void)configRefresh {
    kWeakSelf(self)
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = 1;
        [weakself requestTopup_country_list];
    }];
    _mainTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestTopup_country_list];
    }];
}

#pragma mark - Request
- (void)requestTopup_country_list {
    kWeakSelf(self);
    NSString *page = [NSString stringWithFormat:@"%li",_currentPage];
    NSString *size = NetworkSize;
    NSDictionary *params = @{@"page":page,@"size":size};
    [RequestService requestWithUrl10:topup_country_list_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [TopupCountryModel mj_objectArrayWithKeyValuesArray:responseObject[@"countryList"]];
            if (weakself.currentPage == 1) {
                [weakself.sourceArr removeAllObjects];
            }
            
            weakself.currentPage += 1;
            
            [weakself.sourceArr addObjectsFromArray:arr];
            [weakself.mainTable reloadData];
            
            if (arr.count < [NetworkSize integerValue]) {
                [weakself.mainTable.mj_footer endRefreshingWithNoMoreData];
//                weakself.mainTable.mj_footer.hidden = arr.count<=0?YES:NO;
                weakself.mainTable.mj_footer.hidden = YES;
            } else {
                weakself.mainTable.mj_footer.hidden = NO;
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {

    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ChooseCountryCodeCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectIndex = indexPath.row;
    
    TopupCountryModel *model = _sourceArr[indexPath.row];
    if (_resultB) {
        _resultB(model);
    }
    
    [self backAction:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseCountryCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:ChooseCountryCodeCellReuse];
    
    TopupCountryModel *model = _sourceArr[indexPath.row];
    
    BOOL isSelect = NO;
    if (_inputCountryCode) {
        if ([model.globalRoaming isEqualToString:_inputCountryCode]) {
            isSelect = YES;
            _selectIndex = indexPath.row;
        }
    }
    
    [cell config:model isSelect:isSelect];
    
    return cell;
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
