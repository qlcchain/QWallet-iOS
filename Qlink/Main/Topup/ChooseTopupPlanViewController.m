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
#import "TopupPayQLC_Deduction_CNYViewController.h"
#import "RefreshHelper.h"
#import "TopupProductModel.h"
#import <QLCFramework/QLCWalletManage.h>
#import "TopupConstants.h"
#import "TopupDeductionTokenModel.h"
#import "TopupPayETH_Deduction_CNYViewController.h"
#import "RLArithmetic.h"
#import "WalletCommonModel.h"
#import "ChooseWalletViewController.h"
#import "NSString+RemoveZero.h"
#import "ETHWalletManage.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "ChooseCountryUtil.h"
#import "ChooseCountryCodeViewController.h"
#import "TopupCountryModel.h"
#import "NSDate+Category.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import "TopupOrderModel.h"
#import "TopupPayQLC_DeductionViewController.h"
#import "TopupPayETH_DeductionViewController.h"
#import "NeoTransferUtil.h"
#import "GroupBuyDetialViewController.h"
#import "GroupBuyListModel.h"
#import "GroupBuyUtil.h"

static NSInteger DeductionTokenBtnTag = 6649;
static NSInteger DeductionTokenTickTag = 9223;
static NSString *const ChooseTopupPlanNetworkSize = @"20";

@interface ChooseTopupPlanViewController () <UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate, UITextFieldDelegate> {
    CNContactPickerViewController * _peoplePickVC;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainTableHeight;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@property (weak, nonatomic) IBOutlet UILabel *countryCodeLab;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
//@property (weak, nonatomic) IBOutlet UIButton *phonePrefixBtn;
@property (weak, nonatomic) IBOutlet UILabel *cardLab;
@property (weak, nonatomic) IBOutlet UILabel *regionLab;

@property (weak, nonatomic) IBOutlet UIButton *lookupProductBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitingBackHeight; // 80
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tokenBackHeight; // 76
@property (weak, nonatomic) IBOutlet UIView *deductionTokenContentV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deductionTokenContentWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foundTopHeight; // 20
@property (weak, nonatomic) IBOutlet UILabel *foundTipLab;
@property (weak, nonatomic) IBOutlet UIView *waitBack;
@property (weak, nonatomic) IBOutlet UIView *tokenBack;

@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) NSArray *deductionTokenArr;
@property (nonatomic, strong) TopupDeductionTokenModel *selectDeductionTokenM;
@property (nonatomic, strong) NSArray *ispArr;
@property (nonatomic, strong) NSArray *provinceArr;

@end

@implementation ChooseTopupPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self refreshCountrySelect:_inputCountryM];
    [self requestTopup_pay_token];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    if (_sourceArr.count <= 0) {
//        [_phoneTF becomeFirstResponder];
//    }
}

#pragma mark - Operation
- (void)configInit {
    
    _foundTipLab.hidden = YES;
    _waitBack.hidden = YES;
    _tokenBack.hidden = YES;
    
//    _numBack.layer.cornerRadius = 8;
//    _numBack.layer.masksToBounds = YES;
//    _numBack.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
//    _numBack.layer.borderWidth = 1;
    _lookupProductBtn.layer.cornerRadius = 4;
    _lookupProductBtn.layer.masksToBounds = YES;
    _regionLab.text = kLang(@"optional");
    
    _currentPage = 1;
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:ChooseTopupPlanCellReuse bundle:nil] forCellReuseIdentifier:ChooseTopupPlanCellReuse];
    self.baseTable = _mainTable;
    
    [_phoneTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [_phoneTF addTarget:self action:@selector(textFieldEditDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    _phoneTF.delegate = self;

    kWeakSelf(self)
    _mainScroll.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = 1;
        [weakself requestTopup_product_list_v2];
    }];
    _mainScroll.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestTopup_product_list_v2];
    }];
}

