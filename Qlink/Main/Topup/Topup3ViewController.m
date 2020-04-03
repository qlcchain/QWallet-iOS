//
//  TopupViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import "Topup3ViewController.h"
//#import "TopupCell.h"
#import "TopupMobilePlanCell.h"
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
#import "ClaimQGASTipView.h"
#import "UserModel.h"
#import "UserUtil.h"
#import "JPushConstants.h"
#import "AppDelegate+AppService.h"
#import "SheetMiningViewController.h"
#import "SheetMiningUtil.h"
#import "QLCHistoryChartView.h"
#import "TokenPriceModel.h"
#import "RLArithmetic.h"
#import "TabbarHelper.h"
#import "WZLBadgeImport.h"
#import "RedPointModel.h"
#import "ShareFriendsViewController.h"
#import "InviteFriendNowViewController.h"
#import "TxidBackUtil.h"
#import "AppJumpHelper.h"
#import "TopupMobilePlanCountry.h"
#import "TopupCountryModel.h"
#import <QLCFramework/QLCFramework.h>
//#import "StakingProcessAnimateView.h"
//#import "StakingProcessView.h"
#import "AgentRewardViewController.h"
#import "GroupBuyUtil.h"
#import "NinaPagerView.h"
#import "NinaBaseView.h"
#import "TopupProductSubViewController.h"
#import "ChooseDeductionTokenViewController.h"
#import "TopupDeductionTokenModel.h"
#import <UIButton+WebCache.h>
#import "GroupKindModel.h"
#import "QgasVoteUtil.h"
#import "BuybackBurnUtil.h"
#import "WebViewController.h"
#import "QlinkTabbarViewController.h"
#import "MainTabbarViewController.h"
#import "HomeBuySellViewController.h"
#import "BuybackDetailViewController.h"
#import <TMCache/TMCache.h>

static NSString *const TopupNetworkSize = @"20";
static NSInteger const insetForSectionDistance = 16;
static NSInteger const miniSpacingDistance = 8;

static NSString *const Show_Make_More = @"Show_Make_More";
static NSString *const Show_Sheet_Mining = @"Show_Sheet_Mining";
static NSString *const Show_Partner_Plan = @"Show_Partner_Plan";
static NSString *const Show_Buyback_Burn = @"Show_Buyback_Burn";

static NSString *const TM_Chache_Topup_Country_List = @"TM_Chache_Topup_Country_List";

@interface Topup3ViewController () <UIScrollViewDelegate,NinaPagerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
//@property (weak, nonatomic) IBOutlet UILabel *sendRechargeLab;
//@property (weak, nonatomic) IBOutlet UILabel *inputTipLab;
@property (weak, nonatomic) IBOutlet UILabel *earnMoreLab;

@property (weak, nonatomic) IBOutlet UIButton *chooseDeductionBtn;


@property (weak, nonatomic) IBOutlet UIView *introduceFriendBack;
@property (weak, nonatomic) IBOutlet UILabel *introduceFriendLab;
@property (weak, nonatomic) IBOutlet UIButton *actNowBtn;
//@property (weak, nonatomic) IBOutlet UILabel *carrierPackageLab;

@property (weak, nonatomic) IBOutlet UIView *topGradientBack;
//@property (weak, nonatomic) IBOutlet UIView *sendTopupBack;
@property (weak, nonatomic) IBOutlet UIView *makeMoreBack;
//@property (weak, nonatomic) IBOutlet UIView *numBack;
//@property (weak, nonatomic) IBOutlet UITableView *mainTable;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainTableHeight;
//@property (weak, nonatomic) IBOutlet UICollectionView *mainCollection;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainCollectionHeight;

@property (weak, nonatomic) IBOutlet UIView *inviteRankBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inviteRankHeight;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;

//@property (weak, nonatomic) IBOutlet UIView *qlcLineBack;

@property (weak, nonatomic) IBOutlet UIScrollView *cycleScrollV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cycleContentWidth;
@property (weak, nonatomic) IBOutlet UIPageControl *cyclePageC;
@property (nonatomic, strong) NSTimer *cycleTimer;

@property (weak, nonatomic) IBOutlet UIView *miningBack;
@property (weak, nonatomic) IBOutlet UIButton *mining_detailBtn;
@property (weak, nonatomic) IBOutlet UILabel *mining_tipLab;

@property (weak, nonatomic) IBOutlet UILabel *buyback_tipLab;
@property (weak, nonatomic) IBOutlet UIButton *buyback_detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyback_joinBtn;
@property (weak, nonatomic) IBOutlet UIView *buybackBack;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *makeMoreWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sheetMiningWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parterPlanWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buybackBurnWidth;

@property (weak, nonatomic) IBOutlet UIView *tableBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBackHeight; // 300

//@property (weak, nonatomic) IBOutlet UIView *qlcTradeBack;
//@property (weak, nonatomic) IBOutlet UILabel *qlcPriceLab;
//@property (weak, nonatomic) IBOutlet UILabel *qlcGainLab;
//@property (weak, nonatomic) IBOutlet UILabel *qlcTradeLab;

//@property (weak, nonatomic) IBOutlet UIView *chartBack;
//@property (weak, nonatomic) IBOutlet UIButton *hourBtn;
//@property (weak, nonatomic) IBOutlet UIButton *dayBtn;
//@property (weak, nonatomic) IBOutlet UIButton *weekBtn;
//@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
//@property (weak, nonatomic) IBOutlet UIButton *yearBtn;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chartBackHeight; // 191
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qlcBackHeight; // 318

