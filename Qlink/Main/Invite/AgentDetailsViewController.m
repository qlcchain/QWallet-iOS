//
//  AgentDetailsViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/1/17.
//  Copyright © 2020 pan. All rights reserved.
//

#import "AgentDetailsViewController.h"
#import "UIView+Gradient.h"

@interface AgentDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIView *topBack;

@end

@implementation AgentDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
    [_topBack addVerticalQGradientWithStart:UIColorFromRGB(0xF9BD5E) end:UIColorFromRGB(0xFC7D32) frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
