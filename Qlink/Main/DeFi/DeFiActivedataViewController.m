//
//  DeFiActivedataViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DeFiActivedataViewController.h"
#import "DefiProjectListModel.h"
#import "DefiChartView.h"
#import "DefiHistoricalStatsListModel.h"

static NSInteger Type_Btn_Tag = 5555;

@interface DeFiActivedataViewController ()


@property (weak, nonatomic) IBOutlet UIView *typeBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeBackWidth;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *year1Btn;
@property (weak, nonatomic) IBOutlet UIButton *day90Btn;
@property (weak, nonatomic) IBOutlet UIButton *day30Btn;
@property (weak, nonatomic) IBOutlet UIButton *day7Btn;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *timeBtnArr;

@property (weak, nonatomic) IBOutlet UIView *chartBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chartBackHeight; // 230

@property (nonatomic, strong) DefiChartView *chartV;
@property (nonatomic, strong) NSArray *statsListArr;


@end

@implementation DeFiActivedataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self addChart];
    
    [self request_defi_stats_list];
}


#pragma mark - Operation

- (void)configInit {
//    [_tvlusdBtn setTitle:kLang(@"defi_tvl_usd") forState:UIControlStateNormal];
//    _ethBtn;
//    _daiBtn;
    _titleLab.text = @"";

    [_allBtn setTitle:kLang(@"defi_all") forState:UIControlStateNormal];
    [_year1Btn setTitle:kLang(@"defi_year1") forState:UIControlStateNormal];
    [_day90Btn setTitle:kLang(@"defi_day90") forState:UIControlStateNormal];
    [_day30Btn setTitle:kLang(@"defi_day30") forState:UIControlStateNormal];
    [_day7Btn setTitle:kLang(@"defi_day7") forState:UIControlStateNormal];
    
    UIColor *titleNormalColor = UIColorFromRGB(0x9496A1);
    UIColor *titleSelectColor = [UIColor whiteColor];
    UIColor *titleNormalBackColor = UIColorFromRGB(0xF5F5F5);
    UIColor *titleSelectBackColor = MAIN_BLUE_COLOR;
    [_timeBtnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        [btn setTitleColor:titleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:titleSelectColor forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:titleNormalBackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:titleSelectBackColor] forState:UIControlStateSelected];
        btn.layer.cornerRadius = 12;
        btn.layer.masksToBounds = YES;
    }];
    
//    _tvlusdBtn.selected = YES;
    _allBtn.selected = YES;
}

- (void)addChart {
    _chartV = [DefiChartView getInstance];
    _chartV.inputProjectListM = _inputProjectListM;
    [_chartBack addSubview:_chartV];
    kWeakSelf(self);
    [_chartV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(weakself.chartBack).offset(0);
    }];
    
    [_chartV configWithNoDataBlock:^{
        weakself.chartBackHeight.constant = 0;
    } haveDataBlock:^{
        weakself.chartBackHeight.constant = 230;
    }];
}

- (void)handlerTypeView {
    if (_statsListArr.count > 0) {
        DefiHistoricalStatsListModel *firstM = _statsListArr.firstObject;
        NSMutableArray *tempArr = [NSMutableArray array];
        if ([firstM.tvlUsd floatValue] > 0) {
            [tempArr addObject:kLang(@"defi_tvl_usd")];
        }
        if ([firstM.eth floatValue] > 0) {
            [tempArr addObject:@"ETH"];
        }
        if ([firstM.dai floatValue] > 0) {
            [tempArr addObject:@"DAI"];
        }
        if ([firstM.btc floatValue] > 0) {
            [tempArr addObject:@"BTC"];
        }
        kWeakSelf(self);
        [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(70*idx, 0, 70, 50);
            [btn setTitle:obj forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:UIColorFromRGB(0x1E1E24) forState:UIControlStateNormal];
            [btn setTitleColor:MAIN_BLUE_COLOR forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(typeHandler:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = Type_Btn_Tag+idx;
            [weakself.typeBack addSubview:btn];
        }];
        weakself.typeBackWidth.constant = tempArr.count*70;
        
        if (tempArr.count > 0) {
            UIButton *btn = [_typeBack viewWithTag:Type_Btn_Tag];
            [self typeHandler:btn];
        }
        
    }
}

- (void)typeHandler:(UIButton *)sender {
    
    if (sender.selected == YES) {
        return;
    }
    
    kWeakSelf(self);
    [_statsListArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [weakself.typeBack viewWithTag:Type_Btn_Tag+idx];
        btn.selected = sender==btn?YES:NO;
    }];
    
    
    NSString *titleStr = @"";
    if ([sender.currentTitle isEqualToString:kLang(@"defi_tvl_usd")]) {
        _chartV.inputType = DefiChartTypeTVLUSD;
        titleStr = kLang(@"defi_total_value_locked_usd");
    } else if ([sender.currentTitle isEqualToString:@"ETH"]) {
        _chartV.inputType = DefiChartTypeETH;
        titleStr = kLang(@"defi_eth_locked_in_maker");
    } else if ([sender.currentTitle isEqualToString:@"DAI"]) {
        _chartV.inputType = DefiChartTypeDAI;
        titleStr = kLang(@"defi_dai_locked_in_maker");
    } else if ([sender.currentTitle isEqualToString:@"BTC"]) {
        _chartV.inputType = DefiChartTypeBTC;
        titleStr = kLang(@"defi_btn_locked_in_maker");
    }
    _titleLab.text = titleStr;
    
    [_chartV refreshChart];
}

#pragma mark - Request
- (void)request_defi_stats_list {
    kWeakSelf(self);
     NSString *page = @"1";
    NSString *size = @"30";
    NSString *projectId = _inputProjectListM.ID?:@"";
    NSDictionary *params = @{@"page":page,@"size":size,@"projectId":projectId};
    [RequestService requestWithUrl5:defi_stats_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [weakself.chartV handlerData:responseObject];
            
            weakself.statsListArr = [DefiHistoricalStatsListModel mj_objectArrayWithKeyValuesArray:responseObject[@"historicalStatsList"]];
            [weakself handlerTypeView];
            
            
            
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        weakself.chartBackHeight.constant = 0;
    }];
}

#pragma mark - Action

- (IBAction)timeAction:(UIButton *)sender {
    [_timeBtnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        btn.selected = btn==sender?YES:NO;
    }];
    
    
}





@end
