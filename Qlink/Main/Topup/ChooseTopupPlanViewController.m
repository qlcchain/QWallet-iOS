//
//  ChooseTopupPlanViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ChooseTopupPlanViewController.h"
#import "ChooseTopupPlanCell.h"
#import <ContactsUI/ContactsUI.h>
#import "TopupPayQLCViewController.h"
#import "RefreshHelper.h"
#import "TopupProductModel.h"
#import <QLCFramework/QLCWalletManage.h>
#import "TopupConstants.h"
#import "TopupPayTokenModel.h"
#import "TopupPayETHViewController.h"
#import "RLArithmetic.h"
#import "WalletCommonModel.h"
#import "ChooseWalletViewController.h"
#import "NSString+RemoveZero.h"
#import "ETHWalletManage.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>

static NSInteger PayTokenBtnTag = 6649;
static NSInteger PayTokenTickTag = 9223;
static NSString *const ChooseTopupPlanNetworkSize = @"20";

@interface ChooseTopupPlanViewController () <UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate> {
    CNContactPickerViewController * _peoplePickVC;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (weak, nonatomic) IBOutlet UIView *numBack;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *phonePrefixBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookupProductBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitingBackHeight; // 80
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tokenBackHeight; // 76
@property (weak, nonatomic) IBOutlet UIView *payTokenContentV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payTokenContentWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foundTopHeight; // 20
@property (weak, nonatomic) IBOutlet UILabel *foundTipLab;
@property (weak, nonatomic) IBOutlet UIView *waitBack;
@property (weak, nonatomic) IBOutlet UIView *tokenBack;

@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) NSArray *payTokenArr;
@property (nonatomic, strong) TopupPayTokenModel *selectPayTokenM;

@end

@implementation ChooseTopupPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self requestTopup_pay_token];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_sourceArr.count <= 0) {
        [_phoneTF becomeFirstResponder];
    }
}

#pragma mark - Operation
- (void)configInit {
    _foundTipLab.hidden = YES;
    _waitBack.hidden = YES;
    _tokenBack.hidden = YES;
    
    _numBack.layer.cornerRadius = 8;
    _numBack.layer.masksToBounds = YES;
    _numBack.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    _numBack.layer.borderWidth = 1;
    _lookupProductBtn.layer.cornerRadius = 4;
    _lookupProductBtn.layer.masksToBounds = YES;
    
    _currentPage = 1;
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:ChooseTopupPlanCellReuse bundle:nil] forCellReuseIdentifier:ChooseTopupPlanCellReuse];
    
    [_phoneTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [_phoneTF addTarget:self action:@selector(textFieldEditDidEnd:) forControlEvents:UIControlEventEditingDidEnd];

    kWeakSelf(self)
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = 1;
        [weakself requestTopup_product_list];
    }];
    _mainTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestTopup_product_list];
    }];
}

- (void)changedTextField:(UITextField *)tf {
    if ([tf.text isEmptyString]) {
        _waitingBackHeight.constant = 80;
        [_sourceArr removeAllObjects];
        [_mainTable reloadData];
    }
}

- (void)textFieldEditDidEnd:(UITextField *)tf {
    if (![tf.text isEmptyString]) {
        [_mainTable.mj_header beginRefreshing];
    }
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)refreshPayTokenView {
    if (!_payTokenArr || _payTokenArr.count <= 0) {
        [_payTokenContentV.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        _payTokenContentWidth.constant = 0;
        return;
    }
    
    CGFloat offset = 13;
    CGFloat btnWidth = 0;
    if (_payTokenArr.count<=1) {
        btnWidth = SCREEN_WIDTH-16*2;
    } else if (_payTokenArr.count==2) {
        btnWidth = (SCREEN_WIDTH-16*2-offset)/2;
    } else if (_payTokenArr.count>2) {
        btnWidth = (SCREEN_WIDTH-16*2-2*offset)/2.5;
    }
    CGFloat btnHeight = 40;
    CGFloat top = (_payTokenContentV.height-btnHeight)/2.0;
    kWeakSelf(self);
    [_payTokenArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(idx*(btnWidth+offset), top, btnWidth, btnHeight);
        btn.tag = PayTokenBtnTag+idx;
        [btn addTarget:weakself action:@selector(payTokenAction:) forControlEvents:UIControlEventTouchUpInside];
        [weakself.payTokenContentV addSubview:btn];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        
        UIImageView *imgV = [UIImageView new];
        imgV.frame = CGRectMake(btn.right-21, btn.bottom-19, 21, 19);
        imgV.tag = PayTokenTickTag+idx;
        imgV.image = [UIImage imageNamed:@"topup_btn_selected"];
        [weakself.payTokenContentV addSubview:imgV];
        
        TopupPayTokenModel *model = obj;
        [weakself showPayTokenUnselect:idx];
        if (idx == 0) {
            weakself.selectPayTokenM = model;
            [weakself showPayTokenSelect:idx];
        }
    }];
    
    _payTokenContentWidth.constant = _payTokenArr.count*btnWidth+(_payTokenArr.count-1)*offset;
}

