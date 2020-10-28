//
//  WalletsViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/25.
//  Copyright © 2018 pan. All rights reserved.
//

#import "WalletsViewController.h"
#import "WalletsCell.h"
#import "WalletsSwitchViewController.h"
#import "ETHWalletDetailViewController.h"
#import "ETHTransactionRecordViewController.h"
#import "ChooseWalletViewController.h"
#import <ETHFramework/ETHFramework.h>
#import "ETHAddressInfoModel.h"
#import "WalletsSwitchViewController.h"
//#import "QlinkNavViewController.h"
#import "QNavigationController.h"
#import "WalletCommonModel.h"
//#import "SRRefreshView.h"
#import "ETHWalletAddressViewController.h"
#import "TokenPriceModel.h"
#import "NSString+RemoveZero.h"
#import "NEOWalletUtil.h"
#import "NEOAddressInfoModel.h"
#import "NEOWalletDetailViewController.h"
#import "NEOTransactionRecordViewController.h"
#import "NeoTransferUtil.h"
#import "NEOWalletAddressViewController.h"
#import "NeoGotWGasModel.h"
#import "NeoQueryWGasModel.h"
#import "NeoQueryWGasView.h"
#import "WalletQRViewController.h"
#import "ETHTransferViewController.h"
#import "NEOTransferViewController.h"
#import "ETHWalletInfo.h"
#import "Qlink-Swift.h"
#import "NeoClaimGasTipView.h"
#import "NEOGasClaimUtil.h"
#import "EOSWalletInfo.h"
#import <eosFramework/RegularExpression.h>
#import "EOSSymbolModel.h"
#import "EOSTransactionRecordViewController.h"
#import "EOSResourcesViewController.h"
#import "EOSAccountQRViewController.h"
#import "EOSWalletDetailViewController.h"
#import "EOSActivateAccountViewController.h"
#import "EOSTransferViewController.h"
#import "UserModel.h"
#import "RefreshHelper.h"
#import "QLCWalletInfo.h"
#import <QLCFramework/QLCFramework.h>
#import <QLCFramework/QLCFramework-Swift.h>
#import "QLCAddressInfoModel.h"
#import "QLCWalletDetailViewController.h"
#import "QLCTransactionRecordViewController.h"
#import "QLCWalletAddressViewController.h"
#import "QLCTransferViewController.h"
#import "QLCTokenInfoModel.h"
#import "MyStakingsViewController.h"
#import "NEOWalletInfo.h"
//#import "WebTestViewController.h"
//#import "GlobalConstants.h"
#import <SwiftTheme/SwiftTheme-Swift.h>
#import "UserUtil.h"
#import "RLArithmetic.h"
#import "AppDelegate+AppService.h"
#import "NEOBackupDetailViewController.h"
#import "QLCBackupDetailViewController.h"
#import "ETHMnemonicViewController.h"
#import "TokenListHelper.h"
#import "EOSAddressInfoModel.h"
#import "NEOJSUtil.h"
#import "NEOGasClaimModel.h"
#import <LYEmptyView/LYEmptyViewHeader.h>
#import <TMCache/TMCache.h>
#import "QSwipHmoeViewController.h"
#import "ContractETHRequest.h"

static NSString *const TM_Wallet_Source = @"TM_Wallet_Source";

@interface WalletsViewController () <UITableViewDataSource, UITableViewDelegate/*,SRRefreshDelegate,UIScrollViewDelegate*/>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *refreshScroll;

@property (weak, nonatomic) IBOutlet UILabel *walletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *walletAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *walletBalanceLab;
@property (weak, nonatomic) IBOutlet UIImageView *walletIcon;

@property (weak, nonatomic) IBOutlet UIView *walletBack;

// QLC Staking
@property (weak, nonatomic) IBOutlet UILabel *myStakingsLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stakingHeight; // 53

// NEO Gas
@property (weak, nonatomic) IBOutlet UILabel *claimgasLab;
@property (weak, nonatomic) IBOutlet UILabel *claimLab;
@property (weak, nonatomic) IBOutlet UIImageView *claimStatusIcon;
@property (weak, nonatomic) IBOutlet UIView *claimBtnBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gasBackHeight; // 71

// EOS Resources
@property (weak, nonatomic) IBOutlet UILabel *eosResourceLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eosResourcesHeight; // 53

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalBackheight; // 147
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

// 备份助记词
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backupBackHeight; // 180 220
@property (weak, nonatomic) IBOutlet UILabel *backupTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *backupTip1Lab;
@property (weak, nonatomic) IBOutlet UILabel *backupTip2Lab;
@property (weak, nonatomic) IBOutlet UIButton *backupBtn;

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) NSMutableArray *tokenPriceArr;
@property (nonatomic, strong) NSMutableArray *tokenSymbolArr;

@property (nonatomic, strong) ETHAddressInfoModel *ethAddressInfoM;
@property (nonatomic, strong) NEOAddressInfoModel *neoAddressInfoM;
@property (nonatomic, strong) QLCAddressInfoModel *qlcAddressInfoM;
//@property (nonatomic, strong) SRRefreshView *slimeView;

@end

@implementation WalletsViewController

#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(walletChange:) name:Wallet_Change_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addETHWallet:) name:Add_ETH_Wallet_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteWalletSuccess:) name:Delete_Wallet_Success_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNEOWallet:) name:Add_NEO_Wallet_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currencyChang:) name:Currency_Change_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addEOSWallet:) name:Add_EOS_Wallet_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addQLCWallet:) name:Add_QLC_Wallet_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qlcAccountPendingDone:) name:QLC_AccountPending_Done_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeNoti:) name:kLanguageChangeNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNoti:) name:User_Login_Success_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ethBackupUpdateNoti:) name:ETH_Wallet_Backup_Update_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(neoBackupUpdateNoti:) name:NEO_Wallet_Backup_Update_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qlcBackupUpdateNoti:) name:QLC_Wallet_Backup_Update_Noti object:nil];
}

#pragma mark - Life Cycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 提前初始化
    //[ContractETHRequest addContractETHRequest];
    
    [self addObserve];
    
    self.view.theme_backgroundColor = globalBackgroundColorPicker;
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:WalletsCellReuse bundle:nil] forCellReuseIdentifier:WalletsCellReuse];
    [self configEmptyView:_mainTable contentViewY:60];
//    self.baseTable = _mainTable;
    
    [self refreshTitle];
    [self renderView];
    [self configInit];
    [self refreshBackupView]; // 刷新备份助记词
    
    [self showCacheData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    if (!_slimeView) {
//        [_refreshScroll addSubview:self.slimeView];
//    }
    
}

#pragma mark - Operation
- (void)renderView {
//    UIColor *borderColor = UIColorFromRGB(0x29282A);
    UIColor *walletShadowColor = [UIColorFromRGB(0xCACACA) colorWithAlphaComponent:0.5];
    [_walletBack addShadowWithOpacity:1 shadowColor:walletShadowColor shadowOffset:CGSizeMake(0,4) shadowRadius:10 andCornerRadius:12];
    
    [_claimLab cornerRadius:8.5];
    
    _backupBtn.layer.cornerRadius = 6;
    _backupBtn.layer.masksToBounds = YES;
}

- (void)configInit {
    _tokenSymbolArr = [NSMutableArray array];
    _tokenPriceArr = [NSMutableArray array];
    
    _gasBackHeight.constant = 0;
    _eosResourcesHeight.constant = 0;
    _stakingHeight.constant = 0;
//    _contentHeight.constant = SCREEN_HEIGHT-Height_NavBar-Height_TabBar+_totalBackheight.constant;
    _contentHeight.constant = SCREEN_HEIGHT-Height_NavBar-Height_TabBar;
    _backupBackHeight.constant = 0;
    
    _contentView.hidden = YES;
    _refreshScroll.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"background_list_empty" titleStr:kLang(@"no_data") detailStr:nil];
    _refreshScroll.ly_emptyView.contentViewY = 160;
    [_refreshScroll ly_showEmptyView];
    
    kWeakSelf(self)
    _refreshScroll.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        [weakself pullToRefresh];
    } type:RefreshTypeWhite];
    
    [self refreshClaimGas:nil];
    [self judgeWallet];
}

- (void)judgeWallet {
//    [ETHWalletInfo refreshTrustWallet]; // 如果keychain中的钱包在Trust中没有则自动导入
    BOOL haveEthWallet = [ETHWalletInfo haveETHWallet];
    BOOL haveNeoWallet = [NEOWalletInfo haveNEOWallet];
    BOOL haveEosWallet = [EOSWalletInfo haveEOSWallet];
    BOOL haveQlcWallet = [QLCWalletInfo haveQLCWallet];
    if (haveEthWallet) {
        [WalletCommonModel refreshETHWallet];
    }
    if (haveNeoWallet) {
        [WalletCommonModel refreshNEOWallet];
    }
    if (haveEosWallet) {
        [WalletCommonModel refreshEOSWallet];
    }
    if (haveQlcWallet) {
        [WalletCommonModel refreshQLCWallet];
    }
    // 进入请求钱包数据
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (!currentWalletM) { // 当前没有选择钱包
        if ([WalletCommonModel getAllWalletModel].count > 0) { // 默认选择第一个钱包
            currentWalletM = [WalletCommonModel getAllWalletModel].firstObject;
            [WalletCommonModel setCurrentSelectWallet:currentWalletM];
        }
    }
    if (currentWalletM) {
        [self requestTokenList];
        
        [self startReceiveQLC]; // QLC--account pending
        
    }
//    else { // 没有钱包 则跳转创建钱包页面
//        [self jumpToChooseWallet:NO];
//    }
}