- (void)refreshCountrySelect:(TopupCountryModel *)model {
    if (!model) {
        return;
    }
    _countryCodeLab.text = [NSString stringWithFormat:@"%@ %@",model.nameEn,model.globalRoaming];
    _cardLab.text = nil;
    _ispArr = nil;
    _regionLab.text = kLang(@"optional");
    _provinceArr = nil;
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
        [_mainScroll.mj_header beginRefreshing];
    }
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)refreshDeductionTokenView {
    if (!_deductionTokenArr || _deductionTokenArr.count <= 0) {
        [_deductionTokenContentV.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        _deductionTokenContentWidth.constant = 0;
        return;
    }
    
    CGFloat offset = 13;
    CGFloat btnWidth = 0;
    if (_deductionTokenArr.count<=1) {
        btnWidth = SCREEN_WIDTH-16*2;
    } else if (_deductionTokenArr.count==2) {
        btnWidth = (SCREEN_WIDTH-16*2-offset)/2;
    } else if (_deductionTokenArr.count>2) {
        btnWidth = (SCREEN_WIDTH-16*2-2*offset)/2.5;
    }
    CGFloat btnHeight = 40;
    CGFloat top = (_deductionTokenContentV.height-btnHeight)/2.0;
    kWeakSelf(self);
    [_deductionTokenArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(idx*(btnWidth+offset), top, btnWidth, btnHeight);
        btn.tag = DeductionTokenBtnTag+idx;
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(8, 0, 8, 8)];
        [btn addTarget:weakself action:@selector(deductionTokenAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [weakself.deductionTokenContentV addSubview:btn];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        
        UIImageView *imgV = [UIImageView new];
        imgV.frame = CGRectMake(btn.right-21, btn.bottom-19, 21, 19);
        imgV.tag = DeductionTokenTickTag+idx;
        imgV.image = [UIImage imageNamed:@"topup_btn_selected"];
        [weakself.deductionTokenContentV addSubview:imgV];
        
        TopupDeductionTokenModel *model = obj;
        [weakself showDeductionTokenUnselect:idx];
        if (idx == 0) {
            weakself.selectDeductionTokenM = model;
            [weakself showDeductionTokenSelect:idx];
        }
        
        NSURL *url = [NSURL URLWithString:model.logoPng];
        [btn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[model getDeductionTokenImage] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            UIImage *img = [image sd_resizedImageWithSize:CGSizeMake(28, 28) scaleMode:SDImageScaleModeAspectFit];
            if (image) {
                [btn setImage:img forState:UIControlStateNormal];
            }
        }];
    }];
    
    _deductionTokenContentWidth.constant = _deductionTokenArr.count*btnWidth+(_deductionTokenArr.count-1)*offset;
}

- (void)deductionTokenAction:(UIButton *)btn {
    NSInteger selectIdx = btn.tag - DeductionTokenBtnTag;
    
    kWeakSelf(self);
    [_deductionTokenArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TopupDeductionTokenModel *model = obj;
        [weakself showDeductionTokenUnselect:idx];
        if (idx == selectIdx) {
            weakself.selectDeductionTokenM = model;
            [weakself showDeductionTokenSelect:idx];
        }
    }];
    
    [_mainTable reloadData];
    if (_sourceArr.count>0) {
        [_mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)showDeductionTokenUnselect:(NSInteger)idx {
    TopupDeductionTokenModel *model = _deductionTokenArr[idx];
    UIButton *btn = [_deductionTokenContentV viewWithTag:DeductionTokenBtnTag+idx];
//    [btn setImage:[model getDeductionTokenImage] forState:UIControlStateNormal];
    [btn setTitle:model.symbol forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x1E1E24) forState:UIControlStateNormal];
    btn.layer.cornerRadius = 6;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = UIColorFromRGB(0xE3E3E3).CGColor;
    
    UIImageView *imgV = [_deductionTokenContentV viewWithTag:DeductionTokenTickTag+idx];
    imgV.hidden = YES;
    
    btn.alpha = 0.5;
    imgV.alpha = 0.5;
}

