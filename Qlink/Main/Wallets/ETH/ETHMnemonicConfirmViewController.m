//
//  ETHMnemonicConfirmViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ETHMnemonicConfirmViewController.h"
#import "Qlink-Swift.h"
//#import <TagListView/TagListView-Swift.h>
//#import "TagListView-Swift.h"
#import "SuccessTipView.h"
#import <TTGTextTagCollectionView.h>

@interface ETHMnemonicConfirmViewController () <TTGTextTagCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *selectTagListView;
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *normalTagListView;

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
    
    _normalTagListView.delegate = self;
    _normalTagListView.horizontalSpacing = 6.0;
    _normalTagListView.verticalSpacing = 8.0;
    _normalTagListView.enableTagSelection = YES;
    _normalTagListView.backgroundColor = [UIColor clearColor];
    TTGTextTagConfig *config = _normalTagListView.defaultConfig;
    config.textFont = [UIFont systemFontOfSize:18.0f];
    config.textColor = MAIN_BLUE_COLOR;
    //    config.selectedTextColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.backgroundColor = [UIColor whiteColor];
    //    config.selectedBackgroundColor = [UIColor colorWithRed:0.97 green:0.64 blue:0.27 alpha:1.00];
    //    config.borderColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    //    config.selectedBorderColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    //    config.borderWidth = 1;
    //    config.selectedBorderWidth = 1;
    config.shadowColor = [UIColor blackColor];
    config.shadowOffset = CGSizeMake(0, 0.3);
    config.shadowOpacity = 0.3f;
    config.shadowRadius = 0.5f;
    config.cornerRadius = 7;
    
    _selectTagListView.delegate = self;
    _selectTagListView.horizontalSpacing = 6.0;
    _selectTagListView.verticalSpacing = 8.0;
    _selectTagListView.enableTagSelection = YES;
    _selectTagListView.backgroundColor = [UIColor clearColor];
    config = _selectTagListView.defaultConfig;
    config.textFont = [UIFont systemFontOfSize:18.0f];
    config.textColor = MAIN_BLUE_COLOR;
    //    config.selectedTextColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.backgroundColor = [UIColor whiteColor];
    //    config.selectedBackgroundColor = [UIColor colorWithRed:0.97 green:0.64 blue:0.27 alpha:1.00];
    config.borderColor = MAIN_BLUE_COLOR;
//    config.selectedBorderColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.borderWidth = 1;
    //    config.selectedBorderWidth = 1;
    config.shadowColor = [UIColor blackColor];
    config.shadowOffset = CGSizeMake(0, 0.3);
    config.shadowOpacity = 0.3f;
    config.shadowRadius = 0.5f;
    config.cornerRadius = 7;
//    _selectTagListView.textFont = [UIFont systemFontOfSize:18];
//    _normalTagListView.textFont = [UIFont systemFontOfSize:18];
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
    [_selectTagListView.allTags enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tagArr addObject:obj];
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

#pragma mark - TTGTextTagCollectionViewDelegate
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(NSString *)tagText
                      atIndex:(NSUInteger)index
                     selected:(BOOL)selected
                    tagConfig:(TTGTextTagConfig *)config {
//    NSLog(@"Tag pressed:%@  %@  isSelected:%@",tagText,sender,@(tagView.isSelected));
    if (textTagCollectionView == _normalTagListView) {
        [_normalTagListView removeTag:tagText];
        [_selectTagListView addTag:tagText];
    } else if (textTagCollectionView == _selectTagListView) {
        [_selectTagListView removeTag:tagText];
        [_normalTagListView addTag:tagText];
    }
}



@end