- (void)showCacheData {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM) {
        switch (currentWalletM.walletType) {
            case WalletTypeETH:
            {
                [self handlerWithETH];
            }
                break;
            case WalletTypeEOS:
            {
                NSString *accountName = currentWalletM.account_name?:@"";
                [self handlerWithAccountName:accountName];
            }
                break;
            case WalletTypeNEO:
            {
                [self handlerWithNEO];
            }
                break;
            case WalletTypeQLC:
            {
                [self handlerWithQLC];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)showContentView {
    _contentView.hidden = NO;
    [_refreshScroll ly_hideEmptyView];
}

- (void)updateWalletWithETH:(ETHAddressInfoModel *)ethModel {
    NSArray *allWallets = [WalletCommonModel getAllWalletModel];
    [allWallets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WalletCommonModel *walletM = obj;
        if ([[walletM.address lowercaseString] isEqualToString:[ethModel.address lowercaseString]]) {
            walletM.ETHBalance = ethModel.ETH.balance;
            [WalletCommonModel updateWalletModel:walletM];
            *stop = YES;
        }
    }];
}

- (void)refreshDataWithETH {
    [self showContentView];
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    _totalLab.text = [NSString stringWithFormat:@"%@ %@",[ConfigUtil getLocalUsingCurrencySymbol],@"0"];
    _walletNameLab.text = currentWalletM.name;
    _walletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[currentWalletM.address substringToIndex:8],[currentWalletM.address substringWithRange:NSMakeRange(currentWalletM.address.length - 8, 8)]];
//    [self refreshPriceTotal:@"0"];
    _walletIcon.image = [UIImage imageNamed:@"eth_wallet"];
    
    [_sourceArr removeAllObjects];
//    [_sourceArr addObject:[self getETHToken]];
    [_sourceArr addObjectsFromArray:_ethAddressInfoM.tokens];
    [_mainTable reloadData];
    
    [_tokenSymbolArr removeAllObjects];
//    [_tokenSymbolArr addObject:@"ETH"];
    kWeakSelf(self);
    [_ethAddressInfoM.tokens enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Token *token = obj;
        [weakself.tokenSymbolArr addObject:token.tokenInfo.symbol];
    }];
//    [[NSNotificationCenter defaultCenter] postNotificationName:Token_Change_Noti object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself requestTokenPrice];
    });
}

//- (Token *)getETHToken {
//    TokenInfo *tokenInfo = [[TokenInfo alloc] init];
//    tokenInfo.address = _ethAddressInfoM.address;
//    tokenInfo.decimals = @"0";
//    tokenInfo.name = @"ETH";
//    tokenInfo.symbol = @"ETH";
//    Token *token = [[Token alloc] init];
//    token.balance = _ethAddressInfoM.ETH.balance;
//    token.tokenInfo = tokenInfo;
//    return token;
//}

//- (void)updateWalletWithQLC:(QLCAddressInfoModel *)qlcModel {
//    NSArray *allWallets = [WalletCommonModel getAllWalletModel];
//    [allWallets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        WalletCommonModel *walletM = obj;
//        if ([[walletM.address lowercaseString] isEqualToString:[qlcModel.account lowercaseString]]) {
//            [qlcModel.tokens enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                QLCTokenModel *tokenM = obj;
//                if ([tokenM.tokenName isEqualToString:@"QLC"]) {
//                    NSString *balance = [tokenM getTokenNum];
//                    walletM.balance = @([balance doubleValue]);
//                    [WalletCommonModel updateWalletModel:walletM];
//                    *stop = YES;
//                }
//            }];
//
//            *stop = YES;
//        }
//    }];
//}

- (void)refreshDataWithQLC {
    [self showContentView];
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    _totalLab.text = [NSString stringWithFormat:@"%@ %@",[ConfigUtil getLocalUsingCurrencySymbol],@"0"];
    _walletNameLab.text = currentWalletM.name;
    _walletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[currentWalletM.address substringToIndex:8],[currentWalletM.address substringWithRange:NSMakeRange(currentWalletM.address.length - 8, 8)]];
//    [self refreshPriceTotal:@"0"];
    
    [self updateStakingUI];
    _walletIcon.image = [UIImage imageNamed:@"qlc_wallet"];
    
    [_sourceArr removeAllObjects];
    [_sourceArr addObjectsFromArray:_qlcAddressInfoM.tokens];
    [_mainTable reloadData];
    
    [_tokenSymbolArr removeAllObjects];
    kWeakSelf(self);
    [_qlcAddressInfoM.tokens enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QLCTokenModel *asset = obj;
        [weakself.tokenSymbolArr addObject:asset.tokenName];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself requestTokenPrice];
    });
}

//- (void)updateWalletWithNEO:(NEOAddressInfoModel *)neoModel {
//    NSArray *allWallets = [WalletCommonModel getAllWalletModel];
//    [allWallets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        WalletCommonModel *walletM = obj;
//        if ([[walletM.address lowercaseString] isEqualToString:[neoModel.address lowercaseString]]) {
//            walletM.balance = neoModel.amount;
//            [WalletCommonModel updateWalletModel:walletM];
//            *stop = YES;
//        }
//    }];
//}

- (void)refreshDataWithNEO {
    [self showContentView];
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    _totalLab.text = [NSString stringWithFormat:@"%@ %@",[ConfigUtil getLocalUsingCurrencySymbol],@"0"];
    _walletNameLab.text = currentWalletM.name;
    _walletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[currentWalletM.address substringToIndex:8],[currentWalletM.address substringWithRange:NSMakeRange(currentWalletM.address.length - 8, 8)]];
//    [self refreshPriceTotal:@"0"];
    _walletIcon.image = [UIImage imageNamed:@"neo_wallet"];
    
    [_sourceArr removeAllObjects];
//    [_sourceArr addObject:[self getNEOToken]];
    [_sourceArr addObjectsFromArray:_neoAddressInfoM.balance];
    [_mainTable reloadData];
    
    [_tokenSymbolArr removeAllObjects];
//    [_tokenSymbolArr addObject:@"NEO"];
    kWeakSelf(self);
    [_neoAddressInfoM.balance enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOAssetModel *asset = obj;
        [weakself.tokenSymbolArr addObject:asset.asset_symbol];
    }];
//    [[NSNotificationCenter defaultCenter] postNotificationName:Token_Change_Noti object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself requestTokenPrice];
    });
}

//- (void)updateWalletWithEosBalance:(NSNumber *)eosBalance accountName:(NSString *)account_name {
//    NSArray *allWallets = [WalletCommonModel getAllWalletModel];
//    [allWallets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        WalletCommonModel *walletM = obj;
//        if ([walletM.account_name isEqualToString:account_name]) {
//            walletM.balance = eosBalance;
//            [WalletCommonModel updateWalletModel:walletM];
//            *stop = YES;
//        }
//    }];
//}

- (void)refreshDataWithEOS:(NSArray *)tokenList {
    [self showContentView];
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    _totalLab.text = [NSString stringWithFormat:@"%@ %@",[ConfigUtil getLocalUsingCurrencySymbol],@"0"];
    _walletNameLab.text = currentWalletM.name;
    _eosResourceLab.text = kLang(@"resources");
//    _walletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[currentWalletM.address substringToIndex:8],[currentWalletM.address substringWithRange:NSMakeRange(currentWalletM.address.length - 8, 8)]];
    _walletAddressLab.text = currentWalletM.account_name;
//    [self refreshPriceTotal:@"0"];
    _eosResourcesHeight.constant = 53;
    _walletIcon.image = [UIImage imageNamed:@"eos_wallet"];
    
    [_sourceArr removeAllObjects];
    [_sourceArr addObjectsFromArray:tokenList];
    [_mainTable reloadData];
    
    [_tokenSymbolArr removeAllObjects];
    kWeakSelf(self);
    [tokenList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EOSSymbolModel *model = obj;
        [weakself.tokenSymbolArr addObject:model.symbol];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself requestTokenPrice];
    });
}

- (void)refreshPriceTotal:(NSString *)total {
    _walletBalanceLab.text = [NSString stringWithFormat:@"%@ %@",[ConfigUtil getLocalUsingCurrencySymbol],[total showfloatStr:2]];
}

- (void)refreshPrice {
    __block NSString *totalPrice = @"";
    __block NSString *walletBalance = @"0";
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeETH) {
        __block NSString *totalPriceStr = @"0";
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isKindOfClass:[Token class]]) {
                *stop = YES;
            } else {
                Token *token = obj;
//                totalPriceNum = @([totalPriceNum doubleValue]+[[token getPrice:_tokenPriceArr] doubleValue]);
                totalPriceStr = totalPriceStr.add([token getPrice:_tokenPriceArr]);
            }
        }];
