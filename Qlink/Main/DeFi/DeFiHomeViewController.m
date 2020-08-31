//
//  HomeBuySellViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/8.
//  Copyright © 2019 pan. All rights reserved.
//

#import "DeFiHomeViewController.h"
#import <SwiftTheme/SwiftTheme-Swift.h>
#import "UISegmentedControl+Adapt.h"
#import "UIView+Gradient.h"
#import "DeFiSub_DefiViewController.h"
#import "DeFiSub_HotViewController.h"
#import "FirebaseUtil.h"
#import "FirebaseConstants.h"
#import "DeFiNewsWebViewController.h"
#import "DefiTokenModel.h"
#import "LFAdvertScrollView.h"
#import <TMCache/TMCache.h>
#import "OutbreakRedUtil.h"
#import "QSwipHmoeViewController.h"


@interface DeFiHomeViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *mainSeg;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (weak, nonatomic) IBOutlet UIView *mainScrollContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainScrollContentWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cycleHeight;
@property (weak, nonatomic) IBOutlet UIView *cycleBackView;

@property (nonatomic, strong) LFAdvertScrollView *cycleView;

@end

@implementation DeFiHomeViewController
    
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
    [self addChild];
    [self addChildVC];
    
    _cycleHeight.constant = 0;
    [self request_defi_list];
    [self requestSys_index];
    
    
    self.tabBarController.selectedIndex = 2;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

#pragma mark - Operation
- (void)configInit {
    [self refreshSegTitle];
    
    [self.view addHorizontalQGradientWithStart:UIColorFromRGB(0x4986EE) end:UIColorFromRGB(0x4752E9) frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_mainSeg segmentedIOS13Style];
    
    _mainScrollContentWidth.constant = SCREEN_WIDTH*2;
}

- (void)refreshSegTitle {
    [_mainSeg setTitle:kLang(@"defi") forSegmentAtIndex:0];
    [_mainSeg setTitle:kLang(@"defi_hot") forSegmentAtIndex:1];
}

- (void)addChild {
//    kWeakSelf(self);
    DeFiSub_DefiViewController *defi = [[DeFiSub_DefiViewController alloc]init];
    [self addChildViewController:defi];
    
    DeFiSub_HotViewController *hot = [[DeFiSub_HotViewController alloc]init];
    [self addChildViewController:hot];
    
//    DeFiNewsWebViewController *news = [DeFiNewsWebViewController new];
////    NSString *url = @"https://www.chainnews.com/articles/360764508535.htm";
//    NSString *url = @"https://cointelegraph.com/tags/defi";
//    news.inputUrl = url;
//    [self addChildViewController:news];
}

- (void)addChildVC {
    NSInteger n = _mainScroll.contentOffset.x / _mainScroll.frame.size.width;
    UITableViewController * ChildVC = (UITableViewController * )self.childViewControllers[n];
    ChildVC.view.frame = _mainScroll.bounds;
    if (ChildVC.view.superview) {
        return;
    }
    [_mainScroll addSubview:ChildVC.view];
    kWeakSelf(self);
    [ChildVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.mas_equalTo(weakself.mainScroll).offset(0);
        make.top.mas_equalTo(weakself.mainScroll).offset(0);
        make.left.mas_equalTo(n*SCREEN_WIDTH);
        make.bottom.mas_equalTo(weakself.mainScroll).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
}

- (void) showORCycleLabel:(NSArray *) modes
{
    _cycleHeight.constant = 35;
    if (self.cycleView) {
        
    } else {
        _cycleView = [[LFAdvertScrollView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-10, 35) withDataSuources:modes];
        [_cycleBackView addSubview:_cycleView];
        
//        kWeakSelf(self);
//        [_cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.bottom.right.mas_equalTo(weakself.cycleBackView).offset(0);
//        }];
    }
}

- (void)handlerSysIndex {
    NSDictionary *responseObject = [[TMCache sharedCache] objectForKey:@"TM_Chache_Topup_Sys_Index"]?:@{};
    
    if (responseObject.count <= 0) {
        return;
    }

    NSDictionary *dictList = responseObject[@"dictList"];
    // COVID-19
    NSString *show19 = dictList[@"show19"];
    NSString *appShow19 = dictList[@"appShow19"];
    [OutbreakRedUtil shareInstance].show19 = show19;
    [OutbreakRedUtil shareInstance].appShow19 = appShow19;
    
}


#pragma reqeust-- 网络请求
- (void) request_defi_list {
    kWeakSelf(self);
    NSDictionary *params = @{@"page":@(1),@"size":@(20)};
    [RequestService requestWithUrl5:defi_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
            if ([responseObject[Server_Code] integerValue] == 0) {
                NSArray *tokenModels = [DefiTokenModel mj_objectArrayWithKeyValuesArray:responseObject[@"deFiTokenList"]];
                if (tokenModels && tokenModels.count > 0) {
                    [weakself showORCycleLabel:tokenModels];
                }
                
            } else {
                [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
            }
        } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
            
        }];
}

#pragma mark - Request
- (void)requestSys_index {
    kWeakSelf(self);
//    NSString *page = @"1";
//    NSString *size = TopupNetworkSize;
    NSDictionary *params = @{};
    [RequestService requestWithUrl10:sys_index_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        if ([responseObject[Server_Code] integerValue] == 0) {
            
            [[TMCache sharedCache] setObject:responseObject forKey:@"TM_Chache_Topup_Sys_Index"];
            
            [weakself handlerSysIndex];
            
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
       
    }];
}



#pragma mark - UIScrollViewDelegate
//执行动画结束跳转到这里
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == _mainScroll) {
        [self addChildVC];
    }
    
}

//人为手动滚动结束到这里
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSInteger n = _mainScroll.contentOffset.x / _mainScroll.width;
    
    if (scrollView == _mainScroll) {
        [self addChildVC];
    }
}

#pragma mark - Action
- (IBAction)segAction:(id)sender {

    if (_mainSeg.selectedSegmentIndex == 0) {
        [FirebaseUtil logEventWithItemID:Defi_Home_Top_Defi itemName:Defi_Home_Top_Defi contentType:Defi_Home_Top_Defi];
    } else {
        [FirebaseUtil logEventWithItemID:Defi_Home_Top_Hot itemName:Defi_Home_Top_Hot contentType:Defi_Home_Top_Hot];
    }
    CGPoint offSet = _mainScroll.contentOffset;
    offSet.x = _mainSeg.selectedSegmentIndex * SCREEN_WIDTH;
    [_mainScroll setContentOffset:offSet animated:YES];
}

#pragma mark - Noti
- (void)languageChangeNoti:(NSNotification *)noti {
    [self refreshSegTitle];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    QSwipHmoeViewController *vc = [QSwipHmoeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
