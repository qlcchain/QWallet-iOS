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
#import "SkyRadiusView.h"
#import "RankingStartCell.h"

#define PAGE_PADDING 86
#define PAGE_HEIGHT 150//(SCREEN_WIDTH - PAGE_PADDING) * 9 / 16

#define START_STR @"START"
#define END_STR @"END"
#define PRIZED_STR @"PRIZED"

@interface RankingViewController ()<NewPagedFlowViewDelegate,NewPagedFlowViewDataSource,UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate>

@property (nonatomic ,strong) NewPagedFlowView *pageFlowView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageFlowContraintH;
@property (weak, nonatomic) IBOutlet UIView *flowBackView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) NSMutableArray *sourceArray;
@property (weak, nonatomic) IBOutlet SkyRadiusView *tabBackView;
@property (strong, nonatomic) RefreshTableView *myTabV;
//@property (strong, nonatomic) RefreshTableView *mainTable;
@property (nonatomic ,strong) NSString *currentTime;
@property (nonatomic ,strong) RankingMode *currentRank;
@property (weak, nonatomic) IBOutlet UILabel *lblTopTitle;

@end

@implementation RankingViewController
- (void)dealloc
{
    _pageFlowView.delegate = nil;
    _pageFlowView.dataSource = nil;
    _pageFlowView.cells = nil;
    _pageFlowView = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取活动列表接口
    [self sendQueryActsRequest];
    
}

#pragma mark -init pageview
- (void) loadPageViewWithCurrentPage:(NSInteger) index {
    _pageFlowContraintH.constant = PAGE_HEIGHT + 28;
    _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0,14, SCREEN_WIDTH, PAGE_HEIGHT)];
    _pageFlowView.delegate = self;
    _pageFlowView.dataSource = self;
    _pageFlowView.minimumPageAlpha = 0.8;
    _pageFlowView.isCarousel = NO;
    _pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    _pageFlowView.isOpenAutoScroll = YES;
    [_pageFlowView reloadData];
    [_pageFlowView scrollToPage:index];
    [_flowBackView addSubview:_pageFlowView];
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
    if ([self.currentRank.actStatus isEqualToString:END_STR] || [self.currentRank.actStatus isEqualToString:PRIZED_STR]) {
        
        RankingCell *myCell = [tableView dequeueReusableCellWithIdentifier:RankingCellReuse];
        if (indexPath.row == 0) {
            myCell.lblNumber.hidden = YES;
            myCell.trophyImgView.hidden = NO;
        } else {
            myCell.lblNumber.hidden = NO;
            myCell.trophyImgView.hidden = YES;
        }
        [myCell setVPNRankMode:self.sourceArray[indexPath.row] withType:self.currentRank.actStatus withEnd:indexPath.row == (self.sourceArray.count-1) ? YES:NO];
        myCell.lblNumber.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        return myCell;
    } else if ([self.currentRank.actStatus isEqualToString:START_STR]){
        RankingStartCell *myCell = [tableView dequeueReusableCellWithIdentifier:RankingStartCellReuse];
        [myCell setVPNRankMode:self.sourceArray[indexPath.row] withRow:indexPath.row];
        
        return myCell;
    } else {
        
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    VPNRankMode *model = self.sourceArray[indexPath.row];
    if ([self.currentRank.actStatus isEqualToString:START_STR] && model.isEarn50) {
        return RankingStartCell_EARN_Height;
    } else {
         return RankingCell_Height;
    }
    return RankingCell_Height;
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
    if ([rankMode.actStatus isEqualToString:END_STR] || [rankMode.actStatus isEqualToString:PRIZED_STR]) {
        PageThreeView *threeView = (PageThreeView *)[flowView dequeueReusableCell];
        if (!threeView) {
            threeView = [[[NSBundle mainBundle] loadNibNamed:@"PageThreeView" owner:self options:nil] lastObject];
            threeView.frame = CGRectMake(0,0, SCREEN_WIDTH - PAGE_PADDING, PAGE_HEIGHT);
            threeView.layer.cornerRadius = 5;
            threeView.layer.masksToBounds = YES;
            threeView.backgroundColor = MAIN_PURPLE_COLOR;
        }
        threeView.lblCountDesc.text = [NSString stringWithFormat:@"%@ %@",rankMode.actAmount?:@"0",NSStringLocalizable(@"qlc_pool")];
        threeView.lblRound.text = rankMode.actName?:@"";
        return threeView;
    } else if ([rankMode.actStatus isEqualToString:START_STR]){
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
        
        NSString *actAmount = rankMode.actAmount?:@"0";
        NSString *msg = [NSString stringWithFormat:@"Up to %@ QLC",actAmount];
        NSMutableAttributedString *msgArrtrbuted = [[NSMutableAttributedString alloc] initWithString:msg];
        [msgArrtrbuted addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"VAGRoundedBT-Regular" size:16.0] range:NSMakeRange(0, msg.length)];
        [msgArrtrbuted addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"VAGRoundedBT-Regular" size:20.0] range:[msg rangeOfString:actAmount]];
        oneView.lblNumber.attributedText = msgArrtrbuted;
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
    if ([self.currentRank.actStatus isEqualToString:START_STR]) {
        _lblTopTitle.text = NSStringLocalizable(@"rank_top_title2");
    } else {
        _lblTopTitle.text = NSStringLocalizable(@"rank_top_title1");
    }
    if (self.sourceArray.count > 0) {
        [self.sourceArray removeAllObjects];
        [self.myTabV reloadData];
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
    if (self.myTabV.slimeView) {
        [self.myTabV.slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.myTabV.slimeView) {
        [self.myTabV.slimeView scrollViewDidEndDraging];
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
                __block NSUInteger currentIndex = 0;
                [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    RankingMode *rankMode = (RankingMode *)obj;
                    if ( [rankMode.actStatus isEqualToString:START_STR]) {
                        currentIndex = idx;
                        *stop = YES;
                    }
                }];
                self.currentRank = self.dataArray[currentIndex];
                [self sendQueryVpnRankingsRequestWithActId:self.currentRank.actId];
                [self loadPageViewWithCurrentPage:currentIndex];
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
        [self.myTabV.slimeView endRefresh];
         if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
              NSArray *array = [[responseObject objectForKey:Server_Data] objectForKey:@"vpnRanking"];
             if (self.sourceArray.count > 0) {
                 [self.sourceArray removeAllObjects];
             }
             [self.sourceArray addObjectsFromArray:[VPNRankMode mj_objectArrayWithKeyValuesArray:array]];
             [self handleAndReload];
//             [self.myTabV reloadData];
         } else {
              [AppD.window showHint:[responseObject objectForKey:@"msg"]];
         }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
         [self.myTabV.slimeView endRefresh];
        [AppD.window showHint:NSStringLocalizable(@"request_error")];
    }];
}

