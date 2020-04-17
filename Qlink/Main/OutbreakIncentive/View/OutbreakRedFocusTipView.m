//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "OutbreakRedFocusTipView.h"
#import "UIView+Visuals.h"
#import "WalletCommonModel.h"
#import "GlobalConstants.h"
#import "ClaimConstants.h"
#import "UserModel.h"
#import "MD5Util.h"
#import "RSAUtil.h"
#import "NSDate+Category.h"
#import "SuccessTipView.h"
#import "JPushTagHelper.h"
#import "UIView+PopAnimate.h"

@interface OutbreakRedFocusTipView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UIButton *claimBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic, copy) ClaimQGASTipConfirmBlock confirmBlock;

@end

@implementation OutbreakRedFocusTipView

+ (instancetype)getInstance {
    OutbreakRedFocusTipView *view = [[[NSBundle mainBundle] loadNibNamed:@"OutbreakRedFocusTipView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    view.claimBtn.layer.cornerRadius = 25;
    view.claimBtn.layer.masksToBounds = YES;
    [view configInit];
    [view requestSys_dict];
    return view;
}

- (void)configInit {
    _titleLab.text = kLang(@"claim_the_covid_19_fighter_bounty");
//    _amountLab;
    _tipLab.text = kLang(@"get_bounty_by_checking_out_covid_19_live_updates");
    [_claimBtn setTitle:kLang(@"claim_now") forState:UIControlStateNormal];
//    [_closeBtn setBackgroundImage:kClickEffectBtnImage forState:UIControlStateHighlighted];
//    [_claimBtn setBackgroundImage:kClickEffectBtnImage forState:UIControlStateHighlighted];
}

+ (void)show:(ClaimQGASTipConfirmBlock)block {
    BOOL showV = NO;
    NSNumber *localFocusTipShow = [HWUserdefault getObjectWithKey:OutbreakRedFocus_Showed];
    if (!localFocusTipShow || [localFocusTipShow boolValue] == NO) { // 只弹一次
        showV = YES;
        [HWUserdefault insertObj:@(YES) withkey:OutbreakRedFocus_Showed];
    }
    
    if (showV) {
        OutbreakRedFocusTipView *view = [OutbreakRedFocusTipView getInstance];
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [kAppD.window addSubview:view];
        view.confirmBlock = block;
        [view.tipBack showPopAnimate];
    }
}

- (void)hide {
    [self removeFromSuperview];
}

- (IBAction)okAction:(id)sender {
    if (_confirmBlock) {
        _confirmBlock();
    }
    
    [self hide];
}

- (IBAction)closeAction:(id)sender {
    [self hide];
}

#pragma mark - Request
- (void)requestSys_dict {
    kWeakSelf(self);
    NSDictionary *params = @{@"dictType":winq_reward_qlc_amount};
    [RequestService requestWithUrl10:sys_dict_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSString *valueStr = responseObject[Server_Data][@"value"];
            
            NSString *amountShowStr = [NSString stringWithFormat:@"%@QLC",valueStr];
            NSMutableAttributedString *amountAtt = [[NSMutableAttributedString alloc] initWithString:amountShowStr];
            [amountAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, amountShowStr.length)];
            [amountAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36] range:[amountShowStr rangeOfString:valueStr]];
            [amountAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFC5A43) range:NSMakeRange(0, amountShowStr.length)];
            weakself.amountLab.attributedText = amountAtt;
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}


@end
