//
//  MyOrderListViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/8.
//  Copyright © 2019 pan. All rights reserved.
//

#import "RecordListViewController.h"
#import "MyOrderListEntrustCell.h"
#import "MyOrderListTradeCell.h"
#import "RefreshHelper.h"
#import "NSDate+Category.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import "TradeOrderListModel.h"
#import "EntrustOrderListModel.h"
#import "TradeOrderDetailViewController.h"
#import "EntrustOrderDetailViewController.h"
#import "PairsModel.h"
//#import "GlobalConstants.h"

@interface RecordListViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    BOOL needRefreshSlider;
}

// Posted
@property (weak, nonatomic) IBOutlet UIButton *postedBtn;
@property (weak, nonatomic) IBOutlet UITableView *postedTable;

// Processing
@property (weak, nonatomic) IBOutlet UIButton *processingBtn;
@property (weak, nonatomic) IBOutlet UITableView *processingTable;

// Completed
@property (weak, nonatomic) IBOutlet UIButton *completedBtn;
@property (weak, nonatomic) IBOutlet UITableView *completedTable;

// Closed
@property (weak, nonatomic) IBOutlet UIButton *closedBtn;
@property (weak, nonatomic) IBOutlet UITableView *closedTable;

// Appealed
@property (weak, nonatomic) IBOutlet UIButton *appealedBtn;
@property (weak, nonatomic) IBOutlet UITableView *appealedTable;

@property (weak, nonatomic) IBOutlet UIView *sliderV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainScrollWidth;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;

@property (nonatomic, strong) NSMutableArray *postedArr;
@property (nonatomic) NSInteger postedPage;
@property (nonatomic, strong) NSMutableArray *processingArr;
@property (nonatomic) NSInteger processingPage;
@property (nonatomic, strong) NSMutableArray *completedArr;
@property (nonatomic) NSInteger completedPage;
@property (nonatomic, strong) NSMutableArray *closedArr;
@property (nonatomic) NSInteger closedPage;
@property (nonatomic, strong) NSMutableArray *appealedArr;
@property (nonatomic) NSInteger appealedPage;
@property (nonatomic) RecordListType recordListType;


@end

@implementation RecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    needRefreshSlider = YES;
    [self configInit];
    [self requestEntrust_order_list];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (needRefreshSlider) {
        needRefreshSlider = NO;
        [self refreshSelect:_postedBtn];
    }
}

#pragma mark - Operation
- (void)configInit {
    _mainScrollWidth.constant = SCREEN_WIDTH*5;
    _postedArr = [NSMutableArray array];
    _postedPage = 1;
    _processingArr = [NSMutableArray array];
    _processingPage = 1;
    _completedArr = [NSMutableArray array];
    _completedPage = 1;
    _closedArr = [NSMutableArray array];
    _closedPage = 1;
    _appealedArr = [NSMutableArray array];
    _appealedPage = 1;
    _postedBtn.selected = YES;
    _recordListType = RecordListTypePosted;
    
    kWeakSelf(self)
    [_postedTable registerNib:[UINib nibWithNibName:MyOrderListEntrustCellReuse bundle:nil] forCellReuseIdentifier:MyOrderListEntrustCellReuse];
    _postedTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.postedPage = 1;
        [weakself requestEntrust_order_list];
    }];
    _postedTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestEntrust_order_list];
    }];
    [_processingTable registerNib:[UINib nibWithNibName:MyOrderListTradeCellReuse bundle:nil] forCellReuseIdentifier:MyOrderListTradeCellReuse];
    _processingTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.processingPage = 1;
        [weakself requestTrade_order_list];
    }];
    _processingTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestTrade_order_list];
    }];
    [_completedTable registerNib:[UINib nibWithNibName:MyOrderListTradeCellReuse bundle:nil] forCellReuseIdentifier:MyOrderListTradeCellReuse];
    _completedTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.completedPage = 1;
        [weakself requestTrade_order_list];
    }];
    _completedTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestTrade_order_list];
    }];
    [_closedTable registerNib:[UINib nibWithNibName:MyOrderListTradeCellReuse bundle:nil] forCellReuseIdentifier:MyOrderListTradeCellReuse];
    _closedTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.closedPage = 1;
        [weakself requestTrade_order_list];
    }];
    _closedTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestTrade_order_list];
    }];
    [_appealedTable registerNib:[UINib nibWithNibName:MyOrderListTradeCellReuse bundle:nil] forCellReuseIdentifier:MyOrderListTradeCellReuse];
    _appealedTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.appealedPage = 1;
        [weakself requestTrade_order_list];
    }];
    _appealedTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestTrade_order_list];
    }];
}

