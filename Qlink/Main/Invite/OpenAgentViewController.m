//
//  OpenAgentViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/1/9.
//  Copyright © 2020 pan. All rights reserved.
//

#import "OpenAgentViewController.h"
#import "UIView+Gradient.h"

@interface OpenAgentViewController ()

@property (weak, nonatomic) IBOutlet UIView *personBack;

@end

@implementation OpenAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
    [_personBack addQGradientWithStart:UIColorFromRGB(0x4986EE) end:UIColorFromRGB(0x4752E9) frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
