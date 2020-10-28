//
//  DeFiSub_DefiViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DeFiSub_DefiViewController.h"
#import <SwiftTheme/SwiftTheme-Swift.h>
#import "DeFiHomeCell.h"
#import <MJRefresh/MJRefresh.h>
#import "RefreshHelper.h"
#import "DeFiRecordCell.h"
#import "DeFiDetailViewController.h"
#import "DefiProjectListModel.h"
#import <TMCache/TMCache.h>
#import "FirebaseUtil.h"
#import "FirebaseConstants.h"


static NSString *const TM_defi_project_list = @"TM_defi_project_list";

static NSString *const Defi_type_all = @"All";
//static NSString *const Defi_type_lending = @"Lending";
//static NSString *const Defi_type_dexes = @"DEXes";
//static NSString *const Defi_type_derivatives = @"Derivatives";
//static NSString *const Defi_type_payments = @"Payments";
//static NSString *const Defi_type_assets = @"Assets";

static NSString *const NetworkSize = @"20";
static NSInteger TypeBtn_Tag = 4000;

@interface DeFiSub_DefiViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;
//@property (nonatomic, strong) NSArray *sourceShowArr;

@property (weak, nonatomic) IBOutlet UILabel *nameKeyLab;
@property (weak, nonatomic) IBOutlet UILabel *chainKeyLab;


@property (weak, nonatomic) IBOutlet UITableView *recordTable;
@property (nonatomic, strong) NSMutableArray *recordArr;
@property (weak, nonatomic) IBOutlet UIView *recordBack;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIView *recordContentBack;

@property (weak, nonatomic) IBOutlet UIView *scrollContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentWidth;

@property (weak, nonatomic) IBOutlet UIButton *lockedBtn;

//@property (nonatomic, strong) NSArray *tpyeTitleArr;
@property (nonatomic, strong) NSMutableArray *tpyeTitleEnArr;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) NSString *lockedStr;
@property (nonatomic) NSInteger selectTypeIndex;
@property (nonatomic, strong) NSString *selectTypeStr;
@property (nonatomic) BOOL isRequestEnable;

@end

@implementation DeFiSub_DefiViewController

#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeNoti:) name:kLanguageChangeNoti object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addObserve];
    
    self.view.theme_backgroundColor = globalBackgroundColorPicker;

    [self configInit];
    [self refreshTypeView:YES];
    
    
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself request_defi_category_list];
    });
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshRecordView];
}

#pragma mark - Operation
- (void)configInit {
    _isRequestEnable = YES;
    _recordContentBack.hidden = YES;
    _selectTypeIndex = 0;
    _selectTypeStr = Defi_type_all;
    _currentPage = 1;
    _lockedStr = @"desc";
    _lockedBtn.selected = YES;
    NSArray *tm_defi_project_list = [[TMCache sharedCache] objectForKey:TM_defi_project_list]?:@[];
    _sourceArr = [NSMutableArray arrayWithArray:tm_defi_project_list];
//    _sourceArr = [NSMutableArray array];
    _tpyeTitleEnArr = [NSMutableArray arrayWithObject:Defi_type_all];
    [_mainTable registerNib:[UINib nibWithNibName:DeFiHomeCell_Reuse bundle:nil] forCellReuseIdentifier:DeFiHomeCell_Reuse];
    self.baseTable = _mainTable;
    
    _recordArr = [NSMutableArray array];
    [_recordTable registerNib:[UINib nibWithNibName:DeFiRecordCell_Reuse bundle:nil] forCellReuseIdentifier:DeFiRecordCell_Reuse];
    self.baseTable = _recordTable;
    
    _recordBack.layer.cornerRadius = 13;
    _recordBack.layer.masksToBounds = YES;
    
    kWeakSelf(self)
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = 1;
        [weakself request_defi_project_list];
    } type:RefreshTypeColor];
    _mainTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself request_defi_project_list];
    } type:RefreshTypeColor];
    _mainTable.mj_footer.hidden = YES;
    
    
//    [self refreshTypeData];
    [self refreshText];
}

- (void)refreshText {
    _nameKeyLab.text = kLang(@"defi_project");
    _chainKeyLab.text = kLang(@"defi_rating");
}

//- (void)refreshTypeData {
//    _tpyeTitleEnArr = @[Defi_type_all,Defi_type_lending,Defi_type_dexes,Defi_type_derivatives,Defi_type_payments,Defi_type_assets];
//    _tpyeTitleArr = @[kLang(@"defi_all"),kLang(@"defi_lending"),kLang(@"defi_exchange"),kLang(@"defi_derivative"),kLang(@"defi_payment"),kLang(@"defi_asset")];
//}