- (void)refreshSelect:(UIButton *)sender {
    _postedBtn.selected = sender==_postedBtn?YES:NO;
    _processingBtn.selected = sender==_processingBtn?YES:NO;
    _completedBtn.selected = sender==_completedBtn?YES:NO;
    _closedBtn.selected = sender==_closedBtn?YES:NO;
    _appealedBtn.selected = sender==_appealedBtn?YES:NO;
    if (sender == _postedBtn) {
        _recordListType = RecordListTypePosted;
    } else if (sender == _processingBtn) {
        _recordListType = RecordListTypeProcessing;
    } else if (sender == _completedBtn) {
        _recordListType = RecordListTypeCompleted;
    } else if (sender == _closedBtn) {
        _recordListType = RecordListTypeClosed;
    } else if (sender == _appealedBtn) {
        _recordListType = RecordListTypeAppealed;
    }
    kWeakSelf(self);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakself.sliderV.frame = CGRectMake(0, sender.height, sender.width, 2);
        weakself.sliderV.center = CGPointMake(sender.center.x, sender.height+1);
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_postedBtn.selected) {
        return _postedArr.count;
    } else if (_processingBtn.selected) {
        return _processingArr.count;
    } else if (_completedBtn.selected) {
        return _completedArr.count;
    } else if (_appealedBtn.selected) {
        return _appealedArr.count;
    } else if (_closedBtn.selected) {
        return _closedArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_postedBtn.selected) {
        MyOrderListEntrustCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderListEntrustCellReuse];
        
        EntrustOrderListModel *model = _postedArr[indexPath.row];
        [cell config:model];
        
        return cell;
    } else if (_processingBtn.selected) {
        MyOrderListTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderListTradeCellReuse];
        
        TradeOrderListModel *model = _processingArr[indexPath.row];
        [cell config:model type:RecordListTypeProcessing];
        
        return cell;
    } else if (_completedBtn.selected) {
        MyOrderListTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderListTradeCellReuse];
        
        TradeOrderListModel *model = _completedArr[indexPath.row];
        [cell config:model type:RecordListTypeCompleted];
        
        return cell;
    } else if (_appealedBtn.selected) {
        MyOrderListTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderListTradeCellReuse];
        
        TradeOrderListModel *model = _appealedArr[indexPath.row];
        [cell config:model type:RecordListTypeAppealed];
        
        return cell;
    } else if (_closedBtn.selected) {
        MyOrderListTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderListTradeCellReuse];
        
        TradeOrderListModel *model = _closedArr[indexPath.row];
        [cell config:model type:RecordListTypeClosed];
        
        return cell;
    }
    
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_postedBtn.selected) {
        return MyOrderListEntrustCell_Height;
    } else if (_processingBtn.selected) {
        return MyOrderListTradeCell_Height;
    } else if (_completedBtn.selected) {
        return MyOrderListTradeCell_Height;
    } else if (_appealedBtn.selected) {
        return MyOrderListTradeCell_Height;
    } else if (_closedBtn.selected) {
        return MyOrderListTradeCell_Height;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_postedBtn.selected) {
        EntrustOrderListModel *model = _postedArr[indexPath.row];
        [self jumpToEntrustOrderDetail:model.ID];
    } else if (_processingBtn.selected) {
        TradeOrderListModel *model = _processingArr[indexPath.row];
        [self jumpToOrderDetail:model.ID];
    } else if (_completedBtn.selected) {
        TradeOrderListModel *model = _completedArr[indexPath.row];
        [self jumpToOrderDetail:model.ID];
    } else if (_appealedBtn.selected) {
        TradeOrderListModel *model = _appealedArr[indexPath.row];
        [self jumpToOrderDetail:model.ID];
    } else if (_closedBtn.selected) {
        TradeOrderListModel *model = _closedArr[indexPath.row];
        [self jumpToOrderDetail:model.ID];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _mainScroll) {
        CGFloat offset = _mainScroll.contentOffset.x;
        if (offset/SCREEN_WIDTH == 0) {
            [self refreshSelect:_postedBtn];
        } else if (offset/SCREEN_WIDTH == 1) {
            [self refreshSelect:_processingBtn];
        } else if (offset/SCREEN_WIDTH == 2) {
            [self refreshSelect:_completedBtn];
        } else if (offset/SCREEN_WIDTH == 3) {
            [self refreshSelect:_closedBtn];
        } else if (offset/SCREEN_WIDTH == 4) {
            [self refreshSelect:_appealedBtn];
        }
    }
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)postedAction:(id)sender {
    [self refreshSelect:sender];
    [_mainScroll setContentOffset:CGPointMake(SCREEN_WIDTH*0, 0) animated:YES];
    if (_postedPage == 1) {
        [self requestEntrust_order_list];
    }
}

- (IBAction)processingAction:(id)sender {
    [self refreshSelect:sender];
    [_mainScroll setContentOffset:CGPointMake(SCREEN_WIDTH*1, 0) animated:YES];
    if (_processingPage == 1) {
        [self requestTrade_order_list];
    }
}

