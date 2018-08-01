//
//  RankingViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/8/1.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "RankingViewController.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "RankingCell.h"
#import "RankingSubCell.h"
#import "RankingRuleViewController.h"

#define PAGE_PADDING 86
#define PAGE_HEIGHT 150//(SCREEN_WIDTH - PAGE_PADDING) * 9 / 16


@interface RankingViewController ()<NewPagedFlowViewDelegate,NewPagedFlowViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) NewPagedFlowView *pageFlowView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageFlowContraintH;
@property (weak, nonatomic) IBOutlet UIView *flowBackView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *myTabV;
@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.dataArray addObject:@"1"];
    [self.dataArray addObject:@"2"];
    [self.dataArray addObject:@"3"];
    
    [self loadPageView];
    //
    _myTabV.delegate = self;
    _myTabV.dataSource = self;
    [_myTabV registerNib:[UINib nibWithNibName:RankingCellReuse bundle:nil] forCellReuseIdentifier:RankingCellReuse];
    [_myTabV registerNib:[UINib nibWithNibName:RankingSubCellReuse bundle:nil] forCellReuseIdentifier:RankingSubCellReuse];

}

#pragma mark -init pageview
- (void) loadPageView {
    _pageFlowContraintH.constant = PAGE_HEIGHT + 28;
    _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, PAGE_HEIGHT)];
    _pageFlowView.backgroundColor = [UIColor clearColor];
    _pageFlowView.delegate = self;
    _pageFlowView.dataSource = self;
    _pageFlowView.minimumPageAlpha = 0.5;
    _pageFlowView.minimumPageScale = 0.9;
    _pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    [_pageFlowView reloadData];
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,14, SCREEN_WIDTH, PAGE_HEIGHT)];
    bottomScrollView.backgroundColor = [UIColor clearColor];
    [bottomScrollView addSubview:_pageFlowView];
    
    [_pageFlowView reloadData];
    [_flowBackView addSubview:bottomScrollView];
}

#pragma mark- layz
- (NSMutableArray *)dataArray
{
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        RankingCell *myCell = [tableView dequeueReusableCellWithIdentifier:RankingCellReuse];
        return myCell;
    } else {
        RankingSubCell *myCell = [tableView dequeueReusableCellWithIdentifier:RankingSubCellReuse];
        return myCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return RankingSubCell_Height;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(SCREEN_WIDTH - PAGE_PADDING, PAGE_HEIGHT);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);

}
#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.dataArray.count;
    
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH - PAGE_PADDING, PAGE_HEIGHT)];
    }
    bannerView.layer.cornerRadius = 5;
    bannerView.layer.masksToBounds = YES;
    //在这里下载网络图片
    //  [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
    bannerView.mainImageView.backgroundColor = MAIN_PURPLE_COLOR;
    
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self leftNavBarItemPressedWithPop:YES];
}
- (IBAction)rightAction:(id)sender {
    RankingRuleViewController *vc = [[RankingRuleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