- (void)payTokenAction:(UIButton *)btn {
    NSInteger selectIdx = btn.tag - PayTokenBtnTag;
    
    kWeakSelf(self);
    [_payTokenArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TopupPayTokenModel *model = obj;
        [weakself showPayTokenUnselect:idx];
        if (idx == selectIdx) {
            weakself.selectPayTokenM = model;
            [weakself showPayTokenSelect:idx];
        }
    }];
    
    [_mainTable reloadData];
    if (_sourceArr.count>0) {
        [_mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)showPayTokenUnselect:(NSInteger)idx {
    TopupPayTokenModel *model = _payTokenArr[idx];
    UIButton *btn = [_payTokenContentV viewWithTag:PayTokenBtnTag+idx];
//    [btn setImage:[model getPayTokenImage] forState:UIControlStateNormal];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.logo_png]];
    [btn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[model getPayTokenImage]];
    [btn setTitle:model.symbol forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x1E1E24) forState:UIControlStateNormal];
    btn.layer.cornerRadius = 6;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = UIColorFromRGB(0xE3E3E3).CGColor;
    
    UIImageView *imgV = [_payTokenContentV viewWithTag:PayTokenTickTag+idx];
    imgV.hidden = YES;
    
    btn.alpha = 0.5;
    imgV.alpha = 0.5;
}

- (void)showPayTokenSelect:(NSInteger)idx {
    TopupPayTokenModel *model = _payTokenArr[idx];
    UIButton *btn = [_payTokenContentV viewWithTag:PayTokenBtnTag+idx];
//    [btn setImage:[model getPayTokenImage] forState:UIControlStateNormal];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.logo_png]];
    [btn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[model getPayTokenImage]];
    [btn setTitle:model.symbol forState:UIControlStateNormal];
    [btn setTitleColor:MAIN_BLUE_COLOR forState:UIControlStateNormal];
    btn.layer.cornerRadius = 6;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = MAIN_BLUE_COLOR.CGColor;
    
    UIImageView *imgV = [_payTokenContentV viewWithTag:PayTokenTickTag+idx];
    imgV.hidden = NO;
    
    btn.alpha = 1;
    imgV.alpha = 1;
}

#pragma mark - Request
- (void)requestTopup_product_list {
    if (!_selectPayTokenM) {
        [_mainTable.mj_header endRefreshing];
        [_mainTable.mj_footer endRefreshing];
        return;
    }
    kWeakSelf(self);
    NSString *phoneNumber = _phoneTF.text?:@"";
    NSString *page = [NSString stringWithFormat:@"%li",_currentPage];
    NSString *size = ChooseTopupPlanNetworkSize;
    NSDictionary *params = @{@"page":page,@"size":size,@"phoneNumber":phoneNumber};
    [RequestService requestWithUrl10:topup_product_list_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [TopupProductModel mj_objectArrayWithKeyValuesArray:responseObject[@"productList"]];
            if (weakself.currentPage == 1) {
                [weakself.sourceArr removeAllObjects];
            }
            
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TopupProductModel *model1 = obj;
                [[model1.amountOfMoney componentsSeparatedByString:@","] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TopupProductModel *model2 = [TopupProductModel getObjectWithKeyValues:model1.mj_keyValues];
                    NSString *amountStr = obj;
                    model2.amount = @([amountStr doubleValue]);
                    [weakself.sourceArr addObject:model2];
                }];
            }];
            weakself.currentPage += 1;
            
            weakself.waitingBackHeight.constant = _sourceArr.count<=0?80:0;
            [weakself.mainTable reloadData];
            
            if (arr.count < [ChooseTopupPlanNetworkSize integerValue]) {
                [weakself.mainTable.mj_footer endRefreshingWithNoMoreData];
                weakself.mainTable.mj_footer.hidden = arr.count<=0?YES:NO;
            } else {
                weakself.mainTable.mj_footer.hidden = NO;
            }
            
            weakself.foundTipLab.hidden = weakself.sourceArr.count<=0?YES:NO;
            weakself.foundTopHeight.constant = weakself.sourceArr.count<=0?-20:20;
            weakself.waitBack.hidden = NO;
            weakself.tokenBack.hidden = weakself.sourceArr.count<=0?YES:NO;
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
    }];
}

