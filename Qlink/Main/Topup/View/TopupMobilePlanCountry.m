//
//  TopupMobilePlanCountry.m
//  Qlink
//
//  Created by Jelly Foo on 2019/12/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TopupMobilePlanCountry.h"
#import "GlobalConstants.h"
#import "TopupCountryModel.h"
#import "UIImage+Blur.h"
#import <SDWebImage/UIButton+WebCache.h>

static NSString *const TopupNetworkSize = @"20";
static NSInteger const Btn_Tag = 2342;

@interface TopupMobilePlanCountry ()

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (weak, nonatomic) IBOutlet UIView *scrollContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentWidth;


@end

@implementation TopupMobilePlanCountry

+ (instancetype)getInstance {
    TopupMobilePlanCountry *view = [[[NSBundle mainBundle] loadNibNamed:@"TopupMobilePlanCountry" owner:self options:nil] lastObject];
    [view configInit];
    return view;
}



#pragma mark - Operation
- (void)configInit {
    _sourceArr = [NSMutableArray array];
    
    [self requestTopup_country_list];
}

- (void)configCountryView {
    kWeakSelf(self);
    [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TopupCountryModel *model = obj;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnWidth = 50;
        CGFloat btnHeight = 32;
        CGFloat btnOffset = 6;
        btn.frame = CGRectMake(idx*(btnWidth+btnOffset), 0, btnWidth, btnHeight);
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.imgPath]];
        [btn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:nil];
//        UIImage *btnImg = [UIImage imageNamed:[NSString stringWithFormat:@"topup_flag_%@",model.nameEn.lowercaseString]];
//        UIImage *btnImgSelect = [btnImg lightImage];
//        [btn setImage:btnImg forState:UIControlStateNormal];
//        [btn setImage:btnImgSelect forState:UIControlStateSelected];
        btn.alpha = .5;
        btn.tag = Btn_Tag + idx;
        [btn addTarget:self action:@selector(flagAction:) forControlEvents:UIControlEventTouchUpInside];
        [weakself.scrollContent addSubview:btn];
    }];
}

- (void)flagAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    NSInteger selectIndex = btn.tag - Btn_Tag;
    [self refreshAllBtn:selectIndex];
    btn.alpha = btn.selected?1:.5;
    TopupCountryModel *model = _sourceArr[btn.tag - Btn_Tag];

    NSString *selectGlobalRoaming = btn.selected?model.globalRoaming:@"";
    if (_countrySelectB) {
        _countrySelectB(selectGlobalRoaming);
    }
}

- (void)refreshAllBtn:(NSInteger)selectIndex {
    kWeakSelf(self);
    [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *aBtn = [weakself.scrollContent viewWithTag:Btn_Tag + idx];
        if (idx != selectIndex) {
            aBtn.selected = NO;
        }
    }];
}

- (void)refreshCountryView {
    [self requestTopup_country_list];
}

#pragma mark - Request
- (void)requestTopup_country_list {
    kWeakSelf(self);
    NSString *page = @"1";
    NSString *size = TopupNetworkSize;
    NSDictionary *params = @{@"page":page,@"size":size};
    [RequestService requestWithUrl10:topup_country_list_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [weakself.sourceArr removeAllObjects];
            NSArray *arr = [TopupCountryModel mj_objectArrayWithKeyValuesArray:responseObject[@"countryList"]];
            [weakself.sourceArr addObjectsFromArray:arr];
            weakself.scrollContentWidth.constant = arr.count*56;
            [weakself configCountryView];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {

    }];
}

@end
