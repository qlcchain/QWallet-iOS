//
//  AddMarketsViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/28.
//  Copyright © 2018 pan. All rights reserved.
//

#import "AddMarketsViewController.h"
#import "AddMarketsCell.h"
#import "BinaTpcsModel.h"

//#import "GlobalConstants.h"

#define AddMarkets_Select_Tag 2950

@interface TokenSelectModel : BBaseModel

@property (nonatomic, strong) NSString *symbol;
@property (nonatomic) BOOL isSelect;

@end

@implementation TokenSelectModel

@end

@interface AddMarketsViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) NSMutableArray *searchArr;
@property (nonatomic, strong) NSArray *showArr;

@end

@implementation AddMarketsViewController

#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisAppear:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addObserve];
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self configInit];
    [self requestBinaGetTokens];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Operation

- (void)configInit {
    _sourceArr = [NSMutableArray array];
    _searchArr = [NSMutableArray array];
    _showArr = [NSArray array];
    [_mainTable registerNib:[UINib nibWithNibName:AddMarketsCellReuse bundle:nil] forCellReuseIdentifier:AddMarketsCellReuse];
    [_searchTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self configDataAndRefresh];
}

- (void)configDataAndRefresh {
    NSArray *localArr = [BinaTpcsModel getLocalMarketsSymbol];
    [self.sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TokenSelectModel *model = obj;
        if ([localArr containsObject:model.symbol]) {
            model.isSelect = YES;
        }
    }];
    _showArr = _sourceArr;
    [_mainTable reloadData];
}

- (void)textFieldDidChange:(UITextField *)tf {
    if (tf == _searchTF) {
        [_searchArr removeAllObjects];
        kWeakSelf(self);
        [self.sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TokenSelectModel *model = obj;
            if ([[model.symbol lowercaseString] containsString:[tf.text lowercaseString]]) {
                [weakself.searchArr addObject:model];
            }
        }];
        if (_searchArr.count > 0) {
            _showArr = _searchArr;
        } else {
            if (tf.text.length > 0) {
                _showArr = _searchArr;
            } else {
                _showArr = _sourceArr;
            }
        }
        
        [_mainTable reloadData];
    }
}

- (void)keyboardWillAppear:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    //获取键盘的frame
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //获取键盘弹出的动画时间
//    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey ] doubleValue];
    //让输入框跟随变化
//    [UIView animateWithDuration:animationDuration animations:^{
//        [_ctv mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(@(-keyboardFrame.size.height));
//        }];
//    }];
    //设置tableview的contentInset属性，改变tableview的显示范围
    _mainTable.contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height, 0);
    _mainTable.scrollEnabled = YES;
}

- (void)keyboardWillDisAppear:(NSNotification *)noti {
//    NSDictionary *userInfo = noti.userInfo;
//    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey ] doubleValue];
//    [UIView animateWithDuration:animationDuration animations:^{
//        [_ctv mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(@0);
//            make.height.equalTo(@52);
//        }];
//    }];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _mainTable.contentInset = contentInsets;
}

#pragma mark - Request
- (void)requestBinaGetTokens {
    kWeakSelf(self);
    NSDictionary *params = @{};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl5:binaGetTokens_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            [weakself.sourceArr removeAllObjects];
            NSArray *arr = [responseObject objectForKey:Server_Data];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TokenSelectModel *model = [[TokenSelectModel alloc] init];
                model.symbol = obj;
                model.isSelect = NO;
                [weakself.sourceArr addObject:model];
            }];
            [weakself configDataAndRefresh];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AddMarketsCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _showArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddMarketsCell *cell = [tableView dequeueReusableCellWithIdentifier:AddMarketsCellReuse];
    
    TokenSelectModel *model = _showArr[indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%@/BTC",model.symbol];
    [cell configCellWithTitle:title isSelect:model.isSelect];
    cell.selectBtn.tag = AddMarkets_Select_Tag + indexPath.row;
    [cell.selectBtn removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [cell.selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)selectAction:(UIButton *)sender {
    NSInteger row = sender.tag - AddMarkets_Select_Tag;
    TokenSelectModel *model = _showArr[row];
    model.isSelect = !model.isSelect;
    if (model.isSelect) {
        [BinaTpcsModel addLocalMarketsSymbol:model.symbol];
    } else {
        [BinaTpcsModel deleteLocalMarketsSymbol:model.symbol];
    }
    [_mainTable reloadData];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
