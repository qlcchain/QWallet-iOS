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
#import "CQScrollMenuView.h"
#import <TTGTextTagCollectionView.h>
#import "PairsModel.h"
#import <SwiftTheme/SwiftTheme-Swift.h>

static NSString *const NetworkSize = @"20";
//#import "GlobalConstants.h"

@interface HomeBuySellViewController () <UITableViewDelegate, UITableViewDataSource, TTGTextTagCollectionViewDelegate,CQScrollMenuViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mainSeg;
@property (weak, nonatomic) IBOutlet UIView *menuBack;
//@property (weak, nonatomic) IBOutlet UILabel *tokenLab;

// 侧滑页
@property (strong, nonatomic) IBOutlet UIView *slideView;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *tagListView;

@property (nonatomic, strong) NSArray *sourceArr;
@property (nonatomic, strong) NSMutableArray *buyArr;
@property (nonatomic, strong) NSMutableArray *sellArr;
@property (nonatomic) NSInteger currentBuyPage;
@property (nonatomic) NSInteger currentSellPage;
@property (nonatomic, strong) CQScrollMenuView *menuView;
@property (nonatomic, strong) NSMutableArray<PairsModel *> *pairsArr;
@property (nonatomic) BOOL showSlide;
@property (nonatomic, strong) UIView *slideBack;
@property (nonatomic, strong) NSMutableArray *selectPairsTagArr;
@property (nonatomic, strong) NSString *selectTradeToken;

@end

@implementation HomeBuySellViewController
    
#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeNoti:) name:kLanguageChangeNoti object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addObserve];
    
    self.view.theme_backgroundColor = globalBackgroundColorPicker;

    [self configInit];
    [self requestPairs_pairs];
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
    [self refreshSegTitle];
    
    [self.view addQGradientWithStart:UIColorFromRGB(0x4986EE) end:UIColorFromRGB(0x4752E9) frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _selectPairsTagArr = [NSMutableArray array];
    _showSlide = NO;
    _currentBuyPage = 1;
    _currentSellPage = 1;
    _buyArr = [NSMutableArray array];
    _sellArr = [NSMutableArray array];
    _sourceArr = _buyArr;
    [_mainTable registerNib:[UINib nibWithNibName:HomeBuySellCellReuse bundle:nil] forCellReuseIdentifier:HomeBuySellCellReuse];
    _pairsArr = [NSMutableArray array];
    _resetBtn.layer.borderColor = MAIN_BLUE_COLOR.CGColor;
    _resetBtn.layer.borderWidth = 0.5;
    _resetBtn.layer.cornerRadius = 4;
    _resetBtn.layer.masksToBounds = YES;
    _confirmBtn.layer.cornerRadius = 4;
    _confirmBtn.layer.masksToBounds = YES;
    
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
    
    [self configTagList];
}

- (void)refreshMenuView {
    if (_menuView) {
        [_menuView removeFromSuperview];
        _menuView = nil;
    }
    _menuView = [CQScrollMenuView new];
    _menuView.menuButtonClickedDelegate = self;
    _menuView.frame = CGRectMake(0, 0, SCREEN_WIDTH-2*79, 44);
    NSMutableArray *titleArr = [NSMutableArray array];
    [_selectPairsTagArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PairsModel *model = obj;
        if (![titleArr containsObject:model.tradeToken]) {
            [titleArr addObject:model.tradeToken];
        }
    }];
    _menuView.titleArray = titleArr;
    [_menuBack addSubview:_menuView];
    _menuView.currentButtonIndex = 0;
    
    [PairsModel storeLocalSelect:_selectPairsTagArr]; // 刷新本地存储
    _selectTradeToken = titleArr.count>0?titleArr.firstObject:@"";
    _currentBuyPage=1;
    _currentSellPage=1;
    [self requestEntrust_order_list];
}

- (void)configTagList {
    _tagListView.horizontalSpacing = 12.0;
    _tagListView.verticalSpacing = 8.0;
    _tagListView.enableTagSelection = YES;
//    _tagListView.selectionLimit = 1;
    _tagListView.delegate = self;
    _tagListView.backgroundColor = [UIColor clearColor];
    TTGTextTagConfig *config = _tagListView.defaultConfig;
    config.textFont = [UIFont systemFontOfSize:14.0f];
    config.textColor = UIColorFromRGB(0x29282A);
    config.selectedTextColor = UIColorFromRGB(0x108EE9);
    config.backgroundColor = UIColorFromRGB(0xF4F4F4);
    config.selectedBackgroundColor = UIColorFromRGB(0xCDEAFF);
    config.cornerRadius = 2;
    config.shadowOffset = CGSizeMake(0, 0);
    config.shadowOpacity = 0;
    config.borderWidth = 0;
    config.exactWidth = (SCREEN_WIDTH - 90 - 2*14 - 16) / 2.0;
    config.exactHeight = 40;
    
}

