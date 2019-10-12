//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ClaimQGASTipView.h"
#import "UIView+Visuals.h"
#import "WalletCommonModel.h"
#import "GlobalConstants.h"
#import "ClaimConstants.h"
#import "UserModel.h"
#import "MD5Util.h"
#import "RSAUtil.h"
#import "NSDate+Category.h"
#import "SuccessTipView.h"

@interface ClaimQGASTipView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UIButton *claimBtn;

@end

@implementation ClaimQGASTipView

+ (instancetype)getInstance {
    ClaimQGASTipView *view = [[[NSBundle mainBundle] loadNibNamed:@"ClaimQGASTipView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    view.claimBtn.layer.cornerRadius = 25;
    view.claimBtn.layer.masksToBounds = YES;
    [view configInit];
    [view requestSys_dict];
    return view;
}

- (void)configInit {
    NSString *language = [Language currentLanguageCode];
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        
    }
    _titleLab.text = kLang(@"free_qlc_lending_for_staking");
//    _amountLab;
    _tipLab.text = kLang(@"claim_entitled_qgas_earnings_everyday");
    [_claimBtn setTitle:kLang(@"receive_now") forState:UIControlStateNormal];
}

+ (void)show {
    if (![UserModel haveLoginAccount]) {
        return;
    }
    if (![UserModel isBind]) { // 未绑定 弹出领取QGAS view
        ClaimQGASTipView *view = [ClaimQGASTipView getInstance];
        
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [kAppD.window addSubview:view];
    }
}

- (void)hide {
    [self removeFromSuperview];
}

- (IBAction)okAction:(id)sender {
    if (_confirmBlock) {
        _confirmBlock();
    }
    [self requestUser_bind];
//    [self hide];
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

- (void)requestUser_bind {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        [self hide];
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSDictionary *params = @{@"account":account,@"token":token};
    [RequestService requestWithUrl11:user_bind_Url params:params timestamp:timestamp httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            SuccessTipView *view = [SuccessTipView getInstance];
            [view showWithTitle:kLang(@"successful")];
            userM.bindDate = responseObject[@"bindDate"];
            [UserModel storeUser:userM useLogin:NO];
        }
        
        [weakself hide];
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself hide];
    }];
}

@end
