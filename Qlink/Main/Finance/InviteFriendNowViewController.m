//
//  InviteFriendNowViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/28.
//  Copyright © 2019 pan. All rights reserved.
//

#import "InviteFriendNowViewController.h"
#import "UserModel.h"
#import "SGQRCodeObtain.h"
#import "UIView+Visuals.h"

@interface InviteFriendNowViewController ()

@property (weak, nonatomic) IBOutlet UIView *qrBack;
@property (weak, nonatomic) IBOutlet UIView *inviteBack;
@property (weak, nonatomic) IBOutlet UIView *shareBack;
@property (weak, nonatomic) IBOutlet UIImageView *qrImgV;
@property (weak, nonatomic) IBOutlet UILabel *invitationCodeLab;
@property (weak, nonatomic) IBOutlet UIImageView *inviteBackImg;

@end

@implementation InviteFriendNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
    _qrBack.layer.cornerRadius = 8.0;
    _qrBack.layer.masksToBounds = YES;
    _inviteBack.layer.cornerRadius = 16.0;
    _inviteBack.layer.masksToBounds = YES;
    
    UserModel *userM = [UserModel fetchUserOfLogin];
    _invitationCodeLab.text = userM.number?[NSString stringWithFormat:@"%@",userM.number]:@"00000000";
    
//    _qrImgV.image = [UIImage imageNamed:@"share_download.jpg"];
    
    NSString *language = [Language currentLanguageCode];
    NSString *shareUrl = @"";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        _inviteBackImg.image = [UIImage imageNamed:@"icon_invitation_en"];
        shareUrl = @"https://qwallet.network/en";
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        _inviteBackImg.image = [UIImage imageNamed:@"icon_invitation_ch"];
        shareUrl = @"https://qwallet.network/cn";
    }
    UIImage *img = [[UIImage imageNamed:@"icon_start_icon"] imgWithBackgroundColor:[UIColor whiteColor]];
    _qrImgV.image = [SGQRCodeObtain generateQRCodeWithData:shareUrl size:_qrImgV.width logoImage:img ratio:0.15 logoImageCornerRadius:4.0 logoImageBorderWidth:0.5 logoImageBorderColor:[UIColor whiteColor]];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareAction:(id)sender {
    UIImage *img = [_shareBack getImageFromView];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[img] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAirDrop];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityVC animated:YES completion:nil];
    activityVC.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        if (completed) {
            NSLog(@"Share Success");
        } else {
            NSLog(@"Share Failed == %@",activityError.description);
        }
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