//        totalPrice = [[NSString stringWithFormat:@"%@",totalPriceNum] removeFloatAllZero];
        totalPrice = totalPriceStr;
        
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isKindOfClass:[Token class]]) {
                *stop = YES;
            } else {
                Token *token = obj;
//                if ([token.tokenInfo.symbol isEqualToString:@"ETH"]) {
                NSString *assetPrice = [token getPrice:_tokenPriceArr];
                    walletBalance = walletBalance.add(assetPrice);
//                    *stop = YES;
//                }
            }
        }];
    } else if (currentWalletM.walletType == WalletTypeEOS) {
        __block NSString *totalPriceStr = @"0";
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isKindOfClass:[EOSSymbolModel class]]) {
                *stop = YES;
            } else {
                EOSSymbolModel *model = obj;
//                totalPriceNum = @([totalPriceNum doubleValue]+[[model getPrice:_tokenPriceArr] doubleValue]);
                totalPriceStr = totalPriceStr.add([model getPrice:_tokenPriceArr]);
            }
        }];
//        totalPrice = [[NSString stringWithFormat:@"%@",totalPriceNum] removeFloatAllZero];
        totalPrice = totalPriceStr;
        
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isKindOfClass:[EOSSymbolModel class]]) {
                *stop = YES;
            } else {
                EOSSymbolModel *model = obj;
//                if ([model.symbol isEqualToString:@"EOS"]) {
                NSString *assetPrice = [model getPrice:_tokenPriceArr];
                    walletBalance = walletBalance.add(assetPrice);
//                    *stop = YES;
//                }
            }
        }];
    } else if (currentWalletM.walletType == WalletTypeNEO) {
        __block NSString *totalPriceStr = @"0";
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isKindOfClass:[NEOAssetModel class]]) {
                *stop = YES;
            } else {
                NEOAssetModel *asset = obj;
//                totalPriceNum = @([totalPriceNum doubleValue]+[[asset getPrice:_tokenPriceArr] doubleValue]);
                totalPriceStr = totalPriceStr.add([asset getPrice:_tokenPriceArr]);
            }
        }];
//        totalPrice = [[NSString stringWithFormat:@"%@",totalPriceNum] removeFloatAllZero];
        totalPrice = totalPriceStr;
        
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isKindOfClass:[NEOAssetModel class]]) {
                *stop = YES;
            } else {
                NEOAssetModel *asset = obj;
//                if ([asset.asset_symbol isEqualToString:@"NEO"]) {
                NSString *assetPrice = [asset getPrice:_tokenPriceArr];
                    walletBalance = walletBalance.add(assetPrice);
//                    *stop = YES;
//                }
            }
        }];
    } else if (currentWalletM.walletType == WalletTypeQLC) {
        __block NSString *totalPriceStr = @"0";
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isKindOfClass:[QLCTokenModel class]]) {
                *stop = YES;
            } else {
                QLCTokenModel *asset = obj;
//                totalPriceNum = @([totalPriceNum doubleValue]+[[asset getPrice:_tokenPriceArr] doubleValue]);
                totalPriceStr = totalPriceStr.add([asset getPrice:_tokenPriceArr]);
            }
        }];
//        totalPrice = [[NSString stringWithFormat:@"%@",totalPriceNum] removeFloatAllZero];
        totalPrice = totalPriceStr;
        
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isKindOfClass:[QLCTokenModel class]]) {
                *stop = YES;
            } else {
                QLCTokenModel *asset = obj;
//                if ([asset.tokenName isEqualToString:@"QLC"]) {
                NSString *assetPrice = [asset getPrice:_tokenPriceArr];
                    walletBalance = walletBalance.add(assetPrice);
//                    *stop = YES;
//                }
            }
        }];
    }
    
//    _totalLab.text = [NSString stringWithFormat:@"%@ %@",[ConfigUtil getLocalUsingCurrencySymbol],totalPrice];
//    _walletBalanceLab.text = [NSString stringWithFormat:@"%@ %@",[ConfigUtil getLocalUsingCurrencySymbol],walletBalance];
    [self refreshPriceTotal:walletBalance];
    
    [self showContentView];
    [_mainTable reloadData];
}

//- (void)refreshWGas:(BalanceInfo *)model {
//    NSString *winqGas = model?[model getWinqGas]:@"0.00";
//    _winqgasLab.text = winqGas;
//}

- (void)neoGasStatusInit {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeNEO) {
        _gasBackHeight.constant = 0;
//        _gasBackHeight.constant = 71;
        [NEOGasClaimUtil shareInstance].claimStatus = NEOGasClaimStatusNone; // 初始化
    }
}

- (void)refreshClaimGas:(NSString *)amount {
    NEOGasClaimStatus status = [NEOGasClaimUtil shareInstance].claimStatus;
    _claimStatusIcon.hidden = YES;
    if (status == NEOGasClaimStatusNone) {
        _claimLab.text = @"Claim";
        _claimLab.hidden = NO;
        _claimgasLab.text = amount?:@"0";
//    } else if (status == NEOGasClaimStatusSync) {
//        _claimLab.text = @"Sync";
//        _claimLab.hidden = NO;
//        _claimgasLab.text = amount?:@"0";
//    } else if (status == NEOGasClaimStatusSyncLoading) {
//        _claimLab.hidden = YES;
//        _claimgasLab.text = amount?:@"0";
    } else if (status == NEOGasClaimStatusClaim) {
        _claimLab.text = @"Claim";
        _claimLab.hidden = NO;
        _claimgasLab.text = amount?:@"0";
    } else if (status == NEOGasClaimStatusClaimLoading) {
        _claimLab.text = @"Claim";
        _claimLab.hidden = NO;
        _claimgasLab.text = amount?:@"0";
    } else if (status == NEOGasClaimStatusClaimSuccess) {
        _claimLab.hidden = YES;
        _claimgasLab.text = amount?:@"0";
        _claimStatusIcon.hidden = NO;
        _claimStatusIcon.image = [UIImage imageNamed:@"icon_success_orange"];
        kWeakSelf(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakself.gasBackHeight.constant = 0;
        });
    } else if (status == NEOGasClaimStatusClaimFail) {
        _claimLab.text = @"Claim";
        _claimLab.hidden = NO;
    }
}

- (void)neoClaimGasActionWithShowLoad:(BOOL)showLoad {
    kWeakSelf(self);
    if (showLoad) {
        [kAppD.window makeToastInView:kAppD.window];
    }
    
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    NSString *privateKey = [NEOWalletInfo getNEOPrivateKeyWithAddress:currentWalletM.address]?:@"";
    NSString *wif = [NEOWalletInfo getNEOEncryptedKeyWithAddress:currentWalletM.address]?:@"";
    [NEOJSUtil addNEOJSView];
    [NEOJSUtil claimgasWithPrivateKey:privateKey resultHandler:^(id  _Nullable result, BOOL success, NSString * _Nullable message) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        NEOGasClaimStatus status = [NEOGasClaimUtil shareInstance].claimStatus;
        if (success) {
            if (status == NEOGasClaimStatusClaimLoading) {
                [NEOGasClaimUtil shareInstance].claimStatus = NEOGasClaimStatusClaimSuccess;
                [weakself refreshClaimGas:nil];
            }
//                    [weakself requestGetNeoCliamGas];
            [kAppD.window makeToastDisappearWithText:kLang(@"claimed_successfully")];
        } else {
            [NEOGasClaimUtil shareInstance].claimStatus = NEOGasClaimStatusClaimFail;
            [weakself refreshClaimGas:nil];
            [kAppD.window makeToastDisappearWithText:kLang(@"claimed_failed")];
        }
        
        [NEOJSUtil removeNEOJSView];
    }];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [NEOGasUtil.sharedInstance neoClaimGas:^(BOOL success) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (showLoad) {
//                    [kAppD.window hideToast];
//                }
//                NEOGasClaimStatus status = [NEOGasClaimUtil shareInstance].claimStatus;
//                if (success) {
//                    if (status == NEOGasClaimStatusClaimLoading) {
//                        [NEOGasClaimUtil shareInstance].claimStatus = NEOGasClaimStatusClaimSuccess;
//                        [weakself refreshClaimGas:nil];
//                    }
////                    [weakself requestGetNeoCliamGas];
//                    [kAppD.window makeToastDisappearWithText:kLang(@"claimed_successfully")];
//                } else {
//                    [NEOGasClaimUtil shareInstance].claimStatus = NEOGasClaimStatusClaimFail;
//                    [weakself refreshClaimGas:nil];
//                    [kAppD.window makeToastDisappearWithText:kLang(@"claimed_failed")];
//                }
//            });
//        }];
//    });
}

- (void)showNeoClaimGasTip:(NSString *)amount {
    NeoClaimGasTipView *tipV = [NeoClaimGasTipView getInstance];
    kWeakSelf(self);
    tipV.claimBlock = ^{
        [weakself neoClaimGasActionWithShowLoad:NO];
    };
    tipV.closeBlock = ^{
        [NEOGasClaimUtil shareInstance].claimStatus = NEOGasClaimStatusClaim;
    };
    [tipV showWithNum:amount];
}

- (void)showNeoQueryWGas:(NeoQueryWGasModel *)model {
    NeoQueryWGasView *tipV = [NeoQueryWGasView getInstance];
    kWeakSelf(self);
    tipV.okBlock = ^{
        [weakself requestNeoGotWGasWithShowLoad:NO];
    };
    [tipV showWithNum:[model getNum]];
}

- (void)showNeoGotWGas:(NeoGotWGasModel *)model {
    [kAppD.window makeToastDisappearWithText:model.tips];
}

#pragma mark-- update ui
- (void) updateStakingUI
{
     WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeQLC) {
        
        _stakingHeight.constant = 53;
        _myStakingsLab.text = @"My Stakings";
        
    } else if (currentWalletM.walletType == WalletTypeETH) {
        
        //_stakingHeight.constant = 53;
        //_myStakingsLab.text = kLang(@"QLC_Cross-chain_Swap");
        
    } else if (currentWalletM.walletType == WalletTypeNEO) {
        
        //_stakingHeight.constant = 53;
        //_myStakingsLab.text = kLang(@"QLC_Cross-chain_Swap");
        
    }
}

