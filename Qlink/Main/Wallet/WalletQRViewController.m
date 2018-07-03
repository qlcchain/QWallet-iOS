//
//  WalletQRViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/4.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "WalletQRViewController.h"
#import "HMScannerMaskView.h"
#import "HMScannerBorder.h"
#import "HMScanner.h"
#import <Masonry/Masonry.h>
//#import "UIButton+UserHead.h"
#import "WalletAlertView.h"
#import "WalletCreateSuccessViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "UIImage+Resize.h"
#import "Qlink-Swift.h"

@interface WalletQRViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *parentView;
@property (nonatomic ,strong) HMScanner *scanner;
@property (nonatomic ,strong) HMScannerBorder *scannerBorder;
@property (nonatomic ,strong) HMScannerMaskView *maskView;
@property (weak, nonatomic) IBOutlet UIButton *userHeadBtn;

@end

@implementation WalletQRViewController
- (IBAction)clickBack:(id)sender {
    [self leftNavBarItemPressedWithPop:YES];
}
- (IBAction)clickHead:(id)sender {
    [self clickAlbumButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [_scannerBorder startScannerAnimating];
//    [_scanner startScan];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_scannerBorder startScannerAnimating];
    [self.scanner startScan];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_scannerBorder stopScannerAnimating];
    [_scanner stopScan];
}

- (instancetype) initWithCodeQRCompleteBlock:(void (^)(NSString *codeValue)) completion
{
    if (self = [super init]) {
        self.completeBlcok = completion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _parentView.frame = CGRectMake(0, 110, SCREEN_WIDTH, SCREEN_HEIGHT-110);
    [self prepareScanerBorder];
    
}
#pragma mark - lazy
- (HMScanner *)scanner {
    if (!_scanner) {
        // 实例化扫描器
        @weakify_self
        _scanner = [HMScanner scanerWithView:_parentView scanFrame:_scannerBorder.frame completion:^(NSString *stringValue) {
            DDLogDebug(@"codeValue = %@",stringValue);
            if (weakSelf.completeBlcok) {
                weakSelf.completeBlcok(stringValue);
                [weakSelf leftNavBarItemPressedWithPop:YES];
            } else {
                // 完成回调
                [weakSelf checkPrivatekeyFormat:stringValue];
            }
           
        }];
    }
    return _scanner;
}

#pragma mark - Config View
- (void)refreshContent {

}

/// 准备扫描框
- (void)prepareScanerBorder {
    
    CGFloat width = _parentView.frame.size.width - 90;
    
    _scannerBorder = [[HMScannerBorder alloc] initWithFrame:CGRectMake(45,75, width, width)];
   // _scannerBorder.center = self.view.center;
    _scannerBorder.tintColor = MAIN_PURPLE_COLOR;
    [_parentView addSubview:_scannerBorder];
    
    
    _maskView = [HMScannerMaskView maskViewWithFrame:_parentView.bounds cropRect:_scannerBorder.frame];
    [_parentView insertSubview:_maskView atIndex:0];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"bg_gray_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake((SCREEN_WIDTH-140)/2,CGRectGetMaxY(_scannerBorder.frame)+20, 140, 44);
    [backBtn setTitle:NSStringLocalizable(@"cancel") forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:@"VAGRoundedBT-Regular" size:14];
    [_parentView addSubview:backBtn];
}

/**
 检查privatekey的格式

 @param stringValue privatekey
 */
- (void) checkPrivatekeyFormat:(NSString *) stringValue
{
    if (stringValue && ![stringValue isEmptyString]) {
        if (stringValue.length == 52 || stringValue.length == 64) {
            [self showAlertViewWithMsg:stringValue];
        } else {
            [AppD.window showHint:NSStringLocalizable(@"privateKey_format")];
            [_scanner startScan];
        }
    }
}

- (void) showAlertViewWithMsg:(NSString *) msg
{
    WalletAlertView *alertView = [WalletAlertView loadWalletAlertView];
    alertView.lblMsg.text = msg;
    alertView.lblTitle.text = NSStringLocalizable(@"private_key");
    [alertView showIsTwoBtn:YES];
    
     @weakify_self
    [alertView setYesClickBlock:^{
        [weakSelf sendImportWalletRequest:msg];
    }];
    [alertView setCancelClickBlock:^{
        [weakSelf.scanner startScan];
    }];
}

#pragma mark - 选择图片
/// 点击相册按钮
- (void) clickAlbumButton {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [AppD.window showHint:NSStringLocalizable(@"unable_photo")];
        return;
    }
    
    //调用系统相册的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    //    更改titieview的字体颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [pickerController.navigationBar setTitleTextAttributes:attrs];
    pickerController.navigationBar.translucent = NO;
    pickerController.navigationBar.barTintColor = MAIN_PURPLE_COLOR;
    //设置相册呈现的样式
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //UIImagePickerControllerSourceTypeSavedPhotosAlbum;//图片分组列表样式
    pickerController.delegate = self;
    //使用模态呈现相册
    [self.navigationController presentViewController:pickerController animated:YES completion:nil];
}
#pragma UIImagePickerController delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //使用模态返回到软件界面
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (resultImage) {
        resultImage = [resultImage resizeImage:resultImage];
        // 扫描图像
        @weakify_self
        [HMScanner scaneImage:resultImage completion:^(NSArray *values) {
            if (weakSelf.completeBlcok) {
                if (values.count > 0) {
                    weakSelf.completeBlcok(values.firstObject);
                } else {
                    [AppD.window showHint:NSStringLocalizable(@"no_code")];
                }
            } else {
                // 完成回调
                if (values.count > 0) {
                    [weakSelf checkPrivatekeyFormat:values.firstObject];
                } else {
                    [AppD.window showHint:NSStringLocalizable(@"no_code")];
                }
            }
            
        }];
    }
    
}

#pragma mark - 发送导入钱包请求
/**
 导入钱包
 */
- (void) sendImportWalletRequest:(NSString *) privateKey
{
    
    [AppD.window showHudInView:self.view hint:NSStringLocalizable(@"Loading")];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isScueess = [WalletManage.shareInstance3 getWalletWithPrivatekeyWithPrivatekey:privateKey];
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
                [_scanner startScan];
                [AppD.window showHint:NSStringLocalizable(@"wallet_import")];
            });
        }
    });
    
    /*
    [AppD.window showHudInView:self.view hint:@"Loading.."];
    NSDictionary *params = @{@"key":privateKey};
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
                    // 移除当前vs
                   // [self moveNavgationViewController:self];
                    // 移除前二个vs
                    [self moveNavgationBackViewController];
                }
            }
        } else {
            [AppD.window showHint:[responseObject objectForKey:@"msg"]];
             [_scanner startScan];
        }
        
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [AppD.window hideHud];
        [_scanner startScan];
        [AppD.window showHint:NSStringLocalizable(@"request_error")];
    }];*/
    
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
