//
//  DeFiDetailViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DeFiDetailViewController.h"
#import "UIView+Gradient.h"
#import "UIView+Visuals.h"
#import "DeFiKeystatsViewController.h"
#import "DeFiActivedataViewController.h"
#import "DeFiHistoricalstatsViewController.h"
#import "DefiProjectListModel.h"
#import <TMCache/TMCache.h>
#import "DefiRatePopView.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import "NEOWalletInfo.h"
#import "TokenListHelper.h"
#import "RLArithmetic.h"
#import "NEOAddressInfoModel.h"
#import "DefiRateLoadView.h"
#import "DefiProjectModel.h"
#import "FirebaseConstants.h"
#import "FirebaseUtil.h"
#import "DefiRateFailView.h"

@interface DeFiDetailViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (weak, nonatomic) IBOutlet UIView *mainScrollContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainScrollContentWidth;

@property (weak, nonatomic) IBOutlet UIButton *rateBtn;
@property (weak, nonatomic) IBOutlet UIButton *experBtn;

@property (weak, nonatomic) IBOutlet UILabel *ratingKeyLab;
@property (weak, nonatomic) IBOutlet UILabel *ratingValLab;
@property (weak, nonatomic) IBOutlet UIView *rateBack;

@property (weak, nonatomic) IBOutlet UIView *topBack;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;


@property (weak, nonatomic) IBOutlet UIView *type1Back;
@property (weak, nonatomic) IBOutlet UILabel *type1Lab;
@property (weak, nonatomic) IBOutlet UIView *type2Back;
@property (weak, nonatomic) IBOutlet UILabel *type2Lab;

@property (weak, nonatomic) IBOutlet UIButton *keystatsBtn;
@property (weak, nonatomic) IBOutlet UIButton *activedateBtn;
@property (weak, nonatomic) IBOutlet UIButton *historicalstatsBtn;
@property (weak, nonatomic) IBOutlet UIView *sliderV;

@property (nonatomic, strong) DeFiKeystatsViewController *keystats;

@property (nonatomic, strong) DefiRateLoadView *rateLoadView;
@property (nonatomic, strong) __block NSString *qlcAmount_Neo;
@property (nonatomic, strong) NSString *selectScore;

@end

@implementation DeFiDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self addChild];
    [self addChildVC];
    [self handlerRecordLocal];
    [self request_defi_project];
}

#pragma mark - Operation
- (void)configInit {
    [self.view addHorizontalQGradientWithStart:UIColorFromRGB(0x4986EE) end:UIColorFromRGB(0x4752E9) frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _rateBtn.layer.cornerRadius = 4;
    _rateBtn.layer.masksToBounds = YES;
    _rateBtn.layer.borderColor = MAIN_BLUE_COLOR.CGColor;
    _rateBtn.layer.borderWidth = 1.0;
    _experBtn.layer.cornerRadius = 4;
    _experBtn.layer.masksToBounds = YES;
    _rateBack.hidden = YES;
    _ratingValLab.text = kLang(@"defi_unrated");
    
    [_topBack addShadowWithOpacity:1 shadowColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1] shadowOffset:CGSizeMake(0,4) shadowRadius:10 andCornerRadius:12];
    [_rateBack addShadowWithOpacity:1 shadowColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15] shadowOffset:CGSizeMake(0,2) shadowRadius:5 andCornerRadius:6];
    
    _type1Back.layer.cornerRadius = 2;
    _type1Back.layer.masksToBounds = YES;
    _type2Back.layer.cornerRadius = 2;
    _type2Back.layer.masksToBounds = YES;
    
    _mainScrollContentWidth.constant = SCREEN_WIDTH*3;
    
    [self refreshProjectView];
    [self refreshText];
}

- (void)refreshProjectView {
    NSString *iconStr = [[_inputProjectListM.name lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    _icon.image = [UIImage imageNamed:iconStr];
    _nameLab.text = [_inputProjectListM getShowName];
//    _detailLab.text = _inputProjectListM.description;
    
    _type1Lab.text = _inputProjectListM.chain;
    _type2Lab.text = _inputProjectListM.category;
    _type2Lab.textColor = [_inputProjectListM getCategoryColor];
    _type2Back.backgroundColor = [[_inputProjectListM getCategoryColor] colorWithAlphaComponent:0.15];
}

- (void)refreshText {
    _titleLab.text = kLang(@"defi_details");
    _ratingKeyLab.text = kLang(@"defi_rating");
    [_keystatsBtn setTitle:kLang(@"defi_key_stats") forState:UIControlStateNormal];
    [_activedateBtn setTitle:kLang(@"defi_active_data") forState:UIControlStateNormal];
    [_historicalstatsBtn setTitle:kLang(@"defi_historical_stats") forState:UIControlStateNormal];
    [_rateBtn setTitle:kLang(@"defi_rate") forState:UIControlStateNormal];
    [_experBtn setTitle:kLang(@"defi_exper") forState:UIControlStateNormal];
}

- (void)handlerRecordLocal {
    kWeakSelf(self);
    NSArray *localArr = [[TMCache sharedCache] objectForKey:Defi_Record_Local]?:@[];
    __block BOOL isContain = NO;
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DefiProjectListModel *model = obj;
        if ([model.ID isEqualToString:weakself.inputProjectListM.ID]) {
            isContain = YES;
        }
    }];
    if (isContain == NO) {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:localArr];
        [tempArr addObject:_inputProjectListM];
        [[TMCache sharedCache] setObject:tempArr forKey:Defi_Record_Local];
    }
}

