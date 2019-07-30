//
//  HomeBuySellViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/8.
//  Copyright © 2019 pan. All rights reserved.
//

#import "HomeBuySellViewController.h"
#import "HomeBuySellCell.h"
#import "RefreshHelper.h"
#import "EntrustOrderListModel.h"
#import "NewOrderViewController.h"
#import "RecordListViewController.h"
#import "UIView+Gradient.h"
#import "BuySellDetailViewController.h"
#import "UserModel.h"
#import "VerificationViewController.h"
#import "VerifyTipView.h"

@interface HomeBuySellViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mainSeg;
@property (nonatomic, strong) NSArray *sourceArr;
@property (nonatomic, strong) NSMutableArray *buyArr;
@property (nonatomic, strong) NSMutableArray *sellArr;
@property (nonatomic) NSInteger currentBuyPage;
@property (nonatomic) NSInteger currentSellPage;

@end

@implementation HomeBuySellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.theme_backgroundColor = globalBackgroundColorPicker;
    
    [self configInit];
    [self requestEntrust_order_list];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (kAppD.pushToOrderList) {
        kAppD.pushToOrderList = NO;
        [self jumpToMyOrderList];
    }
}

#pragma mark - Operation
- (void)configInit {
    [self.view addQGradientWithStart:UIColorFromRGB(0x4986EE) end:UIColorFromRGB(0x4752E9) frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _currentBuyPage = 1;
    _currentSellPage = 1;
    _buyArr = [NSMutableArray array];
    _sellArr = [NSMutableArray array];
    _sourceArr = _buyArr;
    [_mainTable registerNib:[UINib nibWithNibName:HomeBuySellCellReuse bundle:nil] forCellReuseIdentifier:HomeBuySellCellReuse];
    
    kWeakSelf(self)
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        if (weakself.mainSeg.selectedSegmentIndex==0) {
            weakself.currentBuyPage=1;
        } else {
            weakself.currentSellPage=1;
        }
        [weakself requestEntrust_order_list];
    }];
    _mainTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestEntrust_order_list];
    }];
}

- (void)showVerifyTipView {
    VerifyTipView *view = [VerifyTipView getInstance];
    kWeakSelf(self);
    view.okBlock = ^{
        [weakself jumpToVerification];
    };
    [view showWithTitle:@"Please finish the verification on Me Page."];
}

#pragma mark - Request
- (void)requestEntrust_order_list {
    kWeakSelf(self);
    NSString *page = [NSString stringWithFormat:@"%li",weakself.mainSeg.selectedSegmentIndex==0?_currentBuyPage:_currentSellPage];
    NSString *size = @"20";
    NSString *type = _mainSeg.selectedSegmentIndex == 0?@"SELL":@"BUY";
    NSDictionary *params = @{@"userId":@"",@"type":type,@"page":page,@"size":size,@"status":@"NORMAL"};
    [RequestService requestWithUrl:entrust_order_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [EntrustOrderListModel mj_objectArrayWithKeyValuesArray:responseObject[@"orderList"]];
            if (weakself.mainSeg.selectedSegmentIndex == 0) {
                if (weakself.currentBuyPage == 1) {
                    [weakself.buyArr removeAllObjects];
                }
                
                [weakself.buyArr addObjectsFromArray:arr];
                weakself.sourceArr = weakself.buyArr;
                
                weakself.currentBuyPage += 1;
            } else {
                if (weakself.currentSellPage == 1) {
                    [weakself.sellArr removeAllObjects];
                }
                
                [weakself.sellArr addObjectsFromArray:arr];
                weakself.sourceArr = weakself.sellArr;
                
                weakself.currentSellPage += 1;
            }
            
            [weakself.mainTable reloadData];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeBuySellCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeBuySellCellReuse];
    
    EntrustOrderListModel *model = _sourceArr[indexPath.row];
    [cell config:model];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HomeBuySellCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EntrustOrderListModel *model = _sourceArr[indexPath.row];
    [self jumpToBuySellDetail:model];
}

#pragma mark - Action

- (IBAction)addAction:(id)sender {
    [self jumpToNewOrder];
}

- (IBAction)listAction:(id)sender {
    [self jumpToMyOrderList];
}

- (IBAction)segAction:(id)sender {
    if (_mainSeg.selectedSegmentIndex == 0) {
        if (_currentBuyPage == 1) {
            [self requestEntrust_order_list];
        } else {
            _sourceArr = _buyArr;
            [_mainTable reloadData];
        }
    } else {
        if (_currentSellPage == 1) {
            [self requestEntrust_order_list];
        } else {
            _sourceArr = _sellArr;
            [_mainTable reloadData];
        }
    }
}

#pragma mark - Transition
- (void)jumpToMyOrderList {
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (![userM.vStatus isEqualToString:@"KYC_SUCCESS"]) {
        [self showVerifyTipView];
        return;
    }
    
    RecordListViewController *vc = [RecordListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToNewOrder {
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (![userM.vStatus isEqualToString:@"KYC_SUCCESS"]) {
        [self showVerifyTipView];
        return;
    }
    
    NewOrderViewController *vc = [NewOrderViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToBuySellDetail:(EntrustOrderListModel *)model {
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (![userM.vStatus isEqualToString:@"KYC_SUCCESS"]) {
        [self showVerifyTipView];
        return;
    }
    
    BuySellDetailViewController *vc = [BuySellDetailViewController new];
    vc.inputEntrustOrderListM = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToVerification {
    VerificationViewController *vc = [VerificationViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