- (void)requestTopup_pay_token {
    kWeakSelf(self);
    NSDictionary *params = @{};
    [RequestService requestWithUrl10:topup_pay_token_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            weakself.payTokenArr = [TopupPayTokenModel mj_objectArrayWithKeyValuesArray:responseObject[@"payTokenList"]];
            [weakself refreshPayTokenView];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ChooseTopupPlanCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_selectPayTokenM.chain isEqualToString:ETH_Chain]) {
        if (![WalletCommonModel haveETHWallet]) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:kLang(@"you_do_not_have_wallet_created_immediately"),@"ETH"] preferredStyle:UIAlertControllerStyleAlert];
            kWeakSelf(self);
            UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertC addAction:alertCancel];
            UIAlertAction *alertBuy = [UIAlertAction actionWithTitle:kLang(@"create") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakself jumpToChooseWallet:YES];
            }];
            [alertC addAction:alertBuy];
            [self presentViewController:alertC animated:YES completion:nil];
            
            return;
        }
    } else if ([_selectPayTokenM.chain isEqualToString:QLC_Chain]) {
        if (![WalletCommonModel haveQLCWallet]) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:kLang(@"you_do_not_have_wallet_created_immediately"),@"QLC"] preferredStyle:UIAlertControllerStyleAlert];
            kWeakSelf(self);
            UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertC addAction:alertCancel];
            UIAlertAction *alertBuy = [UIAlertAction actionWithTitle:kLang(@"create") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakself jumpToChooseWallet:YES];
            }];
            [alertC addAction:alertBuy];
            [self presentViewController:alertC animated:YES completion:nil];
            
            return;
        }
    }
    
    TopupProductModel *model = _sourceArr[indexPath.row];
    
    NSNumber *amountNum = model.amount;
//    NSNumber *faitNum = @([model.discount doubleValue]*[model.amount doubleValue]);
//    NSNumber *qgasNum = @([model.amount doubleValue]*[model.qgasDiscount doubleValue]);
    NSString *faitStr = [model.discount.mul(model.amount) showfloatStr:4];
    NSString *qgasStr = [model.amount.mul(model.qgasDiscount).div(_selectPayTokenM.price) showfloatStr:3];
    NSString *message = @"";
    if ([_selectPayTokenM.chain isEqualToString:ETH_Chain]) {
        message = [NSString stringWithFormat:kLang(@"use_to_purchase__yuan_of_phone_charge_for_deduction"),amountNum,qgasStr,_selectPayTokenM.symbol,faitStr];
    } else if ([_selectPayTokenM.chain isEqualToString:QLC_Chain]) {
        message = [NSString stringWithFormat:kLang(@"use_to_purchase__yuan_of_phone_charge_for_deduction"),amountNum,qgasStr,_selectPayTokenM.symbol,faitStr];
    }
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    kWeakSelf(self);
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    UIAlertAction *alertBuy = [UIAlertAction actionWithTitle:kLang(@"purchase") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([weakself.selectPayTokenM.chain isEqualToString:ETH_Chain]) {
            [weakself jumpToTopupPayETH:model];
        } else if ([weakself.selectPayTokenM.chain isEqualToString:QLC_Chain]) {
            [weakself jumpToTopupPayQLC:model];
        }
       
    }];
    [alertC addAction:alertBuy];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseTopupPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:ChooseTopupPlanCellReuse];
    
    TopupProductModel *model = _sourceArr[indexPath.row];
    [cell config:model payToken:_selectPayTokenM];
    
    return cell;
}

 #pragma mark - Action
 
 - (IBAction)backAction:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
 }

- (IBAction)choosePrefixNumAction:(id)sender {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:kLang(@"choose_international_and_regional") preferredStyle:UIAlertControllerStyleActionSheet];
    kWeakSelf(self);
    NSArray *sourceArr = @[@"+86"];
    [sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *phonePrefix = obj;
        UIAlertAction *alert = [UIAlertAction actionWithTitle:phonePrefix style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself.phonePrefixBtn setTitle:phonePrefix forState:UIControlStateNormal];
        }];
        [alertC addAction:alert];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (IBAction)chooseContactAction:(id)sender {
    _peoplePickVC = [[CNContactPickerViewController alloc] init];
    _peoplePickVC.delegate = self;
    //只是展示电话号码,email 等不展示
    //    _peoplePickVC.displayedPropertyKeys = [NSArray arrayWithObject:CNContactPhoneNumbersKey];
    //让有 email 的对象才可以选中
    //    _peoplePickVC.predicateForEnablingContact = [NSPredicate predicateWithFormat:@"emailAddresses.@count > 0"];
    //选中联系人是否返回
    //    _peoplePickVC.predicateForSelectionOfContact =  [NSPredicate predicateWithValue:false];
    //选中属性是否返回
    //    _peoplePickVC.predicateForSelectionOfProperty = [NSPredicate predicateWithValue:false];
    [self presentViewController:_peoplePickVC animated:YES
                     completion:^{
                     }];
//    [self showViewController:_peoplePickVC sender:nil];
}

