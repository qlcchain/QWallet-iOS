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
    _invitationCodeLab.text = userM.ID?:@"00000000";
    
    _qrImgV.image = [SGQRCodeObtain generateQRCodeWithData:Download_Link size:_qrImgV.width logoImage:nil ratio:0.15];
//    kWeakSelf(self);
//    [HMScanner qrImageWithString:Download_Link avatar:nil completion:^(UIImage *image) {
//        weakself.qrImgV.image = image;
//    }];
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
