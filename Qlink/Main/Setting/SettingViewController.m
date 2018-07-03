//
//  SettingViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2018/5/29.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "WalletUtil.h"
#import "VPNMode.h"
#import "WalletDetailViewController.h"
#import "WebViewController.h"
#import "WalletChangeWalletViewController.h"
#import "MyAssetsViewController.h"
#import "NSBundle+Language.h"
#import "UserManage.h"
#import "Qlink-Swift.h"
#import "QlinkTabbarViewController.h"

// 标题部分
//#define WALLET_DETAIL   NSStringLocalizable(@"wallet_details")// 钱包详情
//#define SWITCH_WALLETS  NSStringLocalizable(@"swith_wallets") // 钱包开关
//#define MY_ASSETS  NSStringLocalizable(@"my_register_assets") // 我的资产
//#define FINGERPRINT_TOUCH  NSStringLocalizable(@"fingeprint_unlock") // 指纹验证锁
//#define LANGUAGE  NSStringLocalizable(@"language") // 语言
//#define VERSON  NSStringLocalizable(@"verson") // 版本
//#define DISCLAIMER  NSStringLocalizable(@"disclaimer") // 免责声明

// 图标部分
#define WALLET_DETAIL_ICON  @"icon_wallet" // 钱包详情
#define SWITCH_WALLETS_ICON  @"icon_switch" // 钱包开关
#define MY_ASSETS_ICON  @"icon_registered" // 我的资产
#define FINGERPRINT_TOUCH_ICON  @"icon_fingerprint" // 指纹验证锁
#define LANGUAGE_ICON  @"icon_language" // 语言
#define VERSON_ICON  @"icon_version" // 版本
#define DISCLAIMER_ICON  @"icon_disclaimer" // 免责声明


@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger languageIndex;
    NSInteger currentIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic , copy) NSArray *titleArray;
@property (nonatomic , copy) NSArray *imgArray;
@property (nonatomic , copy) NSArray *languageArray;
@property (weak, nonatomic) IBOutlet UIView *bottomView1;
@property (weak, nonatomic) IBOutlet UIView *bottomView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewContraintBottom;
@end

@implementation SettingViewController
- (IBAction)clickBack:(id)sender {
    [self leftNavBarItemPressedWithPop:YES];
}
- (IBAction)clickBottom:(UIButton *)sender {
    WebViewController *vc = [[WebViewController alloc] initWithType:sender.tag];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[NSStringLocalizable(@"wallet_details"),NSStringLocalizable(@"swith_wallets"),NSStringLocalizable(@"my_register_assets"),NSStringLocalizable(@"fingeprint_unlock"),NSStringLocalizable(@"language"),NSStringLocalizable(@"switch_server"),NSStringLocalizable(@"version"),NSStringLocalizable(@"disclaimer")];
   // _languageArray = @[@"English",@"Chinese",@"Korean",@"Russain",@"Turkish"];
     _languageArray = @[@"English",@"Turkish"];
     NSString *languages = [[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGES];
     languageIndex = 0;
     if ([[NSStringUtil getNotNullValue:languages] isEqualToString:@"tr"]) {
        languageIndex = 1;
     }
    
    _imgArray = @[WALLET_DETAIL_ICON,SWITCH_WALLETS_ICON,MY_ASSETS_ICON,FINGERPRINT_TOUCH_ICON,LANGUAGE_ICON,SWITCH_WALLETS_ICON,VERSON_ICON,DISCLAIMER_ICON];
    _bottomView1.layer.cornerRadius = 5.0f;
    _bottomView2.layer.cornerRadius = 5.0f;
    if (IS_iPhoneX) {
        _backViewContraintBottom.constant = 34;
    }
    
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [_myTableView registerNib:[UINib nibWithNibName:SettingCellReuse bundle:nil] forCellReuseIdentifier:SettingCellReuse];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self addNewGuide];
}

