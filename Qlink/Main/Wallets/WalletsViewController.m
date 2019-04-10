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
#import "SRRefreshView.h"
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

@interface WalletsViewController () <UITableViewDataSource, UITableViewDelegate,SRRefreshDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *refreshScroll;

@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *winqgasLab;
@property (weak, nonatomic) IBOutlet UILabel *walletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *walletAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *walletBalanceLab;
@property (weak, nonatomic) IBOutlet UIImageView *walletIcon;

@property (weak, nonatomic) IBOutlet UIView *walletBack;

@property (weak, nonatomic) IBOutlet UILabel *claimgasLab;
@property (weak, nonatomic) IBOutlet UILabel *claimLab;
@property (weak, nonatomic) IBOutlet UIImageView *claimStatusIcon;
@property (weak, nonatomic) IBOutlet UIView *claimBtnBack;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gasBackHeight; // 71

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eosResourcesHeight; // 53


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalBackheight; // 147
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) NSMutableArray *tokenPriceArr;
@property (nonatomic, strong) NSMutableArray *tokenSymbolArr;

@property (nonatomic, strong) ETHAddressInfoModel *ethAddressInfoM;
@property (nonatomic, strong) NEOAddressInfoModel *neoAddressInfoM;
@property (nonatomic, strong) SRRefreshView *slimeView;

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
}

#pragma mark - Life Cycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addObserve];
    
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:WalletsCellReuse bundle:nil] forCellReuseIdentifier:WalletsCellReuse];
    [self renderView];
    [self configInit];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_slimeView) {
        [_refreshScroll addSubview:self.slimeView];
    }
    
}

#pragma mark - Operation
- (void)renderView {
//    UIColor *borderColor = UIColorFromRGB(0x29282A);
    UIColor *walletShadowColor = [UIColorFromRGB(0xCACACA) colorWithAlphaComponent:0.5];
    [_walletBack addShadowWithOpacity:1 shadowColor:walletShadowColor shadowOffset:CGSizeMake(0,4) shadowRadius:10 andCornerRadius:12];
    
    [_claimLab cornerRadius:8.5];
}

- (void)configInit {
    _tokenSymbolArr = [NSMutableArray array];
    _tokenPriceArr = [NSMutableArray array];
    
    _gasBackHeight.constant = 0;
    _contentHeight.constant = SCREEN_HEIGHT-Height_NavBar-Height_TabBar+_totalBackheight.constant;
    
    [self refreshClaimGas:nil];
    [self judgeWallet];
}

- (void)judgeWallet {
//    [ETHWalletInfo refreshTrustWallet]; // 如果keychain中的钱包在Trust中没有则自动导入
    BOOL haveEthWallet = TrustWalletManage.sharedInstance.isHavaWallet;
    BOOL haveNeoWallet = [NEOWalletInfo getAllNEOWallet].count>0?YES:NO;
    BOOL haveEosWallet = [EOSWalletInfo getAllWalletInKeychain].count>0?YES:NO;
    if (haveEthWallet) {
        [WalletCommonModel refreshETHWallet];
    }
    if (haveNeoWallet) {
        [WalletCommonModel refreshNEOWallet];
    }
    if (haveEosWallet) {
        [WalletCommonModel refreshEOSWallet];
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
//        [WalletCommonModel refreshCurrentWallet]; // 刷新当前钱包
        [self refreshTokenList];
        kWeakSelf(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
            [weakself requestGetTokenBalance]; // 刷新winqgas
        });
    } else {
        [self jumpToChooseWallet:NO];
    }
}

- (void)updateWalletWithETH:(ETHAddressInfoModel *)ethModel {
    NSArray *allWallets = [WalletCommonModel getAllWalletModel];
    [allWallets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WalletCommonModel *walletM = obj;
        if ([[walletM.address lowercaseString] isEqualToString:[ethModel.address lowercaseString]]) {
            walletM.balance = ethModel.ETH.balance;
            [WalletCommonModel updateWalletModel:walletM];
            *stop = YES;
        }
    }];
}

