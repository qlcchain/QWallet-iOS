//
//  ETHTransactionRecordViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/26.
//  Copyright © 2018 pan. All rights reserved.
//

#import "OutbreakRedRecordViewController.h"
#import "OutbreakRedRecordCell.h"
#import "QLCWalletAddressViewController.h"
#import "QLCAddressInfoModel.h"
#import "WalletCommonModel.h"
#import "QLCAddressHistoryModel.h"
#import "QLCTransferViewController.h"
#import "TokenPriceModel.h"
#import "NSString+RemoveZero.h"
#import "HistoryChartView.h"
#import "Qlink-Swift.h"
#import "QLCTokenInfoModel.h"
#import <QLCFramework/QLCFramework-Swift.h>
#import "UserModel.h"
#import "RSAUtil.h"
#import "MD5Util.h"
#import <OutbreakRed/OutbreakRed.h>
#import "RefreshHelper.h"
#import "OutbreakFocusModel.h"

//#import "GlobalConstants.h"

static NSString *const OutbreakRedRecordNetworkSize = @"20";

@interface OutbreakRedRecordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic) NSInteger currentPage;

@end

@implementation OutbreakRedRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    
    [self configInit];
    [self requestGzbd_list];
}

#pragma mark - Operation

- (void)configInit {
    _currentPage = 1;
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:OutbreakRedRecordCellReuse bundle:nil] forCellReuseIdentifier:OutbreakRedRecordCellReuse];
    self.baseTable = _mainTable;
    
    kWeakSelf(self)
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = 1;
        [weakself requestGzbd_list];
    } type:RefreshTypeColor];
    _mainTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestGzbd_list];
    } type:RefreshTypeColor];
}

#pragma mark - Request
- (void)requestGzbd_list {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    
    NSString *page = [NSString stringWithFormat:@"%li",_currentPage];
    NSString *size = OutbreakRedRecordNetworkSize;
    NSString *status = OutbreakFocusStatus_AWARDED;
    
    OR_RequestModel *requestM = [OR_RequestModel new];
    requestM.p2pId = [UserModel getTopupP2PId];
    requestM.appBuild = APP_Build;
    requestM.appVersion = APP_Version;
    
    [OutbreakRedSDK requestGzbd_listWithAccount:account token:token page:page size:size status:status orStatus:nil timestamp:timestamp requestM:requestM completeBlock:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nonnull responseObject, NSError * _Nonnull error) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        if (!error) {
            if ([responseObject[Server_Code] integerValue] == 0) {
                NSArray *arr = [OutbreakFocusModel mj_objectArrayWithKeyValuesArray:responseObject[@"recordList"]];
                if (weakself.currentPage == 1) {
                    [weakself.sourceArr removeAllObjects];
                }

                [weakself.sourceArr addObjectsFromArray:arr];
                weakself.currentPage += 1;

                [weakself.mainTable reloadData];

                if (arr.count < [OutbreakRedRecordNetworkSize integerValue]) {
                    [weakself.mainTable.mj_footer endRefreshingWithNoMoreData];
                    weakself.mainTable.mj_footer.hidden = arr.count<=0?YES:NO;
                } else {
                    weakself.mainTable.mj_footer.hidden = NO;
                }
            }
        } else {
            
        }
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return OutbreakRedRecordCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OutbreakFocusModel *model = _sourceArr[indexPath.row];
    if (model.transfer.txid && model.transfer.txid.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QLC_Transaction_Url,model.transfer.txid?:@""]] options:@{} completionHandler:nil];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OutbreakRedRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:OutbreakRedRecordCellReuse];
    
    OutbreakFocusModel *model = _sourceArr[indexPath.row];
    [cell config:model];
    
    return cell;
}

#pragma mark - Action
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Transition

@end
