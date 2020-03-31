//
//  NewStakingViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/8/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "NewStakingViewController.h"
#import "NinaPagerView.h"
#import "TokenMintageViewController.h"
#import "ConfidantViewController.h"
#import "VotingMiningNodeViewController.h"
#import "StakingTypesViewController.h"


@interface NewStakingViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentBack;


@end

@implementation NewStakingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self setupNinaPage];
}

#pragma mark - Operation
- (void)setupNinaPage {
    VotingMiningNodeViewController *vc1 = [VotingMiningNodeViewController new];
//    ConfidantViewController *vc2 = [ConfidantViewController new];
    TokenMintageViewController *vc3 = [TokenMintageViewController new];
//    NSArray *titles = @[kLang(@"voting_mining_node"), @"Confidant", kLang(@"token_mintage")];
    NSArray *titles = @[kLang(@"voting_mining_node"), kLang(@"token_mintage")];
//    NSArray *objs = @[vc1, vc2, vc3];
    NSArray *objs = @[vc1, vc3];
    
    NinaPagerView *_ninaPageView = [[NinaPagerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) WithTitles:titles WithObjects:objs];
    _ninaPageView.unSelectTitleColor = UIColorFromRGB(0xB3B3B3);
    _ninaPageView.selectTitleColor = MAIN_BLUE_COLOR;
    _ninaPageView.titleFont = 14;
    _ninaPageView.titleScale = 1;
    _ninaPageView.selectBottomLinePer = 0.8;
    _ninaPageView.selectBottomLineHeight = 1;
    _ninaPageView.underlineColor = MAIN_BLUE_COLOR;
    _ninaPageView.underLineHidden = YES;
    _ninaPageView.topTabHeight = 44;
    _ninaPageView.nina_autoBottomLineEnable = YES;
    [_contentBack addSubview:_ninaPageView];
    kWeakSelf(self);
    [_ninaPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(weakself.contentBack).offset(0);
    }];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)questionAction:(id)sender {
    [self jumpToStakingTypes];
}


#pragma mark - Transition
- (void)jumpToStakingTypes {
    StakingTypesViewController *vc = [StakingTypesViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