- (void)refreshDataWithETH {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    _totalLab.text = [NSString stringWithFormat:@"$ %@",currentWalletM.balance];
    _totalLab.text = [NSString stringWithFormat:@"%@ %@",[ConfigUtil getLocalUsingCurrencySymbol],@"0"];
    _walletNameLab.text = currentWalletM.name;
    _walletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[currentWalletM.address substringToIndex:8],[currentWalletM.address substringWithRange:NSMakeRange(currentWalletM.address.length - 8, 8)]];
//    _walletBalanceLab.text = [NSString stringWithFormat:@"$ %@",currentWalletM.balance];
    _walletBalanceLab.text = [NSString stringWithFormat:@"%@ %@",[ConfigUtil getLocalUsingCurrencySymbol],@"0"];
    _gasBackHeight.constant = 0;
    _eosResourcesHeight.constant = 0;
    _walletIcon.image = [UIImage imageNamed:@"eth_wallet"];
    
    [_sourceArr removeAllObjects];
    [_sourceArr addObject:[self getETHToken]];
    [_sourceArr addObjectsFromArray:_ethAddressInfoM.tokens];
    [_mainTable reloadData];
    
    [_tokenSymbolArr removeAllObjects];
    [_tokenSymbolArr addObject:@"ETH"];
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

- (Token *)getETHToken {
    TokenInfo *tokenInfo = [[TokenInfo alloc] init];
    tokenInfo.address = _ethAddressInfoM.address;
    tokenInfo.decimals = @"0";
    tokenInfo.name = @"ETH";
    tokenInfo.symbol = @"ETH";
    Token *token = [[Token alloc] init];
    token.balance = _ethAddressInfoM.ETH.balance;
    token.tokenInfo = tokenInfo;
    return token;
}

- (void)updateWalletWithNEO:(NEOAddressInfoModel *)neoModel {
    NSArray *allWallets = [WalletCommonModel getAllWalletModel];
    [allWallets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WalletCommonModel *walletM = obj;
        if ([[walletM.address lowercaseString] isEqualToString:[neoModel.address lowercaseString]]) {
            walletM.balance = neoModel.amount;
            [WalletCommonModel updateWalletModel:walletM];
            *stop = YES;
        }
    }];
}

- (void)refreshDataWithNEO {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    //    _totalLab.text = [NSString stringWithFormat:@"$ %@",currentWalletM.balance];
    _totalLab.text = [NSString stringWithFormat:@"%@ %@",[ConfigUtil getLocalUsingCurrencySymbol],@"0"];
    _walletNameLab.text = currentWalletM.name;
    _walletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[currentWalletM.address substringToIndex:8],[currentWalletM.address substringWithRange:NSMakeRange(currentWalletM.address.length - 8, 8)]];
    //    _walletBalanceLab.text = [NSString stringWithFormat:@"$ %@",currentWalletM.balance];
    _walletBalanceLab.text = [NSString stringWithFormat:@"%@ %@",[ConfigUtil getLocalUsingCurrencySymbol],@"0"];
    _gasBackHeight.constant = 71;
    _eosResourcesHeight.constant = 0;
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

- (void)updateWalletWithEosBalance:(NSNumber *)eosBalance accountName:(NSString *)account_name {
    NSArray *allWallets = [WalletCommonModel getAllWalletModel];
    [allWallets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WalletCommonModel *walletM = obj;
        if ([walletM.account_name isEqualToString:account_name]) {
            walletM.balance = eosBalance;
            [WalletCommonModel updateWalletModel:walletM];
            *stop = YES;
        }
    }];
}

