//
//  ETHMnemonicViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/22.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ETHExportMnemonicViewController.h"
#import <TagListView/TagListView-Swift.h>
#import "MnemonicTipView.h"
#import "WalletCommonModel.h"
#import <ETHFramework/ETHFramework.h>

@interface ETHExportMnemonicViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet TagListView *tagListView;

@end

@implementation ETHExportMnemonicViewController

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
    
    _tagListView.textFont = [UIFont systemFontOfSize:18];
//    [_tagListView addTags:@[@"crisp", @"second", @"fold", @"uniform", @"gas", @"elbow", @"bind", @"castle", @"index", @"machine", @"foster", @"elbow"]];
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    kWeakSelf(self);
    [TrustWalletManage.sharedInstance exportMnemonicWithAddress:currentWalletM.address?:@"" :^(NSArray<NSString *> * arr) {
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
    [self backToRoot];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
