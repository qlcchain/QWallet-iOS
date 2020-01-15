//
//  AgentRewardViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/1/9.
//  Copyright © 2020 pan. All rights reserved.
//

#import "AgentRewardViewController.h"
#import "UIView+Gradient.h"
#import "OpenAgentViewController.h"

@interface AgentRewardViewController ()

@property (weak, nonatomic) IBOutlet UIView *personBack;

@property (weak, nonatomic) IBOutlet UILabel *openLab;
@property (weak, nonatomic) IBOutlet UIView *openDelegateBtnBack;


@end

@implementation AgentRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
//    [_personBack addQGradientWithStart:UIColorFromRGB(0xF9BD5E) end:UIColorFromRGB(0xFC7D32) frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _openLab.layer.cornerRadius = 8;
    _openLab.layer.masksToBounds = YES;
//    [_openDelegateBtnBack addQGradientWithStart:UIColorFromRGB(0xFE6B4B) end:UIColorFromRGB(0xFC5140) frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _openDelegateBtnBack.layer.cornerRadius = 20;
    _openDelegateBtnBack.layer.masksToBounds = YES;
    
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)openDelegateAction:(id)sender {
    [self jumpToOpenDelegate];
}


#pragma mark - Transition
- (void)jumpToOpenDelegate {
    OpenAgentViewController *vc = [OpenAgentViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
