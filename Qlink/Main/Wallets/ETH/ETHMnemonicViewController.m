//
//  ETHMnemonicViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/22.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ETHMnemonicViewController.h"
#import "Qlink-Swift.h"
//#import <TagListView/TagListView-Swift.h>
#import "MnemonicTipView.h"
#import "ETHMnemonicConfirmViewController.h"
#import <TTGTextTagCollectionView.h>
#import "AppConfigUtil.h"
#import "ETHWalletInfo.h"

@interface ETHMnemonicViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *tagListView;


@end

@implementation ETHMnemonicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self renderView];
}

#pragma mark - Operation
- (void)renderView {
    UIColor *btnShadowColor = [UIColorFromRGB(0x1F314A) colorWithAlphaComponent:0.12];
    [_nextBtn addShadowWithOpacity:1 shadowColor:btnShadowColor shadowOffset:CGSizeMake(0, 2) shadowRadius:4 andCornerRadius:6];
    
    _tagListView.horizontalSpacing = 6.0;
    _tagListView.verticalSpacing = 8.0;
    _tagListView.enableTagSelection = NO;
    _tagListView.backgroundColor = [UIColor clearColor];
    TTGTextTagConfig *config = _tagListView.defaultConfig;
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
//    _tagListView.textFont = [UIFont systemFontOfSize:18];
//    [_tagListView addTags:@[@"crisp", @"second", @"fold", @"uniform", @"gas", @"elbow", @"bind", @"castle", @"index", @"machine", @"foster", @"elbow"]];
    [_tagListView addTags:_walletInfo.mnemonicArr];
//    _tagListView.alignment = .Center // possible values are .Left, .Center, and .Right
//    _tagListView.addTag("TagListView")
//    _tagListView.insertTag("This should be the second tag", at: 1)
//    _tagListView.setTitle("New Title", at:6) // to replace the title a tag
//    _tagListView.removeTag("meow") // all tags with title “meow” will be removed
//    _tagListView.removeAllTags()
}

- (void)okOperation {
    [self jumpToMnemonicConfirm];
}

#pragma mark - Action

- (IBAction)nextAction:(id)sender {
    MnemonicTipView *tipV = [MnemonicTipView getInstance];
    kWeakSelf(self);
    tipV.okBlock = ^{
        [weakself okOperation];
    };
    [tipV show];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Transition
- (void)jumpToMnemonicConfirm {
    ETHMnemonicConfirmViewController *vc = [[ETHMnemonicConfirmViewController alloc] init];
    vc.walletInfo = _walletInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
