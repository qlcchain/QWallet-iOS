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

@interface ETHMnemonicViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet TagListView *tagListView;


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
    
    _tagListView.textFont = [UIFont systemFontOfSize:18];
//    [_tagListView addTags:@[@"crisp", @"second", @"fold", @"uniform", @"gas", @"elbow", @"bind", @"castle", @"index", @"machine", @"foster", @"elbow"]];
    [_tagListView addTags:AppConfigUtil.shareInstance.mnemonicArr];
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
    [self.navigationController pushViewController:vc animated:YES];
}

@end