//@property (weak, nonatomic) IBOutlet UIView *countryBack;

@property (weak, nonatomic) IBOutlet UILabel *parterPlanLab;
@property (weak, nonatomic) IBOutlet UIView *parterPlanBack;
@property (weak, nonatomic) IBOutlet UIButton *parterPlan_detailBtn;


@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) InviteRankView *inviteRankV;
@property (nonatomic, strong) QLCHistoryChartView *chartV;
@property (nonatomic, strong) NSString *qlcFrequency;
@property (nonatomic, strong) MiningActivityModel *miningActivityM;
@property (nonatomic, strong) BuybackBurnModel *buybackBurnM;
@property (nonatomic) BOOL showQLC;
@property (nonatomic, strong) TopupMobilePlanCountry *countryV;
@property (nonatomic, strong) TopupCountryModel *selectCountryM;
@property (nonatomic, strong) NSMutableArray *cycleContentArr;
@property (nonatomic, strong) NinaPagerView *ninaPagerView;
@property (nonatomic, strong) NSMutableArray *countrySource;
@property (nonatomic, strong) NSMutableArray *ninaObjectSource;
@property (nonatomic, strong) TopupDeductionTokenModel *selectDeductionTokenM;
@property (nonatomic) BOOL isInGroupBuyActiviyTime;
@property (nonatomic, strong) NSString *groupBuyMinimumDiscount;

@end

@implementation Topup3ViewController

#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeNoti:) name:kLanguageChangeNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinPayBackNoti:) name:Weixin_Pay_Back_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNoti:) name:User_Login_Success_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccessNoti:) name:User_Logout_Success_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfoAfterLoginNoti:) name:User_UpdateInfoAfterLogin_Noti object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeCycleTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addObserve];
    
    self.view.theme_backgroundColor = globalBackgroundColorPicker;
    self.view.backgroundColor = MAIN_BLUE_COLOR;
    
    [self configInit];
    [self refreshViewText];
//    [self requestTopup_product_list];
    [self configInviteRankView];
    
    [ClaimQGASTipView show:^{}];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WalletCommonModel handlerCreateWalletInAuto];
    });
    
    
    [self handlerPushJump];
    [self getSheetMining];
    [self getBuybackBurn];
    [self getParterPlan];
//    [self addChart];
//    [self getTokenPrice];
    [self getRedDotOfMe];
//    [self addCountryView];
    
    [self requestTopup_pay_token];
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself requestIsInGroupBuyActiviyTime];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself requestTopup_group_kind_list];
    });
    
    [self handlerTopupCountryList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self addCycleTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeCycleTimer];
}

#pragma mark - Operation
- (void)configInit {
    [_topGradientBack addHorizontalQGradientWithStart:UIColorFromRGB(0x4986EE) end:UIColorFromRGB(0x4752E9) frame:CGRectMake(_topGradientBack.left, _topGradientBack.top, SCREEN_WIDTH, _topGradientBack.height)];
    
    _chooseDeductionBtn.layer.cornerRadius = _chooseDeductionBtn.width/2.0;
    _chooseDeductionBtn.layer.masksToBounds = YES;
    
    _cycleContentArr = [NSMutableArray array];
    _showQLC = NO;
//    _qlcBackHeight.constant = _showQLC?318:0;
    _isInGroupBuyActiviyTime = NO;
    _groupBuyMinimumDiscount = @"0";
    
//    _qlcTradeBack.layer.cornerRadius = 2;
//    _qlcTradeBack.layer.masksToBounds = YES;
//    _qlcLineBack.layer.cornerRadius = 6;
//    _qlcLineBack.layer.masksToBounds = YES;
    _buybackBack.layer.cornerRadius = 6;
    _buybackBack.layer.masksToBounds = YES;
    _buyback_detailBtn.layer.cornerRadius = 2;
    _buyback_detailBtn.layer.masksToBounds = YES;
    _buyback_joinBtn.layer.cornerRadius = 2;
    _buyback_joinBtn.layer.masksToBounds = YES;
    _miningBack.layer.cornerRadius = 6;
    _miningBack.layer.masksToBounds = YES;
    _mining_detailBtn.layer.cornerRadius = 2;
    _mining_detailBtn.layer.masksToBounds = YES;
    _parterPlanBack.layer.cornerRadius = 6;
    _parterPlanBack.layer.masksToBounds = YES;    _parterPlan_detailBtn.layer.cornerRadius = 2;
    _parterPlan_detailBtn.layer.masksToBounds = YES;
    
    _makeMoreWidth.constant = SCREEN_WIDTH;
    [_cycleContentArr addObject:Show_Make_More];
    _sheetMiningWidth.constant = 0;
    _parterPlanWidth.constant = 0;
    _buybackBurnWidth.constant = 0;
    _cycleContentWidth.constant = SCREEN_WIDTH*_cycleContentArr.count;
    _cyclePageC.numberOfPages = _cycleContentArr.count;
    _cycleScrollV.delegate = self;
//    _cyclePageC.numberOfPages = 1;
    _cyclePageC.userInteractionEnabled = NO;
//    _numBack.layer.cornerRadius = 8;
//    _numBack.layer.masksToBounds = YES;
//    _numBack.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
//    _numBack.layer.borderWidth = 1;
//    _sendTopupBack.layer.cornerRadius = 6;
//    _sendTopupBack.layer.masksToBounds = YES;
    _makeMoreBack.layer.cornerRadius = 6;
    _makeMoreBack.layer.masksToBounds = YES;
    _actNowBtn.layer.cornerRadius = 2;
    _actNowBtn.layer.masksToBounds = YES;
    _introduceFriendBack.layer.cornerRadius = 2;
    _introduceFriendBack.layer.masksToBounds = YES;
    
    _countrySource = [NSMutableArray array];
    
    _currentPage = 1;
//    _mainTableHeight.constant = 0;
//    _mainCollectionHeight.constant = 0;
    _inviteRankHeight.constant = 0;
    _sourceArr = [NSMutableArray array];
//    [_mainTable registerNib:[UINib nibWithNibName:TopupCellReuse bundle:nil] forCellReuseIdentifier:TopupCellReuse];
//    [_mainCollection registerNib:[UINib nibWithNibName:TopupMobilePlanCell_Reuse bundle:nil] forCellWithReuseIdentifier:TopupMobilePlanCell_Reuse];
    
    kWeakSelf(self)
    _mainScroll.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = 1;
//        [weakself requestTopup_product_list];
        [weakself refreshNinaPagerViewVC];
        
        if (weakself.inviteRankV) {
            [weakself.inviteRankV startRefresh];
        }
        
        if (weakself.countryV) {
            [weakself.countryV refreshCountryView];
        }
        
        [weakself getBuybackBurn];
        [weakself getSheetMining];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
            [weakself.mainScroll.mj_header endRefreshing];
        });
    } type:RefreshTypeColor];