- (void)refreshTypeView:(BOOL)isRequestFirst {
    _isRequestEnable = isRequestFirst;
    kWeakSelf(self);
    [_scrollContent.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    CGFloat topOffset = 11;
    CGFloat sectionHOffset = 16;
    CGFloat rowHOffset = 10;
    CGFloat rowHeight = 26;
    NSMutableArray *btnWidthArr = [NSMutableArray array];
    [_tpyeTitleEnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIFont *titleFont = [UIFont systemFontOfSize:14];
        NSString *title = obj;
        __block CGFloat rowLeft = sectionHOffset;
        [btnWidthArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *rowWidthNum = obj;
            rowLeft = rowLeft+[rowWidthNum floatValue]+rowHOffset;
        }];
        CGFloat rowTextWidth = [(NSString *)obj boundingRectWithSize:CGSizeMake(1000, rowHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleFont} context:nil].size.width+2;
        CGFloat rowWidth = 2*14+rowTextWidth;
        [btnWidthArr addObject:@(rowWidth)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(rowLeft, topOffset, rowWidth, rowHeight);
        btn.titleLabel.font = titleFont;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x1E1E24) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xF5F5F5)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:MAIN_BLUE_COLOR] forState:UIControlStateSelected];
        btn.layer.cornerRadius = btn.height/2.0;
        btn.layer.masksToBounds = YES;
        btn.tag = TypeBtn_Tag + idx;
        [btn addTarget:self action:@selector(typeHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        [weakself.scrollContent addSubview:btn];
    }];
    
    __block CGFloat contentWidth = 2*sectionHOffset;
    [btnWidthArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *rowWidthNum = obj;
        contentWidth = contentWidth+[rowWidthNum floatValue];
    }];
    if (btnWidthArr.count > 0) {
        contentWidth = contentWidth+(btnWidthArr.count-1)*rowHOffset;
    }
    _scrollContentWidth.constant = contentWidth;
    
    if (_tpyeTitleEnArr.count > 0) {
        UIButton *firstBtn = [weakself.scrollContent viewWithTag:TypeBtn_Tag];
        [self typeHandler:firstBtn];
    }
}

- (void)typeHandler:(UIButton *)btn {
    if (_recordBtn.selected == YES) {
        [self recordAction:_recordBtn];
    }
    if (btn.selected == YES) {
        return;
    }
    
    kWeakSelf(self);
    NSInteger index = btn.tag - TypeBtn_Tag;
    [_tpyeTitleEnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [weakself.scrollContent viewWithTag:TypeBtn_Tag+idx];
        btn.selected = index == idx?YES:NO;
    }];

    _selectTypeIndex = index;
    _selectTypeStr = _tpyeTitleEnArr[_selectTypeIndex];
    if (_isRequestEnable) {
        [self refreshDataByType];
    }
    NSString *event = [NSString stringWithFormat:@"%@%@",Defi_Home_Category_,_selectTypeStr];
    [FirebaseUtil logEventWithItemID:event itemName:event contentType:event];
    
    _isRequestEnable = YES;
}

- (void)refreshDataByType {
    _currentPage = 1;
    [self request_defi_project_list];
//    if ([typeStr isEqualToString:Defi_type_all]) {
//        _sourceShowArr = _sourceArr;
//    } else {
//        NSMutableArray *tempArr = [NSMutableArray array];
//        [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            DefiProjectListModel *model = obj;
//            if ([model.category isEqualToString:typeStr]) {
//                [tempArr addObject:model];
//            }
//        }];
//        _sourceShowArr = tempArr;
//    }
//
//    [_mainTable reloadData];
}

- (void)refreshRecordView {
    NSArray *recordLocalArr = [[TMCache sharedCache] objectForKey:Defi_Record_Local]?:@[];
    [_recordArr removeAllObjects];
    [_recordArr addObjectsFromArray:recordLocalArr];
    [_recordTable reloadData];
}

#pragma mark - Request
- (void)request_defi_project_list {
    kWeakSelf(self);
     NSString *page = [NSString stringWithFormat:@"%li",_currentPage];
    NSString *size = NetworkSize;
    NSString *order = _lockedStr?:@"desc"; // asc|desc
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"page":page,@"size":size,@"order":order}];
    if (![_selectTypeStr isEqualToString:Defi_type_all]) {
        [params setObject:_selectTypeStr forKey:@"category"];
    }
    [RequestService requestWithUrl5:defi_project_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [DefiProjectListModel mj_objectArrayWithKeyValuesArray:responseObject[@"projectList"]];
            if ([page integerValue] == 1) {
                [weakself.sourceArr removeAllObjects];
                [[TMCache sharedCache] setObject:arr forKey:TM_defi_project_list];
                weakself.currentPage = [page integerValue];
            }
            
            [weakself.sourceArr addObjectsFromArray:arr];
            
            weakself.currentPage = weakself.currentPage + 1;
            
            [weakself.mainTable reloadData];
            
            if (arr.count < [NetworkSize integerValue]) {
                [weakself.mainTable.mj_footer endRefreshingWithNoMoreData];
//                weakself.mainTable.mj_footer.hidden = arr.count<=0?YES:NO;
                weakself.mainTable.mj_footer.hidden = YES;
            } else {
                weakself.mainTable.mj_footer.hidden = NO;
            }
            
            [weakself request_defi_stats_cache];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
    }];
}

