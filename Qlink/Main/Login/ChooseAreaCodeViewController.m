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
    
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CountryCode" ofType:@"json"]];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    arr = [AreaCodeModel mj_objectArrayWithKeyValuesArray:arr];
    [_sourceArr addObjectsFromArray:arr];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return  _sourceArr ? _sourceArr.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ChooseAreaCodeCell_Height;
}

//- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    NSLog(@"title = %@  index = %@",title,@(index));
//    return index;
//}

#pragma mark - UITableViewDataSource -
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseAreaCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:ChooseAreaCodeCellReuse];
    AreaCodeModel *model = _sourceArr[indexPath.row];
    [cell configCell:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (_chooseB) {
        AreaCodeModel *model = _sourceArr[indexPath.row];
        _chooseB(model);
    }
    [self backAction:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
