//
//  PasswordManagementViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/15.
//  Copyright © 2018 pan. All rights reserved.
//

#import "PasswordManagementViewController.h"
#import "ResetPWViewController.h"
#import "ConfigUtil.h"

@interface PasswordManagementViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *touchSwitch;

@end

@implementation PasswordManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    _touchSwitch.on = [ConfigUtil getLocalTouch];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchSwitchAction:(UISwitch *)sender {
    [ConfigUtil setLocalTouch:sender.on];
}

- (IBAction)pwSettingsAction:(id)sender {
    [self jumpToResetPW];
}

#pragma mark - Transition
- (void)jumpToResetPW {
    ResetPWViewController *vc = [[ResetPWViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