- (void)refreshDataWithEOS:(NSArray *)tokenList {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    _totalLab.text = [NSString stringWithFormat:@"%@ %@",[ConfigUtil getLocalUsingCurrencySymbol],@"0"];
    _walletNameLab.text = currentWalletM.name;
//    _walletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[currentWalletM.address substringToIndex:8],[currentWalletM.address substringWithRange:NSMakeRange(currentWalletM.address.length - 8, 8)]];
    _walletAddressLab.text = currentWalletM.account_name;
    _walletBalanceLab.text = [NSString stringWithFormat:@"%@ %@",[ConfigUtil getLocalUsingCurrencySymbol],@"0"];
    _gasBackHeight.constant = 0;
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

- (void)refreshPrice {
    __block NSString *totalPrice = @"";
    __block NSString *walletBalance = @"";
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeETH) {
        __block NSNumber *totalPriceNum = @(0);
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isKindOfClass:[Token class]]) {
                *stop = YES;
            } else {
                Token *token = obj;
                totalPriceNum = @([totalPriceNum doubleValue]+[[token getPrice:_tokenPriceArr] doubleValue]);
//                totalPriceDouble += [[token getPrice:_tokenPriceArr] doubleValue];
            }
        }];
        totalPrice = [[NSString stringWithFormat:@"%@",totalPriceNum] removeFloatAllZero];
        
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isKindOfClass:[Token class]]) {
                *stop = YES;
            } else {
                Token *token = obj;
                if ([token.tokenInfo.symbol isEqualToString:@"ETH"]) {
                    walletBalance = [token getPrice:_tokenPriceArr];
                    *stop = YES;
                }
            }
        }];
    } else if (currentWalletM.walletType == WalletTypeEOS) {
        __block NSNumber *totalPriceNum = @(0);
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isKindOfClass:[EOSSymbolModel class]]) {
                *stop = YES;
            } else {
                EOSSymbolModel *model = obj;
                totalPriceNum = @([totalPriceNum doubleValue]+[[model getPrice:_tokenPriceArr] doubleValue]);
            }
        }];
        totalPrice = [[NSString stringWithFormat:@"%@",totalPriceNum] removeFloatAllZero];
        
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isKindOfClass:[EOSSymbolModel class]]) {
                *stop = YES;
            } else {
                EOSSymbolModel *model = obj;
                if ([model.symbol isEqualToString:@"EOS"]) {
                    walletBalance = [model getPrice:_tokenPriceArr];
                    *stop = YES;
                }
            }
        }];
    } else if (currentWalletM.walletType == WalletTypeNEO) {
        __block NSNumber *totalPriceNum = @(0);
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isKindOfClass:[NEOAssetModel class]]) {
                *stop = YES;
            } else {
                NEOAssetModel *asset = obj;
                totalPriceNum = @([totalPriceNum doubleValue]+[[asset getPrice:_tokenPriceArr] doubleValue]);
            }
        }];
        totalPrice = [[NSString stringWithFormat:@"%@",totalPriceNum] removeFloatAllZero];
        
        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isKindOfClass:[NEOAssetModel class]]) {
                *stop = YES;
            } else {
                NEOAssetModel *asset = obj;
                if ([asset.asset_symbol isEqualToString:@"NEO"]) {
                    walletBalance = [asset getPrice:_tokenPriceArr];
                    *stop = YES;
                }
            }
        }];
    }
    
    _totalLab.text = [NSString stringWithFormat:@"%@ %@",[ConfigUtil getLocalUsingCurrencySymbol],totalPrice];
    _walletBalanceLab.text = [NSString stringWithFormat:@"%@ %@",[ConfigUtil getLocalUsingCurrencySymbol],walletBalance];
    
    [_mainTable reloadData];
}

- (void)refreshWGas:(BalanceInfo *)model {
    NSString *winqGas = model?[model getWinqGas]:@"0.00";
    _winqgasLab.text = winqGas;
}

- (void)neoGasStatusInit {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeNEO) {
        [NEOGasClaimUtil shareInstance].claimStatus = NEOGasClaimStatusSync; // 初始化
    }
}

