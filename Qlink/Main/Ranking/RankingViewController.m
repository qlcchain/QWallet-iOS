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
#import "PageOneView.h"
#import "PageThreeView.h"
#import "RefreshTableView.h"
#import "RankingMode.h"
#import "NewRankView.h"
#import "VPNRankMode.h"
#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"

#define PAGE_PADDING 86
#define PAGE_HEIGHT 150//(SCREEN_WIDTH - PAGE_PADDING) * 9 / 16


@interface RankingViewController ()<NewPagedFlowViewDelegate,NewPagedFlowViewDataSource,UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate>
@property (nonatomic ,strong) NewPagedFlowView *pageFlowView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageFlowContraintH;
@property (weak, nonatomic) IBOutlet UIView *flowBackView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) NSMutableArray *sourceArray;
@property (weak, nonatomic) IBOutlet RefreshTableView *myTabV;
//@property (strong, nonatomic) RefreshTableView *mainTable;
@property (nonatomic ,strong) NSString *currentTime;
@property (nonatomic ,strong) RankingMode *currentRank;

@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取活动列表接口
    [self sendQueryActsRequest];
    _myTabV.delegate = self;
    _myTabV.dataSource = self;
    _myTabV.slimeView.delegate = self;
    [_myTabV registerNib:[UINib nibWithNibName:RankingCellReuse bundle:nil] forCellReuseIdentifier:RankingCellReuse];
    [_myTabV registerNib:[UINib nibWithNibName:RankingSubCellReuse bundle:nil] forCellReuseIdentifier:RankingSubCellReuse];

}

#pragma mark -init pageview
- (void) loadPageView {
    _pageFlowContraintH.constant = PAGE_HEIGHT + 28;
    
    _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0,14, SCREEN_WIDTH, PAGE_HEIGHT)];
    _pageFlowView.delegate = self;
    _pageFlowView.dataSource = self;
    _pageFlowView.minimumPageAlpha = 0.8;
    _pageFlowView.isCarousel = NO;
    _pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    _pageFlowView.isOpenAutoScroll = YES;
    
    [_pageFlowView reloadData];
    
    [_flowBackView addSubview:_pageFlowView];
    
//    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,14, SCREEN_WIDTH, PAGE_HEIGHT)];
//    bottomScrollView.backgroundColor = [UIColor clearColor];
//    [bottomScrollView addSubview:_pageFlowView];
//
//    [_pageFlowView reloadData];
//    [_flowBackView addSubview:bottomScrollView];
}

#pragma mark- layz
- (NSMutableArray *)dataArray
{
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)sourceArray
{
    if(!_sourceArray) {
        _sourceArray = [NSMutableArray array];
    }
    return _sourceArray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentRank && [self.currentRank.actStatus isEqualToString:@"NEW"]) {
        return 0;
    }
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentRank.actStatus isEqualToString:@"END"] || [self.currentRank.actStatus isEqualToString:@"PRIZED"]) {
        
        RankingCell *myCell = [tableView dequeueReusableCellWithIdentifier:RankingCellReuse];
        if (indexPath.row == 0) {
            myCell.lblNumber.hidden = YES;
            myCell.trophyImgView.hidden = NO;
        } else {
            myCell.lblNumber.hidden = NO;
            myCell.trophyImgView.hidden = YES;
        }
        [myCell setVPNRankMode:self.sourceArray[indexPath.row] withType:self.currentRank.actStatus];
        myCell.lblNumber.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        return myCell;
    } else if ([self.currentRank.actStatus isEqualToString:@"START"]){
        if (indexPath.row == 0) {
            RankingCell *myCell = [tableView dequeueReusableCellWithIdentifier:RankingCellReuse];
            if (indexPath.row == 0) {
                myCell.lblNumber.hidden = YES;
                myCell.trophyImgView.hidden = NO;
            }
            [myCell setVPNRankMode:self.sourceArray[indexPath.row] withType:self.currentRank.actStatus];
             return myCell;
        } else {
            RankingSubCell *myCell = [tableView dequeueReusableCellWithIdentifier:RankingSubCellReuse];
             myCell.lblNumber.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
            [myCell setVPNRankMode:self.sourceArray[indexPath.row]];
            return myCell;
        }
    } else {
        
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return RankingSubCell_Height;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView{
    return CGSizeMake(SCREEN_WIDTH - PAGE_PADDING, PAGE_HEIGHT);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);

}
#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.dataArray.count;
    
}
- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    RankingMode *rankMode = [self.dataArray objectAtIndex:index];
    if ([rankMode.actStatus isEqualToString:@"END"] || [rankMode.actStatus isEqualToString:@"PRIZED"]) {
        PageThreeView *threeView = (PageThreeView *)[flowView dequeueReusableCell];
        if (!threeView) {
            threeView = [[[NSBundle mainBundle] loadNibNamed:@"PageThreeView" owner:self options:nil] lastObject];
            threeView.frame = CGRectMake(0,0, SCREEN_WIDTH - PAGE_PADDING, PAGE_HEIGHT);
            threeView.layer.cornerRadius = 5;
            threeView.layer.masksToBounds = YES;
            threeView.backgroundColor = MAIN_PURPLE_COLOR;
        }
        threeView.lblCountDesc.text = [NSString stringWithFormat:NSStringLocalizable(@"qlc_pool"),rankMode.actAmount?:@"0"];
        return threeView;
    } else if ([rankMode.actStatus isEqualToString:@"START"]){
        PageOneView *oneView = (PageOneView *)[flowView dequeueReusableCell];
        if (!oneView) {
            oneView = [[[NSBundle mainBundle] loadNibNamed:@"PageOneView" owner:self options:nil] lastObject];
            oneView.frame = CGRectMake(0,0, SCREEN_WIDTH - PAGE_PADDING, PAGE_HEIGHT);
            oneView.layer.cornerRadius = 5;
            oneView.layer.masksToBounds = YES;
            oneView.backgroundColor = MAIN_PURPLE_COLOR;
           NSDateFormatter *formatter = [NSDateFormatter defaultDateFormatter];
           NSDate *currentDate = [formatter dateFromString:_currentTime];
            NSDate *endDate = [formatter dateFromString:rankMode.actEndDate];
            // 秒时间戳
            NSInteger currentDateSceons = [NSDate getTimestampFromDate:currentDate];
            NSInteger endDateSceons = [NSDate getTimestampFromDate:endDate];
            [oneView statrtTimeCountdownWithSecons:endDateSceons-currentDateSceons];
        }
        oneView.lblNumber.text = rankMode.actAmount?:@"0";
        return oneView;
    } else {
        NewRankView *rankView = (NewRankView *)[flowView dequeueReusableCell];
        if (!rankView) {
            rankView = [[[NSBundle mainBundle] loadNibNamed:@"NewRankView" owner:self options:nil] lastObject];
            rankView.frame = CGRectMake(0,0, SCREEN_WIDTH - PAGE_PADDING, PAGE_HEIGHT);
            rankView.layer.cornerRadius = 5;
            rankView.layer.masksToBounds = YES;
            rankView.backgroundColor = MAIN_PURPLE_COLOR;
        }
        return rankView;
    }
    
    //  if ([rankMode.actStatus isEqualToString:@"NEW"])
}



- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    self.currentRank = self.dataArray[pageNumber];
    if (self.sourceArray.count > 0) {
        [self.sourceArray removeAllObjects];
        [_myTabV reloadData];
    }
    [self sendQueryVpnRankingsRequestWithActId:self.currentRank.actId];
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

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_myTabV.slimeView) {
        [_myTabV.slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_myTabV.slimeView) {
        [_myTabV.slimeView scrollViewDidEndDraging];
    }
}

#pragma mark - SRRefreshDelegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView {
    [self sendQueryVpnRankingsRequestWithActId:self.currentRank.actId];
}



#pragma mark - 请求数据方法
// 获取活动列表接口
- (void) sendQueryActsRequest {
    [self.view showHudInView:self.view hint:@"" userInteractionEnabled:YES hideTime:0];
    [RequestService requestWithUrl:queryActs_Url params:@{} httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
         [self.view hideHud];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
           _currentTime = [[responseObject objectForKey:Server_Data] objectForKey:@"currentDate"];
            NSArray *array = [[responseObject objectForKey:Server_Data] objectForKey:@"acts"];
            if (self.dataArray.count > 0) {
                [self.dataArray removeAllObjects];
            }
            if (array.count > 0) {
                [self.dataArray addObjectsFromArray:[RankingMode mj_objectArrayWithKeyValuesArray:array]];
                self.currentRank = self.dataArray[0];
                [self sendQueryVpnRankingsRequestWithActId:self.currentRank.actId];
                [self loadPageView];
            }
            
        } else {
             [AppD.window showHint:[responseObject objectForKey:@"msg"]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [AppD.window showHint:NSStringLocalizable(@"request_error")];
        [self.view hideHud];
    }];
}

- (void) sendQueryVpnRankingsRequestWithActId:(NSString *) actId {
    [RequestService requestWithUrl:queryVpnRankings_Url params:@{@"actId":actId} httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [_myTabV.slimeView endRefresh];
         if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
              NSArray *array = [[responseObject objectForKey:Server_Data] objectForKey:@"vpnRanking"];
             if (self.sourceArray.count > 0) {
                 [self.sourceArray removeAllObjects];
             }
             [self.sourceArray addObjectsFromArray:[VPNRankMode mj_objectArrayWithKeyValuesArray:array]];
             [_myTabV reloadData];
         } else {
              [AppD.window showHint:[responseObject objectForKey:@"msg"]];
         }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
         [_myTabV.slimeView endRefresh];
        [AppD.window showHint:NSStringLocalizable(@"request_error")];
    }];
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
