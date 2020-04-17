//
//  ShareFriendsViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "OutbreakRedViewController.h"
#import "UserModel.h"
#import "ClaimQGASViewController.h"
#import "OutbreakRedCell.h"
#import <OutbreakRed/OutbreakRed.h>
#import <OutbreakRed/OR_HealthStepModel.h>
#import "RSAUtil.h"
#import "OutbreakRedRecordViewController.h"
#import "OutbreakFocusModel.h"
#import "GlobalOutbreakUtil.h"
#import "RefreshHelper.h"
#import "ClaimQLCViewController.h"
#import "FirebaseUtil.h"
#import "OutbreakCreateModel.h"

@interface OutbreakRedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainTableHeight;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@property (weak, nonatomic) IBOutlet UILabel *focus1Lab;
@property (weak, nonatomic) IBOutlet UILabel *focus2Lab;
@property (weak, nonatomic) IBOutlet UILabel *focus3Lab;
@property (weak, nonatomic) IBOutlet UILabel *focus4Lab;
@property (weak, nonatomic) IBOutlet UILabel *focus5Lab;
@property (weak, nonatomic) IBOutlet UILabel *focus6Lab;
@property (weak, nonatomic) IBOutlet UILabel *focus7Lab;
@property (weak, nonatomic) IBOutlet UILabel *focus8Lab;
@property (weak, nonatomic) IBOutlet UILabel *focus9Lab;
@property (weak, nonatomic) IBOutlet UILabel *focus10Lab;
@property (weak, nonatomic) IBOutlet UILabel *focus11Lab;
@property (weak, nonatomic) IBOutlet UILabel *focus12Lab;
@property (weak, nonatomic) IBOutlet UILabel *focus13Lab;
@property (weak, nonatomic) IBOutlet UILabel *focus14Lab;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *focusLabArr;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *focusConnenctArr;


@property (weak, nonatomic) IBOutlet UILabel *continueLab;


@property (weak, nonatomic) IBOutlet UILabel *dailyStepLab;
@property (weak, nonatomic) IBOutlet UILabel *claimedLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dailyEmptyHeight; // 81
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UILabel *claimQLCTipLab;


@property (nonatomic, strong) OutbreakCreateModel *createM;


@end

@implementation OutbreakRedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self setupRefresh];
    [self fetchTodayStep];
    [self requestGzbd_create];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - Operation
- (void)configInit {
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:OutbreakRedCell_Reuse bundle:nil] forCellReuseIdentifier:OutbreakRedCell_Reuse];
    self.baseTable = _mainTable;
    
    _mainTableHeight.constant = 0;
    _dailyEmptyHeight.constant = 0;
    
    [_focusLabArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lab = obj;
        lab.layer.cornerRadius = lab.width/2.0;
        lab.layer.masksToBounds = YES;
    }];
    
    _leftBtn.layer.cornerRadius = _leftBtn.height/2.0;
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.enabled = NO;
    
    UserModel *userM = [UserModel fetchUserOfLogin];
    NSInteger isolationDays = [userM.isolationDays?:@"0" integerValue];
    NSInteger subsidised = [userM.subsidised?:@"0" integerValue];
    [self refreshIsolationView:isolationDays subsidised:subsidised];
}

- (void)setupRefresh {
    kWeakSelf(self)
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        [weakself requestGzbd_create];
    } type:RefreshTypeColor];
}

- (void)refreshIsolationView:(NSInteger)isolationDays subsidised:(NSInteger)subsidised {
    NSInteger leftDayInt = [_createM.rewardQlcDays integerValue] - isolationDays;
    leftDayInt = leftDayInt<=0?0:leftDayInt;
    NSString *leftDay = [NSString stringWithFormat:@"%@",@(leftDayInt)];
    if (isolationDays >= [_createM.rewardQlcDays integerValue] ) { // 14天可以领取
        [_leftBtn setTitle:kLang(@"Claim") forState:UIControlStateNormal];
        _leftBtn.backgroundColor = MAIN_BLUE_COLOR;
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _leftBtn.enabled = YES;
        if (subsidised == 1) { // subsidised=1 已领取不能点击
            [_leftBtn setTitle:kLang(@"awarded") forState:UIControlStateNormal];
            _leftBtn.backgroundColor = UIColorFromRGB(0xECEFF5);
            [_leftBtn setTitleColor:UIColorFromRGB(0x9496A1) forState:UIControlStateNormal];
            _leftBtn.enabled = NO;
        }
    } else { // 未满14天不能领取
        [_leftBtn setTitle:[NSString stringWithFormat:kLang(@"__days_left"),leftDay] forState:UIControlStateNormal];
        _leftBtn.backgroundColor = UIColorFromRGB(0xECEFF5);
        [_leftBtn setTitleColor:UIColorFromRGB(0x9496A1) forState:UIControlStateNormal];
        _leftBtn.enabled = NO;
    }
    
    [_focusLabArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lab = obj;
        lab.backgroundColor = UIColorFromRGB(0xBCBCBC);
        if (isolationDays > 0) {
            if (idx <= isolationDays-1) {
                lab.backgroundColor = MAIN_BLUE_COLOR;
            }
        }
    }];
    [_focusConnenctArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lab = obj;
        lab.textColor = UIColorFromRGB(0xBCBCBC);
        if (isolationDays>1 && isolationDays<=7) {
            if (idx <= isolationDays-2) {
                lab.textColor = MAIN_BLUE_COLOR;
            }
        }
        if (isolationDays>8 && isolationDays<=14) {
            if (idx <= isolationDays-3) {
                lab.textColor = MAIN_BLUE_COLOR;
            }
        }
    }];
    
    kWeakSelf(self);