- (void)request_defi_category_list {
    kWeakSelf(self);
    NSDictionary *params = @{};
    [RequestService requestWithUrl5:defi_category_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = responseObject[@"categoryList"];
            [weakself.tpyeTitleEnArr addObjectsFromArray:arr];
            [weakself refreshTypeView:NO];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)request_defi_stats_cache {
    kWeakSelf(self);
    NSMutableString *projectIds = [NSMutableString string];
    [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DefiProjectListModel *model = obj;
        if (model.cache == nil) {
            [projectIds appendFormat:@"%@,",model.ID];
        }
    }];
    if (projectIds.length > 0) {
        [projectIds deleteCharactersInRange:NSMakeRange(projectIds.length-1, 1)];
    }
    
    if (projectIds.length <= 0) {
        return;
    }
    
    NSDictionary *params = @{@"projectIds":projectIds};
    [RequestService requestWithUrl5:defi_stats_cache_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = responseObject[@"statsCache"];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                [weakself.sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    DefiProjectListModel *model = obj;
                    if ([model.ID isEqualToString:dic[@"id"]]) {
                        model.cache = dic[@"cache"];
                        *stop = YES;
                    }
                }];
            }];
            [weakself.mainTable reloadData];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}




#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _mainTable) {
        return _sourceArr.count;
    } else if (tableView == _recordTable) {
        return _recordArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _mainTable) {
        DeFiHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:DeFiHomeCell_Reuse];
        
        DefiProjectListModel *model = _sourceArr[indexPath.row];
        [cell config:model index:indexPath.row];
        
        return cell;
    } else if (tableView == _recordTable) {
        
        DeFiRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:DeFiRecordCell_Reuse];
        DefiProjectListModel *model = _recordArr[indexPath.row];
        [cell config:model];
        
        return cell;
    }
    
    
    
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _mainTable) {
        return DeFiHomeCell_Height;
    } else if (tableView == _recordTable) {
        return DeFiRecordCell_Height;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _mainTable) {
        DefiProjectListModel *model = _sourceArr[indexPath.row];
        
        [self jumpToDeFiDetail:model];
    } else if (tableView == _recordTable) {
        DefiProjectListModel *model = _recordArr[indexPath.row];
        
        [self jumpToDeFiDetail:model];
    }
    
}

#pragma mark - Action

- (IBAction)recordAction:(id)sender {
    _recordBtn.selected = !_recordBtn.selected;
    _recordBtn.backgroundColor = _recordBtn.selected?MAIN_BLUE_COLOR:UIColorFromRGB(0xF5F5F5);
    
    kWeakSelf(self);
    _recordContentBack.hidden = _recordBtn.selected;
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakself.recordContentBack.hidden = !_recordBtn.selected;
    } completion:^(BOOL finished) {
        
    }];
    
    if (_recordBtn.selected == YES) {
        [FirebaseUtil logEventWithItemID:Defi_Home_Record itemName:Defi_Home_Record contentType:Defi_Home_Record];
        [self refreshRecordView];
    }
    
}

- (IBAction)lockedAction:(id)sender {
    _lockedBtn.selected = !_lockedBtn.selected;
    _lockedStr = _lockedBtn.selected?@"desc":@"asc";
    
    _currentPage = 1;
    [self request_defi_project_list];
}

#pragma mark - Transition
- (void)jumpToDeFiDetail:(DefiProjectListModel *)model {
    DeFiDetailViewController *vc = [DeFiDetailViewController new];
    vc.inputProjectListM = model;
    kWeakSelf(self);
    vc.rateCompleteB = ^(DefiProjectListModel * _Nonnull listM) {
        __block NSInteger replaceIndex = -1;
        NSArray *tempArr = [NSArray arrayWithArray:weakself.sourceArr];
        [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DefiProjectListModel *tempM = obj;
            if ([tempM.ID isEqualToString:listM.ID]) {
                [weakself.sourceArr replaceObjectAtIndex:idx withObject:listM];
                replaceIndex = idx;
                *stop = YES;
            }
        }];
        
        if (replaceIndex >= 0) {
            [weakself.mainTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:replaceIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Noti
- (void)languageChangeNoti:(NSNotification *)noti {
    [_mainTable.mj_header beginRefreshing];
    [self refreshEmptyView:self.mainTable];
    
//    [self refreshTypeData];
//    [self refreshTypeView];
    [self refreshText];
}

@end
