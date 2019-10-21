//
//  TopupViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TopupViewController.h"
#import "TopupCell.h"
#import "MyThemes.h"
#import "UIColor+Random.h"
#import <SwiftTheme/SwiftTheme-Swift.h>
#import "UIView+Gradient.h"
#import "MyTopupOrderViewController.h"
#import "ChooseTopupPlanViewController.h"
#import "RefreshHelper.h"
#import "TopupProductModel.h"
#import "WalletCommonModel.h"
#import "ChooseWalletViewController.h"
#import "TopupWebViewController.h"
#import "InviteRankView.h"

static NSString *const TopupNetworkSize = @"20";

@interface TopupViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *sendRechargeLab;
@property (weak, nonatomic) IBOutlet UILabel *inputTipLab;
@property (weak, nonatomic) IBOutlet UILabel *earnMoreLab;
@property (weak, nonatomic) IBOutlet UIButton *actNowBtn;
@property (weak, nonatomic) IBOutlet UILabel *carrierPackageLab;

@property (weak, nonatomic) IBOutlet UIView *topGradientBack;
@property (weak, nonatomic) IBOutlet UIView *sendTopupBack;
@property (weak, nonatomic) IBOutlet UIView *makeMoreBack;
@property (weak, nonatomic) IBOutlet UIView *numBack;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainTableHeight;

@property (weak, nonatomic) IBOutlet UIView *inviteRankBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inviteRankHeight;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) InviteRankView *inviteRankV;

@end

@implementation TopupViewController

#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeNoti:) name:kLanguageChangeNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinPayBackNoti:) name:Weixin_Pay_Back_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNoti:) name:User_Login_Success_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccessNoti:) name:User_Logout_Success_Noti object:nil];
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
    [self refreshViewText];
    [self requestTopup_product_list];
    [self configInviteRankView];
}

#pragma mark - Operation
- (void)configInit {
    [_topGradientBack addQGradientWithStart:UIColorFromRGB(0x4986EE) end:UIColorFromRGB(0x4752E9) frame:CGRectMake(_topGradientBack.left, _topGradientBack.top, SCREEN_WIDTH, _topGradientBack.height)];
    
    _numBack.layer.cornerRadius = 8;
    _numBack.layer.masksToBounds = YES;
    _numBack.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    _numBack.layer.borderWidth = 1;
    _sendTopupBack.layer.cornerRadius = 6;
    _sendTopupBack.layer.masksToBounds = YES;
    _makeMoreBack.layer.cornerRadius = 6;
    _makeMoreBack.layer.masksToBounds = YES;
    _actNowBtn.layer.cornerRadius = 2;
    _actNowBtn.layer.masksToBounds = YES;
    
    _currentPage = 1;
    _mainTableHeight.constant = 0;
    _inviteRankHeight.constant = 0;
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:TopupCellReuse bundle:nil] forCellReuseIdentifier:TopupCellReuse];
    
    kWeakSelf(self)
    _mainScroll.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = 1;
        [weakself requestTopup_product_list];
        
        if (weakself.inviteRankV) {
            [weakself.inviteRankV startRefresh];
        }
    }];
    _mainScroll.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestTopup_product_list];
    }];
}

- (void)configInviteRankView {
    kWeakSelf(self);
    _inviteRankV = [InviteRankView getInstance];
    [_inviteRankV config:^(CGFloat height) {
        weakself.inviteRankHeight.constant = height;
    }];
    [_inviteRankV startRefresh];
    [_inviteRankBack addSubview:_inviteRankV];
    [_inviteRankV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(weakself.inviteRankBack).offset(0);
    }];
}

- (void)refreshViewText {
    _titleLab.text = kLang(@"top_up");
    _sendRechargeLab.text = kLang(@"send_recharge_to");
    _inputTipLab.text = kLang(@"enter_your_phone_number_or_select_from_your_contacts_");
    _earnMoreLab.text = kLang(@"earn_more_qgas");
    [_actNowBtn setTitle:kLang(@"act_now__") forState:UIControlStateNormal];
    _carrierPackageLab.text = kLang(@"carrier_package");
}

