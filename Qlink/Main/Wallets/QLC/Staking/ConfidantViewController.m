//
//  ConfidantViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/8/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ConfidantViewController.h"

@interface ConfidantViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *securityCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation ConfidantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
    
}

#pragma mark - Action

- (IBAction)confirmAction:(id)sender {
    
}

@end
