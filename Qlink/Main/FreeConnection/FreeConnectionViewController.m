//
//  FreeConnectionViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/7/18.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "FreeConnectionViewController.h"
#import "FreeConnectionCell.h"
#import "SkyRadiusView.h"
#import "PopSelectView.h"
#import "UIView+Visuals.h"

@interface FreeConnectionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet SkyRadiusView *availableBack;
@property (weak, nonatomic) IBOutlet SkyRadiusView *tableBack;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UILabel *availableNumLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation FreeConnectionViewController

#pragma mark -Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configData];
    [self configView];
}

#pragma mark -Config
- (void)configData {
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:FreeConnectionCellReuse bundle:nil] forCellReuseIdentifier:FreeConnectionCellReuse];
}

- (void)configView {
    [_availableBack shadowWithColor:UIColorFromRGB(0x555555) offset:CGSizeMake(3, 3) opacity:0.5 radius:4];
    [_tableBack shadowWithColor:UIColorFromRGB(0x555555) offset:CGSizeMake(3, 3) opacity:0.5 radius:4];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FreeConnectionCell *cell = [tableView dequeueReusableCellWithIdentifier:FreeConnectionCellReuse];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FreeConnectionCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -Operation
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -Action
- (IBAction)backAciton:(id)sender {
    [self back];
}

- (IBAction)typeAction:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
