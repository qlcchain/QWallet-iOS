//
//  WalletPublicAddressViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/28.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "WalletPublicAddressViewController.h"
#import <Hero/Hero-Swift.h>
#import "BalanceInfo.h"
#import "HMScanner.h"
//#import "UIButton+UserHead.h"

#import <SDWebImage/UIButton+WebCache.h>

@interface WalletPublicAddressViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNEO;
@property (weak, nonatomic) IBOutlet UILabel *lblQLC;
@property (weak, nonatomic) IBOutlet UILabel *lblGAS;
@property (nonatomic ,assign) EnterCodeType codeType;
@property (weak, nonatomic) IBOutlet UILabel *lblTopTtile;



@end

@implementation WalletPublicAddressViewController

- (void)viewWillAppear:(BOOL)animated {
   
    [super viewWillAppear:animated];
}

- (IBAction)clickBack:(id)sender {
    [self leftNavBarItemPressedWithPop:YES];
}

- (instancetype) initWithCodeType:(EnterCodeType) codeType
{
    if (self = [super init]) {
        _codeType = codeType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    NSString *codeStr = @"";
    switch (_codeType) {
        case AddressStyle:
            codeStr = [CurrentWalletInfo getShareInstance].address;
            _lblTitle.text = NSStringLocalizable(@"public_address_lower");
            _lblTopTtile.text = NSStringLocalizable(@"public_address");
            break;
        case WifStyle:
            codeStr = [CurrentWalletInfo getShareInstance].wif;
            _lblTitle.text =NSStringLocalizable(@"encrypted_key_lower");
            _lblTopTtile.text =NSStringLocalizable(@"encrypted_key");
            break;
        case PrivateKeyStyle:
            codeStr = [CurrentWalletInfo getShareInstance].privateKey;
            _lblTitle.text =NSStringLocalizable(@"private_key_lower");
            _lblTopTtile.text =NSStringLocalizable(@"private_key");
            break;
        default:
            break;
    }
    
    @weakify_self
    [HMScanner qrImageWithString:codeStr avatar:nil completion:^(UIImage *image) {
        weakSelf.codeImageView.image = image;
    }];
    
//    self.navigationController.isHeroEnabled = YES;
   // self.isHeroEnabled = YES;
  //  _codeImageView.heroID = @"scancode";
  //  _testView2.heroID = @"skyWalker";
    
    // 获取钱包资产
    [self sendGetBalanceRequestWithAddress:[CurrentWalletInfo getShareInstance].address];
    
}

#pragma mark - Config View
- (void)refreshContent {

}

/**
 获取资产
 */
- (void) sendGetBalanceRequestWithAddress:(NSString *) address
{
    [RequestService requestWithUrl:getTokenBalance_Url params:@{@"address":address} httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        //[self hideHud];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dataDic = [responseObject objectForKey:Server_Data];
            if(dataDic)  {
                BalanceInfo *balanceInfo= [BalanceInfo mj_objectWithKeyValues:dataDic];
                if (balanceInfo) {
                    _lblNEO.text = [NSString stringWithFormat:@"%.2f",[balanceInfo.neo floatValue]];
                    _lblQLC.text = [NSString stringWithFormat:@"%.2f",[balanceInfo.qlc floatValue]];
                    _lblGAS.text = [NSString stringWithFormat:@"%.2f",[balanceInfo.gas floatValue]];
                }
            }
        } else {
            [AppD.window showHint:[responseObject objectForKey:@"msg"]];
        }
        
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        //[self hideHud];
        [AppD.window showHint:NSStringLocalizable(@"request_error")];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
