//
//  MyAssetsView.m
//  Qlink
//
//  Created by 旷自辉 on 2018/5/2.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "MyAssetsView.h"
#import "UIView+Animation.h"
#import "VPNMode.h"
#import "WalletUtil.h"
#import "VPNOperationUtil.h"

@implementation MyAssetsView

- (IBAction)clickCancel:(id)sender {
   
    [self zoomOutAnimationDuration:.6 target:self callback:@selector(dismiss)];
}

#pragma uitableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.soureArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MyAssetsCell_Height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAssetsCell *myCell = [tableView dequeueReusableCellWithIdentifier:MyAssetsCellReuse];
    myCell.settingBtn.tag = indexPath.row;
    id mode = [self.soureArray objectAtIndex:indexPath.row];
    [myCell setMode:mode];
    @weakify_self
    [myCell setSetBlock:^(id mode) {
        [weakSelf jumpAssetsWithMode:mode];
    }];
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}

#pragma - mark jump vc
- (void) jumpAssetsWithMode:(id) mode
{
    if (self.setBlock) {
        self.setBlock(mode);
    }
}

+ (MyAssetsView *)getNibView {
    MyAssetsView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"MyAssetsView" owner:self options:nil] firstObject];
    [nibView setTableView];
    return nibView;
}



- (void) setTableView
{
    _tableV.delegate = self;
    _tableV.dataSource = self;
    //_mainTable.slimeView.delegate = self;
    _tableV.showsVerticalScrollIndicator = NO;
    _tableV.showsHorizontalScrollIndicator = NO;
    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableV registerNib:[UINib nibWithNibName:MyAssetsCellReuse bundle:nil] forCellReuseIdentifier:MyAssetsCellReuse];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkData) name:UPDATE_ASSETS_TZ object:nil];
    [self checkData];
}

/**
 同步查询所有数据.
 */
- (void) checkData
{
   //NSArray* finfAlls = [VPNInfo bg_find:VPNREGISTER_TABNAME limit:0 orderBy:@"bg_createTime" desc:YES];
  
    NSArray* finfAlls = nil;
    if ([WalletUtil checkServerIsMian]) {
        finfAlls = [VPNInfo bg_find:VPNREGISTER_TABNAME where:[NSString stringWithFormat:@"where %@=%d order by %@ desc",bg_sqlKey(@"isMainNet"),1,bg_sqlKey(@"bg_createTime")]];
    } else {
        finfAlls = [VPNInfo bg_find:VPNREGISTER_TABNAME where:[NSString stringWithFormat:@"where %@=%d or %@ isnull order by %@ desc",bg_sqlKey(@"isMainNet"),0,bg_sqlKey(@"isMainNet"),bg_sqlKey(@"bg_createTime")]];
    }
    
 
    //NSArray* finfAlls = [VPNInfo bg_findAll:VPNREGISTER_TABNAME];
    if (self.soureArray.count > 0) { // 更新keyChain
        [VPNOperationUtil saveArrayToKeyChain];
    }
    if (finfAlls && finfAlls.count > 0) {
        if (self.soureArray.count > 0) {
            [self.soureArray removeAllObjects];
        }
        [self.soureArray addObjectsFromArray:finfAlls];
        [_tableV reloadData];
        [self sendGetAssetsRequest];
    } else {
        [AppD.window showHint:NSStringLocalizable(@"no_assets")];
    }
}

#pragma -mark lazy
- (NSMutableArray *)soureArray
{
    if (!_soureArray) {
        _soureArray = [NSMutableArray array];
    }
    return _soureArray;
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



/**
 获取资产信息
 */
- (void) sendGetAssetsRequest
{
    
    [RequestService requestWithUrl:ssIdquerys_Url params:@{@"ssIds":[self getVPNNames]} httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        //[self hideHud];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSArray *dataArray = [responseObject objectForKey:Server_Data];
            if(dataArray)  {
                dataArray = [VPNInfo mj_objectArrayWithKeyValuesArray:dataArray];
                [self loadSuccessWithArray:dataArray];
            }
        } else {
            [AppD.window showHint:[responseObject objectForKey:@"msg"]];
        }
        
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        //[self hideHud];
      
        [AppD.window showHint:NSStringLocalizable(@"request_error")];
    }];
}

- (void) loadSuccessWithArray:(NSArray *) array
{
    @weakify_self
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VPNInfo *mode = (VPNInfo *) obj;
        [weakSelf changeVPNQlcWithVPNInfo:mode];
    }];
    [_tableV reloadData];
}

- (void) changeVPNQlcWithVPNInfo:(VPNInfo *) info
{
    [self.soureArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VPNInfo *mode = (VPNInfo *) obj;
        if ([mode.vpnName isEqualToString:info.ssId]) {
            mode.qlc = info.qlc;
            mode.registerQlc = info.registerQlc;
            *stop = YES;
        }
    }];
}

- (NSArray *) getVPNNames
{
    __block NSString *vpnNames = @"";
    @weakify_self
    [self.soureArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VPNInfo *mode = (VPNInfo *) obj;
        vpnNames = [vpnNames stringByAppendingString:mode.vpnName];
        if (idx != weakSelf.soureArray.count-1) {
            vpnNames = [vpnNames stringByAppendingString:@","];
        }
    }];
    return [vpnNames componentsSeparatedByString:@","];
}
@end
