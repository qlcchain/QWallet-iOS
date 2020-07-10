//
//  LFAdvertScrollView.m
//  Qlink
//
//  Created by 旷自辉 on 2020/7/10.
//  Copyright © 2020 pan. All rights reserved.
//

#import "LFAdvertScrollView.h"
#import "cycleCell.h"
#import "DefiTokenModel.h"
#import "NSString+RemoveZero.h"
#import "GlobalConstants.h"

#define YYMaxSections 100

@interface LFAdvertScrollView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) UIPageControl *pageControl;
@property (nonatomic , strong) NSMutableArray *newses;
@property (nonatomic , strong) NSTimer *timer;

@end

@implementation LFAdvertScrollView

- (instancetype) initWithFrame:(CGRect)frame withDataSuources:(NSArray *) models
{
    if (self = [super initWithFrame:frame]) {
        [self.newses addObjectsFromArray:models];
        [self loadColletionView];
    }
    return self;
}

- (NSMutableArray *)newses
{
    if (!_newses) {
        _newses = [NSMutableArray array];
    }
    return _newses;
}

- (void) loadColletionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:collectionView];
    
    _collectionView=collectionView;
    
    [self.collectionView registerNib:[UINib nibWithNibName:cycleCell_Reuse bundle:nil] forCellWithReuseIdentifier:cycleCell_Reuse];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:YYMaxSections/2] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    
     [self addTimer];
}

#pragma mark 添加定时器
-(void) addTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer ;
    
}

#pragma mark 删除定时器
-(void) removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

-(void) nextpage{
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];

    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:YYMaxSections/2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionTop animated:NO];

    NSInteger nextItem = currentIndexPathReset.item +1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem==self.newses.count) {
        nextItem=0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];

    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return YYMaxSections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.newses.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    cycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cycleCell_Reuse forIndexPath:indexPath];
    DefiTokenModel *model = self.newses[indexPath.item];
    cell.lblSysbol.text = model.symbol;
    cell.lblPrice.text = [@"$" stringByAppendingString:[NSString stringWithFormat:@"%.4f",[model.price doubleValue]]];
    cell.lblZF.text = [[NSString stringWithFormat:@"%.4f",[model.percentChange24h doubleValue]] stringByAppendingString:@"%"];
    
    cell.lblZF.textColor = [model.percentChange24h isBiggerAndEqual:@"0"]?UIColorFromRGB(0x07CDB3):UIColorFromRGB(0xFF3669);
    cell.zfIcon.image = [model.percentChange24h isBiggerAndEqual:@"0"]?[UIImage imageNamed:@"icon_arrow_up"]:[UIImage imageNamed:@"icon_arrow_down"];
    return cell;
}


-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

#pragma mark 当用户停止的时候调用
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
    
}

#pragma mark 设置页码
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = (int) (scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%self.newses.count;
    self.pageControl.currentPage =page;
}

-(NSString *)controllerTitle{
    return @"无限轮播";
}
@end
