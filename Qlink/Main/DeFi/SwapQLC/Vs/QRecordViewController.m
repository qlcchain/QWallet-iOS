//
//  QRecordViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2020/8/10.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QRecordViewController.h"
#import "QRecordCell.h"
#import "QClaimAlertView.h"
#import "QSwapHashModel.h"
#import "NSDate+Category.h"
#import "ContractETHRequest.h"
#import "QSwipWrapperRequestUtil.h"
#import "QSwapDetailViewController.h"
#import "QSwapStatusManager.h"
#import "QSwapProcessAnimateView.h"
#import <MJRefresh/MJRefresh.h>
#import "RefreshHelper.h"
#import "WalletCommonModel.h"
#import "QSwapAddressModel.h"

@interface QRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ContractETHRequest *ethRequest;

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *hashArray;
@property (nonatomic, strong) QSwapProcessAnimateView *swapProcessV;

@end

@implementation QRecordViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadLocalHashData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    self.ethRequest = [ContractETHRequest addContractETHRequest];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    [_mainTable registerNib:[UINib nibWithNibName:QRecordCellReuse bundle:nil] forCellReuseIdentifier:QRecordCellReuse];
    [self configEmptyView:_mainTable contentViewY:SCREEN_HEIGHT/2-180];
    
    kWeakSelf(self)
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        [weakself loadLocalHashData];
    } type:RefreshTypeColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swapStatusChangeNoti:) name:SWAP_Status_Change_Noti object:nil];
}

#pragma mark -lazy
- (NSMutableArray *)hashArray
{
    if (!_hashArray) {
        _hashArray = [NSMutableArray array];
    }
    return _hashArray;
}

#pragma mark - operation
- (void) loadLocalHashData
{
   // [QSwapHashModel deleteAllLocationHashs];
    if (self.hashArray.count > 0) {
        [self.hashArray removeAllObjects];
    }
    kWeakSelf(self)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
        NSArray *allHashs = [QSwapHashModel getLocalAllQSwapHashModels];
        if (allHashs.count > 0) {
            // 倒序
            allHashs = [[allHashs reverseObjectEnumerator] allObjects];
        }
           
        [allHashs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               QSwapHashModel *model = obj;
               if ([model.fromAddress isEqualToString:currentWalletM.address]) {
                   [weakself.hashArray addObject:model];
               }
           }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.mainTable.mj_header endRefreshing];
            [weakself.mainTable reloadData];
            
            [weakself.hashArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   QSwapHashModel *hashM = obj;
                if (!(hashM.state == DepositNeoFetchDone || hashM.state == WithDrawEthFetchDone || hashM.state == lockTimeoutState || [QSwapStatusManager isClaimSuccessWithState:hashM.state])) {
            
                    [QSwipWrapperRequestUtil checkEventStatWithRhash:hashM.rHash resultHandler:^(id  _Nullable result, BOOL success, NSString * _Nullable message) {
                        if (success) {
                            NSInteger state = [result[@"state"]?:@"" integerValue];
                            NSString *rHash = [@"0x" stringByAppendingString:result[@"rHash"]?:@""];
                            
                            BOOL neoTimeout = [result[@"neoTimeout"] boolValue];
                            BOOL ethTimeout = [result[@"ethTimeout"] boolValue];
                            if (neoTimeout && ethTimeout) {
                                state = lockTimeoutState;
                            }
                            
                            [weakself updateSwapHashStatelWithRhash:rHash state:state];
                            if (hashM.state >= claimingState) {
                                if (state == WithDrawEthUnlockDone || state == WithDrawEthFetchDone || state == DepositNeoUnLockedDone || state == DepositNeoFetchDone) {
                                    [weakself updateSwapHashStatelWithRhash:rHash state:state];
                                }
                            } else {
                                [weakself updateSwapHashStatelWithRhash:rHash state:state];
                            }
                        }
                    }];
                }
                   
            }];
        });
    });
   
}

