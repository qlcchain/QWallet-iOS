//
//  MoreViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/19.
//  Copyright © 2018 pan. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsCell.h"
#import "ChooseCurrencyViewController.h"
#import "ResetPWViewController.h"
#import "PasswordManagementViewController.h"
#import "WalletsManageViewController.h"
#import "JoinCommunityViewController.h"
#import "WebViewController.h"
#import "UserModel.h"
//#import "GlobalConstants.h"
#import "SystemUtil.h"

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation SettingsViewController

#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currencyChang:) name:Currency_Change_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeNoti:) name:kLanguageChangeNoti object:nil];
}

#pragma mark - Life Cycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self addObserve];
    
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:SettingsCellReuse bundle:nil] forCellReuseIdentifier:SettingsCellReuse];
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
    _titleLab.text = kLang(@"settings");
    [_sourceArr removeAllObjects];
    NSMutableArray *titleArr = [NSMutableArray arrayWithArray:@[kLang(@"currency_unit"),kLang(@"service_agreement"),kLang(@"help_and_feedback"),kLang(@"about_my_qwallet"),kLang(title_screen_lock),kLang(@"language")]];
    if ([UserModel haveLoginAccount]) {
        [titleArr addObject:kLang(@"log_out")];
    }
    kWeakSelf(self);
    [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SettingsShowModel *model = [[SettingsShowModel alloc] init];
        model.title = obj;
        if ([obj isEqualToString:kLang(title_screen_lock)]) {
            model.haveNextPage = NO;
            model.showSwitch = YES;
        } else {
            model.haveNextPage = YES;
            model.showSwitch = NO;
        }
        if ([obj isEqualToString:kLang(@"currency_unit")]) {
            model.detail = [ConfigUtil getLocalUsingCurrency];
        } else if ([obj isEqualToString:kLang(@"about_my_qwallet")]) {
            model.detail = [NSString stringWithFormat:@"Version %@(%@)",APP_Version,APP_Build];
        } else if ([obj isEqualToString:kLang(@"language")]) {
            NSString *language = [Language currentLanguageCode];
            model.detail = [language isEmptyString]?kLang(@"chinese"):[language isEqualToString:LanguageCode[0]]?kLang(@"english"):kLang(@"chinese");
        } else {
            model.detail = nil;
        }
        [weakself.sourceArr addObject:model];
    }];
    [_mainTable reloadData];
}

- (void)refreshDataWithTitle:(NSString *)title detail:(NSString *)detail {
//    kWeakSelf(self);
    [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SettingsShowModel *model = obj;
        if ([model.title isEqualToString:title]) {
            model.detail = detail;
            *stop = YES;
        }
    }];
    [_mainTable reloadData];
}

- (void)logout {
    kWeakSelf(self);
    [SystemUtil requestLogout:^{
        [weakself.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)showSelectLanguage {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:kLang(@"english") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [Language userSelectedLanguage:LanguageCode[0]];
    }];
    [alertVC addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:kLang(@"chinese") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [Language userSelectedLanguage:LanguageCode[1]];
    }];
    [alertVC addAction:action2];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:action3];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SettingsCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SettingsShowModel *model = _sourceArr[indexPath.row];
//    if ([model.title isEqualToString:title0]) {
//        [self jumpToPWManagement];
//    } else
    if ([model.title isEqualToString:kLang(@"currency_unit")]) {
        [self jumpToChooseCurrency];
    } else if ([model.title isEqualToString:kLang(@"service_agreement")]) {
        NSString *url = @"https://docs.google.com/document/d/1yTr1EDXmOclDuSt4o0RRUc0fVjJU3zPREK97C1RmYdI/edit?usp=sharing";
        [self jumpToWeb:url title:kLang(@"service_agreement")];
    } else if ([model.title isEqualToString:kLang(@"log_out")]) {
        [self logout];
    } else if ([model.title isEqualToString:kLang(@"language")]) {
        [self showSelectLanguage];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:SettingsCellReuse];
    
    SettingsShowModel *model = _sourceArr[indexPath.row];
    [cell configCellWithModel:model];
    
    return cell;
}

#pragma mark - Transition
- (void)jumpToChooseCurrency {
    ChooseCurrencyViewController *vc = [[ChooseCurrencyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToPWManagement {
    PasswordManagementViewController *vc = [[PasswordManagementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)jumpToWalletsManage {
//    WalletsManageViewController *vc = [[WalletsManageViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

//- (void)jumpToJoinCommunity {
//    JoinCommunityViewController *vc = [[JoinCommunityViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)jumpToWeb:(NSString *)url title:(NSString *)title {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.inputUrl = url;
    vc.inputTitle = title;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Noti
- (void)currencyChang:(NSNotification *)noti {
    [self refreshDataWithTitle:kLang(@"currency_unit") detail:[ConfigUtil getLocalUsingCurrency]];
}

- (void)languageChangeNoti:(NSNotification *)noti {
    [self configInit];
}

@end