//    isolationDays = 1;
    NSString *isolationStr = [NSString stringWithFormat:@" %@ ",@(isolationDays)];
    __block NSString *stepStr = @"0";
    if (isolationDays > 0) {
        __block NSInteger stepCount = 0;
         NSDate *fromDate = [NSDate date];
        [OutbreakRedSDK getStepWithIntervalDay:isolationDays-1 fromDate:fromDate completeBlock:^(NSArray * _Nonnull stepArr) {
            [stepArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                OR_HealthStepModel *model = stepArr[idx];
                stepCount = stepCount + [model.step?:@(0) integerValue];
            }];
            
            stepStr = [NSString stringWithFormat:@"%@",@(stepCount)];
            
            [weakself refreshContinueView:isolationStr stepStr:stepStr];
        }];
        
    } else {
        [weakself refreshContinueView:isolationStr stepStr:stepStr];
    }
    
}

- (void)refreshContinueView:(NSString *)isolationStr stepStr:(NSString *)stepStr {
    NSString *continueShowStr = [NSString stringWithFormat:kLang(@"you_have_checked_on_the_covid_19_live_updates_page_for_consecutive___"),isolationStr,stepStr];
    NSMutableAttributedString *amountAtt = [[NSMutableAttributedString alloc] initWithString:continueShowStr];
    [amountAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, continueShowStr.length)];
    [amountAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x1E1E24) range:NSMakeRange(0, continueShowStr.length)];
    [amountAtt addAttribute:NSForegroundColorAttributeName value:MAIN_BLUE_COLOR range:[continueShowStr rangeOfString:isolationStr options:NSWidthInsensitiveSearch]];
    [amountAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xF50F6D) range:[continueShowStr rangeOfString:stepStr options:NSBackwardsSearch]];
    _continueLab.attributedText = amountAtt;
}

- (void)fetchTodayStep {
    kWeakSelf(self);
    NSDate *fromDate = [NSDate date];
   [OutbreakRedSDK getStepWithIntervalDay:0 fromDate:fromDate completeBlock:^(NSArray * _Nonnull stepArr) {
       OR_HealthStepModel *model = stepArr.firstObject;
       weakself.dailyStepLab.text = [NSString stringWithFormat:@"%@",model.step];
   }];
}

#pragma mark - Request
- (void)requestGzbd_create {
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
    OR_RequestModel *requestM = [OR_RequestModel new];
    requestM.p2pId = [UserModel getTopupP2PId];
    requestM.appBuild = APP_Build;
    requestM.appVersion = APP_Version;
    [OutbreakRedSDK requestGzbd_createWithAccount:account token:token timestamp:timestamp requestM:requestM completeBlock:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nonnull responseObject, NSError * _Nonnull error) {
        [weakself.mainScroll.mj_header endRefreshing];
        if (!error) {
            if ([responseObject[Server_Code] integerValue] == 0) {
                
                [weakself requestGzbd_list];
                
                weakself.createM  = [OutbreakCreateModel getObjectWithKeyValues:responseObject];
                
                weakself.claimedLab.text = [NSString stringWithFormat:@"%@",weakself.createM.claimedQgas];
                _claimQLCTipLab.text = [NSString stringWithFormat:kLang(@"claim__qlc_when_your_mission_is_completed"),weakself.createM.rewardQlcAmount];
                NSInteger isolationDaysInt = [weakself.createM.isolationDays integerValue];
                NSInteger subsidisedInt = [weakself.createM.subsidised integerValue];
                [weakself refreshIsolationView:isolationDaysInt subsidised:subsidisedInt];
            }
        } else {
            
        }
    }];
}


- (void)requestGzbd_list {
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
    
    NSString *orStatus = [NSString stringWithFormat:@"%@#%@",OutbreakFocusStatus_New,OutbreakFocusStatus_NO_AWARD];
    
    OR_RequestModel *requestM = [OR_RequestModel new];
    requestM.p2pId = [UserModel getTopupP2PId];
    requestM.appBuild = APP_Build;
    requestM.appVersion = APP_Version;
    
    [OutbreakRedSDK requestGzbd_listWithAccount:account token:token page:nil size:nil status:nil orStatus:orStatus timestamp:timestamp requestM:requestM completeBlock:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nonnull responseObject, NSError * _Nonnull error) {
        if (!error) {
            if ([responseObject[Server_Code] integerValue] == 0) {
                [weakself.sourceArr removeAllObjects];
                NSArray *arr = [OutbreakFocusModel mj_objectArrayWithKeyValuesArray:responseObject[@"recordList"]];
                [weakself.sourceArr addObjectsFromArray:arr];
                weakself.mainTableHeight.constant = weakself.sourceArr.count*OutbreakRedCell_Height;
                weakself.dailyEmptyHeight.constant = weakself.sourceArr.count>0?0:81;
                [weakself.mainTable reloadData];
            }
        } else {
            
        }
    }];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)refreshDailyStepAction:(id)sender {
    [self fetchTodayStep];
}