- (void)refreshClaimGas:(NSString *)amount {
    NEOGasClaimStatus status = [NEOGasClaimUtil shareInstance].claimStatus;
    _claimStatusIcon.hidden = YES;
    if (status == NEOGasClaimStatusSync) {
        _claimLab.text = @"Sync";
        _claimLab.hidden = NO;
        _claimgasLab.text = amount?:@"0";
    } else if (status == NEOGasClaimStatusSyncLoading) {
        _claimLab.hidden = YES;
        _claimgasLab.text = amount?:@"0";
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
    } else if (status == NEOGasClaimStatusClaimFail) {
        _claimLab.text = @"Claim";
        _claimLab.hidden = NO;
    }
}

- (void)requestGetNeoCliamGas {
    // 刷新neo claimgas
    kWeakSelf(self);
    [NEOGasUtil.sharedInstance loadClaimableGAS:^(NSString * amount) {
        NEOGasClaimStatus status = [NEOGasClaimUtil shareInstance].claimStatus;
        if (status == NEOGasClaimStatusSyncLoading) {
            [NEOGasClaimUtil shareInstance].claimStatus = NEOGasClaimStatusClaim;
        }
        [weakself refreshClaimGas:amount];
    }];
}

- (void)neoClaimGasAction {
    kWeakSelf(self);
    [kAppD.window makeToastInView:kAppD.window];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NEOGasUtil.sharedInstance neoClaimGas:^(BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [kAppD.window hideToast];
                NEOGasClaimStatus status = [NEOGasClaimUtil shareInstance].claimStatus;
                if (success) {
                    if (status == NEOGasClaimStatusClaimLoading) {
                        [NEOGasClaimUtil shareInstance].claimStatus = NEOGasClaimStatusClaimSuccess;
                        [weakself refreshClaimGas:nil];
                    }
//                    [weakself requestGetNeoCliamGas];
                    [kAppD.window makeToastDisappearWithText:@"Claimed Successfully"];
                } else {
                    [NEOGasClaimUtil shareInstance].claimStatus = NEOGasClaimStatusClaimFail;
                    [weakself refreshClaimGas:nil];
                    [kAppD.window makeToastDisappearWithText:@"Claimed Failed"];
                }
            });
        }];
    });
}

- (void)showNeoClaimGasTip:(NSString *)amount {
    NeoClaimGasTipView *tipV = [NeoClaimGasTipView getInstance];
    kWeakSelf(self);
    tipV.claimBlock = ^{
        [weakself neoClaimGasAction];
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
        [weakself requestNeoGotWGas];
    };
    [tipV showWithNum:[model getNum]];
}

- (void)showNeoGotWGas:(NeoGotWGasModel *)model {
    [kAppD.window makeToastDisappearWithText:model.tips];
}