- (void)handlerWithETH {
    ETHAddressInfoModel *infoM = [[TMCache sharedCache] objectForKey:TM_Wallet_Source]?:nil;
    if (!infoM || ![infoM isKindOfClass:[ETHAddressInfoModel class]]) {
        return;
    }
    [self updateStakingUI];
    self.ethAddressInfoM = infoM;
    [self updateWalletWithETH:_ethAddressInfoM];
    [self refreshDataWithETH];
}

- (void)handlerWithAccountName:(NSString *)accountName {
    EOSAddressInfoModel *infoM = [[TMCache sharedCache] objectForKey:TM_Wallet_Source]?:nil;
    if (!infoM || ![infoM isKindOfClass:[EOSAddressInfoModel class]]) {
        return;
    }
//    __block NSNumber *eosBalance = @(0);
//    [infoM.symbol_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        EOSSymbolModel *model = obj;
//        if ([model.symbol isEqualToString:@"EOS"]) { // 赋值EOS余额
//            eosBalance = model.balance;
//        }
//    }];
//    [self updateWalletWithEosBalance:eosBalance accountName:accountName];
    [self refreshDataWithEOS:infoM.symbol_list];
}

- (void)handlerWithNEO {
    NEOAddressInfoModel *infoM = [[TMCache sharedCache] objectForKey:TM_Wallet_Source]?:nil;
    if (!infoM || ![infoM isKindOfClass:[NEOAddressInfoModel class]]) {
        return;
    }
    
    [self updateStakingUI];
    
    self.neoAddressInfoM = infoM;
    
    [self requestGetNeoCliamGas]; // 请求neocliamgas
    
    __block NSNumber *amount = @(0);
    [self.neoAddressInfoM.balance enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOAssetModel *model = obj;
        if ([model.asset_symbol isEqualToString:@"NEO"]) { // 赋值NEO余额
            amount = model.amount;
        }
    }];
    self.neoAddressInfoM.amount = amount;
//    [self updateWalletWithNEO:self.neoAddressInfoM];
    [self refreshDataWithNEO];
}

- (void)handlerWithQLC {
    QLCAddressInfoModel *infoM = [[TMCache sharedCache] objectForKey:TM_Wallet_Source]?:nil;
    if (!infoM || ![infoM isKindOfClass:[QLCAddressInfoModel class]]) {
        return;
    }
    
    self.qlcAddressInfoM = infoM;
    
//    [self updateWalletWithQLC:self.qlcAddressInfoM];
    [self refreshDataWithQLC];
}

// 接收qlc钱包pending
- (void)startReceiveQLC {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeQLC) {
//        BOOL isMainNetwork = [ConfigUtil isMainNetOfChainNetwork];
        NSString *baseUrl = [ConfigUtil get_qlc_node_normal];
        NSString *privateKey = [QLCWalletInfo getQLCPrivateKeyWithAddress:currentWalletM.address]?:@"";
        [[QLCWalletManage shareInstance] receive_accountsPending:currentWalletM.address baseUrl:baseUrl privateKey:privateKey toastView:[UIApplication sharedApplication].keyWindow]; // QLC钱包接收sendblock
    }
}

- (NEOAssetModel *)getNEOAsset:(NSString *)tokenName {
    __block NEOAssetModel *asset = nil;
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeNEO) {
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NEOAssetModel class]]) {
                NEOAssetModel *temp = obj;
                if ([temp.asset_symbol isEqualToString:tokenName]) {
                    asset = temp;
                    *stop = YES;
                }
            }
        }];
    }
    return asset;
}

- (QLCTokenModel *)getQLCAsset:(NSString *)tokenName {
    __block QLCTokenModel *asset = nil;
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeQLC) {
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[QLCTokenModel class]]) {
                QLCTokenModel *temp = obj;
                if ([temp.tokenName isEqualToString:tokenName]) {
                    asset = temp;
                    *stop = YES;
                }
            }
        }];
    }
    return asset;
}

- (Token *)getETHAsset:(NSString *)tokenName {
    __block Token *asset = nil;
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeETH) {
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[Token class]]) {
                Token *temp = obj;
                if ([temp.tokenInfo.symbol isEqualToString:tokenName]) {
                    asset = temp;
                    *stop = YES;
                }
            }
        }];
    }
    return asset;
}

- (QLCTokenModel *)getQLCAsset {
    __block QLCTokenModel *gasAsset = nil;
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeQLC) {
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[QLCTokenModel class]]) {
                QLCTokenModel *temp = obj;
                if ([temp.tokenName isEqualToString:@"QLC"]) {
                    gasAsset = temp;
                    *stop = YES;
                }
            }
        }];
    }
    return gasAsset;
}

//- (NEOAssetModel *)getQLCAssetOfNeo {
//    __block NEOAssetModel *asset = nil;
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    if (currentWalletM.walletType == WalletTypeNEO) {
//        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([obj isKindOfClass:[NEOAssetModel class]]) {
//                NEOAssetModel *temp = obj;
//                if ([temp.asset_symbol isEqualToString:@"QLC"]) {
//                    asset = temp;
//                    *stop = YES;
//                }
//            }
//        }];
//    }
//    return asset;
//}

- (NEOAssetModel *)getNEOAsset {
    __block NEOAssetModel *asset = nil;
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeNEO) {
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NEOAssetModel class]]) {
                NEOAssetModel *temp = obj;
                if ([temp.asset_symbol isEqualToString:@"NEO"]) {
                    asset = temp;
                    *stop = YES;
                }
            }
        }];
    }
    return asset;
}

- (Token *)getETHAsset {
    __block Token *asset = nil;
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeETH) {
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Token *temp = obj;
            if ([temp.tokenInfo.symbol isEqualToString:@"ETH"]) {
                asset = temp;
                *stop = YES;
            }
        }];
    }
    return asset;
}

- (NSArray *)getETHSource {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeETH) {
        return _sourceArr;
    } else {
        return @[];
    }
}

- (NSArray *)getEOSSource {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeEOS) {
        return _sourceArr;
    } else {
        return @[];
    }
}

- (NSArray *)getNEOSource {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeNEO) {
        return _sourceArr;
    } else {
        return @[];
    }
}

- (NSArray *)getQLCSource {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeQLC) {
        return _sourceArr;
    } else {
        return @[];
    }
}

- (NSNumber *)getGasAssetBalanceOfNeo {
    __block NSNumber *balance = @(0);
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeNEO) {
        if (_neoAddressInfoM) {
            [_neoAddressInfoM.balance enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NEOAssetModel *model = obj;
                if ([model.asset_symbol isEqualToString:@"GAS"]) {
                    balance = model.amount;
                    *stop = YES;
                }
            }];
        }
    }
    return balance;
}

- (void)refreshTitle {
    _titleLab.text = kLang(@"wallet");
}

- (void)refreshLanguage {
    _myStakingsLab.text = kLang(@"my_stakings");
}

