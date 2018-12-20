//
//  ETHMnemonicConfirmViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ETHMnemonicConfirmViewController.h"
//#import "Qlink-Swift.h"
#import <TagListView/TagListView-Swift.h>
//#import "TagListView-Swift.h"
#import "SuccessTipView.h"

@interface ETHMnemonicConfirmViewController () <TagListViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet TagListView *selectTagListView;
@property (weak, nonatomic) IBOutlet TagListView *normalTagListView;

@end

@implementation ETHMnemonicConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;

    [self renderView];
}

#pragma mark - Operation
- (void)renderView {
    
    UIColor *btnShadowColor = [UIColorFromRGB(0x1F314A) colorWithAlphaComponent:0.12];
    [_confirmBtn addShadowWithOpacity:1 shadowColor:btnShadowColor shadowOffset:CGSizeMake(0, 2) shadowRadius:4 andCornerRadius:6];
    
    _selectTagListView.textFont = [UIFont systemFontOfSize:18];
    _normalTagListView.textFont = [UIFont systemFontOfSize:18];
    [_selectTagListView addTags:@[]];
    [_normalTagListView addTags:[self randomArr:AppConfigUtil.shareInstance.mnemonicArr]];
}

- (NSArray *)randomArr:(NSArray *)arr {
    NSArray *result = [arr sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    return result;
}

- (void)showCreateSuccessView {
    SuccessTipView *tip = [SuccessTipView getInstance];
    [tip showWithTitle:@"Create Success"];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Action

- (IBAction)confirmAction:(id)sender {
    NSMutableArray *tagArr = [NSMutableArray array];
    [_selectTagListView.tagViews enumerateObjectsUsingBlock:^(TagView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tagArr addObject:obj.currentTitle];
    }];
    if ([AppConfigUtil.shareInstance.mnemonicArr isEqualToArray:tagArr]) {
        [self showCreateSuccessView];
        [self performSelector:@selector(backToRoot) withObject:nil afterDelay:2];
    } else {
        [kAppD.window makeToastDisappearWithText:@"Order Wrong"];
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TagListViewDelegate
- (void)tagPressed:(NSString *)title tagView:(TagView *)tagView sender:(TagListView *)sender {
    NSLog(@"Tag pressed:%@  %@  isSelected:%@",title,sender,@(tagView.isSelected));
    if (sender == _normalTagListView) {
        [_normalTagListView removeTag:title];
        [_selectTagListView addTag:title];
    } else if (sender == _selectTagListView) {
        [_selectTagListView removeTag:title];
        [_normalTagListView addTag:title];
    }
}

- (void)tagRemoveButtonPressed:(NSString *)title tagView:(TagView *)tagView sender:(TagListView *)sender {
    NSLog(@"Tag remove button:%@  %@",title,sender);
}

@end