- (void)refreshTagList {
    [_tagListView removeAllTags];
    NSMutableArray *arr = [NSMutableArray array];
    kWeakSelf(self);
    [_pairsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PairsModel *model1 = obj;
        NSString *title1 = [NSString stringWithFormat:@"%@/%@",model1.tradeToken,model1.payToken];
        [arr addObject:title1];
    }];
    [_tagListView addTags:arr];
    
    // 设置选择项
    [_pairsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PairsModel *model1 = obj;
        NSString *title1 = [NSString stringWithFormat:@"%@/%@",model1.tradeToken,model1.payToken];
        NSUInteger idx1 = idx;
        
        [weakself.selectPairsTagArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PairsModel *model2 = obj;
            NSString *title2 = [NSString stringWithFormat:@"%@/%@",model2.tradeToken,model2.payToken];
            if ([title1 isEqualToString:title2]) {
                [weakself.tagListView setTagAtIndex:idx1 selected:YES];
                *stop = YES;
            }
        }];
    }];
}

- (void)showSlideView {
    [kAppD.window addSubview:self.slideBack];
    _slideView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _slideView.backgroundColor = [UIColorFromRGB(0x050404) colorWithAlphaComponent:0];
    [kAppD.window addSubview:_slideView];
    kWeakSelf(self);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakself.slideView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}

- (void)hideSlideView {
    kWeakSelf(self);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakself.slideView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [weakself.slideView removeFromSuperview];
        [weakself.slideBack removeFromSuperview];
        weakself.slideBack = nil;
    }];
}

- (void)showVerifyTipView {
    VerifyTipView *view = [VerifyTipView getInstance];
    kWeakSelf(self);
    view.okBlock = ^{
        [weakself jumpToVerification];
    };
    [view showWithTitle:kLang(@"please_finish_the_verification_on_me_page")];
}

- (void)refreshSegTitle {
    [_mainSeg setTitle:kLang(@"buy") forSegmentAtIndex:0];
    [_mainSeg setTitle:kLang(@"sell") forSegmentAtIndex:1];
}

#pragma mark - Request
- (void)requestEntrust_order_list {
    kWeakSelf(self);
    NSString *page = [NSString stringWithFormat:@"%li",weakself.mainSeg.selectedSegmentIndex==0?_currentBuyPage:_currentSellPage];
    NSString *size = NetworkSize;
    NSString *type = _mainSeg.selectedSegmentIndex == 0?@"SELL":@"BUY";
    NSMutableString *pairsId = [NSMutableString string];
    [_selectPairsTagArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PairsModel *model = obj;
        if ([model.tradeToken isEqualToString:weakself.selectTradeToken]) {
            [pairsId appendFormat:@"%@,",model.ID];
        }
    }];
    if (pairsId.length > 0) {
        [pairsId deleteCharactersInRange:NSMakeRange(pairsId.length-1, 1)];
    }
    NSDictionary *params = @{@"userId":@"",@"type":type,@"page":page,@"size":size,@"status":@"NORMAL",@"pairsId":pairsId};
    [RequestService requestWithUrl5:entrust_order_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
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
            
            if (arr.count < [NetworkSize integerValue]) {
                [weakself.mainTable.mj_footer endRefreshingWithNoMoreData];
                weakself.mainTable.mj_footer.hidden = arr.count<=0?YES:NO;
            } else {
                weakself.mainTable.mj_footer.hidden = NO;
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
    }];
}