//    _mainScroll.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
//        [weakself requestTopup_product_list];
//    }];
}

- (void)handlerPushJump {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        NSDictionary *userInfo = [HWUserdefault getObjectWithKey:JPush_Tag_Jump];
        [kAppD handlerPushJump:userInfo isTapLaunch:NO];
    });
}

- (void)getSheetMining {
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SheetMiningUtil requestTrade_mining_list:^(NSArray<MiningActivityModel *> * _Nonnull arr) {
            if (arr.count > 0) {
                MiningActivityModel *model = arr.firstObject;
                weakself.miningActivityM = model;
                weakself.sheetMiningWidth.constant = SCREEN_WIDTH;
                if (![weakself.cycleContentArr containsObject:Show_Sheet_Mining]) {
                    [weakself.cycleContentArr addObject:Show_Sheet_Mining];
                }
                weakself.cycleContentWidth.constant = SCREEN_WIDTH*weakself.cycleContentArr.count;
                weakself.cyclePageC.numberOfPages = weakself.cycleContentArr.count;
                [weakself refreshMiningTip];
            }
        }]; // 交易挖矿活动列表
    });
}

- (void)handlerTopupCountryList {
    NSArray *cacheArr = [[TMCache sharedCache] objectForKey:TM_Chache_Topup_Country_List]?:@[];
    
    [_countrySource removeAllObjects];
    [_countrySource addObjectsFromArray:cacheArr];
    if (_countrySource.count > 0) {
        _selectCountryM = _countrySource.firstObject;
        
        [self setupNinaPage];
    }
}

#pragma mark - QGas回购销毁
- (void)getBuybackBurn {
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [BuybackBurnUtil requestBuybackBurn_list_v2:^(NSArray<BuybackBurnModel *> * _Nonnull arr) {
            if (arr.count > 0) {
                BuybackBurnModel *model = arr.firstObject;
                weakself.buybackBurnM = model;
                weakself.buybackBurnWidth.constant = SCREEN_WIDTH;
                if (![weakself.cycleContentArr containsObject:Show_Buyback_Burn]) {
                    [weakself.cycleContentArr addObject:Show_Buyback_Burn];
                }
                weakself.cycleContentWidth.constant = SCREEN_WIDTH*weakself.cycleContentArr.count;
                weakself.cyclePageC.numberOfPages = weakself.cycleContentArr.count;
//                [weakself refreshBuybackBurn];
            }
        }];
    });
}

- (void)getParterPlan {
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [GroupBuyUtil requestIsInGroupBuyActiviyTime:^(BOOL isInGroupBuyActiviyTime) {
            if (isInGroupBuyActiviyTime) {
                weakself.parterPlanWidth.constant = SCREEN_WIDTH;
                [weakself.cycleContentArr addObject:Show_Partner_Plan];
                weakself.cycleContentWidth.constant = SCREEN_WIDTH*weakself.cycleContentArr.count;
                weakself.cyclePageC.numberOfPages = weakself.cycleContentArr.count;
//                [weakself refreshParterPlan];
            }
        }];
    });
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
        make.top.mas_equalTo(weakself.inviteRankBack).offset(5);
        make.left.bottom.right.mas_equalTo(weakself.inviteRankBack).offset(0);
    }];
}

