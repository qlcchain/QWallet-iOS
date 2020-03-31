//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "SheetMiningTipView.h"
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
#import "MiningActivityModel.h"

@interface SheetMiningTipView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UIButton *claimBtn;
@property (nonatomic, copy) SheetMiningTipConfirmBlock confirmBlock;

@end

@implementation SheetMiningTipView

+ (instancetype)getInstance {
    SheetMiningTipView *view = [[[NSBundle mainBundle] loadNibNamed:@"SheetMiningTipView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    view.claimBtn.layer.cornerRadius = 25;
    view.claimBtn.layer.masksToBounds = YES;
    [view configInit];
//    [view requestSys_dict];
    return view;
}

- (void)configInit {    
    _titleLab.text = kLang(@"qgas_trade_mining_pool_up_to");
    _tipLab.text = kLang(@"mined_qlc_redeem_every_day");
    [_claimBtn setTitle:kLang(@"minging_more_details") forState:UIControlStateNormal];
}

+ (void)show:(MiningActivityModel *)model confirmB:(SheetMiningTipConfirmBlock)block {
    BOOL showV = YES;
    
    if (showV) {
        SheetMiningTipView *view = [SheetMiningTipView getInstance];
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [kAppD.window addSubview:view];
        view.confirmBlock = block;
        
        NSString *valueStr = model.totalRewardAmount;
        NSString *amountShowStr = [NSString stringWithFormat:@"%@ %@",valueStr,model.rewardToken];
        NSMutableAttributedString *amountAtt = [[NSMutableAttributedString alloc] initWithString:amountShowStr];
        [amountAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, amountShowStr.length)];
        [amountAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36] range:[amountShowStr rangeOfString:valueStr]];
        [amountAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x294661) range:NSMakeRange(0, amountShowStr.length)];
        view.amountLab.attributedText = amountAtt;
    }
}

- (void)hide {
    [self removeFromSuperview];
}

- (IBAction)okAction:(id)sender {
    if ([UserModel haveLoginAccount]) { // 登录状态
        if (_confirmBlock) {
            _confirmBlock();
        }
        
        [self hide];
    } else {  // 未登录状态
        [self hide];
        
        if (![UserModel haveLoginAccount]) {
            [kAppD presentLoginNew];
        }
    }
}

- (IBAction)closeAction:(id)sender {
    [self hide];
}

@end