- (void)refreshTokenList {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    DDLogDebug(@"refreshTokenList:%@",@(currentWalletM.walletType));
    switch (currentWalletM.walletType) {
        case WalletTypeETH:
        {
            [self requestETHAddressInfo:currentWalletM.address?:@"" showLoad:YES];
        }
            break;
        case WalletTypeEOS:
        {
            [self requestEOSTokenList:currentWalletM.account_name?:@"" showLoad:YES];
        }
            break;
        case WalletTypeNEO:
        {
            [self requestNEOAddressInfo:currentWalletM.address?:@"" showLoad:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - Request
- (void)requestETHAddressInfo:(NSString *)address showLoad:(BOOL)showLoad {
    // 检查地址有效性
    BOOL isValid = [TrustWalletManage.sharedInstance isValidAddressWithAddress:address];
    if (!isValid) {
        return;
    }
    kWeakSelf(self);
    NSDictionary *params = @{@"address":address,@"token":@""}; // @"0x980e7917c610e2c2d4e669c920980cb1b915bbc7"
    if (showLoad) {
        [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:0];
    }
    [RequestService requestWithUrl:ethAddressInfo_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself endRefresh];
        if (showLoad) {
            [kAppD.window hideToast];
        }
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = [responseObject objectForKey:Server_Data];
            weakself.ethAddressInfoM = [ETHAddressInfoModel getObjectWithKeyValues:dic];
//            weakSelf.ethAddressInfoM.name = name;
            [weakself updateWalletWithETH:weakself.ethAddressInfoM];
            [weakself refreshDataWithETH];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself endRefresh];
        if (showLoad) {
            [kAppD.window hideToast];
        }
    }];
}

- (void)requestNEOAddressInfo:(NSString *)address showLoad:(BOOL)showLoad {
    // 检查地址有效性
    BOOL validateNEOAddress = [NEOWalletManage.sharedInstance validateNEOAddressWithAddress:address];
    if (!validateNEOAddress) {
        return;
    }
    kWeakSelf(self);
    NSDictionary *params = @{@"address":address};
    if (showLoad) {
        [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:0];
    }
    [RequestService requestWithUrl:neoAddressInfo_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself endRefresh];
        if (showLoad) {
            [kAppD.window hideToast];
        }
        [weakself requestGetNeoCliamGas]; // 请求neocliamgas
        
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = [responseObject objectForKey:Server_Data];
            weakself.neoAddressInfoM = [NEOAddressInfoModel getObjectWithKeyValues:dic];
            __block NSNumber *amount = @(0);
            [weakself.neoAddressInfoM.balance enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NEOAssetModel *model = obj;
                if ([model.asset_symbol isEqualToString:@"NEO"]) { // 赋值NEO余额
                    amount = model.amount;
                }
            }];
            weakself.neoAddressInfoM.amount = amount;
            [weakself updateWalletWithNEO:weakself.neoAddressInfoM];
            [weakself refreshDataWithNEO];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself endRefresh];
        if (showLoad) {
            [kAppD.window hideToast];
        }
    }];
}

- (void)requestEOSTokenList:(NSString *)account_name showLoad:(BOOL)showLoad {
    // 检查地址有效性
    BOOL validateEOSAccountName = [RegularExpression validateEosAccountName:account_name];
    if (!validateEOSAccountName) {
        return;
    }
    kWeakSelf(self);
    NSDictionary *params = @{@"account":account_name, @"symbol":@""};
    if (showLoad) {
        [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:0];
    }
    [RequestService requestWithUrl:eosGet_token_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself endRefresh];
        if (showLoad) {
            [kAppD.window hideToast];
        }
        
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = responseObject[Server_Data][Server_Data];
            NSArray *symbol_list = dic[@"symbol_list"];
            __block NSNumber *eosBalance = @(0);
            NSMutableArray *symbolListArr = [NSMutableArray array];
            [symbol_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EOSSymbolModel *model = [EOSSymbolModel getObjectWithKeyValues:obj];
                [symbolListArr addObject:model];
                if ([model.symbol isEqualToString:@"EOS"]) { // 赋值EOS余额
                    eosBalance = model.balance;
                }
            }];
            [weakself updateWalletWithEosBalance:eosBalance accountName:account_name];
            [weakself refreshDataWithEOS:symbolListArr];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself endRefresh];
        if (showLoad) {
            [kAppD.window hideToast];
        }
    }];
}

