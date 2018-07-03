//
//  NewWalletViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/29.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "NewWalletViewController.h"
#import "AppDelegate.h"
#import "QlinkTabbarViewController.h"
#import "WalletImportKeyViewController.h"
#import "WalletQRViewController.h"
#import "WalletInfo.h"
#import "WalletCreateSuccessViewController.h"
#import "WalletUtil.h"
#import "Qlink-Swift.h"

@interface NewWalletViewController ()

@end

@implementation NewWalletViewController
- (IBAction)clickCreateWallet:(id)sender {
    
    [self sendCreateWalletRequest];
    
}
- (IBAction)clickPrivateKey:(id)sender {
    
    WalletImportKeyViewController *vc = [[WalletImportKeyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)clickQR:(id)sender {
    WalletQRViewController *vc = [[WalletQRViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)clickBack:(id)sender {
    if (self.jumpStyle == PassJump) {
        [WalletUtil manageCancelWork];
        [self leftNavBarItemPressedWithPop:YES];
    } else {
        [self leftNavBarItemPressedWithPop:YES];
    }
}

- (instancetype) initWithJump:(JumpStyle) style
{
    if (self = [super init]) {
        self.jumpStyle = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self addNewGuide];
}

#pragma mark - Config View
//- (void)addNewGuide {
////    [HWUserdefault insertObj:@(NO) withkey:NEW_GUIDE_CREATE_NEW_WALLET];
//    NSNumber *guideLocal = [HWUserdefault getObjectWithKey:NEW_GUIDE_CREATE_NEW_WALLET];
//    if (!guideLocal || [guideLocal boolValue] == NO) {
//        UIView *guideBV = [NewGuideUtil showNewGuideWithKey:NEW_GUIDE_CREATE_NEW_WALLET TapBlock:^{
//        }];
//        UIImage *guideImg = [UIImage imageNamed:@"img_img_floating_layer_new_wallet"];
//        UIImageView *guideImgV = [[UIImageView alloc] init];
//        guideImgV.frame = CGRectZero;
//        if (IS_iPhone_5) {
//            guideImgV.frame = CGRectMake((SCREEN_WIDTH-guideImg.size.width)/2.0, 220, guideImg.size.width, guideImg.size.height);
//        } else if (IS_iPhone_6) {
//            guideImgV.frame = CGRectMake((SCREEN_WIDTH-guideImg.size.width)/2.0, 220, guideImg.size.width, guideImg.size.height);
//        } else if (IS_iPhone6_Plus) {
//            guideImgV.frame = CGRectMake((SCREEN_WIDTH-guideImg.size.width)/2.0, 220, guideImg.size.width, guideImg.size.height);
//        } else if (IS_iPhoneX) {
//            guideImgV.frame = CGRectMake((SCREEN_WIDTH-guideImg.size.width)/2.0, 244, guideImg.size.width, guideImg.size.height);
//        }
//        
//        guideImgV.image = guideImg;
//        [guideBV addSubview:guideImgV];
//    }
//}

/**
 创建钱包
 */
- (void) sendCreateWalletRequest
{
    [AppD.window showHudInView:self.view hint:NSStringLocalizable(@"loading")];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isSuccess = [WalletManage.shareInstance3 createWallet];
        if (isSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [AppD.window hideHud];
                WalletInfo *walletInfo = [[WalletInfo alloc] init];
                walletInfo.address = [WalletManage.shareInstance3 getWalletAddress];
                walletInfo.wif = [WalletManage.shareInstance3 getWalletWif];
                walletInfo.privateKey = [WalletManage.shareInstance3 getWalletPrivateKey];
                walletInfo.publicKey = [WalletManage.shareInstance3 getWalletPublicKey];
                WalletCreateSuccessViewController *vc = [[WalletCreateSuccessViewController alloc] initWtihWalletInfo:walletInfo];
                // 发送获取qlc 和 gas 请求
                [WalletUtil sendWalletDefaultReqeustWithAddress:walletInfo.address];
                [self.navigationController pushViewController:vc animated:YES];
                [self moveNavgationViewController:self];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [AppD.window hideHud];
                [AppD.window showHint:NSStringLocalizable(@"wallet_create")];
            });
        }
    });
    
    
   /* [AppD.window showHudInView:self.view hint:@"Loading.."];
    [RequestService requestWithUrl:createWallet_Url params:@{} httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [AppD.window hideHud];
         if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
             NSDictionary *dataDic = [responseObject objectForKey:Server_Data];
             if(dataDic)  {
                 WalletInfo *walletInfo = [WalletInfo mj_objectWithKeyValues:dataDic];
                 if (walletInfo) {
                     //[[CurrentWalletInfo getShareInstance] setAttributValueWithWalletInfo:walletInfo];
                     WalletCreateSuccessViewController *vc = [[WalletCreateSuccessViewController alloc] initWtihWalletInfo:walletInfo];
                     [self.navigationController pushViewController:vc animated:YES];
                     [self moveNavgationViewController:self];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
