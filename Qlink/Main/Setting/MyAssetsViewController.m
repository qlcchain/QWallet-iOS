//
//  MyAssetsViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2018/5/30.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "MyAssetsViewController.h"
#import "MyAssetsView.h"

@interface MyAssetsViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic , strong) MyAssetsView *assetsView;
@end

@implementation MyAssetsViewController
- (IBAction)clickBack:(id)sender {
    [self leftNavBarItemPressedWithPop:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_backView addSubview:self.assetsView];
}

- (MyAssetsView *)assetsView
{
    if (!_assetsView) {
        _assetsView = [MyAssetsView getNibView];
        _assetsView.frame = _backView.bounds;
        _assetsView.cancelContraintH.constant = 0;
        _assetsView.cancelContraintTop.constant = 0;
        _assetsView.cancelContraintBottom = 0;
    }
    return _assetsView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
