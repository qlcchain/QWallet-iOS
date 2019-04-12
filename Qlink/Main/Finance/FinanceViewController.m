//
//  FinanceViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/8.
//  Copyright © 2019 pan. All rights reserved.
//

#import "FinanceViewController.h"
#import "MyThemes.h"
#import "FinanceCell.h"
#import "FinanceProductModel.h"
#import "MyPortfolioViewController.h"
#import "FinanceProductDetailViewController.h"
#import "Qlink-Swift.h"

@interface FinanceViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *productArr;

@end

@implementation FinanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.theme_backgroundColor = globalBackgroundColorPicker;

    _productArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:FinanceCellReuse bundle:nil] forCellReuseIdentifier:FinanceCellReuse];
    
    [self configInit];
    [self requestProduct_list];
}

#pragma mark - Operation
- (void)configInit {
    
}

#pragma mark - Request
// 产品列表
- (void)requestProduct_list {
    kWeakSelf(self);
    NSString *page = @"1";
    NSString *size = @"20";
    NSDictionary *params = @{@"page":page,@"size":size};
    [RequestService requestWithUrl:product_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [FinanceProductModel mj_objectArrayWithKeyValuesArray:responseObject[Server_Data]];
            [weakself.productArr removeAllObjects];
            [weakself.productArr addObjectsFromArray:arr];
            [weakself.mainTable reloadData];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - Action

//- (IBAction)switchThemeAction:(id)sender {
//    [MyThemes switchToNext];
//}
- (IBAction)myPortfolioAction:(id)sender {
    [self jumpToMyPortfolio];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FinanceCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FinanceProductModel *model = _productArr[indexPath.row];
    [self jumpToProductDetail:model];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _productArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FinanceCell *cell = [tableView dequeueReusableCellWithIdentifier:FinanceCellReuse];
    
    FinanceProductModel *model = _productArr[indexPath.row];
    [cell configCell:model];
    
    return cell;
}

#pragma mark - Transition
- (void)jumpToMyPortfolio {
    BOOL haveDefaultNEOWallet = [NEOWalletManage.sharedInstance haveDefaultWallet];
    if (!haveDefaultNEOWallet) {
        [kAppD.window makeToastDisappearWithText:@"Please choose a NEO wallet first"];
        return;
    }
    
    MyPortfolioViewController *vc = [MyPortfolioViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToProductDetail:(FinanceProductModel *)model {
    BOOL haveDefaultNEOWallet = [NEOWalletManage.sharedInstance haveDefaultWallet];
    if (!haveDefaultNEOWallet) {
        [kAppD.window makeToastDisappearWithText:@"Please choose a NEO wallet first"];
        return;
    }
    
    FinanceProductDetailViewController *vc = [FinanceProductDetailViewController new];
    vc.inputM = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
