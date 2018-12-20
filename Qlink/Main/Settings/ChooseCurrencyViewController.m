//
//  ChooseCurrencyViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/31.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ChooseCurrencyViewController.h"
#import "ChooseCurrencyCell.h"
#import "ConfigUtil.h"

@interface ChooseCurrencyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) NSString *selectCurrency;

@end

@implementation ChooseCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    _selectCurrency = [ConfigUtil getLocalUsingCurrency];
     _sourceArr = [NSMutableArray array];
    [_sourceArr addObjectsFromArray:[ConfigUtil getLocalCurrencyArr]];
    [_mainTable registerNib:[UINib nibWithNibName:ChooseCurrencyCellReuse bundle:nil] forCellReuseIdentifier:ChooseCurrencyCellReuse];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ChooseCurrencyCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *currency = _sourceArr[indexPath.row];
    [ConfigUtil setLocalUsingCurrency:currency];
    [_mainTable reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:Currency_Change_Noti object:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseCurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:ChooseCurrencyCellReuse];
    
    NSString *currency = _sourceArr[indexPath.row];
    [cell configCellWithCurrency:currency ];
    
    return cell;
}

@end
