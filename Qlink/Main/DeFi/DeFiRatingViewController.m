//
//  DeFiRatingViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DeFiRatingViewController.h"
#import "DefiRateCircleView.h"
#import "DefiProjectModel.h"
#import "NEOWalletInfo.h"
#import "TokenListHelper.h"
#import "NEOAddressInfoModel.h"
#import "RLArithmetic.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import "DefiRateLoadView.h"
#import "DefiRateFailView.h"
#import "LandScapePicker.h"
#import "DefiRateSuccessView.h"
#import "DeFiRatingInfoModel.h"
#import "FirebaseUtil.h"
#import "AFJSONRPCClient.h"
#import "NSString+RandomStr.h"
#import "QLCWalletInfo.h"

@interface DeFiRatingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *qlcLab;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIView *ratingCircleBack;
@property (weak, nonatomic) IBOutlet UIView *ratingNumBack;
@property (weak, nonatomic) IBOutlet UILabel *myRatingLab;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *ratingBtnArr;
@property (weak, nonatomic) IBOutlet UIImageView *ratingDownIcon;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UIView *ratingDoneBack;
@property (weak, nonatomic) IBOutlet UILabel *ratingDoneLab;
@property (weak, nonatomic) IBOutlet UILabel *ratingDoneWeightLab;

@property (nonatomic, strong) NSString *qlcAmount_Chain;
@property (nonatomic, strong) DefiRateLoadView *rateLoadView;
@property (nonatomic, strong) NSString *selectScore;
@property (nonatomic, strong) LandScapePicker *ratingPicker;
@property (nonatomic, strong) NSArray *ratingArr;
@property (nonatomic, strong) DefiRateCircleView *rateCircleView;
@property (nonatomic, strong) DeFiRatingInfoModel *ratingInfoM;

@end

@implementation DeFiRatingViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;

    [self configInit];
    
    [self addRatingNum];
    [self addRatingCircle];
    
    [self request_defi_rating_info];
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself getUserQLCAmount_NEO];
    });
    
}

#pragma mark - Operation

- (void)configInit {
    _qlcAmount_Chain = @"0";
    _titleLab.text = kLang(@"defi_rate_this_defi");
    _myRatingLab.text = kLang(@"defi_my_rating");
    [_submitBtn setTitle:kLang(@"defi_submit") forState:UIControlStateNormal];
    
    _ratingArr = @[@"A++",@"A+",@"A",@"B++",@"B+",@"B",@"C",@"D"];
//    _ratingDoneBack.hidden = [_inputProjectM.rating integerValue] == 0?YES:NO;
    _ratingDoneBack.hidden = YES;
    
    _submitBtn.layer.cornerRadius = 4;
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.enabled = NO;
//    _submitBtn.backgroundColor = UIColorFromRGB(0xaaaaaa);
    _activityView.hidden = YES;
    
    _ratingDoneWeightLab.layer.cornerRadius = 2;
    _ratingDoneWeightLab.layer.masksToBounds = YES;
    _ratingDoneWeightLab.layer.borderColor = MAIN_BLUE_COLOR.CGColor;
    _ratingDoneWeightLab.layer.borderWidth = 1;
    
    [self refreshDoneView:@"0" weight:@"0"];
}

- (void)addRatingCircle {
    _rateCircleView = [DefiRateCircleView getInstance];
    [_rateCircleView config:_inputProjectM];
    _rateCircleView.frame = CGRectMake(0, 0, rate_radius*2, rate_radius*2);
    _rateCircleView.center = CGPointMake(_ratingCircleBack.width/2.0, _rateCircleView.center.y);
    [_ratingCircleBack addSubview:_rateCircleView];
    
}