- (IBAction)lookupProductAction:(id)sender {
    [self.view endEditing:YES];
    
    if ([_phoneTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_enter_your_mobile_phone_number")];
        return;
    }
    
    [_mainTable.mj_header beginRefreshing];
}

#pragma mark - CNContactPickerDelegate
////获取指定联系人 里面只log了第一个电话号码
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
//
//    //姓名
//    NSString * firstName = contact.familyName;
//    NSString * lastName = contact.givenName;
//
//    //电话
//    NSArray * phoneNums = contact.phoneNumbers;
//    CNLabeledValue *labelValue = phoneNums.firstObject;
//    NSString *phoneValue = [labelValue.value stringValue];
//
//    NSLog(@"姓名：%@%@ 电话：%@", firstName, lastName, phoneValue);
//
//}

// 获取指定电话
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    //姓名
    NSString * firstName = contactProperty.contact.familyName;
    NSString * lastName = contactProperty.contact.givenName;
    //电话
    NSString * phoneNum = [contactProperty.value stringValue];
    DDLogDebug(@"姓名：%@%@ 电话：%@", firstName, lastName, phoneNum);
    _phoneTF.text = phoneNum;
    
    if (![_phoneTF.text isEmptyString]) {
        [_mainTable.mj_header beginRefreshing];
    }
}

////获取多个联系人 里面只log了每个联系人第一个电话号码
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact *> *)contacts {
//
//    //遍历
//    for (CNContact * contact in contacts) {
//
//        //姓名
//        NSString * firstName = contact.familyName;
//        NSString * lastName = contact.givenName;
//
//        //电话
//        NSArray * phoneNums = contact.phoneNumbers;
//        CNLabeledValue *labelValue = phoneNums.firstObject;
//        NSString *phoneValue = [labelValue.value stringValue];
//
//        NSLog(@"姓名：%@%@ 电话：%@", firstName, lastName, phoneValue);
//
//    }
//}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    DDLogDebug(@"contactPickerDidCancel");
}

#pragma mark - Transition
- (void)jumpToTopupPayQLC:(TopupProductModel *)model {
    // 检查平台地址
    NSString *qlcAddress = [QLCWalletManage shareInstance].qlcMainAddress;
    if ([qlcAddress isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
//    NSNumber *qgasNum = @([model.amount doubleValue]*[model.qgasDiscount doubleValue]);
    NSString *qgasFaitStr = [model.qgasDiscount.mul(model.amount) showfloatStr:4];
    NSString *qgasStr = [model.amount.mul(model.qgasDiscount).div(_selectPayTokenM.price) showfloatStr:3];
    TopupPayQLCViewController *vc = [TopupPayQLCViewController new];
    vc.sendAmount = [NSString stringWithFormat:@"%@",qgasStr];
    vc.sendToAddress = qlcAddress;
    vc.sendMemo = [NSString stringWithFormat:kLang(@"recharge__yuan_phone_charge_deduction__yuan"),model.amount,qgasStr,_selectPayTokenM.symbol,qgasFaitStr];
    vc.inputPayToken = _selectPayTokenM.symbol?:@"QGAS";
    vc.inputProductM = model;
    vc.inputAreaCode = _phonePrefixBtn.currentTitle?:@"";
    vc.inputPhoneNumber = _phoneTF.text?:@"";
    vc.inputPayTokenId = _selectPayTokenM.ID?:@"";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToTopupPayETH:(TopupProductModel *)model {
    // 检查平台地址
    NSString *ethAddress = [ETHWalletManage shareInstance].ethMainAddress;
    if ([ethAddress isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
    NSString *okbFaitStr = [model.qgasDiscount.mul(model.amount) showfloatStr:4];
    NSString *okbStr = [model.amount.mul(model.qgasDiscount).div(_selectPayTokenM.price) showfloatStr:3];// @([model.amount doubleValue]*[model.qgasDiscount doubleValue]);
    TopupPayETHViewController *vc = [TopupPayETHViewController new];
    vc.sendAmount = [NSString stringWithFormat:@"%@",okbStr];
    vc.sendToAddress = ethAddress;
    vc.sendMemo = [NSString stringWithFormat:kLang(@"recharge__yuan_phone_charge_deduction__yuan"),model.amount,okbStr,_selectPayTokenM.symbol,okbFaitStr];
    vc.inputPayToken = _selectPayTokenM.symbol?:@"OKB";
    vc.inputProductM = model;
    vc.inputAreaCode = _phonePrefixBtn.currentTitle?:@"";
    vc.inputPhoneNumber = _phoneTF.text?:@"";
    vc.inputPayTokenId = _selectPayTokenM.ID?:@"";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToChooseWallet:(BOOL)showBack {
    ChooseWalletViewController *vc = [[ChooseWalletViewController alloc] init];
    vc.showBack = showBack;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
