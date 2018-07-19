//
//  PopSelectView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/7/18.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "PopSelectView.h"

@interface PopSelectView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSArray *sourceArr;
@property (nonatomic , assign) NSInteger currentRow;
@end

@implementation PopSelectView

+ (instancetype)getInstance {
    PopSelectView *view = [[[NSBundle mainBundle] loadNibNamed:@"PopSelectView" owner:self options:nil] firstObject];
    [view config];
    return view;
}



- (void)config {
    _sourceArr = @[@"ALL",@"Gain",@"Used"];
    _currentRow = 0;
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuse = @"reuseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
        cell.textLabel.textColor = RGB(51, 51, 51);
    }
    
    cell.textLabel.text = _sourceArr[indexPath.row];
    
    return cell;
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 38;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_currentRow == indexPath.row) {
        if (self.clickCellBlock) {
            self.clickCellBlock(_sourceArr[indexPath.row],-1);
        }
        return;
    }
    _currentRow = indexPath.row;
    if (self.clickCellBlock) {
        self.clickCellBlock(_sourceArr[indexPath.row],indexPath.row);
    }
}

- (void) showSelectView {
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1.0f;
    }];
}

- (void) hideSelectView {
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