- (void)showDeductionTokenSelect:(NSInteger)idx {
    TopupDeductionTokenModel *model = _deductionTokenArr[idx];
    UIButton *btn = [_deductionTokenContentV viewWithTag:DeductionTokenBtnTag+idx];
//    [btn setImage:[model getDeductionTokenImage] forState:UIControlStateNormal];
    [btn setTitle:model.symbol forState:UIControlStateNormal];
    [btn setTitleColor:MAIN_BLUE_COLOR forState:UIControlStateNormal];
    btn.layer.cornerRadius = 6;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = MAIN_BLUE_COLOR.CGColor;
    
    UIImageView *imgV = [_deductionTokenContentV viewWithTag:DeductionTokenTickTag+idx];
    imgV.hidden = NO;
    
    btn.alpha = 1;
    imgV.alpha = 1;
}

- (NSString *)getGlobalRoamingFromCountryCodeLab {
    NSString *globalRoaming = @"";
    NSString *countryCodeText = _countryCodeLab.text;
    if (![countryCodeText isEmptyString]) {
        globalRoaming = [countryCodeText componentsSeparatedByString:@" "].lastObject;
    }
    
    return globalRoaming;
}

- (void)showIspView {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    kWeakSelf(self);
    [_ispArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *isp = obj;
        UIAlertAction *alert = [UIAlertAction actionWithTitle:isp style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakself.cardLab.text = isp;
            weakself.regionLab.text = kLang(@"optional");
            weakself.provinceArr = nil;
        }];
        [alertC addAction:alert];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    alertC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)showProvinceView {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    kWeakSelf(self);
    [_provinceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *province = obj;
        UIAlertAction *alert = [UIAlertAction actionWithTitle:province style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakself.regionLab.text = province;
        }];
        [alertC addAction:alert];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    alertC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)handlerPayCNY:(TopupProductModel *)model {
    NSString *amountNum = model.localFiatAmount;
    NSString *faitStr = [model.discount.mul(model.payTokenMoney) showfloatStr:4];
    NSNumber *deductionTokenPrice = @(1);
    if ([model.payFiat isEqualToString:@"CNY"]) {
        deductionTokenPrice = _selectDeductionTokenM.price;
    } else if ([model.payFiat isEqualToString:@"USD"]) {
        deductionTokenPrice = _selectDeductionTokenM.usdPrice;
    }
    NSString *qgasStr = [model.payTokenMoney.mul(model.qgasDiscount).div(deductionTokenPrice) showfloatStr:3];
    NSString *message = [NSString stringWithFormat:kLang(@"use_to_purchase__yuan_of_phone_charge_for_deduction"),amountNum,qgasStr,_selectDeductionTokenM.symbol,faitStr];
//    if ([_selectDeductionTokenM.chain isEqualToString:ETH_Chain]) {
//        message = [NSString stringWithFormat:kLang(@"use_to_purchase__yuan_of_phone_charge_for_deduction"),amountNum,qgasStr,_selectDeductionTokenM.symbol,faitStr];
//    } else if ([_selectDeductionTokenM.chain isEqualToString:QLC_Chain]) {
//        message = [NSString stringWithFormat:kLang(@"use_to_purchase__yuan_of_phone_charge_for_deduction"),amountNum,qgasStr,_selectDeductionTokenM.symbol,faitStr];
//    }
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    kWeakSelf(self);
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    UIAlertAction *alertBuy = [UIAlertAction actionWithTitle:kLang(@"purchase") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 老版本
//        if ([weakself.selectDeductionTokenM.chain isEqualToString:ETH_Chain]) {
//            [weakself jumpToTopupPayETH_Deduction_CNY:model];
//        } else if ([weakself.selectDeductionTokenM.chain isEqualToString:QLC_Chain]) {
//            [weakself jumpToTopupPayQLC_Deduction_CNY:model];
//        }
        // 新版
       [weakself requestTopup_order:model];
    }];
    [alertC addAction:alertBuy];
    alertC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)handlerPayToken:(TopupProductModel *)model {
    NSString *amountNum = model.localFiatAmount;
    NSString *fait1Str = model.discount.mul(model.payTokenMoney);
//    NSString *faitMoneyStr = [model.discount.mul(model.payTokenMoney) showfloatStr:4];
    NSString *deduction1Str = model.payTokenMoney.mul(model.qgasDiscount);
    NSNumber *deductionTokenPrice = @(1);
    if ([model.payFiat isEqualToString:@"CNY"]) {
        deductionTokenPrice = _selectDeductionTokenM.price;
    } else if ([model.payFiat isEqualToString:@"USD"]) {
        deductionTokenPrice = _selectDeductionTokenM.usdPrice;
    }
    NSString *deductionAmountStr = [model.payTokenMoney.mul(model.qgasDiscount).div(deductionTokenPrice) showfloatStr:3];
    NSNumber *payTokenPrice = [model.payFiat isEqualToString:@"CNY"]?model.payTokenCnyPrice:[model.payFiat isEqualToString:@"USD"]?model.payTokenUsdPrice:@(0);
    NSString *payAmountStr = [fait1Str.sub(deduction1Str).div(payTokenPrice) showfloatStr:3];
    // Top-up value %@ %@\npay %@ %@ and %@ %@
    // localFiatAmount  lacalFait    qgasStr        payTokenAmount
    NSString *message = [NSString stringWithFormat:kLang(@"use_to_purchase__yuan_of_phone_charge_for_deduction_1"),amountNum, model.localFiat, deductionAmountStr,_selectDeductionTokenM.symbol,payAmountStr, model.payTokenSymbol];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    kWeakSelf(self);
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    UIAlertAction *alertBuy = [UIAlertAction actionWithTitle:kLang(@"purchase") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself requestTopup_order:model];
    }];
    [alertC addAction:alertBuy];
    alertC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertC animated:YES completion:nil];
}



