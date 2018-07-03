//
//  ChooseContinentViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "ChooseContinentViewController.h"
#import "ChooseCountryViewController.h"

@interface ChooseContinentViewController ()

@property (nonatomic, strong) NSString *selectContinent;
@property (weak, nonatomic) IBOutlet UILabel *continentLab;
@property (weak, nonatomic) IBOutlet UIImageView *continentImgV;

@end

@implementation ChooseContinentViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configView:_inputContinent?:ASIA_CONTINENT];
}

#pragma mark - Operation

- (void)configView:(NSString *)continent {
    _selectContinent = continent;
    _continentLab.text = _selectContinent.uppercaseString;
    _continentImgV.image = [UIImage imageNamed:[@"bg_map_" stringByAppendingString:continent]];
}

- (void)jumpToChooseCountry {
    ChooseCountryViewController *vc = [[ChooseCountryViewController alloc] init];
    vc.continent = _selectContinent;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backAction:(id)sender {
    [self back];
}

- (IBAction)asiaAction:(id)sender {
    [self configView:ASIA_CONTINENT];
}

- (IBAction)oceaniaAction:(id)sender {
    [self configView:OCEANIA_CONTINENT];
}

- (IBAction)africaAction:(id)sender {
    [self configView:AFRICA_CONTINENT];
}

- (IBAction)southamericaAction:(id)sender {
    [self configView:SOUTHAMERICA_CONTINENT];
}

- (IBAction)northamericaAction:(id)sender {
    [self configView:NORTHAMERICA_CONTINENT];
}

- (IBAction)europeAction:(id)sender {
    [self configView:EUROPE_CONTINENT];
}

- (IBAction)continueAction:(id)sender {
    [self jumpToChooseCountry];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