#pragma mark - Config View
//- (void)addNewGuide {
////    [HWUserdefault insertObj:@(NO) withkey:NEW_GUIDE_WALLET_DETAIL];
//    NSNumber *guideLocal = [HWUserdefault getObjectWithKey:NEW_GUIDE_WALLET_DETAIL];
//    if (!guideLocal || [guideLocal boolValue] == NO) {
//        UIView *guideBV = [NewGuideUtil showNewGuideWithKey:NEW_GUIDE_WALLET_DETAIL TapBlock:nil];
//        UIImage *guideImg = [UIImage imageNamed:@"img_floating_layer_settings"];
//        UIImageView *guideImgV = [[UIImageView alloc] init];
//        guideImgV.frame = CGRectZero;
//        if (IS_iPhone_5) {
//            guideImgV.frame = CGRectMake((SCREEN_WIDTH-guideImg.size.width)/2.0, 98, guideImg.size.width, guideImg.size.height);
//        } else if (IS_iPhone_6) {
//            guideImgV.frame = CGRectMake((SCREEN_WIDTH-guideImg.size.width)/2.0, 98, guideImg.size.width, guideImg.size.height);
//        } else if (IS_iPhone6_Plus) {
//            guideImgV.frame = CGRectMake((SCREEN_WIDTH-guideImg.size.width)/2.0, 98, guideImg.size.width, guideImg.size.height);
//        } else if (IS_iPhoneX) {
//            guideImgV.frame = CGRectMake((SCREEN_WIDTH-guideImg.size.width)/2.0, 122, guideImg.size.width, guideImg.size.height);
//        }
//
//        guideImgV.image = guideImg;
//        [guideBV addSubview:guideImgV];
//    }
//}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count-1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SettingCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *myCell = [tableView dequeueReusableCellWithIdentifier:SettingCellReuse];
    myCell.lblTitle.text = _titleArray[indexPath.row];
    myCell.iconImgView.image = [UIImage imageNamed:_imgArray[indexPath.row]];
    
    [myCell.rightBtn setImage:[UIImage imageNamed:@"icon_enter"] forState:UIControlStateNormal];
    myCell.rightContraintTopV.constant = 13;
    myCell.rightBtn.enabled = NO;
    myCell.rightBtn.hidden = NO;
    
    
    NSString *titleMsg = _titleArray[indexPath.row];
    if ([titleMsg isEqualToString:NSStringLocalizable(@"wallet_details")]) {
        myCell.lblDetail.text = CurrentWalletInfo.getShareInstance.address;
    } else if ([titleMsg isEqualToString:NSStringLocalizable(@"swith_wallets")]) {
        NSInteger walletCount = 0;
        NSArray *arr = [WalletUtil getAllWalletList];
        if (arr) {
            NSArray *wallets = [arr objectAtIndex:0];
            walletCount = wallets.count;
        }
        myCell.lblDetail.text = [NSString stringWithFormat:@"%ld %@",(long)walletCount,NSStringLocalizable(@"wallets_available")];
//    } else if (indexPath.row == 2) {
//        myCell.lblDetail.text = @"Registrations,Sharing,Transactions";
    } else if ([titleMsg isEqualToString:NSStringLocalizable(@"my_register_assets")]) {
        NSInteger vpnCount = 0;
        NSArray* finfAlls = [VPNInfo bg_find:VPNREGISTER_TABNAME limit:0 orderBy:@"bg_createTime" desc:YES];
        if (finfAlls) {
            vpnCount = finfAlls.count;
        }
        myCell.lblDetail.text = [NSString stringWithFormat:@"%@:%d  %@:%ld",NSStringLocalizable(@"wifi_assets"),0,NSStringLocalizable(@"vpn_assets"),(long)vpnCount];
    } else if ([titleMsg isEqualToString:NSStringLocalizable(@"fingeprint_unlock")]) {
        myCell.rightContraintTopV.constant = 9;
        myCell.rightBtn.enabled = YES;
        NSString *touchStatu = [HWUserdefault getStringWithKey:TOUCH_SWITCH_KEY];
        if ([[NSStringUtil getNotNullValue:touchStatu] isEqualToString:@"1"]) {
            myCell.lblDetail.text = @"";// @"Open";
            [myCell.rightBtn setImage:[UIImage imageNamed:@"icon_in"] forState:UIControlStateNormal];
        } else {
            myCell.lblDetail.text = @"";// @"Disabled";
            [myCell.rightBtn setImage:[UIImage imageNamed:@"icon_off"] forState:UIControlStateNormal];
        }
        [myCell.rightBtn addTarget:self action:@selector(clickTouchSwitch) forControlEvents:UIControlEventTouchUpInside];
    }  else if ([titleMsg isEqualToString:NSStringLocalizable(@"switch_server")]) {
        NSString *serverNetwork = [HWUserdefault getStringWithKey:SERVER_NETWORK];
        if ([[NSStringUtil getNotNullValue:serverNetwork] isEqualToString:@"1"]) {
            myCell.lblDetail.text = NSStringLocalizable(@"main_server");
        } else {
            myCell.lblDetail.text = NSStringLocalizable(@"test_server");
        }
        
    }else if ([titleMsg isEqualToString:NSStringLocalizable(@"language")]) {
         myCell.lblDetail.text = _languageArray[languageIndex];
    } else if ([titleMsg isEqualToString:NSStringLocalizable(@"version")]) {
        myCell.lblDetail.text = [NSString stringWithFormat:@"%@ %@",NSStringLocalizable(@"version"),APP_Version];
        myCell.rightBtn.hidden = YES;
    } else if ([titleMsg isEqualToString:NSStringLocalizable(@"disclaimer")]) {
        myCell.lblDetail.text = NSStringLocalizable(@"government");
        myCell.rightBtn.hidden = YES;
    }
    
    return myCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    currentIndex = indexPath.row;
    if([_titleArray[indexPath.row] isEqualToString:NSStringLocalizable(@"wallet_details")]){
        WalletDetailViewController *vc = [[WalletDetailViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([_titleArray[indexPath.row] isEqualToString:NSStringLocalizable(@"swith_wallets")]) {
        WalletChangeWalletViewController *vc = [[WalletChangeWalletViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([_titleArray[indexPath.row] isEqualToString:NSStringLocalizable(@"my_register_assets")]) {
        MyAssetsViewController *vc = [[MyAssetsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([_titleArray[indexPath.row] isEqualToString:NSStringLocalizable(@"language")]) {
        [self languageChange];
    } else if ([_titleArray[indexPath.row] isEqualToString:NSStringLocalizable(@"switch_server")]) {
        [self walletServerChange];
    }
}
#pragma mark - 语言切换
- (void) languageChange {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //NSArray *enArr = @[@"zh-Hans",@"en",@"ko",@"ru",@"tr"];
     NSArray *enArr = @[@"en",@"tr"];
    @weakify_self
    [_languageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *alert = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (languageIndex != idx) {
                languageIndex = idx;
                // 更改App语言
                [AppD.window showHudInView:self.view hint:@"setting..."];
                [weakSelf changeLanguageTo:enArr[idx]];
               // [weakSelf.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:currentIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        }];
        [alertC addAction:alert];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:NSStringLocalizable(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    [self presentViewController:alertC animated:YES completion:nil];
}

/**
 更改app语言

 @param language 语言标识
 */
- (void)changeLanguageTo:(NSString *)language {
    // 设置语言
    @weakify_self
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       BOOL isSuccess = [weakSelf changeLanguage:language];
        if (isSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [AppD.window hideHud];
                // 我们要把系统windown的rootViewController替换掉
                QlinkTabbarViewController  *tabbarC = [[QlinkTabbarViewController alloc] init];
                
                CATransition *animation = [CATransition animation];
                //动画时间
                animation.duration = 0.4f;
                //过滤效果
                animation.type = kCATransitionReveal;
                //枚举值:
               // kCATransitionPush 推入效果
              //  kCATransitionMoveIn 移入效果
              //  kCATransitionReveal 截开效果
              //  kCATransitionFade 渐入渐出效果
                //动画执行完毕时是否被移除
                animation.removedOnCompletion = YES;
                //设置方向-该属性从下往上弹出
                animation.subtype = kCATransitionFromRight;
               // 枚举值:
              //  kCATransitionFromRight//右侧弹出
              //  kCATransitionFromLeft//左侧弹出
                //kCATransitionFromTop//顶部弹出
               // kCATransitionFromBottom//底部弹出
                [AppD.window.layer addAnimation:animation forKey:nil];
                AppD.window.rootViewController = tabbarC;
                [AppD.window showHint:NSStringLocalizable(@"switch_success")];
            });
        }
    });

    // 跳转到设置页
   //tab.selectedIndex = 2;
}

- (BOOL) changeLanguage:(NSString *) language
{
    sleep(.5);
    [NSBundle setLanguage:language];
    // 然后将设置好的语言存储好，下次进来直接加载
    [HWUserdefault insertObj:language withkey:LANGUAGES];
    return YES;
}

#pragma -mark 服务器切换
- (void) walletServerChange {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSArray *netArr = @[NSStringLocalizable(@"main_server"),NSStringLocalizable(@"test_server")];
    @weakify_self
    [netArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *alert = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [RequestService cancelAllOperations];
            if (idx == 0) {
                if (![WalletUtil checkServerIsMian]) {
                    // 重新初始化 Account->将Account设为当前钱包->重新设置网络
                    [HWUserdefault insertString:@"1" withkey:SERVER_NETWORK];
                    [WalletManage.shareInstance3 configureAccountWithMainNet:[WalletUtil checkServerIsMian]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_SERVER_NOTI object:nil];
                    [UserManage fetchUserInfo];
                }
               
            } else {
                if ([WalletUtil checkServerIsMian]) {
                    [HWUserdefault insertString:@"0" withkey:SERVER_NETWORK];
                    [WalletManage.shareInstance3 configureAccountWithMainNet:[WalletUtil checkServerIsMian]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_SERVER_NOTI object:nil];
                    [UserManage fetchUserInfo];
                }
                
            }
            [weakSelf.view showHint:NSStringLocalizable(@"switch_success")];
            [weakSelf.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:currentIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }];
        [alertC addAction:alert];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:NSStringLocalizable(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void) clickTouchSwitch
{
     NSString *touchStatu = [HWUserdefault getStringWithKey:TOUCH_SWITCH_KEY];
    if ([[NSStringUtil getNotNullValue:touchStatu] isEqualToString:@"1"]) {
        [HWUserdefault insertString:@"0" withkey:TOUCH_SWITCH_KEY];
    } else {
        [HWUserdefault insertString:@"1" withkey:TOUCH_SWITCH_KEY];
    }
    [_myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:currentIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