#pragma mark - Request
- (void)requestTopup_product_list_v2 {
    if (!_selectDeductionTokenM) {
        [_mainScroll.mj_header endRefreshing];
        [_mainScroll.mj_footer endRefreshing];
        return;
    }
    kWeakSelf(self);
//    NSString *phoneNumber = _phoneTF.text?:@"";
    NSString *globalRoaming = [self getGlobalRoamingFromCountryCodeLab];
    NSString *isp = _cardLab.text?:@"";
    NSString *province = _regionLab.text?[_regionLab.text isEqualToString:kLang(@"optional")]?@"":_regionLab.text:@"";
    NSString *page = [NSString stringWithFormat:@"%li",_currentPage];
    NSString *size = ChooseTopupPlanNetworkSize;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"page":page,@"size":size}];
    if (![globalRoaming isEmptyString]) {
        [params setObject:globalRoaming forKey:@"globalRoaming"];
    }
    if (![isp isEmptyString]) {
        [params setObject:isp forKey:@"isp"];
    }
    if (![province isEmptyString]) {
        [params setObject:province forKey:@"province"];
    }
    [RequestService requestWithUrl10:topup_product_list_v2_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainScroll.mj_header endRefreshing];
        [weakself.mainScroll.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [TopupProductModel mj_objectArrayWithKeyValuesArray:responseObject[@"productList"]];
            if (weakself.currentPage == 1) {
                [weakself.sourceArr removeAllObjects];
            }
            
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TopupProductModel *model1 = obj;
                [[model1.amountOfMoney componentsSeparatedByString:@","] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TopupProductModel *model2 = [TopupProductModel getObjectWithKeyValues:model1.mj_keyValues];
                    model2.localFaitMoney = obj;
                    if (![model1.payFiatAmount isEmptyString]) {
                        model2.payTokenMoney = [model1.payFiatAmount componentsSeparatedByString:@","][idx]?:@"0";
                    }
                    [weakself.sourceArr addObject:[model2 v2ToV3]];
                }];
            }];
            weakself.currentPage += 1;
            
            weakself.waitingBackHeight.constant = _sourceArr.count<=0?80:0;
            weakself.mainTableHeight.constant = _sourceArr.count*ChooseTopupPlanCell_Height;
            [weakself.mainTable reloadData];
            
            if (arr.count < [ChooseTopupPlanNetworkSize integerValue]) {
                [weakself.mainScroll.mj_footer endRefreshingWithNoMoreData];
//                weakself.mainTable.mj_footer.hidden = arr.count<=0?YES:NO;
                weakself.mainScroll.mj_footer.hidden = YES;
            } else {
                weakself.mainScroll.mj_footer.hidden = NO;
            }
            
            weakself.foundTipLab.hidden = weakself.sourceArr.count<=0?YES:NO;
            weakself.foundTopHeight.constant = weakself.sourceArr.count<=0?-20:20;
            weakself.waitBack.hidden = NO;
            weakself.tokenBack.hidden = weakself.sourceArr.count<=0?YES:NO;
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.mainScroll.mj_header endRefreshing];
        [weakself.mainScroll.mj_footer endRefreshing];
    }];
}

