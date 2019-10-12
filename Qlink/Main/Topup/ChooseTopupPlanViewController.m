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
#import "TopupPayQGASViewController.h"
#import "RefreshHelper.h"
#import "TopupProductModel.h"
#import <QLCFramework/QLCWalletManage.h>
#import "TopupConstants.h"

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitingBackHeight; // 102
@property (nonatomic) NSInteger currentPage;


@end

@implementation ChooseTopupPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
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
        _waitingBackHeight.constant = 102;
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

#pragma mark - Request
- (void)requestTopup_product_list {
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
            
            weakself.waitingBackHeight.constant = _sourceArr.count<=0?102:0;
            [weakself.mainTable reloadData];
            
            if (arr.count < [ChooseTopupPlanNetworkSize integerValue]) {
                [weakself.mainTable.mj_footer endRefreshingWithNoMoreData];
                weakself.mainTable.mj_footer.hidden = arr.count<=0?YES:NO;
            } else {
                weakself.mainTable.mj_footer.hidden = NO;
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ChooseTopupPlanCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TopupProductModel *model = _sourceArr[indexPath.row];
    
    NSNumber *amountNum = model.amount;
    NSNumber *faitNum = @([model.discount doubleValue]*[model.amount doubleValue]);
    NSNumber *qgasNum = @([model.amount doubleValue]*[model.qgasDiscount doubleValue]);
    NSString *message = [NSString stringWithFormat:kLang(@"use_qgas_to_purchase__yuan_of_phone_charge_for_deduction"),amountNum,qgasNum,faitNum];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    kWeakSelf(self);
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    UIAlertAction *alertBuy = [UIAlertAction actionWithTitle:kLang(@"purchase") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself jumpToTopupPayQGAS:model];
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
    [cell config:model];
    
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
- (void)jumpToTopupPayQGAS:(TopupProductModel *)model {
    // 检查平台地址
    NSString *qlcAddress = [QLCWalletManage shareInstance].qlcMainAddress;
    if ([qlcAddress isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
//    NSNumber *faitNum = @([model.discount doubleValue]*[model.amount doubleValue]);
    NSNumber *qgasNum = @([model.amount doubleValue]*[model.qgasDiscount doubleValue]);
    TopupPayQGASViewController *vc = [TopupPayQGASViewController new];
    vc.sendAmount = [NSString stringWithFormat:@"%@",qgasNum];
    vc.sendToAddress = qlcAddress;
    vc.sendMemo = [NSString stringWithFormat:kLang(@"recharge__yuan_phone_charge__QGAS_deduction__yuan"),model.amount,qgasNum,qgasNum];
    vc.inputPayToken = @"QGAS";
    vc.inputProductM = model;
    vc.inputAreaCode = _phonePrefixBtn.currentTitle?:@"";
    vc.inputPhoneNumber = _phoneTF.text?:@"";
    [self.navigationController pushViewController:vc animated:YES];
}


@end