- (void)addRatingNum {
    _ratingPicker = [[LandScapePicker alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 77)];
    _ratingPicker.backgroundColor = [UIColor clearColor];
    _ratingPicker.titleColor = MAIN_BLUE_COLOR;
    [_ratingNumBack addSubview:_ratingPicker];
    
    _ratingPicker.pTitles = _ratingArr;
    
    kWeakSelf(self);
    _ratingPicker.lspSelected = ^(NSInteger row, NSString *title) {
        if (row == 0 || row == 1 || row == 2) {
            weakself.selectScore = [DefiProjectModel getScoreStr:weakself.ratingArr[row]];
            UIButton *btnA = weakself.ratingBtnArr[0];
            [weakself refreshRatingBtn:btnA];
        } else if (row == 3 || row == 4 || row == 5) {
            weakself.selectScore = [DefiProjectModel getScoreStr:weakself.ratingArr[row]];
            UIButton *btnB = weakself.ratingBtnArr[1];
            [weakself refreshRatingBtn:btnB];
        } else if (row == 6) {
            weakself.selectScore = [DefiProjectModel getScoreStr:weakself.ratingArr[row]];
            UIButton *btnC = weakself.ratingBtnArr[2];
            [weakself refreshRatingBtn:btnC];
        } else if (row == 7) {
            weakself.selectScore = [DefiProjectModel getScoreStr:weakself.ratingArr[row]];
            UIButton *btnD = weakself.ratingBtnArr[3];
            [weakself refreshRatingBtn:btnD];
        }
    };
    
//    kWeakSelf(self);
    [_ratingBtnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        btn.layer.borderColor = UIColorFromRGB(0xE6E6E6).CGColor;
        btn.layer.borderWidth = .5;
        [btn setTitleColor:UIColorFromRGB(0x808080) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xffffff)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:MAIN_BLUE_COLOR] forState:UIControlStateSelected];
        
        if (idx == 0) {
            [weakself ratingAction:btn];
        }
    }];
    CGFloat ratingBtnWidth = (SCREEN_WIDTH-24*2)/4.0;
    _ratingDownIcon.frame = CGRectMake((ratingBtnWidth/2.0-_ratingDownIcon.width/2.0), 0, _ratingDownIcon.width, _ratingDownIcon.height);
}

- (void)refreshCircleRating:(NSString *)rating {
    if (_rateCircleView) {
        [_rateCircleView refreshRating:rating];
    }
}

- (void)refreshCircleWeight:(NSString *)weight {
    if (_rateCircleView) {
        [_rateCircleView drawArc:weight];
    }
}


- (void)refreshRatingBtn:(UIButton *)sender {
    __block NSInteger selectIdx = 0;
    [_ratingBtnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        btn.selected = sender==btn?YES:NO;
        if (sender == btn) {
            selectIdx = idx;
        }
    }];
    
    CGFloat ratingBtnWidth = (SCREEN_WIDTH-24*2)/4.0;
    kWeakSelf(self);
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakself.ratingDownIcon.frame = CGRectMake((ratingBtnWidth/2.0-_ratingDownIcon.width/2.0)+selectIdx*ratingBtnWidth, 0, _ratingDownIcon.width, _ratingDownIcon.height);
    } completion:^(BOOL finished) {
    }];
}

- (void)refreshQLCView:(NSString *)qlcAmount {
    _qlcLab.text = [NSString stringWithFormat:@"%@ QLC",qlcAmount?:@"0"];
}

- (void)refreshDoneView:(NSString *)score weight:(NSString *)weight {
    if ([score integerValue] != 0) {
        _ratingDoneBack.hidden = NO;
        _ratingDoneLab.text = [DefiProjectModel getRatingStr:score];
        _ratingDoneWeightLab.text = [NSString stringWithFormat:@"%@ %@%%",kLang(@"defi_my_rating_weight"),weight?weight.mul(@"100"):@"0"];
    } else {
        _ratingDoneBack.hidden = YES;
    }
}

- (void)getUserQLCAmount_NEO {
    _submitBtn.enabled = NO;
    _submitBtn.backgroundColor = UIColorFromRGB(0xaaaaaa);
    _activityView.hidden = NO;
    [_activityView startAnimating];
    
    _qlcAmount_Chain = @"0";
    NSArray *neoWallet = [NEOWalletInfo getAllWalletInKeychain];
    if (neoWallet.count > 0) {
        [self getUserQLCAmountOneByOne_NEO:neoWallet];
    } else { // 所有neo钱包的qlc总量=0
        [self handlerQLC_NEOChain_Done];
    }
}

- (void)getUserQLCAmountOneByOne_NEO:(NSArray *)neoArr {
    kWeakSelf(self);
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:neoArr];
    NEOWalletInfo *model = tempArr.firstObject;
    [TokenListHelper requestNEOAddressInfo:model.address?:@"" showLoad:NO completeBlock:^(NEOAddressInfoModel *infoM, BOOL success) {
        if (success) {
            if (weakself == nil) {
                return;
            }
            [infoM.balance enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NEOAssetModel *assetModel = obj;
                if ([assetModel.asset_symbol isEqualToString:@"QLC"]) {
                    weakself.qlcAmount_Chain = weakself.qlcAmount_Chain.add(assetModel.amount);
                    [weakself refreshQLCView:weakself.qlcAmount_Chain];
                    *stop = YES;
                }
            }];
            [tempArr removeObjectAtIndex:0];
            if (tempArr.count > 0) {
                [weakself getUserQLCAmountOneByOne_NEO:tempArr];
            } else { // 所有neo钱包的qlc总量
                [weakself handlerQLC_NEOChain_Done];
            }
        } else {
            [weakself handlerQLC_NEOChain_Done];
        }
    }];
}

