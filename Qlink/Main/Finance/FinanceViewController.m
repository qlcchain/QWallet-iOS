//
//  FinanceViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/8.
//  Copyright © 2019 pan. All rights reserved.
//

#import "FinanceViewController.h"
#import "MyThemes.h"

@interface FinanceViewController ()

@end

@implementation FinanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.theme_backgroundColor = globalBackgroundColorPicker;
}

#pragma mark - Action

- (IBAction)switchThemeAction:(id)sender {
    [MyThemes switchToNext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
