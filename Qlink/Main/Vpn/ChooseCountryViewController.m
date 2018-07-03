//
//  ChooseCountryViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "ChooseCountryViewController.h"
#import "ChooseCountryCell.h"
#import "ContinentModel.h"
#import "VpnViewController.h"
#import "ChooseCountryUtil.h"
#import "VPNRegisterViewController.h"
//#import "UIButton+UserHead.h"
#import "SelectCountryModel.h"

#import <SDWebImage/UIButton+WebCache.h>

#define TableHeight 362

@interface ChooseCountryViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

//@property (weak, nonatomic) IBOutlet UIButton *userHeadBtn;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong) NSMutableArray *countryArr;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSArray *continentArr;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBackHeight; // 362

@end

@implementation ChooseCountryViewController

#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addNoticeForKeyboard];
    _sourceArr = [NSMutableArray array];
    _countryArr = [NSMutableArray array];
    _selectArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:ChooseCountryCellReuse bundle:nil] forCellReuseIdentifier:ChooseCountryCellReuse];
    [_searchTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self dataInit];
    
}

#pragma mark - Config View
- (void)refreshContent {

}

#pragma mark - Operation

- (void)dataInit {
    if (_continent) {
        // 获取当前大陆板块的国家
        [self.continentArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ContinentModel *model = obj;
            if ([model.continent isEqualToString:_continent]) {
                [_countryArr addObjectsFromArray:model.country];
                *stop = YES;
            }
        }];
        
        // 对国家进行字母排序
        NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
        [_countryArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            CountryModel *model1 = obj1;
            CountryModel *model2 = obj2;
            NSRange range = NSMakeRange(0,model1.name.length);
            return [model1.name compare:model2.name options:comparisonOptions range:range];
        }];
        
        if (_countryArr.count > 0) {
            [_selectArr addObject:((CountryModel *)_countryArr.firstObject).name];
            _sourceArr = _countryArr;
            [_mainTable reloadData];
        }
    }
}

- (void)refreshNormal {
    _sourceArr = _countryArr;
    [_mainTable reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:ChooseCountryCellReuse];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CountryModel *model = _sourceArr[indexPath.row];
    BOOL isSelect = [_selectArr containsObject:model.name];
    [cell configCell:model isSelect:isSelect];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ChooseCountryCell_Height;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_selectArr removeAllObjects];
    CountryModel *model = _sourceArr[indexPath.row];
    [_selectArr addObject:model.name];
    [_mainTable reloadData];
}

#pragma mark - Keyboard

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGRect tableFrame =[_mainTable.superview convertRect:_mainTable.frame toView:AppD.window];
    
    CGFloat offset = kbHeight - (SCREEN_HEIGHT - tableFrame.size.height - tableFrame.origin.y);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            _tableBackHeight.constant = TableHeight - offset;
            [_mainTable.superview setNeedsLayout];
            [_mainTable.superview layoutIfNeeded];
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        _tableBackHeight.constant = TableHeight;
        [_mainTable.superview setNeedsLayout];
        [_mainTable.superview layoutIfNeeded];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchAction];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textF {
    [self searchAction];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (textField.text.length == 0 && string.length == 0) { // 退格 ---
//        if (_seleConArray && _seleConArray.count >= 1) {
//            [self removeCellAtIndex:[_seleConArray indexOfObject:_seleConArray.lastObject]];
//        }
//    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [textField endEditing:YES];
    [self refreshNormal];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //    textField.showsCancelButton = NO;
//    textField.text = nil;
    [textField endEditing:YES];
//    [self refreshNormal];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //    textField.showsCancelButton = YES;
}

- (void)textFieldDidDeleteBackward:(UITextField *)textField {
}

#pragma mark - Action
- (void)back {
    ChooseCountryEntry entry = [ChooseCountryUtil shareInstance].entry;
    Class entryClass = [VpnViewController class];
    switch (entry) {
        case VPNList:
            entryClass = [VpnViewController class];
            break;
        case VPNRegister:
            entryClass = [VPNRegisterViewController class];
            break;
            
        default:
            break;
    }
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:entryClass]) {
            [self.navigationController popToViewController:obj animated:YES];
            *stop = YES;
        }
    }];
}

- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelAction:(id)sender {
    [self cancel];
}

- (IBAction)continueAction:(id)sender {
    NSString *name = _selectArr.firstObject;
    ChooseCountryEntry entry = [ChooseCountryUtil shareInstance].entry;
    SelectCountryModel *selectM = [[SelectCountryModel alloc] init];
    selectM.country = name?:@"";
    selectM.continent = _continent?:@"";
    switch (entry) {
        case VPNList:
            [[NSNotificationCenter defaultCenter] postNotificationName:SELECT_COUNTRY_NOTI_VPNLIST object:selectM];
            break;
        case VPNRegister:
            [[NSNotificationCenter defaultCenter] postNotificationName:SELECT_COUNTRY_NOTI_VPNREGISTER object:selectM];
            break;
            
        default:
            break;
    }
    
    
    [self back];
}

- (void)searchAction {
    if (_searchTF.text == nil || _searchTF.text.length <= 0) {
        [self refreshNormal];
        return;
    }
    
    NSMutableArray *tempArr = [NSMutableArray array];
    [_countryArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CountryModel *model = obj;
        if ([model.name containsString:_searchTF.text]) {
            [tempArr addObject:model];
        }
    }];
    
    _sourceArr = tempArr;
    [_mainTable reloadData];
}

#pragma mark - Lazy

- (NSArray *)continentArr {
    if (!_continentArr) {
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ContinentAndCountryBean" ofType:@"json"]];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *tempArr = [NSMutableArray array];
        [dic[@"continent"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ContinentModel *model = [ContinentModel getObjectWithKeyValues:obj];
            [tempArr addObject:model];
        }];
        
        _continentArr = [NSArray arrayWithArray:tempArr];
    }
    return _continentArr;
    
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