- (void)refreshBackupView {
    _backupBackHeight.constant = 0;
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (!currentWalletM) {
        return;
    }
    
    _backupTitleLab.text = kLang(@"security_reminders");
    _backupTip1Lab.text = kLang(@"please_back_up_your_private_key_mnemonic_phrase_now_");
    _backupTip2Lab.text = kLang(@"if_your_lose_your_mobile_devices_you_could_use_your_private_key_or_mnemonic_phrase_to_recover_your_wallet_");
    [_backupBtn setTitle:kLang(@"backup_now") forState:UIControlStateNormal];
    
    NSString *language = [Language currentLanguageCode];
    if (currentWalletM.walletType == WalletTypeETH) {
        ETHWalletInfo *walletInfo = [ETHWalletInfo getWalletInKeychain:currentWalletM.address?:@""];
        if (walletInfo.mnemonicArr && walletInfo.isBackup && [walletInfo.isBackup boolValue] == NO) { // 字段存在且未备份且有助记词
            if ([language isEqualToString:LanguageCode[0]]) { // 英文
                _backupBackHeight.constant = 220;
            } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
                _backupBackHeight.constant = 180;
            } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
                _backupBackHeight.constant = 220;
            }
        }
    } else if (currentWalletM.walletType == WalletTypeNEO) {
        NEOWalletInfo *walletInfo = [NEOWalletInfo getNEOWalletWithAddress:currentWalletM.address?:@""];
        if (walletInfo.isBackup && [walletInfo.isBackup boolValue] == NO) { // 字段存在且未备份
            if ([language isEqualToString:LanguageCode[0]]) { // 英文
                _backupBackHeight.constant = 220;
            } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
                _backupBackHeight.constant = 180;
            } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
                _backupBackHeight.constant = 220;
            }
        }
    } else if (currentWalletM.walletType == WalletTypeEOS) {
        
    } else if (currentWalletM.walletType == WalletTypeQLC) {
        QLCWalletInfo *walletInfo = [QLCWalletInfo getQLCWalletWithAddress:currentWalletM.address?:@""];
        if (walletInfo.isBackup && [walletInfo.isBackup boolValue] == NO) { // 字段存在且未备份
            if ([language isEqualToString:LanguageCode[0]]) { // 英文
                _backupBackHeight.constant = 220;
            } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
                _backupBackHeight.constant = 180;
            } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
                _backupBackHeight.constant = 220;
            }
        }
    }
}

#pragma mark - Request
- (void)requestTokenList {
    _gasBackHeight.constant = 0;
    _eosResourcesHeight.constant = 0;
    _stakingHeight.constant = 0;
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    DDLogDebug(@"refreshTokenList:%@",@(currentWalletM.walletType));
    kWeakSelf(self);
    switch (currentWalletM.walletType) {
        case WalletTypeETH:
        {
            [TokenListHelper requestETHAddressInfo:currentWalletM.address?:@"" showLoad:NO completeBlock:^(ETHAddressInfoModel *infoM, BOOL success) {
                [weakself endRefresh];
                if (success) {
                    [[TMCache sharedCache] setObject:infoM forKey:TM_Wallet_Source];
                    [weakself handlerWithETH];
                }
            }];
        }
            break;
        case WalletTypeEOS:
        {
            NSString *accountName = currentWalletM.account_name?:@"";
            [TokenListHelper requestEOSTokenList:accountName showLoad:NO completeBlock:^(EOSAddressInfoModel *infoM, BOOL success) {
                [weakself endRefresh];
                if (success) {
                    [[TMCache sharedCache] setObject:infoM forKey:TM_Wallet_Source];
                    [weakself handlerWithAccountName:accountName];
                }
            }];
        }
            break;
        case WalletTypeNEO:
        {
            [TokenListHelper requestNEOAddressInfo:currentWalletM.address?:@"" showLoad:NO completeBlock:^(NEOAddressInfoModel *infoM, BOOL success) {
                [weakself endRefresh];
                if (success) {
                    [[TMCache sharedCache] setObject:infoM forKey:TM_Wallet_Source];
                    [weakself handlerWithNEO];
                }
            }];
        }
            break;
        case WalletTypeQLC:
        {
            [TokenListHelper requestQLCAddressInfo:currentWalletM.address?:@"" showLoad:NO completeBlock:^(QLCAddressInfoModel *infoM, BOOL success) {
                [weakself endRefresh];
                if (success) {
                    [[TMCache sharedCache] setObject:infoM forKey:TM_Wallet_Source];
                    [weakself handlerWithQLC];
                }
            }];
        }
            break;
            
        default:
            break;
    }
}



- (void)requestGetNeoCliamGas {
    
    // 刷新neo claimgas
    kWeakSelf(self);
    if (![NEOWalletManage.sharedInstance haveDefaultWallet]) {
        return;
    }
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    NSDictionary *params = @{@"address" : currentWalletM.address};
//    RequestService.request(withUrl5: "/api/neo/getClaims.json", params: dict, httpMethod: HttpMethodPost, successBlock:
    [RequestService requestWithUrl10:neoGetClaims_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeRelease successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//    [RequestService requestWithUrl5:neoGetClaims_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            
            NEOGasClaimModel *model = [NEOGasClaimModel getObjectWithKeyValues:responseObject[Server_Data]];
            if ([model.unclaimed_str doubleValue] > 0) {
                NEOGasClaimStatus status = [NEOGasClaimUtil shareInstance].claimStatus;
                if (status == NEOGasClaimStatusNone) {
                    _gasBackHeight.constant = 71;
                    [NEOGasClaimUtil shareInstance].claimStatus = NEOGasClaimStatusClaim;
                }
            } else {
                _gasBackHeight.constant = 0;
//                _gasBackHeight.constant = 71;
                [NEOGasClaimUtil shareInstance].claimStatus = NEOGasClaimStatusNone;
            }
            [weakself refreshClaimGas:model.unclaimed_str];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
//    [NEOGasUtil.sharedInstance loadClaimableGAS:^(NSString * amount) {
//
//    }];
}

//- (void)requestETHAddressInfo:(NSString *)address showLoad:(BOOL)showLoad {
//    // 检查地址有效性
//    BOOL isValid = [TrustWalletManage.sharedInstance isValidAddressWithAddress:address];
//    if (!isValid) {
//        return;
//    }
//    kWeakSelf(self);
//    NSDictionary *params = @{@"address":address,@"token":@""}; // @"0x980e7917c610e2c2d4e669c920980cb1b915bbc7"
//    if (showLoad) {
//        [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:0];
//    }
//    [RequestService requestWithUrl5:ethAddressInfo_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        [weakself endRefresh];
//        if (showLoad) {
//            [kAppD.window hideToast];
//        }
//        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
//            NSDictionary *dic = [responseObject objectForKey:Server_Data];
//            weakself.ethAddressInfoM = [ETHAddressInfoModel getObjectWithKeyValues:dic];
////            weakSelf.ethAddressInfoM.name = name;
//            [weakself updateWalletWithETH:weakself.ethAddressInfoM];
//            [weakself refreshDataWithETH];
//
//            [[NSNotificationCenter defaultCenter] postNotificationName:Update_ETH_Wallet_Token_Noti object:nil];
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        [weakself endRefresh];
//        if (showLoad) {
//            [kAppD.window hideToast];
//        }
//    }];
//}

//- (void)requestNEOAddressInfo:(NSString *)address showLoad:(BOOL)showLoad {
//    // 检查地址有效性
//    BOOL validateNEOAddress = [NEOWalletManage.sharedInstance validateNEOAddressWithAddress:address];
//    if (!validateNEOAddress) {
//        return;
//    }
//    kWeakSelf(self);
//    NSDictionary *params = @{@"address":address};
//    if (showLoad) {
//        [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:0];
//    }
//    [RequestService requestWithUrl10:neoAddressInfo_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeRelease successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        [weakself endRefresh];
//        if (showLoad) {
//            [kAppD.window hideToast];
//        }
//        [weakself requestGetNeoCliamGas]; // 请求neocliamgas
//
//        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
//            NSDictionary *dic = [responseObject objectForKey:Server_Data];
//            weakself.neoAddressInfoM = [NEOAddressInfoModel getObjectWithKeyValues:dic];
//            __block NSNumber *amount = @(0);
//            [weakself.neoAddressInfoM.balance enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                NEOAssetModel *model = obj;
//                if ([model.asset_symbol isEqualToString:@"NEO"]) { // 赋值NEO余额
//                    amount = model.amount;
//                }
//            }];
//            weakself.neoAddressInfoM.amount = amount;
//            [weakself updateWalletWithNEO:weakself.neoAddressInfoM];
//            [weakself refreshDataWithNEO];
//
//            [[NSNotificationCenter defaultCenter] postNotificationName:Update_NEO_Wallet_Token_Noti object:nil];
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        [weakself endRefresh];
//        if (showLoad) {
//            [kAppD.window hideToast];
//        }
//    }];
//}

//- (void)requestEOSTokenList:(NSString *)account_name showLoad:(BOOL)showLoad {
//    // 检查地址有效性
//    BOOL validateEOSAccountName = [RegularExpression validateEosAccountName:account_name];
//    if (!validateEOSAccountName) {
//        return;
//    }
//    kWeakSelf(self);
//    NSDictionary *params = @{@"account":account_name, @"symbol":@""};
//    if (showLoad) {
//        [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:0];
//    }
//    [RequestService requestWithUrl5:eosGet_token_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        [weakself endRefresh];
//        if (showLoad) {
//            [kAppD.window hideToast];
//        }
//
//        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
//            NSDictionary *dic = responseObject[Server_Data][Server_Data];
//            NSArray *symbol_list = dic[@"symbol_list"];
//            __block NSNumber *eosBalance = @(0);
//            NSMutableArray *symbolListArr = [NSMutableArray array];
//            [symbol_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                EOSSymbolModel *model = [EOSSymbolModel getObjectWithKeyValues:obj];
//                [symbolListArr addObject:model];
//                if ([model.symbol isEqualToString:@"EOS"]) { // 赋值EOS余额
//                    eosBalance = model.balance;
//                }
//            }];
//            [weakself updateWalletWithEosBalance:eosBalance accountName:account_name];
//            [weakself refreshDataWithEOS:symbolListArr];
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        [weakself endRefresh];
//        if (showLoad) {
//            [kAppD.window hideToast];
//        }
//    }];
//}

//- (void)requestQLCAddressInfo:(NSString *)address showLoad:(BOOL)showLoad {
//    // 检查地址有效性
//    BOOL validateQLCAddress = [QLCWalletManage.shareInstance walletAddressIsValid:address];
//    if (!validateQLCAddress) {
//        return;
//    }
//    kWeakSelf(self);
//    if (showLoad) {
//        [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:0];
//    }
////    NSString *address1 = @"qlc_3wpp343n1kfsd4r6zyhz3byx4x74hi98r6f1es4dw5xkyq8qdxcxodia4zbb";
//    BOOL isMainNetwork = [ConfigUtil isMainNetOfChainNetwork];
//    [QLCLedgerRpc accountInfoWithAddress:address isMainNetwork:isMainNetwork successHandler:^(NSDictionary<NSString * ,id> * _Nonnull responseObject) {
//        [weakself endRefresh];
//        if (showLoad) {
//            [kAppD.window hideToast];
//        }
//
//        if (responseObject != nil) {
//            weakself.qlcAddressInfoM = [QLCAddressInfoModel getObjectWithKeyValues:responseObject];
//            [weakself requestQLCTokensWithShowLoad:NO]; // 请求tokens
////            [weakself updateWalletWithQLC:weakself.qlcAddressInfoM];
////            [weakself refreshDataWithQLC];
//        }
//
//    } failureHandler:^(NSError * _Nullable error, NSString * _Nullable message) {
//        [weakself endRefresh];
//        if (showLoad) {
//            [kAppD.window hideToast];
//        }
//        if ([message isEqualToString:@"account not found"]) { // 找不到账户做特殊处理（先显示出来）
//            weakself.qlcAddressInfoM = [QLCAddressInfoModel new];
//            weakself.qlcAddressInfoM.account = address;
//            weakself.qlcAddressInfoM.coinBalance = @(0);
//            [weakself requestQLCTokensWithShowLoad:NO]; // 请求tokens
//        } else {
//            [kAppD.window makeToastDisappearWithText:message];
//        }
//    }];
//}
//
//- (void)requestQLCTokensWithShowLoad:(BOOL)showLoad {
//    kWeakSelf(self);
//    if (showLoad) {
//        [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:0];
//    }
//    BOOL isMainNetwork = [ConfigUtil isMainNetOfChainNetwork];
//    [QLCLedgerRpc tokensWithIsMainNetwork:isMainNetwork successHandler:^(id _Nullable responseObject) {
//        if (showLoad) {
//            [kAppD.window hideToast];
//        }
//
//        if (responseObject != nil) {
//            NSArray *tokenArr = [QLCTokenInfoModel mj_objectArrayWithKeyValuesArray:responseObject];
//            [weakself.qlcAddressInfoM.tokens enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                QLCTokenModel *tokenM = obj;
//                [tokenArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    QLCTokenInfoModel *tokenInfoM = obj;
//                    if ([tokenM.tokenName isEqualToString:tokenInfoM.tokenName]) {
//                        tokenM.tokenInfoM = tokenInfoM;
//                        *stop = YES;
//                    }
//                }];
//            }];
//            [weakself updateWalletWithQLC:weakself.qlcAddressInfoM];
//            [weakself refreshDataWithQLC];
//
//            [[NSNotificationCenter defaultCenter] postNotificationName:Update_QLC_Wallet_Token_Noti object:nil];
//        }
//
//    } failureHandler:^(NSError * _Nullable error, NSString * _Nullable message) {
//        if (showLoad) {
//            [kAppD.window hideToast];
//        }
//        [kAppD.window makeToastDisappearWithText:message];
//    }];
//}

- (void)requestTokenPrice {
    if (_tokenSymbolArr.count <= 0) {
        [self refreshPriceTotal:@"0"];
        return;
    }
    kWeakSelf(self);
    NSString *coin = [ConfigUtil getLocalUsingCurrency]?:@"";
    NSDictionary *params = @{@"symbols":_tokenSymbolArr,@"coin":coin};
    [RequestService requestWithUrl5:tokenPrice_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            [weakself.tokenPriceArr removeAllObjects];
            NSArray *arr = responseObject[Server_Data];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TokenPriceModel *model = [TokenPriceModel getObjectWithKeyValues:obj];
                model.coin = coin;
                [weakself.tokenPriceArr addObject:model];
            }];
            [weakself refreshPrice];
        } else {
            [weakself refreshPriceTotal:@"0"];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself refreshPriceTotal:@"0"];
    }];
}

