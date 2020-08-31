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
                if (!(hashM.state == 8 || hashM.state == 11 || hashM.state == 13)) {
            
                    [QSwipWrapperRequestUtil checkEventStatWithRhash:hashM.rHash resultHandler:^(id  _Nullable result, BOOL success, NSString * _Nullable message) {
                        if (success) {
                            NSInteger state = [result[@"status"] integerValue];
                            NSString *rHash = result[@"hash"]; //[@"0x" stringByAppendingString:result[@"hash"]];
                            if (hashM.state >= 20) {
                                if (state == 11 || state == 14) {
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
    if (hashM.state == 4) { // 等待兑换
        cell.lblStatus.text = @"Waitting for Claim";
        [cell.claimBtn setTitle:@"Claim" forState:UIControlStateNormal];
        cell.claimBtn.hidden = NO;
        cell.lblExpierTime.text = @"expire in 10 hours";
    } else if (hashM.state == 8) { // 兑换完成
        cell.lblStatus.text = @"Completed";
    } else if (hashM.state == 14 || hashM.state == 12) { // 超时，用户可以续回
        cell.lblStatus.text = @"Expired";
        [cell.claimBtn setTitle:@"Revoke" forState:UIControlStateNormal];
        cell.claimBtn.hidden = NO;
    } else if (hashM.state == 11) { // 超时赎回完成，资产正常释放
        cell.lblStatus.text = @"Revoked";
    } else if (hashM.state == 13) { // 没有锁定成功，失败
           cell.lblStatus.text = @"Failed";
    }else if (hashM.state == 20) { // 赎回中
        cell.lblStatus.text = @"Revoking";
    } else if (hashM.state == 21) { // 兑换中
        cell.lblStatus.text = @"Claiming";
    } else {
        cell.lblStatus.text = @"Pending";
        [cell.claimBtn setTitle:@"Revoke" forState:UIControlStateNormal];
        cell.claimBtn.hidden = NO;
    }
    kWeakSelf(self)
    [cell setClaimBlock:^{
       
        NSString *alertTitle = @"Claim";
        if (hashM.state == 9) {
            alertTitle = @"Revoke";
        }
        QClaimAlertView *alertView = [QClaimAlertView getInstance];
        [alertView configWithFromAddress:hashM.fromAddress toAddress:hashM.toAddress amount:[NSString stringWithFormat:@"%ld",hashM.amount] tokenName:@"ETH-Wallet" fromType:hashM.type==1? WalletTypeNEO:WalletTypeETH alertTitle:alertTitle ethAddress:hashM.fromAddress];

        [alertView setConfirmBlock:^(NSString * _Nonnull gasPrice){
            // 显示loading
            [weakself showSwapProcessView];
            
            [weakself.ethRequest destoryFetchWithPrivate:hashM.privateKey address:hashM.fromAddress rhash:hashM.rHash gasPrice:gasPrice completionHandler:^(id  _Nonnull responseObject) {
                // 隐藏loading
                [weakself hideSwapProcessView];
                
                if (responseObject) {
                    hashM.state = 20;
                    [weakself.mainTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    // 更新本地状态
                    [QSwapHashModel updateSwapHashStateWithHash:hashM.rHash withState:20 swapTxhash:responseObject];
                    // 延时查看wrapper状态
                    [[QSwapStatusManager getShareQSwapStatusManager] updateSwapStatusWithPrames:@[[NSString stringWithFormat:@"%ld",hashM.type],hashM.rHash]];
                }
                
            }];
            
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