#pragma mark - Request
- (void)requestTopup_product_list {
    kWeakSelf(self);
//    NSString *phoneNumber = @"";
    NSString *page = [NSString stringWithFormat:@"%li",_currentPage];
    NSString *size = TopupNetworkSize;
    NSDictionary *params = @{@"page":page,@"size":size};
    [RequestService requestWithUrl10:topup_product_list_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//    [RequestService requestWithUrl5:topup_product_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainScroll.mj_header endRefreshing];
        [weakself.mainScroll.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [TopupProductModel mj_objectArrayWithKeyValuesArray:responseObject[@"productList"]];
            if (weakself.currentPage == 1) {
                [weakself.sourceArr removeAllObjects];
            }
            
//            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                TopupProductModel *model1 = obj;
//                [[model1.amountOfMoney componentsSeparatedByString:@","] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    TopupProductModel *model2 = [TopupProductModel getObjectWithKeyValues:model1.mj_keyValues];
//                    NSString *amountStr = obj;
//                    model2.amount = @([amountStr doubleValue]);
//                    [weakself.sourceArr addObject:model2];
//                }];
//            }];
            [weakself.sourceArr addObjectsFromArray:arr];
            weakself.currentPage += 1;
            
            weakself.mainTableHeight.constant = weakself.sourceArr.count*TopupCell_Height;
            [weakself.mainTable reloadData];
            
            if (arr.count < [TopupNetworkSize integerValue]) {
                [weakself.mainScroll.mj_footer endRefreshingWithNoMoreData];
                weakself.mainScroll.mj_footer.hidden = arr.count<=0?YES:NO;
            } else {
                weakself.mainScroll.mj_footer.hidden = NO;
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.mainScroll.mj_header endRefreshing];
        [weakself.mainScroll.mj_footer endRefreshing];
    }];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TopupCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self jumpToChooseTopupPlan];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopupCell *cell = [tableView dequeueReusableCellWithIdentifier:TopupCellReuse];
    
    TopupProductModel *model = _sourceArr[indexPath.row];
    [cell config:model];
    
    return cell;
}

#pragma mark - Action

- (IBAction)menuAction:(id)sender {
    [self jumpToMyTopupOrder];
}

- (IBAction)inputNumAction:(id)sender {
    [self jumpToChooseTopupPlan];
//    [self jumpToTopupH5];
}

- (IBAction)makeQGASAction:(id)sender {
    [kAppD jumpToWallet];
}

#pragma mark - Transition
- (void)jumpToMyTopupOrder {
    MyTopupOrderViewController *vc = [MyTopupOrderViewController new];
    vc.inputBackToRoot = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToChooseTopupPlan {
    if (![WalletCommonModel haveQLCWallet]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:kLang(@"you_do_not_have_qlc_wallet_created_immediately") preferredStyle:UIAlertControllerStyleAlert];
        kWeakSelf(self);
        UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertC addAction:alertCancel];
        UIAlertAction *alertBuy = [UIAlertAction actionWithTitle:kLang(@"create") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself jumpToChooseWallet:YES];
        }];
        [alertC addAction:alertBuy];
        [self presentViewController:alertC animated:YES completion:nil];
        
        return;
    }
    ChooseTopupPlanViewController *vc = [ChooseTopupPlanViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToChooseWallet:(BOOL)showBack {
    ChooseWalletViewController *vc = [[ChooseWalletViewController alloc] init];
    vc.showBack = showBack;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Noti
- (void)languageChangeNoti:(NSNotification *)noti {
    [self refreshViewText];
    [_mainScroll.mj_header beginRefreshing];
    [_inviteRankV startRefresh];
}

- (void)weixinPayBackNoti:(NSNotification *)noti {
    [self jumpToMyTopupOrder];
}

- (void)loginSuccessNoti:(NSNotification *)noti {
    [_inviteRankV startRefresh];
}

- (void)logoutSuccessNoti:(NSNotification *)noti {
    [_inviteRankV startRefresh];
}


@end