- (void)refreshViewText {
    _titleLab.text = kLang(@"top_up");
//    _sendRechargeLab.text = kLang(@"send_recharge_to");
//    _inputTipLab.text = kLang(@"enter_your_phone_number_or_select_from_your_contacts_");
    [_actNowBtn setTitle:kLang(@"act_now__") forState:UIControlStateNormal];
    _introduceFriendLab.text = kLang(@"refer_friends_");
//    _carrierPackageLab.text = kLang(@"carrier_package");
    
//    _qlcTradeLab.text = kLang(@"qlc_go_trade");
//    [_hourBtn setTitle:kLang(@"qlc_hour") forState:UIControlStateNormal];
//    [_dayBtn setTitle:kLang(@"qlc_day") forState:UIControlStateNormal];
//    [_weekBtn setTitle:kLang(@"qlc_week") forState:UIControlStateNormal];
//    [_monthBtn setTitle:kLang(@"qlc_month") forState:UIControlStateNormal];
//    [_yearBtn setTitle:kLang(@"qlc_year") forState:UIControlStateNormal];
    
    [_buyback_joinBtn setTitle:kLang(@"join_now_1") forState:UIControlStateNormal];
    [_buyback_detailBtn setTitle:kLang(@"minging_more_details") forState:UIControlStateNormal];
    [_mining_detailBtn setTitle:kLang(@"minging_more_details") forState:UIControlStateNormal];
    [_parterPlan_detailBtn setTitle:kLang(@"minging_more_details") forState:UIControlStateNormal];
    
    NSString *parterPlanTipShowStr = kLang(@"join_the_q_wallet_recharge_sales_partner_plan_for_commissions");
    NSString *commissionsStr = kLang(@"commissions");
    NSMutableAttributedString *parterPlan_tipAtt = [[NSMutableAttributedString alloc] initWithString:parterPlanTipShowStr];
    [parterPlan_tipAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Medium" size:14] range:NSMakeRange(0, parterPlanTipShowStr.length)];
//    [parterPlan_tipAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Medium" size:14] range:[tipShowStr rangeOfString:tipStr]];
    [parterPlan_tipAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x29282A) range:NSMakeRange(0, parterPlanTipShowStr.length)];
    [parterPlan_tipAtt addAttribute:NSForegroundColorAttributeName value:MAIN_BLUE_COLOR range:[parterPlanTipShowStr rangeOfString:commissionsStr]];
    _parterPlanLab.attributedText = parterPlan_tipAtt;
    
    NSString *moreQGASShowStr = kLang(@"earn_more_qgas");
    NSString *QGASStr = kLang(@"qgas");
    NSMutableAttributedString *moreQGAS_tipAtt = [[NSMutableAttributedString alloc] initWithString:moreQGASShowStr];
    [moreQGAS_tipAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Medium" size:16] range:NSMakeRange(0, moreQGASShowStr.length)];
    [moreQGAS_tipAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x29282A) range:NSMakeRange(0, moreQGASShowStr.length)];
    [moreQGAS_tipAtt addAttribute:NSForegroundColorAttributeName value:MAIN_BLUE_COLOR range:[moreQGASShowStr rangeOfString:QGASStr]];
    _earnMoreLab.attributedText = moreQGAS_tipAtt;
    
    NSString *buybackQGasStr = @"QGas";
    NSString *buybackShowStr = [NSString stringWithFormat:@"%@ %@",buybackQGasStr,kLang(@"buyback_destruction_plan")];
    NSMutableAttributedString *buyback_tipAtt = [[NSMutableAttributedString alloc] initWithString:buybackShowStr];
    [buyback_tipAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Medium" size:16] range:NSMakeRange(0, buybackShowStr.length)];
    [buyback_tipAtt addAttribute:NSForegroundColorAttributeName value:MAIN_BLUE_COLOR range:NSMakeRange(0, buybackShowStr.length)];
    [buyback_tipAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x29282A) range:[buybackShowStr rangeOfString:buybackQGasStr]];
    _buyback_tipLab.attributedText = buyback_tipAtt;
    
    [self refreshMiningTip];
}

- (void)refreshMiningTip {
    NSString *tipStr = kLang(@"daily_qgas_trade_mining_pool_up_to_");
    NSString *tipShowStr = [NSString stringWithFormat:@"%@%@%@",tipStr,_miningActivityM.totalRewardAmount?:@"0",@" QLC！"];
    NSMutableAttributedString *mining_tipAtt = [[NSMutableAttributedString alloc] initWithString:tipShowStr];
//    NSLog(@"font = %@",_mining_tipLab.font);
    [mining_tipAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Medium" size:20] range:NSMakeRange(0, tipShowStr.length)];
    [mining_tipAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Medium" size:14] range:[tipShowStr rangeOfString:tipStr]];
    [mining_tipAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x0D8EE9) range:NSMakeRange(0, tipShowStr.length)];
    [mining_tipAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x29282A) range:[tipShowStr rangeOfString:tipStr]];
    _mining_tipLab.attributedText = mining_tipAtt;
}

//- (void)getTokenPrice {
//    kWeakSelf(self);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
//        [weakself requestTokenPriceOfQLC];
//    });
//}

//- (void)addChart {
//    if (!_showQLC) {
//        return;
//    }
//    _chartV = [QLCHistoryChartView getInstance];
//    [_chartBack addSubview:_chartV];
//    kWeakSelf(self);
//    [_chartV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.mas_equalTo(weakself.chartBack).offset(0);
//    }];
//
//    [self refreshChartBtn:_hourBtn];
//}

