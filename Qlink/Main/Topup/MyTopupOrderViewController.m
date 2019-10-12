//
//  MyTopupOrderViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MyTopupOrderViewController.h"
#import "MyTopupOrderCell.h"
#import "RefreshHelper.h"
#import "UserModel.h"
#import "TopupOrderModel.h"
#import "TopupConstants.h"
#import "TopupWebViewController.h"

static NSString *const MyTopupOrderNetworkSize = @"20";

@interface MyTopupOrderViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic) NSInteger currentPage;

@end

@implementation MyTopupOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self requestTopup_order_list];
}

#pragma mark - Operation
- (void)configInit {
    _currentPage = 1;
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:MyTopupOrderCellReuse bundle:nil] forCellReuseIdentifier:MyTopupOrderCellReuse];
    
    kWeakSelf(self)
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = 1;
        [weakself requestTopup_order_list];
    }];
    _mainTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestTopup_order_list];
    }];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)payHandler:(TopupOrderModel *)model {
    NSString *sid = Topup_Pay_H5_sid;
    NSString *trace_id = [NSString stringWithFormat:@"%@_%@_%@",Topup_Pay_H5_trace_id,model.userId?:@"",model.ID?:@""];
        NSString *package = [NSString stringWithFormat:@"%@",model.originalPrice];
    NSString *mobile = model.phoneNumber;
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@?sid=%@&trace_id=%@&package=%@&mobile=%@",Topup_Pay_H5_Url,sid,trace_id,package,mobile];
    [self jumpToTopupH5:urlStr];
}

- (void)cancelHandler:(TopupOrderModel *)model {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:kLang(@"qgas_will_be_returned_to_the_payment_address") preferredStyle:UIAlertControllerStyleAlert];
    kWeakSelf(self);
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    UIAlertAction *alertBuy = [UIAlertAction actionWithTitle:kLang(@"confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself requestTopup_cancel_order:model.ID?:@""];
    }];
    [alertC addAction:alertBuy];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - Request
- (void)requestTopup_order_list {
    kWeakSelf(self);
    NSString *account = @"";
    UserModel *userM = [UserModel fetchUserOfLogin];
    if ([UserModel haveLoginAccount]) {
        account = userM.account;
    }
    NSString *p2pId = [UserModel getTopupP2PId];
    NSString *page = [NSString stringWithFormat:@"%li",_currentPage];
    NSString *size = MyTopupOrderNetworkSize;
    NSDictionary *params = @{@"page":page,@"size":size,@"account":account,@"p2pId":p2pId};
    [RequestService requestWithUrl10:topup_order_list_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [TopupOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"orderList"]];
            if (weakself.currentPage == 1) {
                [weakself.sourceArr removeAllObjects];
            }
            
            [weakself.sourceArr addObjectsFromArray:arr];
            weakself.currentPage += 1;
            
            [weakself.mainTable reloadData];
            
            if (arr.count < [MyTopupOrderNetworkSize integerValue]) {
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

- (void)requestTopup_cancel_order:(NSString *)orderId {
    kWeakSelf(self);
    NSString *account = @"";
    UserModel *userM = [UserModel fetchUserOfLogin];
    if ([UserModel haveLoginAccount]) {
        account = userM.account;
    }
    NSString *p2pId = [UserModel getTopupP2PId];
    NSDictionary *params = @{@"account":account,@"p2pId":p2pId,@"orderId":orderId};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl10:topup_cancel_order_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            TopupOrderModel *model = [TopupOrderModel getObjectWithKeyValues:responseObject[@"order"]];
            
            __block NSInteger cancelIndex = 0;
            __block BOOL isExist = NO;
            [weakself.sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TopupOrderModel *tempM = obj;
                if ([tempM.ID isEqualToString:orderId]) {
                    cancelIndex = idx;
                    isExist = YES;
                    *stop = YES;
                }
            }];
            if (isExist) {
                [weakself.sourceArr replaceObjectAtIndex:cancelIndex withObject:model];
                [weakself.mainTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cancelIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MyTopupOrderCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTopupOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:MyTopupOrderCellReuse];
    
    kWeakSelf(self);
    TopupOrderModel *model = _sourceArr[indexPath.row];
    [cell config:model cancelB:^{
        [weakself cancelHandler:model];
    } payB:^{
        [weakself payHandler:model];
    }];
    
    return cell;
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    if (_inputBackToRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Transition
- (void)jumpToTopupH5:(NSString *)urlStr {
    TopupWebViewController *vc = [TopupWebViewController new];
    vc.inputUrl = urlStr;
    [self.navigationController pushViewController:vc animated:YES];
    return;
    
    //    NSURL *url = [NSURL URLWithString:@"https://shop.huagaotx.cn/wap/charge_v3.html?sid=8a51FmcnWGH-j2F-g9Ry2KT4FyZ_Rr5xcKdt7i96&trace_id=mm_1000001_998902&package=0&mobile=15989246851"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        [self backToRoot];
    }
}

@end
