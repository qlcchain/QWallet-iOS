//
//  TopupViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TopupViewController.h"
#import "TopupCell.h"

@interface TopupViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation TopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:TopupCellReuse bundle:nil] forCellReuseIdentifier:TopupCellReuse];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TopupCell_Height;
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
    TopupCell *cell = [tableView dequeueReusableCellWithIdentifier:TopupCellReuse];
    
    return cell;
}

#pragma mark - Action

- (IBAction)menuAction:(id)sender {
    
}

- (IBAction)inputNumAction:(id)sender {
    
}

- (IBAction)makeQGASAction:(id)sender {
    
}


@end