//- (void)refreshChartBtn:(UIButton *)btn {
//    _hourBtn.selected = btn==_hourBtn;
//    _dayBtn.selected = btn==_dayBtn;
//    _weekBtn.selected = btn==_weekBtn;
//    _monthBtn.selected = btn==_monthBtn;
////    _yearBtn.selected = btn==_yearBtn;
//
//    _qlcFrequency = @"";
//    if (btn==_hourBtn) {
//        _qlcFrequency = @"1h";
//    } else if (btn==_dayBtn) {
//        _qlcFrequency = @"1d";
//    } else if (btn==_weekBtn) {
//        _qlcFrequency = @"1w";
//    } else if (btn==_monthBtn) {
//        _qlcFrequency = @"1M";
////    } else if (btn==_yearBtn) {
////        _qlcFrequency = @"1y";
//    }
//
//    kWeakSelf(self);
//    [_chartV updateWithSymbol:@"QLC" frequency:_qlcFrequency?:@"" noDataBlock:^{
//        weakself.chartBackHeight.constant = 191;
//    } haveDataBlock:^{
//        weakself.chartBackHeight.constant = 191;
//    }];
//}

- (void)getRedDotOfMe {
    [TabbarHelper requestUser_red_pointWithCompleteBlock:^(RedPointModel *redPointM) {
        if ([redPointM.dailyIncomePoint integerValue] == 1 || [redPointM.invitePoint integerValue] == 1 || [redPointM.rewardTotal integerValue] == 1) {
            UITabBarItem *item = kAppD.mtabbarC.tabBar.items[TabbarIndexMy];
            [item setBadgeCenterOffset:CGPointMake(0, 5)];
            [item setBadgeColor:UIColorFromRGB(0xD0021B)];
            [item showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
        }
    }];
}

- (void)setupNinaPage {
//    if (_ninaPagerView) {
//        [_ninaPagerView removeFromSuperview];
//        _ninaPagerView = nil;
//    }
    
//    if (!_ninaPagerView) {
        kWeakSelf(self);
        NSMutableArray *titleArr = [NSMutableArray array];
        _ninaObjectSource = [NSMutableArray array];
        NSMutableArray *countryArr = [NSMutableArray array];
        // 全部
        TopupCountryModel *allModel = [TopupCountryModel new];
        allModel.globalRoaming = @"";
        allModel.name = @"全部";
        allModel.nameEn = @"All";
        [countryArr addObject:allModel];
        [countryArr addObjectsFromArray:_countrySource];
        [countryArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TopupCountryModel *model = obj;
            TopupProductSubViewController *vc = [TopupProductSubViewController new];
            vc.inputGlobalRoaming = model.globalRoaming?:@"";
            vc.inputDeductionTokenM = weakself.selectDeductionTokenM;
            if (idx > 0) {
                vc.inputCountryM = weakself.countrySource[idx-1];
            } else {
                vc.inputCountryM = allModel;
            }
            vc.isInGroupBuyActivityTime = weakself.isInGroupBuyActiviyTime;
            vc.groupBuyMinimumDiscount = weakself.groupBuyMinimumDiscount;
            vc.updateTableHeightBlock = ^(CGFloat tableHeight) {
                weakself.tableBackHeight.constant = tableHeight + weakself.ninaPagerView.topTabHeight;
                weakself.ninaPagerView.ninaBaseView.frame = CGRectMake(weakself.ninaPagerView.ninaBaseView.left, weakself.ninaPagerView.ninaBaseView.top, weakself.ninaPagerView.ninaBaseView.width, weakself.tableBackHeight.constant);
                weakself.ninaPagerView.ninaBaseView.scrollView.frame = CGRectMake(weakself.ninaPagerView.ninaBaseView.scrollView.left, weakself.ninaPagerView.ninaBaseView.scrollView.top, weakself.ninaPagerView.ninaBaseView.scrollView.width, tableHeight);
                
            };
            NSString *title = @"";
            NSString *language = [Language currentLanguageCode];
            if ([language isEqualToString:LanguageCode[0]]) { // 英文
                title = model.nameEn;
            } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
                title = model.name;
            } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
                title = model.nameEn;
            }
            [titleArr addObject:title];
            [weakself.ninaObjectSource addObject:vc];
        }];
        
    if (!_ninaPagerView) {
        _ninaPagerView = [[NinaPagerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100) WithTitles:titleArr WithObjects:_ninaObjectSource];
        _ninaPagerView.unSelectTitleColor = UIColorFromRGB(0x505050);
        _ninaPagerView.selectTitleColor = UIColorFromRGB(0xF50B6E);
        _ninaPagerView.titleFont = 16;
        _ninaPagerView.titleScale = 1;
        _ninaPagerView.selectBottomLinePer = 0.8;
        _ninaPagerView.selectBottomLineHeight = 0;
        _ninaPagerView.ninaPagerStyles = NinaPagerStyleStateNormal;
        _ninaPagerView.underlineColor = UIColorFromRGB(0xfdfdfd);
        _ninaPagerView.topTabHeight = 40;
//        _ninaPagerView.sliderHeight = 560;
        _ninaPagerView.topTabBackGroundColor = [UIColor whiteColor];
        _ninaPagerView.delegate = self;
        _ninaPagerView.backgroundColor = [UIColor whiteColor];
        _ninaPagerView.underLineHidden = YES;
        [_tableBack addSubview:_ninaPagerView];
        [_ninaPagerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(weakself.tableBack).offset(0);
        }];
    } else {
        [_ninaPagerView reloadTopTabByTitles:titleArr WithObjects:_ninaObjectSource];
    }
        
        _tableBackHeight.constant = _ninaPagerView.topTabHeight;
        
//    }
}