- (void)requestPairs_pairs {
    kWeakSelf(self);
    NSDictionary *params = @{};
    [RequestService requestWithUrl5:pairs_pairs_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [weakself.pairsArr removeAllObjects];
            [responseObject[@"pairsList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PairsModel *model = [PairsModel getObjectWithKeyValues:obj];
                [weakself.pairsArr addObject:model];
            }];
            
            NSArray *localSelectArr = [PairsModel fetchLocalSelect];
            if (!localSelectArr) {
                [weakself.selectPairsTagArr removeAllObjects];
                [weakself.selectPairsTagArr addObjectsFromArray:weakself.pairsArr];
            } else {
                if (weakself.selectPairsTagArr.count <= 0) {
                    [weakself.selectPairsTagArr addObjectsFromArray:localSelectArr];
                }
                [weakself.selectPairsTagArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    PairsModel *temp1 = obj;
                    __block BOOL isExist = NO;
                    [localSelectArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        PairsModel *temp2 = obj;
                        if ([temp1.ID isEqualToString:temp2.ID]) {
                            isExist = YES;
                            *stop = YES;
                        }
                    }];
                    if (!isExist) {
                        [weakself.selectPairsTagArr removeObject:temp1];
                    }
                }];
            }
            
            [weakself refreshTagList];
            [weakself refreshMenuView];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - Delegate - 菜单栏
// 菜单按钮点击时回调
- (void)scrollMenuView:(CQScrollMenuView *)scrollMenuView clickedButtonAtIndex:(NSInteger)index{
    _selectTradeToken = scrollMenuView.titleArray[index];
    _currentBuyPage=1;
    _currentSellPage=1;
    [self requestEntrust_order_list];
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

#pragma mark - TTGTextTagCollectionViewDelegate
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(NSString *)tagText
                      atIndex:(NSUInteger)index
                     selected:(BOOL)selected
                    tagConfig:(TTGTextTagConfig *)config {
//    kWeakSelf(self);
//    [_pairsArr enumerateObjectsUsingBlock:^(PairsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [weakself.tagListView setTagAtIndex:idx selected:idx==index?YES:NO];
//    }];
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

- (IBAction)filterAction:(UIButton *)sender {
    _showSlide = !_showSlide;
    if (_showSlide) {
        [self showSlideView];
    } else {
        [self hideSlideView];
    }
}

- (IBAction)resetAction:(id)sender {
    [self requestPairs_pairs];
}

- (IBAction)confirmAction:(id)sender {
    kWeakSelf(self);
    [_selectPairsTagArr removeAllObjects];
    [_pairsArr enumerateObjectsUsingBlock:^(PairsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *tagStr = [NSString stringWithFormat:@"%@/%@",obj.tradeToken,obj.payToken];
        if ([weakself.tagListView.allSelectedTags containsObject:tagStr]) {
            [weakself.selectPairsTagArr addObject:obj];
        }
    }];
    
    if (_selectPairsTagArr.count > 0) {
        _showSlide = NO;
        [self hideSlideView];
        [self refreshMenuView];
    }
}

- (IBAction)slideHideAction:(id)sender {
    _showSlide = NO;
    [self hideSlideView];
}


#pragma mark - Transition
- (void)jumpToMyOrderList {
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
//    UserModel *userM = [UserModel fetchUserOfLogin];
//    if (![userM.vStatus isEqualToString:kyc_success]) {
//        [self showVerifyTipView];
//        return;
//    }
    
    RecordListViewController *vc = [RecordListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToNewOrder {
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
//    UserModel *userM = [UserModel fetchUserOfLogin];
//    if (![userM.vStatus isEqualToString:kyc_success]) {
//        [self showVerifyTipView];
//        return;
//    }
    
    NewOrderViewController *vc = [NewOrderViewController new];
    vc.inputPairsArr = _pairsArr;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToBuySellDetail:(EntrustOrderListModel *)model {
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
    if ([model.tradeToken isEqualToString:@"QGAS"] && [model.totalAmount doubleValue] > 1000) { // QGAS总额大于1000的挂单需要进行kyc验证
        UserModel *userM = [UserModel fetchUserOfLogin];
        if (![userM.vStatus isEqualToString:kyc_success]) {
            [self showVerifyTipView];
            return;
        }
    }
    
    BuySellDetailViewController *vc = [BuySellDetailViewController new];
    vc.inputTradeToken = model.tradeToken;
    vc.inputPayToken = model.payToken;
    vc.inputEntrustOrderListM = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToVerification {
    VerificationViewController *vc = [VerificationViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Noti
- (void)languageChangeNoti:(NSNotification *)noti {
    [self refreshSegTitle];
    [_mainTable.mj_header beginRefreshing];
}

#pragma mark - Lazy
- (UIView *)slideBack {
    if (_slideBack == nil) {
        _slideBack = [UIView new];
        _slideBack.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _slideBack.backgroundColor = [UIColorFromRGB(0x050404) colorWithAlphaComponent:0.5];
    }
    return _slideBack;
}

@end
