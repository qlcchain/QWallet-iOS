//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "DefiRatePopView.h"
#import "UIView+Visuals.h"
#import "GlobalConstants.h"
#import "UIView+PopAnimate.h"

@interface DefiRatePopView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *aaaBtn;
@property (weak, nonatomic) IBOutlet UIButton *aaBtn;
@property (weak, nonatomic) IBOutlet UIButton *aBtn;
@property (weak, nonatomic) IBOutlet UIButton *bbbBtn;
@property (weak, nonatomic) IBOutlet UIButton *bbBtn;
@property (weak, nonatomic) IBOutlet UIButton *bBtn;
@property (weak, nonatomic) IBOutlet UIButton *cBtn;
@property (weak, nonatomic) IBOutlet UIButton *dBtn;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *rateBtnArr;

@property (nonatomic, strong) NSString *selectRate;
@property (nonatomic, copy) DefiRateSubmitBlock submitB;

@end

@implementation DefiRatePopView

+ (instancetype)getInstance {
    DefiRatePopView *view = [[[NSBundle mainBundle] loadNibNamed:@"DefiRatePopView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    return view;
}

- (void)show:(DefiRateSubmitBlock)submitB {
    _submitB = submitB;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
    _titleLab.text = kLang(@"defi_rate_this_defi");
    [_submitBtn setTitle:kLang(@"defi_submit") forState:UIControlStateNormal];
    _submitBtn.enabled = NO;
    
    _submitBtn.layer.cornerRadius = 25;
    _submitBtn.layer.masksToBounds = YES;
    
    [_rateBtnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = UIColorFromRGB(0xE3E3E3).CGColor;
        btn.layer.borderWidth = 0.5;
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x7ED321)] forState:UIControlStateSelected];
    }];
    
    [self aaaAction:_aaaBtn];
    
    [self.tipBack showPopAnimate];
}

- (void)hide {
    [self removeFromSuperview];
}

- (IBAction)closeAction:(id)sender {
    [self hide];
}

- (IBAction)submitAction:(id)sender {
    if (_selectRate == nil) {
        return;
    }
    NSString *selectScore = @"10";
    if ([_selectRate isEqualToString:@"A++"]) {
        selectScore = @"10";
    } else if ([_selectRate isEqualToString:@"A+"]) {
        selectScore = @"9";
    } else if ([_selectRate isEqualToString:@"A"]) {
        selectScore = @"8";
    } else if ([_selectRate isEqualToString:@"B++"]) {
        selectScore = @"7";
    } else if ([_selectRate isEqualToString:@"B+"]) {
        selectScore = @"6";
    } else if ([_selectRate isEqualToString:@"B"]) {
        selectScore = @"5";
    } else if ([_selectRate isEqualToString:@"C"]) {
       selectScore = @"4";
   } else if ([_selectRate isEqualToString:@"D"]) {
         selectScore = @"3";
     }
    if (_submitB) {
        _submitB(selectScore);
    }
    
    [self hide];
}

- (IBAction)aaaAction:(UIButton *)sender {
    kWeakSelf(self);
    [_rateBtnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        btn.selected = btn==sender?YES:NO;
        if (btn.selected) {
            weakself.selectRate = btn.currentTitle?:@"";
            weakself.submitBtn.enabled = YES;
        }
    }];
}



@end
