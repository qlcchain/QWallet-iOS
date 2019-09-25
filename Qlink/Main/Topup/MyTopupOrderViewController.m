//
//  MyTopupOrderViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MyTopupOrderViewController.h"
#import "MyTopupOrderCell.h"

@interface MyTopupOrderViewController () <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation MyTopupOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:MyTopupOrderCellReuse bundle:nil] forCellReuseIdentifier:MyTopupOrderCellReuse];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MyTopupOrderCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return _sourceArr.count;
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTopupOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:MyTopupOrderCellReuse];
    
    return cell;
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