#pragma mark - Operation
- (void)handleAndReload {
    if ([self.currentRank.actStatus isEqualToString:START_STR]) { // 标记处需要显示tip的model
        __block BOOL isMark = NO;
        [self.sourceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            VPNRankMode *model = obj;
            if (isMark) {
                model.isEarn50 = NO;
            } else {
                if (model.totalQlc < 50) {
                    model.isEarn50 = YES;
                    isMark = YES;
                }
            }
        }];
    }
    [self.myTabV reloadData];
}

- (RefreshTableView *) myTabV {
    if (!_myTabV) {
        _myTabV = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, _tabBackView.width-20,_tabBackView.height) style:UITableViewStylePlain];
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.slimeView.delegate = self;
        _myTabV.showsVerticalScrollIndicator = NO;
        _myTabV.showsHorizontalScrollIndicator = NO;
        _myTabV.backgroundColor = [UIColor clearColor];
        _myTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTabV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tabBackView addSubview:_myTabV];
        [_myTabV registerNib:[UINib nibWithNibName:RankingCellReuse bundle:nil] forCellReuseIdentifier:RankingCellReuse];
        [_myTabV registerNib:[UINib nibWithNibName:RankingSubCellReuse bundle:nil] forCellReuseIdentifier:RankingSubCellReuse];
        [_myTabV registerNib:[UINib nibWithNibName:RankingStartCellReuse bundle:nil] forCellReuseIdentifier:RankingStartCellReuse];
        [_myTabV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_tabBackView).offset(10);
            make.right.mas_equalTo(_tabBackView).offset(-10);
            make.top.bottom.mas_equalTo(_tabBackView).offset(0);
        }];
    }
    return _myTabV;
}

@end