- (void)refreshNinaPagerViewVC {
    if (_ninaPagerView) {
        TopupProductSubViewController *vc = _ninaObjectSource[_ninaPagerView.pageIndex];
        vc.inputDeductionTokenM = _selectDeductionTokenM;
        vc.groupBuyMinimumDiscount = _groupBuyMinimumDiscount;
        vc.isInGroupBuyActivityTime = _isInGroupBuyActiviyTime;
        [vc pullRefresh];
    } else {
        if (_selectDeductionTokenM) {
            [self requestTopup_country_list];
        } else {
            [self requestTopup_pay_token];
        }
    }
}

- (void)refreshSelectDeductionTokenView {
    if (_selectDeductionTokenM) {
        kWeakSelf(self);
        NSURL *url = [NSURL URLWithString:_selectDeductionTokenM.logoPng];
        [_chooseDeductionBtn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[_selectDeductionTokenM getDeductionTokenImage] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            UIImage *img = [image sd_resizedImageWithSize:CGSizeMake(28, 28) scaleMode:SDImageScaleModeAspectFit];
            if (image) {
                [weakself.chooseDeductionBtn setImage:img forState:UIControlStateNormal];
            }
        }];
    }
}

//- (void)addCountryView {
//    kWeakSelf(self);
//    if (!_countryV) {
//        _countryV = [TopupMobilePlanCountry getInstance];
//        _countryV.countrySelectB = ^(TopupCountryModel *selectCountryM) {
//            weakself.selectCountryM = selectCountryM;
//            weakself.currentPage = 1;
//            [weakself requestTopup_product_list];
//        };
//        [_countryBack addSubview:_countryV];
//        [_countryV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.bottom.right.mas_equalTo(weakself.countryBack).offset(0);
//        }];
//    }
//}

#pragma mark - 轮播图
- (void)addCycleTimer {
    _cycleTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(cycleScrollChange) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_cycleTimer forMode:NSRunLoopCommonModes];
}

- (void)removeCycleTimer {
    if (_cycleTimer) {
        [_cycleTimer invalidate];
        _cycleTimer = nil;
    }
}

- (void)cycleScrollChange {
    if (_cyclePageC.currentPage == _cycleContentArr.count-1) {
        [_cycleScrollV setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        [_cycleScrollV setContentOffset:CGPointMake(SCREEN_WIDTH*(_cyclePageC.currentPage+1), 0) animated:YES];
    }
    
//    if (_cyclePageC.currentPage == 0) {
//        if (_cycleContentWidth.constant > SCREEN_WIDTH) {
//            [_cycleScrollV setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
//        }
//    } else if (_cyclePageC.currentPage == 1) {
//        [_cycleScrollV setContentOffset:CGPointMake(0, 0) animated:YES];
//    }
}

#pragma mark - Request
//- (void)requestTopup_product_list {
//    kWeakSelf(self);
////    NSString *phoneNumber = @"";
//    NSString *page = [NSString stringWithFormat:@"%li",_currentPage];
//    NSString *size = TopupNetworkSize;
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"page":page,@"size":size}];
//    NSString *selectGlobalRoaming = _selectCountryM?_selectCountryM.globalRoaming:@"";
//    if (selectGlobalRoaming != nil && ![selectGlobalRoaming isEmptyString]) {
//        [params setObject:selectGlobalRoaming forKey:@"globalRoaming"];
//    }
//    [RequestService requestWithUrl10:topup_product_list_v2_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
////    [RequestService requestWithUrl5:topup_product_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        [weakself.mainScroll.mj_header endRefreshing];
//        [weakself.mainScroll.mj_footer endRefreshing];
//        if ([responseObject[Server_Code] integerValue] == 0) {
//            NSArray *arr = [TopupProductModel mj_objectArrayWithKeyValuesArray:responseObject[@"productList"]];
//            if (weakself.currentPage == 1) {
//                [weakself.sourceArr removeAllObjects];
//            }
//
//            [weakself.sourceArr addObjectsFromArray:arr];
//            weakself.currentPage += 1;
//
////            weakself.mainTableHeight.constant = weakself.sourceArr.count*TopupCell_Height;
////            [weakself.mainTable reloadData];
//            CGFloat line = ceil(weakself.sourceArr.count/2.0);
////            weakself.mainCollectionHeight.constant = line*TopupMobilePlanCell_Height+(line-1)*miniSpacingDistance;
////            [weakself.mainCollection reloadData];
//
//            if (arr.count < [TopupNetworkSize integerValue]) {
//                [weakself.mainScroll.mj_footer endRefreshingWithNoMoreData];
////                weakself.mainScroll.mj_footer.hidden = arr.count<=0?YES:NO;
//                weakself.mainScroll.mj_footer.hidden = YES;
//            } else {
//                weakself.mainScroll.mj_footer.hidden = NO;
//            }
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        [weakself.mainScroll.mj_header endRefreshing];
//        [weakself.mainScroll.mj_footer endRefreshing];
//    }];
//}

- (void)requestTopup_country_list {
    kWeakSelf(self);
    NSString *page = @"1";
    NSString *size = TopupNetworkSize;
    NSDictionary *params = @{@"page":page,@"size":size};
    [RequestService requestWithUrl10:topup_country_list_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [TopupCountryModel mj_objectArrayWithKeyValuesArray:responseObject[@"countryList"]];
            
            [[TMCache sharedCache] setObject:arr forKey:TM_Chache_Topup_Country_List];
            
            [weakself handlerTopupCountryList];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {

    }];
}

