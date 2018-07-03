//
//  SeizeVPNViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/8.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "SeizeVPNViewController.h"
#import "UnderlineView.h"
#import "BalanceInfo.h"
#import "VPNRegisterViewController.h"

@interface SeizeVPNViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textQLC;
@property (weak, nonatomic) IBOutlet UnderlineView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (nonatomic ,strong) BalanceInfo *balanceInfo;
@end

@implementation SeizeVPNViewController
- (IBAction)clickCancel:(id)sender {
    [self leftNavBarItemPressedWithPop:YES];
}
- (IBAction)clickSeize:(id)sender {
    [self.view endEditing:YES];
    // 抢注价格一定要大于原始价格
    if ([_textQLC.text floatValue] == 0.f || [_textQLC.text floatValue] <= [
                                                                            _lblPrice.text floatValue]) {
        [AppD.window showHint:NSStringLocalizable(@"original_price")];
        return;
    }
    
    [self jumpToVPNRegister];
}

- (instancetype) initWithVPNInfo:(VPNInfo *) mode
{
    if (self = [super init]) {
        self.vpnInfo = mode;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _lineView.textField = _textQLC;
    _textQLC.delegate = self;
    _lblPrice.text = self.vpnInfo.qlc;
    [_textQLC addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self performSelector:@selector(textBecomeFister) withObject:nil afterDelay:0.7];
    
    // 获取资产
    [self sendGetBalanceRequest];
}

#pragma mark - 跳转vpn注册
- (void)jumpToVPNRegister {
    VPNRegisterViewController *addVC = [[VPNRegisterViewController alloc] initWithRegisterType:SeizeVPN withVPNName:self.vpnInfo.vpnName withSeizePrice:_textQLC.text.trim withOldPrice:self.vpnInfo.qlc vpnAddress:self.vpnInfo.address vpnP2pid:self.vpnInfo.p2pId];
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma -mark 获取资产
- (void) sendGetBalanceRequest
{
    [RequestService requestWithUrl:getTokenBalance_Url params:@{@"address":[CurrentWalletInfo getShareInstance].address} httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dataDic = [responseObject objectForKey:Server_Data];
            if(dataDic) {
                self.balanceInfo = [BalanceInfo mj_objectWithKeyValues:dataDic];
            }
        } else {
            [AppD.window showHint:[responseObject objectForKey:@"msg"]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [AppD.window showHint:NSStringLocalizable(@"request_error")];
    }];
}


#pragma -mark textfeild 注册为第一响应
- (void) textBecomeFister
{
    [_textQLC becomeFirstResponder];
}

#pragma mark - UITextField delegate
- (void)textFieldDidChange:(UITextField *)textField
{
    if (self.balanceInfo) {
        if ([textField.text floatValue] > [self.balanceInfo.qlc floatValue]) {
            textField.text = self.balanceInfo.qlc;
        }
    }
}
//textField.text 输入之前的值 string 输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    BOOL isHaveDian = YES;
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if (string.length >0) {
        if (textField.text.length == 0) {
            if([string isEqualToString:@"."]) {
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        // 当第一个为0时  第二个必须为点
        if (textField.text.length == 1 && [textField.text isEqualToString:@"0"]) {
            if (![string isEqualToString:@"."]) {
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        if ([string isEqualToString:@"."]) {
            if (!isHaveDian) { // 还没有点
                isHaveDian = YES;
                return YES;
            } else{
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        } else {
            if (isHaveDian) {//存在小数点
                //判断小数点的位数
                NSRange ran = [textField.text rangeOfString:@"."];
                if (range.location - ran.location <= 2) {
                    return YES;
                }else{
                    return NO;
                }
            } else {
                return YES;
            }
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
