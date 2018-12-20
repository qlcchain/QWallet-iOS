//
//  FreeConnectionViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/7/18.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "FreeConnectionViewController.h"
#import "FreeConnectionCell.h"
#import "SkyRadiusView.h"
#import "PopSelectView.h"
#import "UIView+Visuals.h"
#import "FreeRecordMode.h"
#import "NEOWalletUtil.h"

@interface FreeConnectionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , assign) NSInteger currentRow;
@property (weak, nonatomic) IBOutlet SkyRadiusView *availableBack;
@property (weak, nonatomic) IBOutlet SkyRadiusView *tableBack;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UILabel *availableNumLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic , strong) PopSelectView *selectView;
@property (nonatomic , strong) UIButton *popBackBtn;

@end

@implementation FreeConnectionViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *freeKey = [ConfigUtil isMainNetOfServerNetwork] ? VPN_FREE_MAIN_COUNT : VPN_FREE_COUNT;
    NSString *freeCount = [HWUserdefault getObjectWithKey:freeKey];
    _availableNumLab.text = freeCount?:@"0";
    _currentRow = 0;
    [self configData];
    [self configView];
}

#pragma mark - Config
- (void)configData {
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:FreeConnectionCellReuse bundle:nil] forCellReuseIdentifier:FreeConnectionCellReuse];
    [self sendQueryFreeRecords:@"0"];
}

- (void)configView {
    [_availableBack shadowWithColor:UIColorFromRGB(0xaaaaaa) offset:CGSizeMake(2, 2) opacity:0.2 radius:4];
    [_tableBack shadowWithColor:UIColorFromRGB(0xaaaaaa) offset:CGSizeMake(2, 2) opacity:0.2 radius:4];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FreeConnectionCell *cell = [tableView dequeueReusableCellWithIdentifier:FreeConnectionCellReuse];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FreeRecordMode *mode = [_sourceArr objectAtIndex:indexPath.row];
    [cell setCellMode:mode];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FreeConnectionCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Operation
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Action
- (IBAction)backAciton:(id)sender {
    [self back];
}

- (IBAction)typeAction:(UIButton *)sender {
    [kAppD.window addSubview:self.popBackBtn];
    [kAppD.window addSubview:self.selectView];
    [self.selectView showSelectView];
}

- (void) hideSelectView {
    [self.selectView hideSelectView];
    [self.popBackBtn removeFromSuperview];
}

#pragma mark - Request
- (void) sendQueryFreeRecords:(NSString *) type {
    [self.view makeToastInView:self.view userInteractionEnabled:YES hideTime:0];
    NSDictionary *parames = @{@"p2pId":[ToxManage getOwnP2PId],@"type":type?:@"0"};
    [RequestService requestWithUrl:queryFreeRecords_Url params:parames httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [self.view hideToast];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSArray *dataArray = [responseObject objectForKey:Server_Data];
            if (dataArray) {
                if (_sourceArr.count > 0) {
                    [_sourceArr removeAllObjects];
                }
               [_sourceArr addObjectsFromArray:[FreeRecordMode mj_objectArrayWithKeyValuesArray:dataArray]];
                [_mainTable reloadData];
            }
        } else {
            [kAppD.window makeToastDisappearWithText:[responseObject objectForKey:@"msg"]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"request_error")];
        [self.view hideToast];
    }];
}

#pragma mark - Lazy
- (PopSelectView *)selectView {
    if (!_selectView) {
        _selectView = [PopSelectView getInstance];
        CGFloat selectH = CGRectGetMaxY(_typeBtn.frame)+67;
        selectH += Height_StatusBar;
        _selectView.frame = CGRectMake(SCREEN_WIDTH-12-90,selectH-15, 90, 124);
        kWeakSelf(self);
        [_selectView setClickCellBlock:^(NSString *cellValue,NSInteger row) {
            [weakself hideSelectView];
            if (row >=0) {
                [weakself.typeBtn setTitle:cellValue forState:UIControlStateNormal];
                [weakself sendQueryFreeRecords:[NSString stringWithFormat:@"%zd",row]];
            }
        }];
    }
    return _selectView;
}

- (UIButton *)popBackBtn {
    if (!_popBackBtn) {
        _popBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _popBackBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _popBackBtn.backgroundColor = [UIColor clearColor];
        [_popBackBtn addTarget:self action:@selector(hideSelectView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popBackBtn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
