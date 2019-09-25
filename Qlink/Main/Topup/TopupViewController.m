//
//  TopupViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TopupViewController.h"
#import "TopupCell.h"
#import "MyThemes.h"
#import "UIColor+Random.h"
#import <SwiftTheme/SwiftTheme-Swift.h>
#import "UIView+Gradient.h"
#import "MyTopupOrderViewController.h"
#import "ChooseTopupPlanViewController.h"
#import "TopupWebViewController.h"

@interface TopupViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topGradientBack;
@property (weak, nonatomic) IBOutlet UIView *sendTopupBack;
@property (weak, nonatomic) IBOutlet UIView *numBack;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation TopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.theme_backgroundColor = globalBackgroundColorPicker;
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
    [_topGradientBack addQGradientWithStart:UIColorFromRGB(0x4986EE) end:UIColorFromRGB(0x4752E9) frame:CGRectMake(_topGradientBack.left, _topGradientBack.top, SCREEN_WIDTH, _topGradientBack.height)];
    
    _numBack.layer.cornerRadius = 8;
    _numBack.layer.masksToBounds = YES;
    _numBack.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    _numBack.layer.borderWidth = 1;
    _sendTopupBack.layer.cornerRadius = 6;
    _sendTopupBack.layer.masksToBounds = YES;
    
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:TopupCellReuse bundle:nil] forCellReuseIdentifier:TopupCellReuse];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TopupCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self jumpToChooseTopupPlan];
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
    [self jumpToMyTopupOrder];
}

- (IBAction)inputNumAction:(id)sender {
//    [self jumpToChooseTopupPlan];
    [self jumpToTopupWeb];
}

- (IBAction)makeQGASAction:(id)sender {
    [kAppD jumpToWallet];
}

#pragma mark - Transition
- (void)jumpToMyTopupOrder {
    MyTopupOrderViewController *vc = [MyTopupOrderViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToChooseTopupPlan {
    ChooseTopupPlanViewController *vc = [ChooseTopupPlanViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToTopupWeb {
    NSURL *url = [NSURL URLWithString:@"https://shop.huagaotx.cn/wap/charge_v3.html?sid=8a51FmcnWGH-j2F-g9Ry2KT4FyZ_Rr5xcKdt7i96&trace_id=mm_1000001_998902&package=0&mobile=15989246851"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
    
//    TopupWebViewController *vc = [TopupWebViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
}


@end