- (void)requestNeoGotWGasWithShowLoad:(BOOL)showLoad {
    kWeakSelf(self);
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    NSString *address = currentWalletM.address?:@"";
    
    BOOL haveDefaultNEOWallet = [NEOWalletManage.sharedInstance haveDefaultWallet];
    if (!haveDefaultNEOWallet) {
        return;
    }
    NSString *address = [NEOWalletManage.sharedInstance getWalletAddress];
    
    NSString *myP2pId = [UserModel getOwnP2PId];
    NSDictionary *params = @{@"p2pId":myP2pId,@"address":address};
    if (showLoad) {
        [kAppD.window makeToastInView:kAppD.window];
    }
    [RequestService requestWithUrl10:neoGotWGas_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeRelease successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = [responseObject objectForKey:Server_Data];
            NeoGotWGasModel *model = [NeoGotWGasModel getObjectWithKeyValues:dic];
            [weakself showNeoGotWGas:model];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
    }];
}

- (void)requestNeoQueryWGasWithShowLoad:(BOOL)showLoad {
    kWeakSelf(self);
    NSString *myP2pId = [UserModel getOwnP2PId];
    NSDictionary *params = @{@"p2pId":myP2pId};
    if (showLoad) {
        [kAppD.window makeToastInView:kAppD.window];
    }
    [RequestService requestWithUrl10:neoQueryWGas_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeRelease successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = [responseObject objectForKey:Server_Data];
            NeoQueryWGasModel *model = [NeoQueryWGasModel getObjectWithKeyValues:dic];
            [weakself showNeoQueryWGas:model];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
    }];
}

// // 刷新winqgas
//- (void)requestGetTokenBalance {
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    if (currentWalletM.walletType != WalletTypeNEO) {
//        return;
//    }
//    NSString *address = currentWalletM.address?:@"";
//    NSDictionary *params = @{@"address":address};
//    kWeakSelf(self);
//    [RequestService requestWithUrl:getTokenBalance_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
//            NSDictionary *dataDic = [responseObject objectForKey:Server_Data];
//            BalanceInfo *balanceInfo = [BalanceInfo mj_objectWithKeyValues:dataDic];
//            [weakself refreshWGas:balanceInfo];
//        } else {
//            [weakself refreshWGas:nil];
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        [weakself refreshWGas:nil];
//    }];
//}

//- (void)requestNeoGetClaims {
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    NSString *address = currentWalletM.address;
//    NSDictionary *params = @{@"address":address};
//    kWeakSelf(self);
//    [RequestService requestWithUrl:neoGetClaims_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
//            NSDictionary *dataDic = [responseObject objectForKey:Server_Data];
//            BalanceInfo *balanceInfo = [BalanceInfo mj_objectWithKeyValues:dataDic];
//            [weakself refreshWGas:balanceInfo];
//        } else {
//            [weakself refreshWGas:nil];
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        [self refreshWGas:nil];
//    }];
//}

#pragma mark - Action
- (IBAction)scanAction:(id)sender {
//    WebTestViewController *vc1 = [WebTestViewController new];
//    [self.navigationController pushViewController:vc1 animated:YES];
//    return;
    
    kWeakSelf(self);
    WalletQRViewController *vc = [[WalletQRViewController alloc] initWithCodeQRCompleteBlock:^(NSString *codeValue) {
        WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
        if (currentWalletM.walletType == WalletTypeETH) {
            BOOL isValid = [TrustWalletManage.sharedInstance isValidAddressWithAddress:codeValue];
            if (!isValid) {
                [kAppD.window makeToastDisappearWithText:kLang(@"please_provide_a_valid_qrcode_of_eth")];
                return;
            }
            [weakself jumpToETHTransfer:codeValue];
        } else if (currentWalletM.walletType == WalletTypeNEO) {
            BOOL validateNEOAddress = [NEOWalletManage.sharedInstance validateNEOAddressWithAddress:codeValue];
            if (!validateNEOAddress) {
                [kAppD.window makeToastDisappearWithText:kLang(@"please_provide_a_valid_qrcode_of_neo")];
                return;
            }
            [weakself jumpToNEOTransfer:codeValue];
        } else if (currentWalletM.walletType == WalletTypeEOS) {
            BOOL validateEOSAccountName = [RegularExpression validateEosAccountName:codeValue];
            if (!validateEOSAccountName) {
                NSDictionary *qrDic = codeValue.mj_JSONObject;
                NSString *accountName = qrDic[@"accountName"];
                NSString *activePublicKey = qrDic[@"activePublicKey"];
                NSString *ownerPublicKey = qrDic[@"ownerPublicKey"];
                if (accountName != nil && activePublicKey != nil && ownerPublicKey != nil) {
                    [weakself jumpToEOSActiveAccount:qrDic];
                } else {
                    [kAppD.window makeToastDisappearWithText:kLang(@"please_provide_a_valid_qrcode_of_eos")];
                }
            } else {
                [weakself jumpToEOSTransfer:codeValue];
            }
        } else if (currentWalletM.walletType == WalletTypeQLC) {
            BOOL validateQLCAddress = [QLCWalletManage.shareInstance walletAddressIsValid:codeValue];
            if (!validateQLCAddress) {
                [kAppD.window makeToastDisappearWithText:kLang(@"please_provide_a_valid_qrcode_of_qlc")];
                return;
            }
            [weakself jumpToQLCTransfer:codeValue];
        }
    } needPop:NO];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)addAction:(id)sender {
    [self jumpToChooseWallet:YES];
}

- (IBAction)qrcodeAction:(id)sender {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeETH) {
        [self jumpToETHWalletAddress];
    } else if (currentWalletM.walletType == WalletTypeNEO) {
        [self jumpToNEOWalletAddress];
    } else if (currentWalletM.walletType == WalletTypeEOS) {
        [self jumpToEOSAccountQR];
    } else if (currentWalletM.walletType == WalletTypeQLC) {
        [self jumpToQLCWalletAddress];
    }
}

