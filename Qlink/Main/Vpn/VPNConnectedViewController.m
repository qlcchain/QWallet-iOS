//
//  VPNConnectedViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/11.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VPNConnectedViewController.h"
#import "Qlink-Swift.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "VPNMode.h"

@interface VPNConnectedViewController ()

@property (weak, nonatomic) IBOutlet UIButton *vpnUserBtn;
@property (weak, nonatomic) IBOutlet UILabel *vpnNameLab;

@end

@implementation VPNConnectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _vpnNameLab.text = _vpnInfo.vpnName;
    [self updateVpnUserBtn];
}

#pragma mark - ConfigView
- (void)updateVpnUserBtn {
    __weak typeof(_vpnUserBtn) weakVpnUserBtn = _vpnUserBtn;
    NSString *head = [NSString stringWithFormat:@"%@%@",[RequestService getPrefixUrl],_vpnInfo.imgUrl];
    [_vpnUserBtn sd_setImageWithURL:[NSURL URLWithString:head] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_person"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            weakVpnUserBtn.imageView.layer.cornerRadius = weakVpnUserBtn.imageView.frame.size.width/2;
            weakVpnUserBtn.imageView.layer.masksToBounds = YES;
            weakVpnUserBtn.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            weakVpnUserBtn.imageView.layer.borderWidth = Photo_White_Circle_Length;
        }
    }];
}

#pragma mark - Operation
- (void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)cancelConnect {
    [VPNUtil.shareInstance stopVPN];
}

#pragma mark - Action

- (IBAction)headerAction:(id)sender {
    [self cancelConnect];
}

- (IBAction)backAction:(id)sender {
    [self back];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
