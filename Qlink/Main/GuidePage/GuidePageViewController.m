//
//  GuidePageViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2018/6/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "GuidePageViewController.h"
#import "GuidePageView1.h"

@interface GuidePageViewController ()

@property (nonatomic ,strong) UIScrollView *mainScrollView;

@end

@implementation GuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _mainScrollView.bounces = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.backgroundColor = [UIColor clearColor];
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:_mainScrollView];
    
    [self addGuidePageView];
}

// 添加引导页
- (void) addGuidePageView {
    GuidePageView1 *page1 = [GuidePageView1 loadGuidePageView1];
    page1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [page1.startBtn addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainScrollView addSubview:page1];
}

// 开始
- (void)startAction:(UIButton *)sender {
    [kAppD addLaunchAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
