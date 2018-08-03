//
//  RankingRuleViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/8/1.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "RankingRuleViewController.h"

@interface RankingRuleViewController ()

@end

@implementation RankingRuleViewController
- (IBAction)backAction:(id)sender {
    [self leftNavBarItemPressedWithPop:YES];
}
- (IBAction)jumpLink:(id)sender {
    // iOS 10打开url方式
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/winqdapp"] options:@{UIApplicationOpenURLOptionsOpenInPlaceKey:@"1"} completionHandler:^(BOOL success) {// 回调
        
        if (!success) {
            
        }
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
