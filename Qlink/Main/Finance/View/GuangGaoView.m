//
//  GuangGaoView.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/16.
//  Copyright © 2019 pan. All rights reserved.
//

#import "GuangGaoView.h"
#import <TYCyclePagerView/TYCyclePagerView.h>
#import <TYCyclePagerView/TYPageControl.h>
#import "GuangGaoCollectionCell.h"
#import "ShareFriendsModel.h"

@interface GuangGaoView () <TYCyclePagerViewDelegate,TYCyclePagerViewDataSource>

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation GuangGaoView

+ (instancetype)getInstance {
    GuangGaoView *view = [[[NSBundle mainBundle] loadNibNamed:@"GuangGaoView" owner:self options:nil] lastObject];
    view.sourceArr = [NSMutableArray array];
    [view addPagerView];
    [view addPageControl];
    return view;
}

- (void)addPagerView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
    pagerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    pagerView.layer.borderWidth = 1;
    pagerView.isInfiniteLoop = YES;
    pagerView.autoScrollInterval = 5.0;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    // registerClass or registerNib
    [pagerView registerNib:[UINib nibWithNibName:GuangGaoCollectionCellReuse bundle:nil] forCellWithReuseIdentifier:GuangGaoCollectionCellReuse];
    [self addSubview:pagerView];
    kWeakSelf(self)
    [pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(weakself).offset(0);
    }];
    _pagerView = pagerView;
}

- (void)addPageControl {
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    pageControl.frame = CGRectMake(0, CGRectGetHeight(_pagerView.frame) - 26, CGRectGetWidth(_pagerView.frame), 26);
    //pageControl.numberOfPages = _datas.count;
    pageControl.currentPageIndicatorSize = CGSizeMake(6, 6);
    pageControl.pageIndicatorSize = CGSizeMake(12, 6);
    pageControl.currentPageIndicatorTintColor = [UIColor mainColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    //    pageControl.pageIndicatorImage = [UIImage imageNamed:@"Dot"];
    //    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"DotSelected"];
    //    pageControl.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    //    pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //    pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    [pageControl addTarget:self action:@selector(pageControlValueChangeAction:) forControlEvents:UIControlEventValueChanged];
    [_pagerView addSubview:pageControl];
    kWeakSelf(self)
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakself.pagerView).offset(0);
        make.bottom.mas_equalTo(weakself.pagerView).offset(0);
        make.height.mas_equalTo(@26);
    }];
    _pageControl = pageControl;
}

- (void)configData:(NSArray *)arr {
    [_sourceArr removeAllObjects];
    [_sourceArr addObjectsFromArray:arr];
    _pageControl.numberOfPages = _sourceArr.count;
    [_pagerView reloadData];
    //[_pagerView scrollToItemAtIndex:3 animate:YES];
}

//- (void)loadData {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSMutableArray *datas = [NSMutableArray array];
//        for (int i = 0; i < 5; ++i) {
//            if (i == 0) {
//                [datas addObject:[UIColor redColor]];
//                continue;
//            }
//            [datas addObject:[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:arc4random()%255/255.0]];
//        }
//        _datas = [datas copy];
//        _pageControl.numberOfPages = _datas.count;
//        [_pagerView reloadData];
//    });
//}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return _sourceArr.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    GuangGaoCollectionCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:GuangGaoCollectionCellReuse forIndex:index];
    
    GuanggaoListModel *model = _sourceArr[index];
    [cell configCell:model];
    
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
//    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame)*0.8, CGRectGetHeight(pageView.frame)*0.8);
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 0;
    //layout.minimumAlpha = 0.3;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
//    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
}

- (void)pageControlValueChangeAction:(TYPageControl *)sender {
    NSLog(@"pageControlValueChangeAction: %ld",sender.currentPage);
}

@end