// 更新状态
- (void) updateSwapHashStatelWithRhash:(NSString *) rhash state:(NSInteger) state
{
    kWeakSelf(self)
    [self.hashArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QSwapHashModel *hashM = obj;
        if ([hashM.rHash isEqualToString:rhash]) {
            // 更新状态
            hashM.state = state;
            // 刷新tabble
            [weakself.mainTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            // 更新本地状态
            [QSwapHashModel updateSwapHashStateWithHash:rhash withState:state];
            *stop = YES;
        }
    }];
}

#pragma mark --UITableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hashArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     QSwapHashModel *hashM = self.hashArray[indexPath.row];
    if (hashM.state == 4) {
         return QRecordCell_Height;
    }
    return QRecordCell_Height-20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:QRecordCellReuse];
    QSwapHashModel *hashM = self.hashArray[indexPath.row];
    cell.lblTime.text = [[NSDate dateWithTimeIntervalSince1970:hashM.lockTime] formattedDateYearYueRi:yyyyMMddHHmm];
    cell.lblAmount.text = [NSString stringWithFormat:@"%ld", hashM.amount];
    
    cell.claimBtn.hidden = YES;
    cell.lblExpierTime.text = @"";
    if (hashM.state == DepositEthLockedDone || hashM.state == DepositEthUnLockedDone || hashM.state == WithDrawNeoLockedDone) { // 等待兑换
        cell.lblStatus.text = kLang(@"waiting_for_claim");
        [cell.claimBtn setTitle:kLang(@"claim") forState:UIControlStateNormal];
        cell.claimBtn.hidden = NO;
        //cell.lblExpierTime.text = @"expire in 10 hours";
    } else if ([QSwapStatusManager isClaimSuccessWithState:hashM.state]) { // unlock完成
        cell.lblStatus.text = kLang(@"completed");
    } else if (hashM.state == WithDrawNeoFetchDone || hashM.state == DepositEthFetchDone || hashM.state == lockTimeoutState) { // 超时，用户可以续回 19:erc20 8:nep5 29:超时
        cell.lblStatus.text = kLang(@"expired");
        [cell.claimBtn setTitle:kLang(@"swap_revoke") forState:UIControlStateNormal];
        cell.claimBtn.hidden = NO;
    } else if (hashM.state == DepositNeoFetchDone || hashM.state == WithDrawEthFetchDone) { // 超时赎回完成，资产正常释放
        cell.lblStatus.text = kLang(@"swap_revoked");
    } else if (hashM.state == revokeingState) { // 赎回中
        cell.lblStatus.text = kLang(@"revoking");
    } else if (hashM.state == claimingState) { // 兑换中
        cell.lblStatus.text = kLang(@"claiming");
    } else {
        cell.lblStatus.text = kLang(@"swap_pending");
    }
    kWeakSelf(self)
    [cell setClaimBlock:^{
       
        NSString *alertTitle = kLang(@"claim");
        if (hashM.state == 9) {
            alertTitle = kLang(@"swap_revoke");
        }
        NSString *ethAddress = hashM.fromAddress;
        if (hashM.type == DepositEthLockedPending && hashM.state == WithDrawNeoLockedDone) { // unlock到neo 不需要手续费
            ethAddress = @"";
        }
        QClaimAlertView *alertView = [QClaimAlertView getInstance];
        [alertView configWithFromAddress:hashM.fromAddress toAddress:hashM.toAddress amount:[NSString stringWithFormat:@"%ld",hashM.amount] tokenName:@"ETH-Wallet" fromType:hashM.type==1? WalletTypeNEO:WalletTypeETH alertTitle:alertTitle ethAddress:ethAddress];

        [alertView setConfirmBlock:^(NSString * _Nonnull gasPrice){
            // 显示loading
            //[weakself showSwapProcessView];
           
            if (hashM.type == DepositEthLockedPending && hashM.state == WithDrawNeoLockedDone) { // unlock 到 nep5
                [kAppD.window makeToastInView:kAppD.window text:NSStringLocalizable(@"claiming")];
                [QSwipWrapperRequestUtil unLockToNep5WithRhash:hashM.rOrigin userNep5Addr:hashM.toAddress resultHandler:^(id  _Nullable result, BOOL success, NSString * _Nullable message) {
                    if (success) {
                        [kAppD.window hideToast];
                        [kAppD.window makeToastDisappearWithText:kLang(@"success")];
                        hashM.state = claimingState;
                        hashM.swaptxHash = result;
                        [weakself.mainTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        // 更新本地状态
                        [QSwapHashModel updateSwapHashStateWithHash:hashM.rHash withState:claimingState swapTxhash:result];
                        // 延时查看wrapper状态
                        [[QSwapStatusManager getShareQSwapStatusManager] updateSwapStatusWithRhash:hashM.rHash];
                    } else {
                        //[weakself hideSwapProcessView];
                        [kAppD.window hideToast];
                        [kAppD.window makeToastDisappearWithText:kLang(@"failed")];
                    }
                }];
            } else if (hashM.type == 2 && (hashM.state == WithDrawNeoFetchDone || hashM.state == lockTimeoutState)) { // eth -> nep 超时赎回
                [kAppD.window makeToastInView:kAppD.window text:NSStringLocalizable(@"revoking")];
                
                [QSwipWrapperRequestUtil checkWrapperOnlineWithFetchEthAddress:hashM.fromAddress resultHandler:^(id  _Nullable result, BOOL success, NSString * _Nullable message) {
                    if (success) {
                        if (![QSwapAddressModel getShareObject].withdrawLimit) {
                            
                            [weakself.ethRequest destoryFetchWithPrivate:hashM.privateKey address:hashM.fromAddress rhash:hashM.rHash gasPrice:gasPrice completionHandler:^(id  _Nonnull responseObject) {
                                // 隐藏loading
                                //[weakself hideSwapProcessView];
                                [kAppD.window hideToast];
                                if (responseObject) {
                                    
                                    hashM.state = revokeingState;
                                    hashM.swaptxHash = responseObject;
                                    [weakself.mainTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                    // 更新本地状态
                                    [QSwapHashModel updateSwapHashStateWithHash:hashM.rHash withState:revokeingState swapTxhash:responseObject];
                                    // 延时查看wrapper状态
                                    [[QSwapStatusManager getShareQSwapStatusManager] updateSwapStatusWithRhash:hashM.rHash];
                                }
                                
                            }];
                            
                        } else {
                            // 次数被限制
                            [kAppD.window hideToast];
                            [kAppD.window makeToastDisappearWithText:kLang(@"failed")];
                        }
                    } else {
                        [kAppD.window hideToast];
                        [kAppD.window makeToastDisappearWithText:kLang(@"failed")];
                    }
                }];
            }
            
        }];
        [alertView show];
        
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QSwapHashModel *hashM = self.hashArray[indexPath.row];
    QRecordCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    QSwapDetailViewController *vc = [[QSwapDetailViewController alloc] initWithSwapHashModel:hashM withStatuString:cell.lblStatus.text];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark --- 通知
- (void) swapStatusChangeNoti:(NSNotification *) note
{
    NSArray *results = note.object;
    kWeakSelf(self)
    [self.hashArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QSwapHashModel *hashM = obj;
        if ([results[0] isEqualToString:hashM.rHash]) {
            hashM.state = [results[1] integerValue];
            // 刷新tabble
            [weakself.mainTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            *stop = YES;
        }
    }];
}

#pragma mark---进度load
- (void)showSwapProcessView {
    _swapProcessV = [QSwapProcessAnimateView getInstance];
    [_swapProcessV show];
}

- (void)hideSwapProcessView {
    if (_swapProcessV) {
        [_swapProcessV hide];
        _swapProcessV = nil;
    }
}
@end