- (void)requestTopup_pay_token {
    kWeakSelf(self);
    NSDictionary *params = @{};
    [RequestService requestWithUrl10:topup_pay_token_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            weakself.deductionTokenArr = [TopupDeductionTokenModel mj_objectArrayWithKeyValuesArray:responseObject[@"payTokenList"]];
            [weakself refreshDeductionTokenView];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestTopup_isp_list {
    kWeakSelf(self);
    NSString *globalRoaming = [self getGlobalRoamingFromCountryCodeLab];
    NSDictionary *params = @{@"globalRoaming":globalRoaming};
    [RequestService requestWithUrl10:topup_isp_list_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            weakself.ispArr = responseObject[@"ispList"];
            [weakself showIspView];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestTopup_province_list {
    kWeakSelf(self);
    NSString *globalRoaming = [self getGlobalRoamingFromCountryCodeLab];
    NSString *isp = _cardLab.text?:@"";
    NSDictionary *params = @{@"globalRoaming":globalRoaming, @"isp":isp};
    [RequestService requestWithUrl10:topup_province_list_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            weakself.provinceArr = responseObject[@"ispList"];
            [weakself showProvinceView];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestTopup_order:(TopupProductModel *)model {
    kWeakSelf(self);
    NSString *account = @"";
    UserModel *userM = [UserModel fetchUserOfLogin];
    if ([UserModel haveLoginAccount]) {
        account = userM.account;
    }
    NSString *p2pId = [UserModel getTopupP2PId];
    NSString *productId = model.ID?:@"";
    NSString *phoneNumber = _phoneTF.text?:@"";
    NSString *localFiatAmount = [NSString stringWithFormat:@"%@",model.localFiatAmount];
    NSString *deductionTokenId = _selectDeductionTokenM.ID?:@"";
    NSDictionary *params = @{@"account":account,@"p2pId":p2pId,@"productId":productId,@"phoneNumber":phoneNumber,@"localFiatAmount":localFiatAmount,@"deductionTokenId":deductionTokenId?:@""};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl10:topup_order_v2_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            
            TopupOrderModel *orderM = [TopupOrderModel getObjectWithKeyValues:responseObject[@"order"]];
            
            if ([weakself.selectDeductionTokenM.chain isEqualToString:ETH_Chain]) {
                [weakself jumpToTopupPayETH_Deduction:orderM];
            } else if ([weakself.selectDeductionTokenM.chain isEqualToString:QLC_Chain]) {
                [weakself jumpToTopupPayQLC_Deduction:orderM];
            }
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
//        [weakself hidePayLoadView];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _phoneTF) {
        return [self validateNumber:string];
    }
    return YES;
}
 
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ChooseTopupPlanCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 抵扣币
    if ([_selectDeductionTokenM.chain isEqualToString:ETH_Chain]) {
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
            alertC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:alertC animated:YES completion:nil];
            
            return;
        }
    } else if ([_selectDeductionTokenM.chain isEqualToString:QLC_Chain]) {
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
            alertC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:alertC animated:YES completion:nil];
            
            return;
        }
    }
    
    TopupProductModel *model = _sourceArr[indexPath.row];
    
    if ([_phoneTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"phone_number_cannot_be_empty")];
        return;
    }
    if ([[_phoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] length] > 0 || _phoneTF.text.length < 6) { // 大于6位的纯数字
        [kAppD.window makeToastDisappearWithText:kLang(@"please_fill_in_a_valid_phone_number")];
        return;
    }
    
    if ([model.payWay isEqualToString:@"FIAT"]) { // 法币支付
        if ([model.payFiat isEqualToString:@"CNY"]) {
            [self handlerPayCNY:model];
        } else if ([model.payFiat isEqualToString:@"USD"]) {
            
        }
    } else if ([model.payWay isEqualToString:@"TOKEN"]) { // 代币支付
        
        kWeakSelf(self);
        [GroupBuyUtil requestIsInGroupBuyActiviyTime:^(BOOL isInGroupBuyActiviyTime) {
            if (isInGroupBuyActiviyTime) {
                [weakself jumpToGroupBuyDetial:model];
            } else {
                [weakself handlerPayToken:model];
            }
        }];
        
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseTopupPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:ChooseTopupPlanCellReuse];
    
    TopupProductModel *model = _sourceArr[indexPath.row];
    [cell config:model token:_selectDeductionTokenM];
    
    return cell;
}

 #pragma mark - Action
 
 - (IBAction)backAction:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
 }