- (IBAction)claimedAction:(id)sender {
    [self jumpToOutbreakRedRecord];
}

- (IBAction)leftAction:(id)sender {
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
    
    kWeakSelf(self);
    UserModel *userM = [UserModel fetchUserOfLogin];
    if ([userM.subsidised integerValue] == 0) { // 未领取
        if ([userM.isolationDays integerValue] >= [_createM.rewardQlcDays integerValue] ) { // 隔离14天
//            __block BOOL isRightStep = YES;
//            NSDate *fromDate = [NSDate date];
//            [OutbreakRedSDK getStepWithIntervalDay:13 fromDate:fromDate completeBlock:^(NSArray * _Nonnull stepArr) {
//                [stepArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    OR_HealthStepModel *model = obj;
//                    if ([model.step integerValue] > 1000) {
//                        isRightStep = NO;
//                        *stop = YES;
//                    }
//                }];
//
//                if (isRightStep) { // 每天步数<=1000
                    [FirebaseUtil logEventWithItemID:Campaign_Covid19_QLC_Claim itemName:Campaign_Covid19_QLC_Claim contentType:Campaign_Covid19_QLC_Claim];
                    [weakself jumpToClaimQLC];
//                }
//            }];
        }
    }
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return OutbreakRedCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OutbreakRedCell *cell = [tableView dequeueReusableCellWithIdentifier:OutbreakRedCell_Reuse];
    
    kWeakSelf(self);
    OutbreakFocusModel *model = _sourceArr[indexPath.row];
    [cell config:model clickB:^(OutbreakFocusModel * _Nonnull clickM) {
        if ([clickM.status isEqualToString:OutbreakFocusStatus_New]) {
            [GlobalOutbreakUtil transitionToGlobalOutbreak];
            [GlobalOutbreakUtil requestGzbd_focus:^(NSString * _Nonnull subsidised, NSString * _Nonnull isolationDays, NSString * _Nonnull claimedQgas) {
                weakself.claimedLab.text = [NSString stringWithFormat:@"%@",claimedQgas];
                NSInteger isolationDaysInt = [isolationDays integerValue];
                NSInteger subsidisedInt = [subsidised integerValue];
                [weakself refreshIsolationView:isolationDaysInt subsidised:subsidisedInt];
                
                [weakself requestGzbd_list]; // 关注回来刷新列表
            }];
         } else if ([clickM.status isEqualToString:OutbreakFocusStatus_NO_AWARD]) {
             [FirebaseUtil logEventWithItemID:Campaign_Covid19_QGas_Claim itemName:Campaign_Covid19_QGas_Claim contentType:Campaign_Covid19_QGas_Claim];
             [weakself jumpToClaimQGAS:clickM];
         } else if ([clickM.status isEqualToString:OutbreakFocusStatus_AWARDED]) {
             
        } else if ([clickM.status isEqualToString:OutbreakFocusStatus_OVERDUE]) {

           }
    }];
    
    return cell;
}

#pragma mark - Transition
- (void)jumpToClaimQGAS:(OutbreakFocusModel *)model {
    if (![UserModel haveLoginAccount]) {
        [kAppD presentLoginNew];
        return;
    }
    
    ClaimQGASViewController *vc = [ClaimQGASViewController new];
    vc.inputCovidRecordId = model.ID?:@"";
//    vc.inputCanClaimAmount = model.qgasAmount_str?:@"";
    vc.inputCanClaimAmount = model.qgasAmount?:@"";
    vc.claimQGASType = ClaimQGASTypeCLAIM_COVID;
    kWeakSelf(self);
    vc.claimSuccessBlock = ^{
        [weakself requestGzbd_create]; // 领取回来要刷新页面数据
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToOutbreakRedRecord {
    OutbreakRedRecordViewController *vc = [OutbreakRedRecordViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToClaimQLC {
    if (![UserModel haveLoginAccount]) {
        [kAppD presentLoginNew];
        return;
    }
    
    ClaimQLCViewController *vc = [ClaimQLCViewController new];
    vc.inputCanClaimAmount = _createM.rewardQlcAmount;
    vc.claimQLCType = ClaimQLCTypeCLAIM_COVID;
    kWeakSelf(self);
    vc.claimSuccessBlock = ^{
        [weakself requestGzbd_create]; // 领取回来要刷新页面数据
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
