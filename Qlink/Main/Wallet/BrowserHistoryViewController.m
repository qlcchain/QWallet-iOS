//
//  BrowserHistoryViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2020/10/27.
//  Copyright © 2020 pan. All rights reserved.
//

#import "BrowserHistoryViewController.h"
#import "Qlink-Swift.h"
#import <ETHFramework/ETHFramework.h>
#import "WalletCommonModel.h"
#import "NSString+Trim.h"
#import "UrlCell.h"
#import "WalletSelectViewController.h"
#import "QNavigationController.h"
#import "NSString+RegexCategory.h"

@interface BrowserHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *serarchTF;
@property (weak, nonatomic) IBOutlet UIView *searchBackView;
@property (weak, nonatomic) IBOutlet UITableView *mainTabView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BrowserHistoryViewController

#pragma mark -------layz
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        // 取得沙河中的路径
        NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        // 新增文件路径（在后续的操作中如发现没有，会自动创建）
        NSString *dataPath = [docPath stringByAppendingPathComponent:@"url_data.plist"];
        NSArray *urls = [NSArray arrayWithContentsOfFile:dataPath];
        [_dataArray addObjectsFromArray:urls];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchBackView.layer.cornerRadius = 4.0f;
    
    _serarchTF.returnKeyType = UIReturnKeySearch; //设置按键类型
    _serarchTF.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    _serarchTF.delegate = self;
    
    _mainTabView.delegate = self;
    _mainTabView.dataSource = self;
    _mainTabView.scrollEnabled = NO;
    [_mainTabView registerNib:[UINib nibWithNibName:UrlCellReuse bundle:nil] forCellReuseIdentifier:UrlCellReuse];
    
    [self performSelector:@selector(showKeyBord) withObject:self afterDelay:0.7];
}


- (void) showKeyBord
{
    [_serarchTF becomeFirstResponder];
}


- (IBAction)cancleAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---------uitableview delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UrlCelllHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UrlCell *cell = [tableView dequeueReusableCellWithIdentifier:UrlCellReuse];
    cell.tag = indexPath.row;
    cell.lblName.text = self.dataArray[indexPath.row];
    
    kWeakSelf(self)
    [cell setClearBlock:^(NSInteger tag) {
        [weakself.dataArray removeObjectAtIndex:tag];
        // 取得沙河中的路径
        NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        // 新增文件路径（在后续的操作中如发现没有，会自动创建）
        NSString *dataPath = [docPath stringByAppendingPathComponent:@"url_data.plist"];
        [weakself.dataArray writeToFile:dataPath atomically:YES];
        [weakself.mainTabView reloadData];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM && currentWalletM.walletType == WalletTypeETH) {
        [self gotoBrowserWithUrl:self.dataArray[indexPath.row] withAddress:currentWalletM.address];
    } else {
        [self jumpSelectWalletVCWithUrl:self.dataArray[indexPath.row]];
    }
   
}

- (void) jumpSelectWalletVCWithUrl:(NSString *) urlString {
    kWeakSelf(self);
    WalletSelectViewController *vc = [[WalletSelectViewController alloc] init];
    vc.inputWalletType = WalletTypeETH;
       
    [vc configSelectBlock:^(WalletCommonModel * _Nonnull model) {
        [WalletCommonModel setCurrentSelectWallet:model];
        [weakself gotoBrowserWithUrl:urlString withAddress:model.address];
    }];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark ---------textfeild
 //点击UITextField--Return响应事件

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField.text && [textField.text trim_whitespace].length > 0) {
         WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
         if (currentWalletM && currentWalletM.walletType == WalletTypeETH) {
             [self gotoBrowserWithUrl:textField.text withAddress:currentWalletM.address];
         } else {
             [self jumpSelectWalletVCWithUrl:textField.text];
         }
    } else {
        [kAppD.window makeToastDisappearWithText:@"url is null"];
    }
    
    
    return YES;
}

- (void) gotoBrowserWithUrl:(NSString *) url withAddress:(NSString *) address
{
    if (url && [url trim_whitespace].length > 0) {
        
        
        if (![url hasPrefix:@"https://"] && ![url hasPrefix:@"http://"]) {
            url = [@"https://" stringByAppendingString:url];
        }
        if (![url isValidUrl]) {
            [kAppD.window makeToastDisappearWithText:@"url is invalid"];
            return;
        }
        
        BrowserViewController *vc  = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];
        
        
        
        BOOL isexit = NO;
        for (NSString *urlStr in self.dataArray) {
            if ([urlStr isEqualToString:url]) {
                isexit = YES;
                break;
            }
        }
        if (!isexit) {
            [self.dataArray insertObject:url atIndex:0];
            if (self.dataArray.count > 10) {
                [self.dataArray removeLastObject];
            }
            // 取得沙河中的路径
            NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            // 新增文件路径（在后续的操作中如发现没有，会自动创建）
            NSString *dataPath = [docPath stringByAppendingPathComponent:@"url_data.plist"];
            [self.dataArray writeToFile:dataPath atomically:YES];
            [_mainTabView reloadData];
        }
        
        vc.defaultAddress = address;
        vc.websitUrl = url;
        vc.navTitleString = url;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [kAppD.window makeToastDisappearWithText:@"url is null"];
    }
}
@end