- (IBAction)countryCodeAction:(id)sender {
    [self jumpToChooseCountryCode];
}

- (IBAction)cardAction:(id)sender {
    if ([_countryCodeLab.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_choose_country_code_first")];
        return;
    }
    
    if (_ispArr) {
        [self showIspView];
    } else {
        [self requestTopup_isp_list];
    }
}

- (IBAction)regionAction:(id)sender {
    if ([_countryCodeLab.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_choose_country_code_first")];
        return;
    }
    
    if ([_cardLab.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_choose_operator_first")];
        return;
    }
    
    if (_provinceArr) {
        [self showProvinceView];
    } else {
        [self requestTopup_province_list];
    }
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
    _peoplePickVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:_peoplePickVC animated:YES
                     completion:^{
                     }];
//    [self showViewController:_peoplePickVC sender:nil];
}

- (IBAction)lookupProductAction:(id)sender {
    [self.view endEditing:YES];
    
//    if ([_phoneTF.text isEmptyString]) {
//        [kAppD.window makeToastDisappearWithText:kLang(@"please_enter_your_mobile_phone_number")];
//        return;
//    }
    
    [_mainScroll.mj_header beginRefreshing];
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
    NSString *num = [ChooseCountryUtil removeCodeContain:phoneNum];
    _phoneTF.text = num;
    
    if (![_phoneTF.text isEmptyString]) {
        [_mainScroll.mj_header beginRefreshing];
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
- (void)jumpToTopupPayQLC_Deduction_CNY:(TopupProductModel *)model {
    // 检查平台地址
    NSString *qlcAddress = [QLCWalletManage shareInstance].qlcMainAddress;
    if ([qlcAddress isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
//    NSNumber *qgasNum = @([model.amount doubleValue]*[model.qgasDiscount doubleValue]);
    NSString *faitStr = [model.discount.mul(model.payTokenMoney) showfloatStr:4];
//    NSString *qgasFaitStr = [model.qgasDiscount.mul(model.amount) showfloatStr:4];
    NSNumber *deductionTokenPrice = @(1);
    if ([model.payFiat isEqualToString:@"CNY"]) {
        deductionTokenPrice = _selectDeductionTokenM.price;
    } else if ([model.payFiat isEqualToString:@"USD"]) {
        deductionTokenPrice = _selectDeductionTokenM.usdPrice;
    }
    NSString *qgasStr = [model.payTokenMoney.mul(model.qgasDiscount).div(deductionTokenPrice) showfloatStr:3];
    TopupPayQLC_Deduction_CNYViewController *vc = [TopupPayQLC_Deduction_CNYViewController new];
    vc.sendAmount = [NSString stringWithFormat:@"%@",qgasStr];
    vc.sendToAddress = qlcAddress;
//    vc.sendMemo = [NSString stringWithFormat:kLang(@"recharge__yuan_phone_charge_deduction__yuan"),model.amount,qgasStr,_selectDeductionTokenM.symbol,qgasFaitStr];
    vc.sendMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",model.ID?:@"",faitStr?:@""];
    vc.inputDeductionToken = _selectDeductionTokenM.symbol?:@"QGAS";
    vc.inputProductM = model;
    vc.inputAreaCode = [self getGlobalRoamingFromCountryCodeLab];
    vc.inputPhoneNumber = _phoneTF.text?:@"";
    vc.inputDeductionTokenId = _selectDeductionTokenM.ID?:@"";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToTopupPayETH_Deduction_CNY:(TopupProductModel *)model {
    // 检查平台地址
    NSString *ethAddress = [ETHWalletManage shareInstance].ethMainAddress;
    if ([ethAddress isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
    NSString *fait1Str = model.discount.mul(model.payTokenMoney);
    NSString *faitMoneyStr = [model.discount.mul(model.payTokenMoney) showfloatStr:4];
    NSString *deduction1Str = model.payTokenMoney.mul(model.qgasDiscount);
    NSNumber *deductionTokenPrice = @(1);
    if ([model.payFiat isEqualToString:@"CNY"]) {
        deductionTokenPrice = _selectDeductionTokenM.price;
    } else if ([model.payFiat isEqualToString:@"USD"]) {
        deductionTokenPrice = _selectDeductionTokenM.usdPrice;
    }
    NSString *deductionAmountStr = [model.payTokenMoney.mul(model.qgasDiscount).div(deductionTokenPrice) showfloatStr:3];
    NSNumber *payTokenPrice = [model.payFiat isEqualToString:@"CNY"]?model.payTokenCnyPrice:[model.payFiat isEqualToString:@"USD"]?model.payTokenUsdPrice:@(0);
    NSString *payAmountStr = [fait1Str.sub(deduction1Str).div(payTokenPrice) showfloatStr:3];
    TopupPayETH_Deduction_CNYViewController *vc = [TopupPayETH_Deduction_CNYViewController new];
    vc.sendAmount = [NSString stringWithFormat:@"%@",deductionAmountStr];
    vc.sendToAddress = ethAddress;
//    vc.sendMemo = [NSString stringWithFormat:kLang(@"recharge__yuan_phone_charge_deduction__yuan"),model.localFiatAmount,okbStr,_selectDeductionTokenM.symbol,okbFaitStr];
    vc.sendMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",model.ID?:@"",faitMoneyStr?:@""];
    vc.inputDeductionToken = _selectDeductionTokenM.symbol?:@"OKB";
    vc.inputProductM = model;
    vc.inputAreaCode = [self getGlobalRoamingFromCountryCodeLab];
    vc.inputPhoneNumber = _phoneTF.text?:@"";
    vc.inputDeductionTokenId = _selectDeductionTokenM.ID?:@"";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToTopupPayQLC_Deduction:(TopupOrderModel *)orderM {
    // 检查平台地址
    NSString *qlcAddress = [QLCWalletManage shareInstance].qlcMainAddress;
    if ([qlcAddress isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
    if ([TopupOrderModel checkPayTokenChainServerAddressIsEmpty:orderM]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
    TopupPayQLC_DeductionViewController *vc = [TopupPayQLC_DeductionViewController new];
    vc.sendDeductionAmount = [NSString stringWithFormat:@"%@",orderM.qgasAmount];
    vc.sendDeductionToAddress = qlcAddress;
    vc.sendDeductionMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.payTokenAmount_str?:@""];
    vc.sendPayTokenAmount = [NSString stringWithFormat:@"%@",orderM.payTokenAmount_str];
    vc.sendPayTokenToAddress = [TopupOrderModel getPayTokenChainServerAddress:orderM];
    vc.sendPayTokenMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.qgasAmount?:@""];
    vc.inputPayToken = orderM.payTokenSymbol;
    vc.inputDeductionToken = _selectDeductionTokenM.symbol?:@"QGAS";
//    vc.inputProductM = productM;
    vc.inputOrderM = orderM;
//    vc.inputAreaCode = [self getGlobalRoamingFromCountryCodeLab];
//    vc.inputPhoneNumber = _phoneTF.text?:@"";
//    vc.inputDeductionTokenId = _selectDeductionTokenM.ID?:@"";
    vc.inputPayType = TopupPayTypeNormal;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToTopupPayETH_Deduction:(TopupOrderModel *)orderM {
    // 检查平台地址
    NSString *ethAddress = [ETHWalletManage shareInstance].ethMainAddress;
    if ([ethAddress isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
    if ([TopupOrderModel checkPayTokenChainServerAddressIsEmpty:orderM]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
    TopupPayETH_DeductionViewController *vc = [TopupPayETH_DeductionViewController new];
    vc.sendDeductionAmount = [NSString stringWithFormat:@"%@",orderM.qgasAmount];
    vc.sendDeductionToAddress = ethAddress;
    vc.sendDeductionMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.qgasAmount?:@""];
    vc.sendPayTokenAmount = [NSString stringWithFormat:@"%@",orderM.payTokenAmount_str];
    vc.sendPayTokenToAddress = [TopupOrderModel getPayTokenChainServerAddress:orderM];
    vc.sendPayTokenMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.payTokenAmount_str?:@""];
    vc.inputPayToken = orderM.payTokenSymbol;
    vc.inputDeductionToken = _selectDeductionTokenM.symbol?:@"OKB";
//    vc.inputProductM = productM;
    vc.inputOrderM = orderM;
//    vc.inputAreaCode = [self getGlobalRoamingFromCountryCodeLab];
//    vc.inputPhoneNumber = _phoneTF.text?:@"";
//    vc.inputDeductionTokenId = _selectDeductionTokenM.ID?:@"";
    vc.inputPayType = TopupPayTypeNormal;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToChooseWallet:(BOOL)showBack {
    ChooseWalletViewController *vc = [[ChooseWalletViewController alloc] init];
    vc.showBack = showBack;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToChooseCountryCode {
    ChooseCountryCodeViewController *vc = [ChooseCountryCodeViewController new];
    vc.inputCountryCode = [self getGlobalRoamingFromCountryCodeLab];
    kWeakSelf(self);
    vc.resultB = ^(TopupCountryModel * _Nonnull selectM) {
        [weakself refreshCountrySelect:selectM];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToGroupBuyDetial:(TopupProductModel *)model {
    GroupBuyDetialViewController *vc = [GroupBuyDetialViewController new];
    vc.inputProductM = model;
//    vc.inputCountryM = _inputCountryM;
//    vc.inputPhoneNum = _phoneTF.text?:@"";
    vc.inputDeductionTokenM = _selectDeductionTokenM;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