- (IBAction)walletMoreAction:(id)sender {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeETH) {
        [self jumpToETHWalletDetail];
    } else if (currentWalletM.walletType == WalletTypeNEO) {
        [self jumpToNEOWalletDetail];
    } else if (currentWalletM.walletType == WalletTypeEOS) {
        [self jumpToEOSWalletDetail];
    } else if (currentWalletM.walletType == WalletTypeQLC) {
        [self jumpToQLCWalletDetail];
    }
    
}

- (IBAction)switchWalletAction:(id)sender {
    [self jumpToWalletsSwitch];
}

- (IBAction)copyAction:(id)sender {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (currentWalletM.walletType == WalletTypeEOS) {
        pasteboard.string = currentWalletM.account_name;
    } else {
        pasteboard.string = currentWalletM.address;
    }
    [kAppD.window makeToastDisappearWithText:kLang(@"copied")];
}

- (IBAction)winqGasClaimAction:(id)sender {
    [self requestNeoQueryWGasWithShowLoad:NO];
}

- (IBAction)neoClaimAction:(id)sender {
    NEOGasClaimStatus status = [NEOGasClaimUtil shareInstance].claimStatus;
    if (status == NEOGasClaimStatusNone) {
//        [NEOGasClaimUtil shareInstance].claimStatus = NEOGasClaimStatusSyncLoading;
        [self requestGetNeoCliamGas];
    } else if (status == NEOGasClaimStatusClaim || status == NEOGasClaimStatusClaimFail) {
        [NEOGasClaimUtil shareInstance].claimStatus = NEOGasClaimStatusClaimLoading;
        NSString *gas = _claimgasLab.text?:@"0";
        if ([gas doubleValue] <= 0) {
            [kAppD.window makeToastDisappearInView:kAppD.window text:kLang(@"there_is_no_gas_to_claim")];
            [NEOGasClaimUtil shareInstance].claimStatus = NEOGasClaimStatusClaim;
        } else {
            [self showNeoClaimGasTip:gas];
        }
    }
    
//    NSString *gas = _claimgasLab.text?:@"0";
//    [self showNeoClaimGasTip:gas];
}

- (IBAction)eosResourcesAction:(id)sender {
    [self jumpToEOSResouces];
}

- (IBAction)myStakingsAction:(id)sender {
    [self jumpToMyStakings];
}

- (IBAction)backupAction:(id)sender {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (!currentWalletM) {
        return;
    }
    if (currentWalletM.walletType == WalletTypeETH) {
        ETHWalletInfo *walletInfo = [ETHWalletInfo getWalletInKeychain:currentWalletM.address?:@""];
        [self jumpToCreateETH:walletInfo];
    } else if (currentWalletM.walletType == WalletTypeNEO) {
        NEOWalletInfo *walletInfo = [NEOWalletInfo getNEOWalletWithAddress:currentWalletM.address?:@""];
        [self jumpToNEOBackupDetail:walletInfo];
    } else if (currentWalletM.walletType == WalletTypeEOS) {
        
    } else if (currentWalletM.walletType == WalletTypeQLC) {
        QLCWalletInfo *walletInfo = [QLCWalletInfo getQLCWalletWithAddress:currentWalletM.address?:@""];
        [self jumpToQLCBackupDetail:walletInfo];
    }
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WalletsCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeETH) {
        id obj = _sourceArr[indexPath.row];
        if (![obj isKindOfClass:[Token class]]) {
            return;
        }
        [self jumpToETHTransactionRecord:obj];
    } else if (currentWalletM.walletType == WalletTypeNEO) {
        id obj = _sourceArr[indexPath.row];
        if (![obj isKindOfClass:[NEOAssetModel class]]) {
            return;
        }
        [self jumpToNEOTransactionRecord:obj];
    } else if (currentWalletM.walletType == WalletTypeEOS) {
        id obj = _sourceArr[indexPath.row];
        if (![obj isKindOfClass:[EOSSymbolModel class]]) {
            return;
        }
        [self jumpToEOSTransactionRecord:obj];
    } else if (currentWalletM.walletType == WalletTypeQLC) {
        id obj = _sourceArr[indexPath.row];
        if (![obj isKindOfClass:[QLCTokenModel class]]) {
            return;
        }
        [self jumpToQLCTransactionRecord:obj];
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletsCell *cell = [tableView dequeueReusableCellWithIdentifier:WalletsCellReuse];
    
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeETH) {
        Token *token = _sourceArr[indexPath.row];
        [cell configCellWithToken:token tokenPriceArr:_tokenPriceArr];
    } else if (currentWalletM.walletType == WalletTypeNEO) {
        NEOAssetModel *asset = _sourceArr[indexPath.row];
        [cell configCellWithAsset:asset tokenPriceArr:_tokenPriceArr];
    } else if (currentWalletM.walletType == WalletTypeEOS) {
        EOSSymbolModel *model = _sourceArr[indexPath.row];
        [cell configCellWithSymbol:model tokenPriceArr:_tokenPriceArr];
    } else if (currentWalletM.walletType == WalletTypeQLC) {
        QLCTokenModel *asset = _sourceArr[indexPath.row];
        [cell configCellWithQLCToken:asset tokenPriceArr:_tokenPriceArr];
    }
    
    return cell;
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _refreshScroll) {
        if (_refreshScroll.contentOffset.y < 0) {
            _refreshScroll.theme_backgroundColor = globalBackgroundColorPicker;
        } else if (_refreshScroll.contentOffset.y > _refreshScroll.contentSize.height - [self scrollViewVisibleSize:_refreshScroll].height) {
            _refreshScroll.backgroundColor = MAIN_WHITE_COLOR;
        }
    }
}
    
- (CGSize) scrollViewVisibleSize:(UIScrollView *)scrollView {
    UIEdgeInsets contentInset = scrollView.contentInset;
    CGSize scrollViewSize = CGRectStandardize(scrollView.bounds).size;
    CGFloat width = scrollViewSize.width - contentInset.left - contentInset.right;
    CGFloat height = scrollViewSize.height - contentInset.top - contentInset.bottom;
    return CGSizeMake(width, height);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _refreshScroll) {
//        if (_slimeView) {
//            [_slimeView scrollViewDidEndDraging];
//        }
    }
}

- (void)pullToRefresh {
    
    [self startReceiveQLC];
    
    [self neoGasStatusInit]; // neo gas 状态初始化
    
    [self requestTokenList]; // 请求token列表
    
//    kWeakSelf(self);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
//        [weakself requestGetTokenBalance]; // 刷新winqgas
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
//        [NeoTransferUtil sendGetBalanceRequest]; // 查询当前NEO钱包资产
//    });
}

- (void)endRefresh {
    [_refreshScroll.mj_header endRefreshing];
}

