//
//  QSwapDetailViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2020/8/22.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QSwapDetailViewController.h"
#import "QSwapHashModel.h"
#import "ConfigUtil.h"
#import "WebViewController.h"
#import "QSwapStatusManager.h"

@interface QSwapDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblFromAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblToAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblLockTxHash;
@property (weak, nonatomic) IBOutlet UILabel *lblTxHash;
@property (weak, nonatomic) IBOutlet UILabel *lblClaimTitle;
@property (weak, nonatomic) IBOutlet UIButton *claimCopyBtn;
@property (weak, nonatomic) IBOutlet UIButton *claimTxBtn;

@property (nonatomic, strong) NSString *statuString;

@property (nonatomic, strong) QSwapHashModel *hashM;

@end

@implementation QSwapDetailViewController

- (instancetype)initWithSwapHashModel:(QSwapHashModel *) hashM withStatuString:(NSString *) statusString
{
    if (self = [super init]) {
        self.hashM = hashM;
        self.statuString = statusString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    _lblAmount.text = [NSString stringWithFormat:@"%ld",self.hashM.amount];
    _lblFromAddress.text = self.hashM.fromAddress;
    _lblToAddress.text = self.hashM.toAddress;
    _lblLockTxHash.text = self.hashM.txHash?:@"";
    _lblStatus.text = self.statuString;
    if (!self.hashM.swaptxHash || self.hashM.swaptxHash.length == 0) {
        _lblTxHash.hidden = YES;
        _lblClaimTitle.hidden = YES;
        _claimCopyBtn.hidden = YES;
        _claimTxBtn.hidden = YES;
    } else {
//        if (self.hashM.state == 31 || self.hashM.state == 19) {
//            _lblClaimTitle.text = @"Revoke Tx";
//        } else if (self.hashM.state == 30 || self.hashM.state == 9) {
//            _lblClaimTitle.text = @"Claim Tx";
//        }
        _lblTxHash.text = self.hashM.swaptxHash?:@"";
    }
    
}

#pragma mark -Action
- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickSwapTX:(id)sender {
    NSString *url = @"";
    if (_hashM.type == 2) {
        url = [[ConfigUtil get_eth_check_node_normal] stringByAppendingString:_hashM.txHash];
    } else {
        url = [[ConfigUtil get_neo_check_node_normal] stringByAppendingString:_hashM.txHash];
    }
    
    WebViewController *vc = [[WebViewController alloc] init];
    vc.inputUrl = url;
    vc.inputTitle = kLang(@"transfer_deail");
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickClaimTX:(id)sender {
    NSString *url = @"";
    if (_hashM.type == 2) {
        if ([QSwapStatusManager isClaimSuccessWithState:_hashM.state]) {
            url = [[ConfigUtil get_neo_check_node_normal] stringByAppendingString:_hashM.txHash];
        } else {
            url = [[ConfigUtil get_eth_check_node_normal] stringByAppendingString:_hashM.txHash];
        }
    } else {
        if ([QSwapStatusManager isClaimSuccessWithState:_hashM.state]) {
            url = [[ConfigUtil get_eth_check_node_normal] stringByAppendingString:_hashM.txHash];
        } else {
            url = [[ConfigUtil get_neo_check_node_normal] stringByAppendingString:_hashM.txHash];
        }
    }
    
    
    WebViewController *vc = [[WebViewController alloc] init];
    vc.inputUrl = url;
    vc.inputTitle = kLang(@"transfer_deail");
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)copyClick:(UIButton *)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (sender.tag == 1) {
        pasteboard.string = self.hashM.fromAddress;
    } else if (sender.tag == 2) {
        pasteboard.string = self.hashM.toAddress;
    } else if (sender.tag == 3) {
        pasteboard.string = self.hashM.txHash;
    } else {
        pasteboard.string = self.hashM.swaptxHash;
    }
    [kAppD.window makeToastDisappearWithText:kLang(@"copied")];
}

@end