- (void)requestTopup_pay_token {
    kWeakSelf(self);
    NSDictionary *params = @{};
    [RequestService requestWithUrl10:topup_pay_token_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [TopupDeductionTokenModel mj_objectArrayWithKeyValuesArray:responseObject[@"payTokenList"]];
            weakself.selectDeductionTokenM = (arr&&arr.count>0)?arr.firstObject:nil;
            [weakself refreshSelectDeductionTokenView];
            
            [weakself requestTopup_country_list];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestIsInGroupBuyActiviyTime {
    kWeakSelf(self);
    [GroupBuyUtil requestIsInGroupBuyActiviyTime:^(BOOL isInGroupBuyActiviyTime) {
        weakself.isInGroupBuyActiviyTime = isInGroupBuyActiviyTime;
        if (weakself.ninaPagerView) {
            TopupProductSubViewController *vc = weakself.ninaObjectSource[weakself.ninaPagerView.pageIndex];
            vc.isInGroupBuyActivityTime = weakself.isInGroupBuyActiviyTime;
            [vc refreshTable];
        }
    }];
}

- (void)requestTopup_group_kind_list {
    kWeakSelf(self);
    NSString *page = @"1";
    NSString *size = TopupNetworkSize;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"page":page,@"size":size}];
    [RequestService requestWithUrl10:topup_group_kind_list_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [GroupKindModel mj_objectArrayWithKeyValuesArray:responseObject[@"groupKindList"]];
            arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    GroupKindModel *m1 = obj1;
                    GroupKindModel *m2 = obj2;
                return ([m1.discount doubleValue] > [m2.discount doubleValue]);
//                    return NSOrderedAscending;
            }];
            if (arr && arr.count > 0) {
                weakself.groupBuyMinimumDiscount = ((GroupKindModel *)arr.firstObject).discount;
                if (weakself.ninaPagerView) {
                    TopupProductSubViewController *vc = weakself.ninaObjectSource[weakself.ninaPagerView.pageIndex];
                    vc.groupBuyMinimumDiscount = weakself.groupBuyMinimumDiscount;
                    [vc refreshTable];
                }
            }
            
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

//- (void)requestTokenPriceOfQLC {
//    kWeakSelf(self);
//    NSString *symbol = @"QLC";
//    NSString *coin = [ConfigUtil getLocalUsingCurrency]?:@"";
//    NSDictionary *params = @{@"symbols":@[symbol],@"coin":coin};
//    [RequestService requestWithUrl5:tokenPrice_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
//            NSMutableArray *tokenPriceArr = [NSMutableArray array];
//            NSArray *arr = responseObject[Server_Data];
//            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                TokenPriceModel *model = [TokenPriceModel getObjectWithKeyValues:obj];
//                model.coin = coin;
//                [tokenPriceArr addObject:model];
//            }];
//
//            __block NSString *price = @"";
//            NSString *num = @"1";
//            [tokenPriceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                TokenPriceModel *tempM = obj;
//                if ([tempM.symbol isEqualToString:symbol]) {
//                    price = num.mul(tempM.price);
//                    *stop = YES;
//                }
//            }];
//            weakself.qlcPriceLab.text = [NSString stringWithFormat:@"%@%@",[ConfigUtil getLocalUsingCurrencySymbol],price];
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//    }];
//}

#pragma mark - NinaPagerViewDelegate
- (void)ninaCurrentPageIndex:(NSInteger)currentPage currentObject:(id)currentObject lastObject:(id)lastObject {    
    TopupProductSubViewController *vc = currentObject;
    vc.isInGroupBuyActivityTime = _isInGroupBuyActiviyTime;
    vc.groupBuyMinimumDiscount = _groupBuyMinimumDiscount;
    if (vc.updateTableHeightBlock) {
        vc.updateTableHeightBlock([vc getTableHeight]);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _cycleScrollV) {
        int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        _cyclePageC.currentPage = index;
    }
}

//#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return TopupCell_Height;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    TopupProductModel *model = _sourceArr[indexPath.row];
//    if (model.stock && [model.stock doubleValue] == 0) { // 售罄
//        return;
//    }
//
//    [self jumpToChooseTopupPlan];
//}
//
//#pragma mark - UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _sourceArr.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    TopupCell *cell = [tableView dequeueReusableCellWithIdentifier:TopupCellReuse];
//
//    TopupProductModel *model = _sourceArr[indexPath.row];
//    [cell config:model];
//
//    return cell;
//}

//#pragma mark - UICollectionViewDataSource
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return _sourceArr.count;
//}
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    TopupMobilePlanCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TopupMobilePlanCell_Reuse forIndexPath:indexPath];
//
//    TopupProductModel *model = _sourceArr[indexPath.item];
//    [cell config:model];
//
//    return cell;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    CGFloat width = (SCREEN_WIDTH - miniSpacingDistance - 2*insetForSectionDistance)/2.0;
////    CGSize size = [@"1234" boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
////       options:NSStringDrawingUsesLineFragmentOrigin
////    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
////       context:nil].size;
////    CGFloat height = 220-24+size.height;
////    return CGSizeMake(width, height);
//    return CGSizeMake(width, TopupMobilePlanCell_Height);
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
////    CGFloat left = (GHScreenWidth-GHCoursePeopleCell_Width*2)/4.0;
////    return UIEdgeInsetsMake(insetForSectionDistance, left, insetForSectionDistance, left);
//    //    return UIEdgeInsetsMake(0, insetForSectionDistance, 0, insetForSectionDistance);
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return miniSpacingDistance;
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return miniSpacingDistance;
//}
//
//////HeaderView
////- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
////{
////    PublicCommentCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:publicCommentCollectionViewCellHeaderIdentifier forIndexPath:indexPath];
////    if (indexPath.section == 0) {
////        headerView.titleLab.text = @"分类";
////    } else if (indexPath.section == 1) {
////        headerView.titleLab.text = @"商圈";
////    }
////
////    return headerView;
////}
////
////- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
////{
////    return CGSizeMake(k_Screen_Width, 44);
////}
//
//#pragma mark --UICollectionViewDelegate
////UICollectionView被选中时调用的方法
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//
//    TopupProductModel *model = _sourceArr[indexPath.item];
//    if (model.stock && [model.stock doubleValue] == 0) { // 售罄
//        return;
//    }
//
//    [self jumpToChooseTopupPlan];
//}
//
////返回这个UICollectionView是否可以被选择
//-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