- (void)addChild {
//    kWeakSelf(self);
    _keystats = [[DeFiKeystatsViewController alloc]init];
    [self addChildViewController:_keystats];
    
    DeFiActivedataViewController *activedata = [[DeFiActivedataViewController alloc]init];
    activedata.inputProjectListM = _inputProjectListM;
    [self addChildViewController:activedata];
    
    DeFiHistoricalstatsViewController *historicalstats = [[DeFiHistoricalstatsViewController alloc]init];
    historicalstats.inputProjectListM = _inputProjectListM;
    [self addChildViewController:historicalstats];
}

- (void)addChildVC {
    NSInteger n = _mainScroll.contentOffset.x / _mainScroll.frame.size.width;
    UITableViewController * ChildVC = (UITableViewController * )self.childViewControllers[n];
    ChildVC.view.frame = _mainScroll.bounds;
    if (ChildVC.view.superview) {
        return;
    }
    [_mainScroll addSubview:ChildVC.view];
    kWeakSelf(self);
    [ChildVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.mas_equalTo(weakself.mainScroll).offset(0);
        make.top.mas_equalTo(weakself.mainScroll).offset(0);
        make.left.mas_equalTo(n*SCREEN_WIDTH);
        make.bottom.mas_equalTo(weakself.mainScroll).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
}
    
- (void)animateSlider:(UIButton *)btn {
    kWeakSelf(self);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakself.sliderV.center = CGPointMake(btn.center.x, btn.bottom+weakself.sliderV.height/2.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)getUserQLCAmount_NEO {
    _rateLoadView = [DefiRateLoadView getInstance];
    [_rateLoadView show];
    
    _qlcAmount_Neo = @"0";
    NSArray *neoWallet = [NEOWalletInfo getAllWalletInKeychain];
    if (neoWallet.count > 0) {
        [self getUserQLCAmountOneByOne_NEO:neoWallet];
    } else { // 所有neo钱包的qlc总量=0
        [[DefiRateFailView getInstance] show];
//        [self request_defi_rating];
    }
}

- (void)getUserQLCAmountOneByOne_NEO:(NSArray *)neoArr {
    kWeakSelf(self);
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:neoArr];
    NEOWalletInfo *model = tempArr.firstObject;
    [TokenListHelper requestNEOAddressInfo:model.address?:@"" showLoad:NO completeBlock:^(NEOAddressInfoModel *infoM, BOOL success) {
        if (success) {
            [infoM.balance enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NEOAssetModel *assetModel = obj;
                if ([assetModel.asset_symbol isEqualToString:@"QLC"]) {
                    weakself.qlcAmount_Neo = weakself.qlcAmount_Neo.add(assetModel.amount);
                    *stop = YES;
                }
            }];
            [tempArr removeObjectAtIndex:0];
            if (tempArr.count > 0) {
                [weakself getUserQLCAmountOneByOne_NEO:tempArr];
            } else { // 所有neo钱包的qlc总量
                RLComparisonResult result = weakself.qlcAmount_Neo.compare(@"0");
                if (result == RLOrderedSame || result == RLOrderedAscending) {
                    [[DefiRateFailView getInstance] show];
                } else {
                    [weakself request_defi_rating];
                }
            }
        } else {
            [weakself.rateLoadView hide];
            [kAppD.window makeToastDisappearWithText:@"defi_load_qlc_amount_fail"];
        }
    }];
}

#pragma mark - Request
- (void)request_defi_rating {
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
    NSString *projectId = _inputProjectListM.ID?:@"";
    NSString *qlcAmount = _qlcAmount_Neo?:@"";
    NSString *score = _selectScore?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"projectId":projectId,@"score":score,@"qlcAmount":qlcAmount};
    [RequestService requestWithUrl6:defi_rating_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.rateLoadView hide];
        if ([responseObject[Server_Code] integerValue] == 0) {
            [weakself request_defi_project];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.rateLoadView hide];
    }];
}