- (void)requestTokenPrice {
    if (_tokenSymbolArr.count <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *coin = [ConfigUtil getLocalUsingCurrency]?:@"";
    NSDictionary *params = @{@"symbols":_tokenSymbolArr,@"coin":coin};
    [RequestService requestWithUrl:tokenPrice_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            [weakself.tokenPriceArr removeAllObjects];
            NSArray *arr = [responseObject objectForKey:Server_Data];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TokenPriceModel *model = [TokenPriceModel getObjectWithKeyValues:obj];
                model.coin = coin;
                [weakself.tokenPriceArr addObject:model];
            }];
            [self refreshPrice];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestNeoGotWGas {
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
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:neoGotWGas_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = [responseObject objectForKey:Server_Data];
            NeoGotWGasModel *model = [NeoGotWGasModel getObjectWithKeyValues:dic];
            [weakself showNeoGotWGas:model];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

- (void)requestNeoQueryWGas {
    kWeakSelf(self);
    NSString *myP2pId = [UserModel getOwnP2PId];
    NSDictionary *params = @{@"p2pId":myP2pId};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:neoQueryWGas_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = [responseObject objectForKey:Server_Data];
            NeoQueryWGasModel *model = [NeoQueryWGasModel getObjectWithKeyValues:dic];
            [weakself showNeoQueryWGas:model];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

 // 刷新winqgas
- (void)requestGetTokenBalance {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType != WalletTypeNEO) {
        return;
    }
    NSString *address = currentWalletM.address?:@"";
    NSDictionary *params = @{@"address":address};
    kWeakSelf(self);
    [RequestService requestWithUrl:getTokenBalance_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dataDic = [responseObject objectForKey:Server_Data];
            BalanceInfo *balanceInfo = [BalanceInfo mj_objectWithKeyValues:dataDic];
            [weakself refreshWGas:balanceInfo];
        } else {
            [weakself refreshWGas:nil];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself refreshWGas:nil];
    }];
}

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
    kWeakSelf(self);
    WalletQRViewController *vc = [[WalletQRViewController alloc] initWithCodeQRCompleteBlock:^(NSString *codeValue) {
        WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
        if (currentWalletM.walletType == WalletTypeETH) {
            BOOL isValid = [TrustWalletManage.sharedInstance isValidAddressWithAddress:codeValue];
            if (!isValid) {
                [kAppD.window makeToastDisappearWithText:@"Please provide a valid QR Code Of ETH"];
                return;
            }
            [weakself jumpToETHTransfer:codeValue];
        } else if (currentWalletM.walletType == WalletTypeNEO) {
            BOOL validateNEOAddress = [NEOWalletManage.sharedInstance validateNEOAddressWithAddress:codeValue];
            if (!validateNEOAddress) {
                [kAppD.window makeToastDisappearWithText:@"Please provide a valid QR Code Of NEO"];
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
                    [kAppD.window makeToastDisappearWithText:@"Please provide a valid QR Code Of EOS"];
                }
            } else {
                [weakself jumpToEOSTransfer:codeValue];
            }
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
    [kAppD.window makeToastDisappearWithText:@"Copied"];
}

- (IBAction)winqGasClaimAction:(id)sender {
    [self requestNeoQueryWGas];
}

- (IBAction)neoClaimAction:(id)sender {
    NEOGasClaimStatus status = [NEOGasClaimUtil shareInstance].claimStatus;
    if (status == NEOGasClaimStatusSync) {
        [NEOGasClaimUtil shareInstance].claimStatus = NEOGasClaimStatusSyncLoading;
        [self requestGetNeoCliamGas];
    } else if (status == NEOGasClaimStatusClaim || status == NEOGasClaimStatusClaimFail) {
        [NEOGasClaimUtil shareInstance].claimStatus = NEOGasClaimStatusClaimLoading;
        NSString *gas = _claimgasLab.text?:@"0";
        if ([gas doubleValue] <= 0) {
            [kAppD.window makeToastDisappearInView:kAppD.window text:@"There is no gas to claim!"];
            [NEOGasClaimUtil shareInstance].claimStatus = NEOGasClaimStatusClaim;
        } else {
            [self showNeoClaimGasTip:gas];
        }
    }
}

- (IBAction)eosResourcesAction:(id)sender {
    [self jumpToEOSResouces];
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
    }
    
    return cell;
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _refreshScroll) {
        if (_refreshScroll.contentOffset.y < 0) {
//            _refreshScroll.backgroundColor = MAIN_BLUE_COLOR;
            _refreshScroll.theme_backgroundColor = globalBackgroundColorPicker;
//        } else if (_refreshScroll.contentOffset.y > _refreshScroll.contentSize.height - _refreshScroll.visibleSize.height) {
        } else if (_refreshScroll.contentOffset.y > _refreshScroll.contentSize.height - [self scrollViewVisibleSize:_refreshScroll].height) {
            _refreshScroll.backgroundColor = MAIN_WHITE_COLOR;
        }
        if (_slimeView) {
            [_slimeView scrollViewDidScroll];
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
        if (_slimeView) {
            [_slimeView scrollViewDidEndDraging];
        }
    }
}