- (void)getUserQLCAmount_QLC {
    NSArray *qlcWallet = [QLCWalletInfo getAllWalletInKeychain];
    if (qlcWallet.count > 0) {
        [self getUserQLCAmountOneByOne_QLC:qlcWallet];
    } else { // 所有QLC钱包的qlc总量=0
        [self handlerQLC_QLCChain_Done];
    }
}

- (void)getUserQLCAmountOneByOne_QLC:(NSArray *)qlcArr {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:qlcArr];
    QLCWalletInfo *model = tempArr.firstObject;
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_node_release]]];
    NSString *requestId = [NSString randomOf32];
    kWeakSelf(self);
    NSArray *params = @[model.address];
    DDLogDebug(@"pledge_getPledgeBeneficialTotalAmount params = %@",params);
//    [kAppD.window makeToastInView:kAppD.window];
    [client invokeMethod:@"pledge_getPledgeBeneficialTotalAmount" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
//        [kAppD.window hideToast];
        DDLogDebug(@"pledge_getPledgeBeneficialTotalAmount responseObject=%@",responseObject);
        if (responseObject) {
            if (weakself == nil) {
                return;
            }
//            NSNumber *totalAmounts = [NSNumber numberWithLong:[responseObject[@"TotalAmounts"] longLongValue]];
            NSNumber *totalAmounts = [NSNumber numberWithLong:[responseObject longLongValue]];
            NSString *amount = totalAmounts.div(@(QLC_UnitNum));
            weakself.qlcAmount_Chain = weakself.qlcAmount_Chain.add(amount);
            [weakself refreshQLCView:weakself.qlcAmount_Chain];
            [tempArr removeObjectAtIndex:0];
            if (tempArr.count > 0) {
                [weakself getUserQLCAmountOneByOne_QLC:tempArr];
            } else { // 所有neo钱包的qlc总量
                [weakself handlerQLC_QLCChain_Done];
            }
        } else {
            [weakself handlerQLC_QLCChain_Done];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DDLogDebug(@"pledge_getPledgeBeneficialTotalAmount error=%@",error);
        [weakself handlerQLC_QLCChain_Done];
    }];
}

- (void)handlerQLC_QLCChain_Done {
    [self refreshQLCView:_qlcAmount_Chain];
    [self handlerWeightLogic:_ratingInfoM];
    _submitBtn.enabled = YES;
    _submitBtn.backgroundColor = MAIN_BLUE_COLOR;
    _activityView.hidden = YES;
    [_activityView stopAnimating];
}

- (void)handlerQLC_NEOChain_Done {
    [self getUserQLCAmount_QLC];
}

- (void)handlerWeightLogic:(DeFiRatingInfoModel *)model {
    if (model == nil) {
        return;
    }
    BOOL userIsRate = NO; // 用户未评级
    NSString *weight = @"0";
    
    RLComparisonResult weightResult = (model.weight?:@"0").compare(@"0");
    RLComparisonResult scoreResult = (model.score?:@"0").compare(@"0");
    if (weightResult == RLOrderedDescending || scoreResult == RLOrderedDescending) { //>0  用户已评级
        userIsRate = YES;
    }
    
    if (userIsRate == NO) { // 用户未评级
        RLComparisonResult userQlcResult = _qlcAmount_Chain.compare(@"0");
        if (userQlcResult == RLOrderedDescending) { // 用户qlcAmount>0
            NSString *projectQlcAmount = model.qlcAmount?:@"0";
            RLComparisonResult projectQlcResult = projectQlcAmount.compare(@"0");
            if (projectQlcResult == RLOrderedSame) { // 项目qlcAmount=0
                weight = @"1";
            } else if (projectQlcResult == RLOrderedDescending) { // 项目qlcAmount>0
                NSString *allQlcAmount = projectQlcAmount.add(_qlcAmount_Chain);
                weight = _qlcAmount_Chain.div(allQlcAmount);
            }
        }
    } else { // 用户已评级
        weight = model.weight;
    }
    
    [self refreshCircleWeight:weight];
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
    NSString *projectId = _inputProjectM.ID?:@"";
    NSString *qlcAmount = _qlcAmount_Chain?:@"";
    NSString *score = _selectScore?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"projectId":projectId,@"score":score,@"qlcAmount":qlcAmount};
    _rateLoadView = [DefiRateLoadView getInstance];
    [_rateLoadView show];
    [RequestService requestWithUrl6:defi_rating_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.rateLoadView hide];
            if ([responseObject[Server_Code] integerValue] == 0) {
                
                NSString *logProjectName = [[[weakself.inputProjectM getShowName] stringByReplacingOccurrencesOfString:@" " withString:@"_"] stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
                NSString *logRating = [DefiProjectModel getRatingStr:weakself.selectScore];
                NSString *logEvent = [NSString stringWithFormat:@"%@%@_%@",Defi_Detail_Rate_,logProjectName,logRating];
                [FirebaseUtil logEventWithItemID:logEvent itemName:logEvent contentType:logEvent];
                
                [[DefiRateSuccessView getInstance] show];
                
                [weakself request_defi_rating_info];
                
                if (weakself.ratingSuccessB) {
                    NSString *rating = [NSString stringWithFormat:@"%@",responseObject[@"rating"]];
                    weakself.ratingSuccessB(rating);
                }
            } else {
                [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
            }
        });
        
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.rateLoadView hide];
    }];
}