- (void)request_defi_project {
    kWeakSelf(self);
    NSString *projectId = _inputProjectListM.ID?:@"";
    NSDictionary *params = @{@"projectId":projectId};
    [RequestService requestWithUrl5:defi_project_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            DefiProjectModel *model = [DefiProjectModel mj_objectWithKeyValues:responseObject[@"project"]];
            weakself.detailLab.text = model.Description;
            weakself.rateBack.hidden = [model.rating integerValue] == 0?YES:NO;
            weakself.ratingValLab.text = [model getRatingStr];
            
            [weakself.keystats refreshView:model.tvlArr];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
    }];
}

#pragma mark - UIScrollViewDelegate
//执行动画结束跳转到这里
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == _mainScroll) {
        [self addChildVC];
    }
    
}

//人为手动滚动结束到这里
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSInteger n = _mainScroll.contentOffset.x / _mainScroll.width;
    
    if (scrollView == _mainScroll) {
        [self addChildVC];
    }
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rateAction:(id)sender {
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
    
    kWeakSelf(self);
    [[DefiRatePopView getInstance] show:^(NSString * _Nonnull score) {
        weakself.selectScore = score;
        [weakself getUserQLCAmount_NEO];
    }];
    
    [FirebaseUtil logEventWithItemID:Defi_Detail_Rate itemName:Defi_Detail_Rate contentType:Defi_Detail_Rate];
}

- (IBAction)experAction:(id)sender {
    NSString *url = [DefiProjectListModel getExperUrl:_inputProjectListM.name];
    if (url && url.length > 0) {
        [FirebaseUtil logEventWithItemID:Defi_Detail_Explore itemName:Defi_Detail_Explore contentType:Defi_Detail_Explore];
        
//        [self jumpToAXWeb:url];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    }
}

- (IBAction)keystatsAction:(id)sender {
    if (_keystatsBtn.selected == YES) {
        return;
    }
    _keystatsBtn.selected = YES;
    _activedateBtn.selected = NO;
    _historicalstatsBtn.selected = NO;
    
    [self animateSlider:_keystatsBtn];
    
    CGPoint offSet = _mainScroll.contentOffset;
    offSet.x = 0 * SCREEN_WIDTH;
    [_mainScroll setContentOffset:offSet animated:YES];
    
    [FirebaseUtil logEventWithItemID:Defi_Detail_KeyStats itemName:Defi_Detail_KeyStats contentType:Defi_Detail_KeyStats];
}

- (IBAction)activedataAction:(id)sender {
    if (_activedateBtn.selected == YES) {
        return;
    }
    _keystatsBtn.selected = NO;
    _activedateBtn.selected = YES;
    _historicalstatsBtn.selected = NO;
    
    [self animateSlider:_activedateBtn];
    
    CGPoint offSet = _mainScroll.contentOffset;
    offSet.x = 1 * SCREEN_WIDTH;
    [_mainScroll setContentOffset:offSet animated:YES];
    
    [FirebaseUtil logEventWithItemID:Defi_Detail_ActiveData itemName:Defi_Detail_ActiveData contentType:Defi_Detail_ActiveData];
}

- (IBAction)historacalstatsAction:(id)sender {
    if (_historicalstatsBtn.selected == YES) {
        return;
    }
    _keystatsBtn.selected = NO;
    _activedateBtn.selected = NO;
    _historicalstatsBtn.selected = YES;
    
    [self animateSlider:_historicalstatsBtn];
    
    CGPoint offSet = _mainScroll.contentOffset;
    offSet.x = 2 * SCREEN_WIDTH;
    [_mainScroll setContentOffset:offSet animated:YES];
    
    [FirebaseUtil logEventWithItemID:Defi_Detail_HistoricalStats itemName:Defi_Detail_HistoricalStats contentType:Defi_Detail_HistoricalStats];
}

- (IBAction)detailAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        _detailLab.numberOfLines = 0;
    } else {
        _detailLab.numberOfLines = 3;
    }
    
}

//#pragma mark - Transition
//- (void)jumpToAXWeb:(NSString *)url {
//    self.navigationController.navigationBarHidden = NO;
//    AXWebViewController *webVC = [[AXWebViewController alloc] initWithAddress:url];
//    webVC.showsToolBar = NO;
//    webVC.navigationController.navigationBar.translucent = NO;
////    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.100f green:0.100f blue:0.100f alpha:0.800f];
////    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.996f green:0.867f blue:0.522f alpha:1.00f];
//    [self.navigationController pushViewController:webVC animated:YES];
//}



@end