#pragma mark - Transition
- (void)jumpToETHWalletDetail {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.isWatch == YES) {
        return;
    }
    
    ETHWalletDetailViewController *vc = [[ETHWalletDetailViewController alloc] init];
    vc.inputWalletCommonM = [WalletCommonModel getCurrentSelectWallet];
    vc.isDeleteCurrentWallet = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToETHTransactionRecord:(Token *)token {
    ETHTransactionRecordViewController *vc = [[ETHTransactionRecordViewController alloc] init];
    vc.inputToken = token;
    vc.inputSourceArr = _sourceArr;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToChooseWallet:(BOOL)showBack {
    ChooseWalletViewController *vc = [[ChooseWalletViewController alloc] init];
    vc.showBack = showBack;
    vc.hidesBottomBarWhenPushed = NO;
//    AppConfigUtil.shareInstance.hideBottomWhenPush = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToWalletsSwitch {
    WalletsSwitchViewController *vc = [[WalletsSwitchViewController alloc] init];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)jumpToETHWalletAddress {
    ETHWalletAddressViewController *vc = [[ETHWalletAddressViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToNEOWalletDetail {
    NEOWalletDetailViewController *vc = [[NEOWalletDetailViewController alloc] init];
    vc.inputWalletCommonM = [WalletCommonModel getCurrentSelectWallet];
    vc.isDeleteCurrentWallet = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToNEOTransactionRecord:(NEOAssetModel *)asset {
    NEOTransactionRecordViewController *vc = [[NEOTransactionRecordViewController alloc] init];
    vc.inputAsset = asset;
    vc.inputSourceArr = _sourceArr;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToNEOWalletAddress {
    NEOWalletAddressViewController *vc = [[NEOWalletAddressViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToNEOTransfer:(NSString *)address {
    if (_sourceArr.count<=0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"no_wallet_is_available")];
        return;
    }
    id obj = _sourceArr.firstObject;
    if (![obj isKindOfClass:[NEOAssetModel class]]) {
        return;
    }
    NEOTransferViewController *vc = [[NEOTransferViewController alloc] init];
    vc.inputAsset = _sourceArr.firstObject;
    vc.inputSourceArr = _sourceArr;
    vc.inputAddress = address;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToQLCWalletDetail {
    QLCWalletDetailViewController *vc = [[QLCWalletDetailViewController alloc] init];
    vc.inputWalletCommonM = [WalletCommonModel getCurrentSelectWallet];
    vc.isDeleteCurrentWallet = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToQLCTransactionRecord:(QLCTokenModel *)asset {
    QLCTransactionRecordViewController *vc = [[QLCTransactionRecordViewController alloc] init];
    vc.inputAsset = asset;
    vc.inputSourceArr = _sourceArr;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToQLCWalletAddress {
    QLCWalletAddressViewController *vc = [[QLCWalletAddressViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToQLCTransfer:(NSString *)address {
    if (_sourceArr.count<=0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"no_wallet_is_available")];
        return;
    }
    id obj = _sourceArr.firstObject;
    if (![obj isKindOfClass:[QLCTokenModel class]]) {
        return;
    }
    QLCTransferViewController *vc = [[QLCTransferViewController alloc] init];
    vc.inputAsset = _sourceArr.firstObject;
    vc.inputSourceArr = _sourceArr;
    vc.inputAddress = address;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToETHTransfer:(NSString *)address {
    if (_sourceArr.count<=0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"no_assets_can_be_transferred")];
        return;
    }
    id obj = _sourceArr.firstObject;
    if (![obj isKindOfClass:[Token class]]) {
        return;
    }
    ETHTransferViewController *vc = [[ETHTransferViewController alloc] init];
    vc.inputToken = _sourceArr.firstObject;
    vc.inputSourceArr = _sourceArr;
    vc.inputAddress = address;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToEOSTransactionRecord:(EOSSymbolModel *)model {
    EOSTransactionRecordViewController *vc = [[EOSTransactionRecordViewController alloc] init];
    vc.inputSymbol = model;
    vc.inputSourceArr = _sourceArr;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToEOSResouces {
    EOSResourcesViewController *vc = [[EOSResourcesViewController alloc] init];
//    vc.inputTotalAsset = _totalLab.text;
    __block EOSSymbolModel *symbolM = nil;
    [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EOSSymbolModel *tempM = obj;
        if ([tempM.symbol isEqualToString:@"EOS"]) {
            symbolM = tempM;
            *stop = YES;
        }
    }];
    vc.inputSymbolM = symbolM;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToEOSAccountQR {
    EOSAccountQRViewController *vc = [[EOSAccountQRViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToEOSWalletDetail {
    EOSWalletDetailViewController *vc = [[EOSWalletDetailViewController alloc] init];
    vc.inputWalletCommonM = [WalletCommonModel getCurrentSelectWallet];
    vc.isDeleteCurrentWallet = YES;
    __block EOSSymbolModel *symbolM = nil;
    [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EOSSymbolModel *tempM = obj;
        if ([tempM.symbol isEqualToString:@"EOS"]) {
            symbolM = tempM;
            *stop = YES;
        }
    }];
    vc.inputSymbolM = symbolM;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToEOSActiveAccount:(NSDictionary *)qrDic {
    EOSActivateAccountViewController *vc = [[EOSActivateAccountViewController alloc] init];
    vc.qrDic = qrDic;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToEOSTransfer:(NSString *)accountName {
    if (_sourceArr.count<=0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"no_wallet_is_available")];
        return;
    }
    id obj = _sourceArr.firstObject;
    if (![obj isKindOfClass:[EOSSymbolModel class]]) {
        return;
    }
    EOSTransferViewController *vc = [[EOSTransferViewController alloc] init];
    vc.inputSymbol = _sourceArr.firstObject;
    vc.inputSourceArr = _sourceArr;
    vc.inputAccount_name = accountName;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToMyStakings {
    
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeQLC) {
        MyStakingsViewController *vc = [MyStakingsViewController new];
        vc.inputAddress = [WalletCommonModel getCurrentSelectWallet].address?:@"";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (currentWalletM.walletType == WalletTypeNEO) {
        QSwipHmoeViewController *vc = [[QSwipHmoeViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }  else if (currentWalletM.walletType == WalletTypeETH) {
        QSwipHmoeViewController *vc = [[QSwipHmoeViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

- (void)jumpToNEOBackupDetail:(NEOWalletInfo *)walletInfo {
    NEOBackupDetailViewController *vc = [[NEOBackupDetailViewController alloc] init];
    vc.walletInfo = walletInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToQLCBackupDetail:(QLCWalletInfo *)walletInfo {
    QLCBackupDetailViewController *vc = [[QLCBackupDetailViewController alloc] init];
    vc.walletInfo = walletInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToCreateETH:(ETHWalletInfo *)walletInfo {
    ETHMnemonicViewController *vc = [[ETHMnemonicViewController alloc] init];
    vc.walletInfo = walletInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Noti
- (void)walletChange:(NSNotification *)noti {
    [self neoGasStatusInit]; // neo gas 状态初始化
    [self requestTokenList]; // 请求token列表
    
    [self startReceiveQLC]; // 接收qlc链数据
//    kWeakSelf(self);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
//        [weakself requestGetTokenBalance]; // 刷新winqgas
//    });
    [self refreshBackupView]; // 刷新备份view
}

- (void)addETHWallet:(NSNotification *)noti {
    [WalletCommonModel refreshETHWallet];
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (!currentWalletM || currentWalletM.walletType == WalletTypeETH) {
        [self judgeWallet];
    }
}

- (void)addNEOWallet:(NSNotification *)noti {
    [WalletCommonModel refreshNEOWallet];
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (!currentWalletM || currentWalletM.walletType == WalletTypeNEO) {
        [self judgeWallet];
    }
}

- (void)addEOSWallet:(NSNotification *)noti {
    [WalletCommonModel refreshEOSWallet];
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (!currentWalletM || currentWalletM.walletType == WalletTypeEOS) {
        [self judgeWallet];
    }
}

- (void)addQLCWallet:(NSNotification *)noti {
    [WalletCommonModel refreshQLCWallet];
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (!currentWalletM || currentWalletM.walletType == WalletTypeQLC) {
        [self judgeWallet];
    }
}

- (void)deleteWalletSuccess:(NSNotification *)noti {
    NSArray *walletArr = [WalletCommonModel getAllWalletModel];
    if (walletArr.count > 0) {
        WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
        if (currentWalletM == nil) { // 当前钱包不存在
            WalletCommonModel *firstM = walletArr.firstObject;
            [WalletCommonModel setCurrentSelectWallet:firstM];
            [self requestTokenList];
        }
    }
}

- (void)currencyChang:(NSNotification *)noti {
    [self requestTokenList];
}

- (void)qlcAccountPendingDone:(NSNotification *)noti {
    [self pullToRefresh];
}

- (void)languageChangeNoti:(NSNotification *)noti {
    [self refreshTitle];
    [self refreshLanguage];
    [_refreshScroll.mj_header beginRefreshing];
    
    [self refreshBackupView];
    
    [self refreshEmptyView:_refreshScroll];
}

- (void)loginSuccessNoti:(NSNotification *)noti {
    
}

- (void)ethBackupUpdateNoti:(NSNotification *)noti {
    [self refreshBackupView];
}

- (void)neoBackupUpdateNoti:(NSNotification *)noti {
    [self refreshBackupView];
}

- (void)qlcBackupUpdateNoti:(NSNotification *)noti {
    [self refreshBackupView];
}

#pragma mark - Lazy

@end
