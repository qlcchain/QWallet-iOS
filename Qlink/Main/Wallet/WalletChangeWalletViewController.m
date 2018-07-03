//
//  WalletChangeWalletViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "WalletChangeWalletViewController.h"
#import "WalletUtil.h"
#import "WalletSelectCell.h"
#import "NewWalletViewController.h"
#import "BalanceInfo.h"
#import "Qlink-Swift.h"

#import <SDWebImage/UIButton+WebCache.h>

static NSString *celldef = @"walletselectcell";

@interface WalletChangeWalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *lblQLC;
@property (weak, nonatomic) IBOutlet UILabel *lblGAS;
@property (weak, nonatomic) IBOutlet UIButton *userHeadBtn;

@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) NSMutableArray *addressArray;
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (nonatomic ,assign) NSInteger currentIndex;
@property (weak, nonatomic) IBOutlet UILabel *lblNEO;

@end

@implementation WalletChangeWalletViewController
- (IBAction)clickBack:(id)sender {
    
    [self leftNavBarItemPressedWithPop:YES];
}
- (IBAction)clickAddWallet:(id)sender {
    
    
    
    NewWalletViewController *vc = [[NewWalletViewController alloc] initWithJump:WalletJump];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickSelectWallet:(id)sender {
    [WalletUtil setKeyValue:CURRENT_WALLET_KEY value:[NSString stringWithFormat:@"%ld",(long)_currentIndex]];
    
    [WalletUtil getCurrentWalletInfo];
    // 重新初始化 Account->将Account设为当前钱包
    [WalletManage.shareInstance3 configureAccountWithMainNet:[WalletUtil checkServerIsMian]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WALLET_CHANGE_TZ object:nil];
    [self leftNavBarItemPressedWithPop:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取钱包资产
    [self sendGetBalanceRequestWithAddress:[CurrentWalletInfo getShareInstance].address];
    // 获取所有钱包
    [self getAllWalletList];
    // 获取当前钱包的索引
    _currentIndex = [WalletUtil getCurrentWalletIndex];
    // 注册cell
    [_tableV registerNib:[UINib nibWithNibName:@"WalletSelectCell" bundle:nil] forCellReuseIdentifier:celldef];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    // 注册钱包添加时通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllWalletList) name:WALLET_ADD_TZ object:nil];
    
}

#pragma mark - Config View
- (void)refreshContent {

}

/**
 获取所有钱包
 */
- (void) getAllWalletList
{
    
   NSArray *arr = [WalletUtil getAllWalletList];
    if (arr) {
        if (_dataArray) {
            [_dataArray removeAllObjects];
            [_addressArray removeAllObjects];
            [_dataArray addObjectsFromArray:arr[0]];
            [_addressArray addObjectsFromArray:arr[1]];
            [_tableV reloadData];
            
        } else {
            _dataArray = [NSMutableArray arrayWithArray:arr[0]];
            _addressArray = [NSMutableArray arrayWithArray:arr[1]];
        }
        
    }
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
            if (dataDic) {
                BalanceInfo *balanceInfo = [BalanceInfo mj_objectWithKeyValues:dataDic];
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

#pragma  tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return !_addressArray ? 0 : _addressArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletSelectCell *myCell = [tableView dequeueReusableCellWithIdentifier:celldef forIndexPath:indexPath];
    NSString *privateKey = _addressArray[indexPath.row];
    myCell.lblWalletKey.text = [NSString stringWithFormat:@"%@**********%@",[privateKey substringToIndex:5],[privateKey substringWithRange:NSMakeRange(privateKey.length-5,5)]] ;
    if (indexPath.row == _currentIndex) {
        [myCell cellSelect:YES];
    } else {
        [myCell cellSelect:NO];
    }
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _currentIndex) {
        return;
    }
    // 获取选择钱包的资产
    [self sendGetBalanceRequestWithAddress:_addressArray[indexPath.row]];
    
    WalletSelectCell *backCell = [_tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    [backCell cellSelect:NO];
    _currentIndex = indexPath.row;
    WalletSelectCell *currentCell = [_tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    [currentCell cellSelect:YES];
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