#pragma mark - Action

- (IBAction)menuAction:(id)sender {
    
//    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",@"18812341234"];
//    NSURL *URL = [NSURL URLWithString:str];
//    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
//        //OpenSuccess=选择 呼叫 为 1  选择 取消 为0
//        NSLog(@"OpenSuccess=%d",success);
//    }];

    [self jumpToMyTopupOrder];
}

//- (IBAction)inputNumAction:(id)sender {
//    [self jumpToChooseTopupPlan];
////    [self jumpToTopupH5];
//}

- (IBAction)makeQGASAction:(id)sender {
    [AppJumpHelper jumpToWallet];
}

- (IBAction)miningDetaiAction:(id)sender {
    [self jumpToSheetMining];
}

//- (IBAction)chartHourAction:(UIButton *)sender {
//    [self refreshChartBtn:sender];
//}
//
//- (IBAction)chartDayAction:(UIButton *)sender {
//    [self refreshChartBtn:sender];
//}
//
//- (IBAction)chartWeekAction:(UIButton *)sender {
//    [self refreshChartBtn:sender];
//}
//
//- (IBAction)chartMonthAction:(UIButton *)sender {
//    [self refreshChartBtn:sender];
//}

//- (IBAction)chartYearAction:(UIButton *)sender {
//    [self refreshChartBtn:sender];
//}

//- (IBAction)qlcTradeAction:(id)sender {
//    [AppJumpHelper jumpToOTC];
//}

- (IBAction)introduceFriendAction:(id)sender {
    [self jumpToShareFriends];
}

- (IBAction)parterPlanAction:(id)sender {
    [self jumpToAgentReward];
}

- (IBAction)chooseTokenAction:(id)sender {
    [self jumpToChooseDeductionToken];
}

- (IBAction)buybackBurnDetailAction:(id)sender {
    [self jumpToBuybackDetail];
    return;
    
    WebViewController *vc = [[WebViewController alloc] init];
    vc.inputUrl = @"https://medium.com/@QLC_team/qlc-chain-is-conducting-qgas-buyback-and-burn-program-in-q-wallet-otc-173cc8c9153b";
    vc.inputTitle = kLang(@"qgas_buyback_destruction_plan");
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)buybackBurnJoinAction:(id)sender {
    [AppJumpHelper jumpToOTC];
    [kAppD.mtabbarC.homeBuySellVC showSellView];
}


#pragma mark - Transition
- (void)jumpToMyTopupOrder {
    MyTopupOrderViewController *vc = [MyTopupOrderViewController new];
    vc.inputBackToRoot = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)jumpToChooseTopupPlan {
//    ChooseTopupPlanViewController *vc = [ChooseTopupPlanViewController new];
//    vc.inputCountryM = _selectCountryM;
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)jumpToSheetMining {
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
    
    SheetMiningViewController *vc = [SheetMiningViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToShareFriends {
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
    
//    ShareFriendsViewController *vc = [ShareFriendsViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
    InviteFriendNowViewController *vc = [InviteFriendNowViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToAgentReward {
    AgentRewardViewController *vc = [AgentRewardViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToChooseDeductionToken {
    ChooseDeductionTokenViewController *vc = [ChooseDeductionTokenViewController new];
    kWeakSelf(self);
    vc.completeBlock = ^(TopupDeductionTokenModel * _Nonnull model) {
        weakself.selectDeductionTokenM = model;
        [weakself refreshSelectDeductionTokenView];
        if (_ninaPagerView) {
            [self refreshNinaPagerViewVC];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToBuybackDetail {
    BuybackDetailViewController *vc = [BuybackDetailViewController new];
    vc.inputBuybackBurnM = _buybackBurnM;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Noti
- (void)languageChangeNoti:(NSNotification *)noti {
    [self refreshViewText];
    [_mainScroll.mj_header beginRefreshing];
    [_inviteRankV startRefresh];
    
//    [self getTokenPrice];
    if (_selectDeductionTokenM) {
        [self requestTopup_country_list];
    } else {
        [self requestTopup_pay_token];
    }
    
}

- (void)weixinPayBackNoti:(NSNotification *)noti {
    [self jumpToMyTopupOrder];
}

- (void)loginSuccessNoti:(NSNotification *)noti {
    [_inviteRankV startRefresh];
    
    [UserUtil updateUserInfoAfterLogin];
}

- (void)logoutSuccessNoti:(NSNotification *)noti {
    [_inviteRankV startRefresh];
}

- (void)updateInfoAfterLoginNoti:(NSNotification *)noti {
    [ClaimQGASTipView show:^{
        
    }];
}


@end
