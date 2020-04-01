//
//  ChooseAreaCodeViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/9.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ChooseAreaCodeViewController.h"
#import "ChooseAreaCodeCell.h"
#import "AreaCodeModel.h"
#import "NSString+PinYin.h"

@interface ChooseAreaCodeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation ChooseAreaCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self dataInit];
}

#pragma mark - Operation
- (void)dataInit {
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:ChooseAreaCodeCellReuse bundle:nil] forCellReuseIdentifier:ChooseAreaCodeCellReuse];
    self.baseTable = _mainTable;
    
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CountryCode" ofType:@"json"]];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    arr = [AreaCodeModel mj_objectArrayWithKeyValuesArray:arr];
    arr = [arr areaCodeModelArrayWithPinYinFirstLetterFormat];
    [_sourceArr addObjectsFromArray:arr];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return  [_sourceArr[section][@"content"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ChooseAreaCodeCell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dict in _sourceArr) {
        NSString *title = dict[@"firstLetter"];
        if (title) {
            [resultArray addObject:title];
        }
    }
    return resultArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSLog(@"title = %@  index = %@",title,@(index));
    return index;
}

#pragma mark - UITableViewDataSource -
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseAreaCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:ChooseAreaCodeCellReuse];
    AreaCodeModel *model = _sourceArr[indexPath.section][@"content"][indexPath.row];
    [cell configCell:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (_chooseB) {
        AreaCodeModel *model = _sourceArr[indexPath.section][@"content"][indexPath.row];
        _chooseB(model);
    }
    [self backAction:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
