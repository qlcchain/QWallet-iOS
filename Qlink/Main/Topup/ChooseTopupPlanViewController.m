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

@interface ChooseTopupPlanViewController () <UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate> {
    CNContactPickerViewController * _peoplePickVC;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (weak, nonatomic) IBOutlet UIView *numBack;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *phonePrefixBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookupProductBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitingBackHeight;


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
    
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:ChooseTopupPlanCellReuse bundle:nil] forCellReuseIdentifier:ChooseTopupPlanCellReuse];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ChooseTopupPlanCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return _sourceArr.count;
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseTopupPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:ChooseTopupPlanCellReuse];
    
    return cell;
}

 #pragma mark - Action
 
 - (IBAction)backAction:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
 }

- (IBAction)choosePrefixNumAction:(id)sender {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"选择国际和地区" preferredStyle:UIAlertControllerStyleActionSheet];
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
- (void)jumpToTopupPayQGAS {
    TopupPayQGASViewController *vc = [TopupPayQGASViewController new];
    vc.sendAmount = @"20";
    vc.sendToAddress = @"dddd";
    vc.sendMemo = @"asf";
    vc.inputPayToken = @"QGAS";
    [self.navigationController pushViewController:vc animated:YES];
}


@end