- (IBAction)completedAction:(id)sender {
    [self refreshSelect:sender];
    [_mainScroll setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
    if (_completedPage == 1) {
        [self requestTrade_order_list];
    }
}

- (IBAction)closedAction:(id)sender {
    [self refreshSelect:sender];
    [_mainScroll setContentOffset:CGPointMake(SCREEN_WIDTH*3, 0) animated:YES];
    if (_closedPage == 1) {
        [self requestTrade_order_list];
    }
}

- (IBAction)appealedAction:(id)sender {
    [self refreshSelect:sender];
    [_mainScroll setContentOffset:CGPointMake(SCREEN_WIDTH*4, 0) animated:YES];
    if (_appealedPage == 1) {
        [self requestTrade_order_list];
    }
}

#pragma mark - Request
- (void)requestTrade_order_list {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    
    NSString *page = @"";
    NSString *status = @""; // 状态[processing/进行中的订单, completed/已完成的, closed/取消|超时, appealed/申诉]
    if (_postedBtn.selected) {
        page = [NSString stringWithFormat:@"%@",@(_postedPage)];
    } else if (_processingBtn.selected) {
        page = [NSString stringWithFormat:@"%@",@(_processingPage)];
        status = @"processing";
    } else if (_completedBtn.selected) {
        page = [NSString stringWithFormat:@"%@",@(_completedPage)];
        status = @"completed";
    } else if (_appealedBtn.selected) {
        page = [NSString stringWithFormat:@"%@",@(_appealedPage)];
        status = @"appealed";
    } else if (_closedBtn.selected) {
        page = [NSString stringWithFormat:@"%@",@(_closedPage)];
        status = @"closed";
    }
    NSString *size = @"20";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"account":account,@"token":token,@"page":page,@"size":size}];
    if (_postedBtn.selected) { // 委托单
        [params setObject:@"" forKey:@"entrustOrderId"];
    } else { // 交易单
        [params setObject:status forKey:@"status"];
    }
    [RequestService requestWithUrl6:trade_order_list_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself hideHeaderAndFooter];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [TradeOrderListModel mj_objectArrayWithKeyValuesArray:responseObject[@"orderList"]];
            if (weakself.processingBtn.selected) {
                if (weakself.processingPage == 1) {
                    [weakself.processingArr removeAllObjects];
                }
                [weakself.processingArr addObjectsFromArray:arr];
                weakself.processingPage += 1;
                [weakself.processingTable reloadData];
            } else if (weakself.completedBtn.selected) {
                if (weakself.completedPage == 1) {
                    [weakself.completedArr removeAllObjects];
                }
                [weakself.completedArr addObjectsFromArray:arr];
                weakself.completedPage += 1;
                [weakself.completedTable reloadData];
            } else if (weakself.appealedBtn.selected) {
                if (weakself.appealedPage == 1) {
                    [weakself.appealedArr removeAllObjects];
                }
                [weakself.appealedArr addObjectsFromArray:arr];
                weakself.appealedPage += 1;
                [weakself.appealedTable reloadData];
            } else if (weakself.closedBtn.selected) {
                if (weakself.closedPage == 1) {
                    [weakself.closedArr removeAllObjects];
                }
                [weakself.closedArr addObjectsFromArray:arr];
                weakself.closedPage += 1;
                [weakself.closedTable reloadData];
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself hideHeaderAndFooter];
    }];
}

- (void)requestEntrust_order_list {
    kWeakSelf(self);
    NSString *page = [NSString stringWithFormat:@"%@",@(_postedPage)];
    NSString *size = @"20";
    NSString *type = @"";
    NSString *userId = [UserModel fetchUserOfLogin].ID;
    NSDictionary *params = @{@"userId":userId?:@"",@"type":type,@"page":page,@"size":size,@"pairsId":@""};
    [RequestService requestWithUrl5:entrust_order_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.postedTable.mj_header endRefreshing];
        [weakself.postedTable.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [EntrustOrderListModel mj_objectArrayWithKeyValuesArray:responseObject[@"orderList"]];
            if (weakself.postedPage == 1) {
                [weakself.postedArr removeAllObjects];
            }
            [weakself.postedArr addObjectsFromArray:arr];
            weakself.postedPage += 1;
            [weakself.postedTable reloadData];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.postedTable.mj_header endRefreshing];
        [weakself.postedTable.mj_footer endRefreshing];
    }];
}

- (void)hideHeaderAndFooter {
    if (_postedBtn.selected) {
        [_postedTable.mj_header endRefreshing];
        [_postedTable.mj_footer endRefreshing];
    } else if (_processingBtn.selected) {
        [_processingTable.mj_header endRefreshing];
        [_processingTable.mj_footer endRefreshing];
    } else if (_completedBtn.selected) {
        [_completedTable.mj_header endRefreshing];
        [_completedTable.mj_footer endRefreshing];
    } else if (_appealedBtn.selected) {
        [_appealedTable.mj_header endRefreshing];
        [_appealedTable.mj_footer endRefreshing];
    } else if (_closedBtn.selected) {
        [_closedTable.mj_header endRefreshing];
        [_closedTable.mj_footer endRefreshing];
    }
}
#pragma mark - Transition
- (void)jumpToOrderDetail:(NSString *)tradeOrderId {
    TradeOrderDetailViewController *vc = [TradeOrderDetailViewController new];
    vc.inputTradeOrderId = tradeOrderId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToEntrustOrderDetail:(NSString *)entrustOrderId {
    EntrustOrderDetailViewController *vc = [EntrustOrderDetailViewController new];
    vc.inputEntrustOrderId = entrustOrderId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
