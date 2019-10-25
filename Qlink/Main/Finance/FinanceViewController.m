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
#import "EarningsRankingViewController.h"
#import "InviteRankingViewController.h"
#import "UIView+Gradient.h"
#import "ShareFriendsViewController.h"
#import "UserModel.h"
#import "RefreshHelper.h"
//#import "GlobalConstants.h"
#import "UIColor+Random.h"
#import <SwiftTheme/SwiftTheme-Swift.h>

@interface FinanceViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topGradientBack;
@property (weak, nonatomic) IBOutlet UIView *dailyBack;
@property (weak, nonatomic) IBOutlet UIButton *joinNowBtn;
@property (weak, nonatomic) IBOutlet UILabel *dailyRateLab;
@property (weak, nonatomic) IBOutlet UILabel *dailyFromQLCLab;
@property (weak, nonatomic) IBOutlet UILabel *dailyNameLab;
@property (weak, nonatomic) IBOutlet UIButton *inviteFriendBtn;
@property (weak, nonatomic) IBOutlet UIButton *earningsRankingBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerScrollWidth;
@property (weak, nonatomic) IBOutlet UIPageControl *centerPageControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainTableHeight; // 388

@property (nonatomic, strong) NSMutableArray *productArr;
@property (nonatomic, strong) FinanceProductModel *dailyM;
@property (nonatomic) NSInteger currentPage;

@end

@implementation FinanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.theme_backgroundColor = globalBackgroundColorPicker;
    
    [self configInit];
    _currentPage = 1;
    [self requestProduct_list];
}

#pragma mark - Operation
- (void)configInit {
    [_topGradientBack addQGradientWithStart:UIColorFromRGB(0x4986EE) end:UIColorFromRGB(0x4752E9) frame:CGRectMake(_topGradientBack.left, _topGradientBack.top, SCREEN_WIDTH, _topGradientBack.height)];
    
    _centerScrollWidth.constant = SCREEN_WIDTH*2;
    _productArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:FinanceCellReuse bundle:nil] forCellReuseIdentifier:FinanceCellReuse];
    
    _dailyBack.layer.cornerRadius = 6;
//    _dailyBack.layer.masksToBounds = YES;
    UIColor *navShadowColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.08];
    [_dailyBack shadowWithColor:navShadowColor offset:CGSizeMake(0, 2) opacity:1 radius:8];
    
    _joinNowBtn.layer.cornerRadius = 4;
    _joinNowBtn.layer.masksToBounds = YES;
    _inviteFriendBtn.layer.cornerRadius = 2;
    _inviteFriendBtn.layer.masksToBounds = YES;
    _earningsRankingBtn.layer.cornerRadius = 2;
    _earningsRankingBtn.layer.masksToBounds = YES;
    
    kWeakSelf(self)
    _mainScroll.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = 1;
        [weakself requestProduct_list];
    }];
    _mainScroll.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestProduct_list];
    }];
}

- (void)refreshDailyView {
    _dailyNameLab.text = _dailyM.nameEn?:@"";
    _dailyRateLab.text = [NSString stringWithFormat:@"%.2f%%",[_dailyM.annualIncomeRate?:@(0) floatValue]*100];
    _dailyFromQLCLab.text = [NSString stringWithFormat:@"Flexible From %@ QLC",_dailyM.leastAmount?:@(0)];
    if ([_dailyM.status isEqualToString:@"ON_SALE"]) {
        _joinNowBtn.backgroundColor = [UIColor mainColor];
        _joinNowBtn.enabled = YES;
    } else if ([_dailyM.status isEqualToString:@"NEW"]) {
        _joinNowBtn.backgroundColor = [UIColor mainColor];
        _joinNowBtn.enabled = YES;
    } else if ([_dailyM.status isEqualToString:@"SELL_OUT"]) {
        _joinNowBtn.backgroundColor = [UIColor mainColorOfHalf];
        _joinNowBtn.enabled = NO;
    } else if ([_dailyM.status isEqualToString:@"END"]) {
        _joinNowBtn.backgroundColor = [UIColor mainColorOfHalf];
        _joinNowBtn.enabled = NO;
    }
}

- (void)refreshTableHeight {
    _mainTableHeight.constant = _productArr.count*FinanceCell_Height;
}

#pragma mark - Request
// 产品列表
- (void)requestProduct_list {
    kWeakSelf(self);
//    NSString *page = @"1";
    NSString *page = [NSString stringWithFormat:@"%li",(long)_currentPage];
    NSString *size = @"20";
    NSDictionary *params = @{@"page":page,@"size":size};
    [RequestService requestWithUrl10:product_list_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainScroll.mj_header endRefreshing];
        [weakself.mainScroll.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [FinanceProductModel mj_objectArrayWithKeyValuesArray:responseObject[Server_Data]];
            if (weakself.currentPage == 1) {
                [weakself.productArr removeAllObjects];
                
                if (arr.count > 0) {
                    // 选第一个显示在头部
                    weakself.dailyM = arr.firstObject;
                    [weakself refreshDailyView];
                    
                    [weakself.productArr addObjectsFromArray:[arr subarrayWithRange:NSMakeRange(1, arr.count - 1)] ];
                }
            } else {
                [weakself.productArr addObjectsFromArray:arr];
            }
            weakself.currentPage += 1;
            [weakself.mainTable reloadData];
        }
        [weakself refreshTableHeight];
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.mainScroll.mj_header endRefreshing];
        [weakself.mainScroll.mj_footer endRefreshing];
        [weakself refreshTableHeight];
    }];
}

#pragma mark - Action

//- (IBAction)switchThemeAction:(id)sender {
//    [MyThemes switchToNext];
//}
- (IBAction)myPortfolioAction:(id)sender {
    [self jumpToMyPortfolio];
}

- (IBAction)joinNowAction:(id)sender {
    if (_dailyM) {
        [self jumpToProductDetail:_dailyM];
    }
}

- (IBAction)inviteFriendAction:(id)sender {
    [self jumpToShareFriends];
}

- (IBAction)earningsRankingAction:(id)sender {
    [self jumpToEarningsRanking];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FinanceCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FinanceProductModel *model = _productArr[indexPath.row];
    if ([model.status isEqualToString:@"ON_SALE"]) {
        
    } else if ([model.status isEqualToString:@"NEW"]) {
        
    } else if ([model.status isEqualToString:@"SELL_OUT"]) {
        return;
    } else if ([model.status isEqualToString:@"END"]) {
        return;
    }
    [self jumpToProductDetail:model];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x/SCREEN_WIDTH;
    _centerPageControl.currentPage = page;
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
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
    kWeakSelf(self)
    if (kAppD.needFingerprintVerification) {
        [kAppD presentFingerprintVerify:^{
            [weakself performSelector:@selector(jumpToMyPortfolio) withObject:nil afterDelay:0.5];
        }];
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
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
    kWeakSelf(self)
    if (kAppD.needFingerprintVerification) {
        [kAppD presentFingerprintVerify:^{
            [weakself performSelector:@selector(jumpToProductDetail:) withObject:model afterDelay:0.5];
        }];
        return;
    }
    
    FinanceProductDetailViewController *vc = [FinanceProductDetailViewController new];
    vc.inputM = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToEarningsRanking {
    EarningsRankingViewController *vc = [EarningsRankingViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToShareFriends {
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
    
    ShareFriendsViewController *vc = [ShareFriendsViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
