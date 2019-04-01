//
//  ChooseCountryView.m
//  Qlink
//
//  Created by 旷自辉 on 2018/7/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "ChooseCountryView.h"
#import "VPN2ChooseCountryCell.h"
#import "ChooseCountryUtil.h"

@interface ChooseCountryView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) NSMutableArray *countryArray;
@property (nonatomic , assign) NSInteger currentRow;
@end


@implementation ChooseCountryView

+ (instancetype) loadChooseCountryView
{
    ChooseCountryView *countryView = [[[NSBundle mainBundle] loadNibNamed:@"ChooseCountryView" owner:self options:nil] lastObject];
    return countryView;
}

- (void)awakeFromNib
{
    _bgView.layer.cornerRadius = 5.0f;
    _currentRow = -1;
    _myTabView.delegate = self;
    _myTabView.dataSource = self;
    [_myTabView registerNib:[UINib nibWithNibName:ChooseCountryCellReuse bundle:nil] forCellReuseIdentifier:ChooseCountryCellReuse];
    _myTabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [super awakeFromNib];
}
- (NSMutableArray *) countryArray
{
    if (!_countryArray) {
        _countryArray =  [ChooseCountryUtil getAllCountry];
    }
    return _countryArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.countryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VPN2ChooseCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:ChooseCountryCellReuse];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CountryModel *model = self.countryArray[indexPath.row];
    if (_isSave) {
        CountryModel *currentCountry =  [CountryModel mj_objectWithKeyValues:[HWUserdefault getObjectWithKey:CURRENT_SELECT_COUNTRY]];
        BOOL isSelct = NO;
        if (currentCountry && [currentCountry.countryCode isEqualToString:model.countryCode] ) {
            isSelct = YES;
        }
        [cell configCell:model isSelect:isSelct];
    } else {
        BOOL isSelct = NO;
        if (indexPath.row == _currentRow ) {
            isSelct = YES;
        }
        [cell configCell:model isSelect:isSelct];
    }
   
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return VPN2ChooseCountryCell_Height;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CountryModel *model = self.countryArray[indexPath.row];
    if (_isSave) {
         [HWUserdefault insertObj:[model mj_keyValues] withkey:CURRENT_SELECT_COUNTRY];
    } else {
        _currentRow = indexPath.row;
    }
    _lblCountry.text = model.name;
    [tableView reloadData];
    if (_selectCountryBlock) {
        _selectCountryBlock (model);
    }
    [self hidde];
    
}
- (IBAction)clickBgBtn:(id)sender {
    [self hidde];
}

/**
 隐藏alertview
 */
- (void) hidde
{
    kWeakSelf(self);
    [UIView animateWithDuration:.4 animations:^{
       weakself.tabContraintH.constant = 0;
        weakself.alpha = 0.5f;
       [weakself layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakself removeFromSuperview];
    }];
}

- (void) showChooseCountryView {
    [kAppD.window addSubview:self];
    self.alpha = 1.0f;
    self.tabContraintH.constant = 0;
    CGFloat tabH = 320;
    if (_isSave) {
        tabH = 265;
    }
    [self layoutIfNeeded];
    kWeakSelf(self);
    [UIView animateWithDuration:.4 animations:^{
        //weakSelf.alpha = 1.0f;
        weakself.tabContraintH.constant = tabH;
         [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
@end
