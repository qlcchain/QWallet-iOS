//
//  GuidePageViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2018/6/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "GuidePageViewController.h"
#import "GuidePageView1.h"
#import "GuidePageView2.h"
#import "GuidePageView3.h"

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
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT);
    [self.view addSubview:_mainScrollView];
    
    [self addGuidePageView];
}

// 添加引导页
- (void) addGuidePageView {
    GuidePageView1 *page1 = [GuidePageView1 loadGuidePageView1];
    page1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    GuidePageView2 *page2 = [GuidePageView2 loadGuidePageView2];
    page2.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    GuidePageView3 *page3 = [GuidePageView3 loadGuidePageView3];
    page3.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [page3.gotBtn addTarget:self action:@selector(clickGotit:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainScrollView addSubview:page1];
    [_mainScrollView addSubview:page2];
    [_mainScrollView addSubview:page3];
}
// 开始
- (void) clickGotit:(UIButton *) sender
{
    [AppD addLaunchAnimation];
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
