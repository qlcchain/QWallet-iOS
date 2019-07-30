//
//  ETHMnemonicViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/22.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ETHExportMnemonicViewController.h"
#import "Qlink-Swift.h"
//#import <TagListView/TagListView-Swift.h>
#import "MnemonicTipView.h"
#import "WalletCommonModel.h"
#import <ETHFramework/ETHFramework.h>
#import <TTGTextTagCollectionView.h>

@interface ETHExportMnemonicViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
//@property (weak, nonatomic) IBOutlet TagListView *tagListView;
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *tagListView;

@end

@implementation ETHExportMnemonicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = MAIN_WHITE_COLOR;
    _titleLab.text = _enterType==ETHExportMnemonicEnterTypeImport?@"Import Wallet":@"Export Mnemonic Phrase";
    
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
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    kWeakSelf(self);
    [TrustWalletManage.sharedInstance exportMnemonicWithAddress:currentWalletM.address?:@"" :^(NSArray<NSString *> * arr) {
//        // 暂时去重 以后再修改TrustWalletManage
//        NSMutableArray *resultArray = [NSMutableArray array];
//        for (NSString *item in arr) {
//            if (![resultArray containsObject:item]) {
//                [resultArray addObject:item];
//            }
//        }
        [weakself.tagListView removeAllTags];
        [weakself.tagListView addTags:arr?:@[]];
    }];
//    _tagListView.alignment = .Center // possible values are .Left, .Center, and .Right
//    _tagListView.addTag("TagListView")
//    _tagListView.insertTag("This should be the second tag", at: 1)
//    _tagListView.setTitle("New Title", at:6) // to replace the title a tag
//    _tagListView.removeTag("meow") // all tags with title “meow” will be removed
//    _tagListView.removeAllTags()
}

- (void)okOperation {
    if (_enterType == ETHExportMnemonicEnterTypeImport) {
        [self backToRoot];
    } else if (_enterType == ETHExportMnemonicEnterTypeExport) {
        [self back];
    }
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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

@end
