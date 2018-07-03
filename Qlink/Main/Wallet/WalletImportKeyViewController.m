//
//  WalletImportKeyViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/4.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "WalletImportKeyViewController.h"
#import "WalletCreateSuccessViewController.h"
#import "UnderlineView.h"
#import "Qlink-Swift.h"

@interface WalletImportKeyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtPrivateKey;
@property (weak, nonatomic) IBOutlet UnderlineView *txtLineView;


@end

@implementation WalletImportKeyViewController
- (IBAction)clickCheck:(UIButton *)sender {
    _txtPrivateKey.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;
    
}
- (IBAction)clickBack:(id)sender {
    [self.view endEditing:YES];
    [self leftNavBarItemPressedWithPop:YES];
}

- (IBAction)clickImport:(id)sender {
    
    [self.view endEditing:YES];
    if ([_txtPrivateKey.text.trim isEmptyString]) {
        [AppD.window showHint:NSStringLocalizable(@"import_private")];
        return;
    }
    if (_txtPrivateKey.text.trim.length == 52 || _txtPrivateKey.text.trim.length == 64) {
        [self sendImportWalletRequest];
    } else {
        [AppD.window showHint:NSStringLocalizable(@"privateKey_format")];
    }
}

/**
 导入钱包
 */
- (void) sendImportWalletRequest
{
    
    NSString *privatekey = _txtPrivateKey.text.trim;
   [AppD.window showHudInView:self.view hint:NSStringLocalizable(@"loading")];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isScueess = [WalletManage.shareInstance3 getWalletWithPrivatekeyWithPrivatekey:privatekey];
        if (isScueess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [AppD.window hideHud];
                WalletInfo *walletInfo = [[WalletInfo alloc] init];
                walletInfo.address = [WalletManage.shareInstance3 getWalletAddress];
                walletInfo.wif = [WalletManage.shareInstance3 getWalletWif];
                walletInfo.privateKey = [WalletManage.shareInstance3 getWalletPrivateKey];
                walletInfo.publicKey = [WalletManage.shareInstance3 getWalletPublicKey];
                WalletCreateSuccessViewController *vc = [[WalletCreateSuccessViewController alloc] initWtihWalletInfo:walletInfo];
                [self.navigationController pushViewController:vc animated:YES];
                // 移除前二个vs
                [self moveNavgationBackViewController];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [AppD.window hideHud];
                [AppD.window showHint:NSStringLocalizable(@"wallet_import")];
            });
        }
    });
   
    
    
    /*
    [AppD.window showHudInView:self.view hint:@"Loading.."];
     NSDictionary *params = @{@"key":_txtPrivateKey.text.trim};
    [RequestService requestWithUrl:exportKey_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [AppD.window hideHud];
         if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
             NSDictionary *dataDic = [responseObject objectForKey:Server_Data];
             if(dataDic)  {
                 WalletInfo *walletInfo = [WalletInfo mj_objectWithKeyValues:dataDic];
                 if (walletInfo) {
                     //[[CurrentWalletInfo getShareInstance] setAttributValueWithWalletInfo:walletInfo];
                     WalletCreateSuccessViewController *vc = [[WalletCreateSuccessViewController alloc] initWtihWalletInfo:walletInfo];
                     [self.navigationController pushViewController:vc animated:YES];
                     // 移除前二个vs
                     [self moveNavgationBackViewController];
                 }
             }
         } else {
            [AppD.window showHint:[responseObject objectForKey:@"msg"]];
        }
        
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [AppD.window hideHud];
        [AppD.window showHint:NSStringLocalizable(@"request_error")];
    }];*/
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _txtLineView.textField = _txtPrivateKey;
    //注意：事件类型是：`UIControlEventEditingChanged`
    [self performSelector:@selector(pwtfBecomeFirstResponder) withObject:self afterDelay:.6];
}
- (void) pwtfBecomeFirstResponder
{
    [_txtPrivateKey becomeFirstResponder];
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