#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView {
    [self neoGasStatusInit]; // neo gas 状态初始化
    
    [self refreshTokenList]; // 请求token列表
    
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself requestGetTokenBalance]; // 刷新winqgas
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [NeoTransferUtil sendGetBalanceRequest]; // 查询当前NEO钱包资产
    });
}

- (void)endRefresh {
    if (_slimeView) {
        [_slimeView endRefresh];
    }
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
//    QlinkNavViewController *nav = [[QlinkNavViewController alloc] initWithRootViewController:vc];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
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

- (void)jumpToETHTransfer:(NSString *)address {
    if (_sourceArr.count<=0) {
        [kAppD.window makeToastDisappearWithText:@"No assets can be transferred."];
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

- (void)jumpToNEOTransfer:(NSString *)address {
    if (_sourceArr.count<=0) {
        [kAppD.window makeToastDisappearWithText:@"No wallet is available"];
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
        [kAppD.window makeToastDisappearWithText:@"No wallet is available"];
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

#pragma mark - Noti
- (void)walletChange:(NSNotification *)noti {
    [self neoGasStatusInit]; // neo gas 状态初始化
    [self refreshTokenList]; // 请求token列表
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself requestGetTokenBalance]; // 刷新winqgas
    });
}

- (void)addETHWallet:(NSNotification *)noti {
    [WalletCommonModel refreshETHWallet];
    [self judgeWallet];
}

- (void)addNEOWallet:(NSNotification *)noti {
    [WalletCommonModel refreshNEOWallet];
    [self judgeWallet];
}

- (void)addEOSWallet:(NSNotification *)noti {
    [WalletCommonModel refreshEOSWallet];
    [self judgeWallet];
}

- (void)deleteWalletSuccess:(NSNotification *)noti {
    NSArray *walletArr = [WalletCommonModel getAllWalletModel];
    if (walletArr.count > 0) {
        WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
        if (currentWalletM == nil) { // 当前钱包不存在
            WalletCommonModel *firstM = [WalletCommonModel getAllWalletModel].firstObject;
            [WalletCommonModel setCurrentSelectWallet:firstM];
            [self requestETHAddressInfo:firstM.address?:@"" showLoad:YES];
        }
    } else {
        [self jumpToChooseWallet:NO];
    }
}

- (void)currencyChang:(NSNotification *)noti {
    [self refreshTokenList];
}

#pragma mark - Lazy
- (SRRefreshView *)slimeView {
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] initWithHeight:SRHeight width:_refreshScroll.width];
        _slimeView.upInset = 0;
        _slimeView.delegate = self;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = SRREFRESH_BACK_COLOR;
        _slimeView.slime.skinColor = SRREFRESH_BACK_COLOR;
//        _slimeView.slime.bodyColor = [UIColor whiteColor];
//        _slimeView.slime.skinColor = [UIColor whiteColor];
        //      _slimeView.slime.lineWith = 1;
        //      _slimeView.slime.shadowBlur = 4;
        //      _slimeView.slime.shadowColor = MAIN_BLUE_COLOR;
    }
    
    return _slimeView;
}

@end