//- (void)request_defi_project {
//    kWeakSelf(self);
//    NSString *projectId = _inputProjectM.ID?:@"";
//    NSDictionary *params = @{@"projectId":projectId};
//    [RequestService requestWithUrl5:defi_project_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        if ([responseObject[Server_Code] integerValue] == 0) {
//            DefiProjectModel *projectM = [DefiProjectModel mj_objectWithKeyValues:responseObject[@"project"]];
//
//        } else {
//            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//
//    }];
//}

- (void)request_defi_rating_info {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *projectId = _inputProjectM.ID?:@"";
    NSDictionary *params = @{@"account":account,@"projectId":projectId};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl5:defi_rating_info_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            weakself.ratingInfoM = [DeFiRatingInfoModel mj_objectWithKeyValues:responseObject];
            NSString *weight = responseObject[@"weight"];
            NSString *rating = responseObject[@"rating"];
            NSString *score = [NSString stringWithFormat:@"%@",responseObject[@"score"]];
            [weakself refreshCircleRating:rating];
            
            [weakself refreshDoneView:score weight:weight];
            
            [weakself handlerWeightLogic:weakself.ratingInfoM];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}


#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)ratingAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    
    [self refreshRatingBtn:sender];
    
    if (_ratingPicker) {
        __block NSInteger btnIndex = 0;
        [_ratingBtnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = obj;
            if (btn == sender) {
                btnIndex = idx;
            }
        }];
        
        _selectScore = [DefiProjectModel getScoreStr:@"A++"];
        if (btnIndex == 0) {
            NSInteger pickerSelectRow = [_ratingPicker getCurrentSelectRow];
            if (pickerSelectRow!=[_ratingArr indexOfObject:@"A++"] && pickerSelectRow!=[_ratingArr indexOfObject:@"A+"] && pickerSelectRow!=[_ratingArr indexOfObject:@"A"]) {
                [_ratingPicker selectRow:[_ratingArr indexOfObject:@"A++"]];
                _selectScore = [DefiProjectModel getScoreStr:@"A++"];
            }
        } else if (btnIndex == 1) {
            NSInteger pickerSelectRow = [_ratingPicker getCurrentSelectRow];
            if (pickerSelectRow!=[_ratingArr indexOfObject:@"B++"] && pickerSelectRow!=[_ratingArr indexOfObject:@"B+"] && pickerSelectRow!=[_ratingArr indexOfObject:@"B"]) {
                [_ratingPicker selectRow:[_ratingArr indexOfObject:@"B++"]];
                _selectScore = [DefiProjectModel getScoreStr:@"B++"];
            }
        } else if (btnIndex == 2) {
            [_ratingPicker selectRow:[_ratingArr indexOfObject:@"C"]];
            _selectScore = [DefiProjectModel getScoreStr:@"C"];
        } else if (btnIndex == 3) {
            [_ratingPicker selectRow:[_ratingArr indexOfObject:@"D"]];
            _selectScore = [DefiProjectModel getScoreStr:@"D"];
        }
        
    }
}


- (IBAction)submitAction:(id)sender {
    RLComparisonResult result = _qlcAmount_Chain.compare(@"0");
    if (result == RLOrderedSame || result == RLOrderedAscending) {
        [[DefiRateFailView getInstance] show];
    } else {
        [self request_defi_rating];
    }
}

@end
