//
//  VerificationViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/6/14.
//  Copyright © 2019 pan. All rights reserved.
//

#import "VerificationViewController.h"
#import "UserModel.h"
#import "NSDate+Category.h"
#import "RSAUtil.h"
#import "UIImage+Resize.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserUtil.h"
#import "TipOKView.h"
#import "PhotoPickerUtil.h"

//#import "GlobalConstants.h"

typedef enum : NSUInteger {
    VerificationPicType1,
    VerificationPicType2,
} VerificationPicType;

@interface VerificationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *pic1;
@property (weak, nonatomic) IBOutlet UIButton *picBtn1;
@property (weak, nonatomic) IBOutlet UIImageView *pic2;
@property (weak, nonatomic) IBOutlet UIButton *picBtn2;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;

@property (nonatomic, strong) UIImage *selectImage1;
@property (nonatomic, strong) UIImage *selectImage2;
@property (nonatomic) VerificationPicType picType;

@end

@implementation VerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [UIApplication sharedApplication].statusBarHidden = NO;
}

#pragma mark - Operation
- (void)configInit {
    _submitBtn.layer.cornerRadius = 4.0;
    _submitBtn.layer.masksToBounds = YES;
    
    [self refreshPhotoStatus];
}

- (void)refreshPhotoStatus {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (userM) {
        if ([userM.vStatus isEqualToString:kyc_not_upload]) {
            _tipLab.text = kLang(@"please_upload_the_required_information_of_your_passport");
        } else if ([userM.vStatus isEqualToString:kyc_uploaded]) {
            _tipLab.text = kLang(@"status_under_review");
        } else if ([userM.vStatus isEqualToString:kyc_success]) {
            _tipLab.text = kLang(@"status_verified");
        } else if ([userM.vStatus isEqualToString:kyc_fail]) {
            _tipLab.text = kLang(@"status_not_approved");
            [self showNotApproved];
        }
        
        if ([userM.vStatus isEqualToString:kyc_not_upload]) {
            _pic1.image = [UIImage imageNamed:@"icon_passport_back"];
            _pic2.image = [UIImage imageNamed:@"icon_hand_passport_back"];
        } else {
            kWeakSelf(self);
            NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],userM.facePhoto]];
            [_pic1 sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"icon_passport_back"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                weakself.selectImage1 = image;
            }];
            
            NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],userM.holdingPhoto]];
            [_pic2 sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@"icon_hand_passport_back"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                weakself.selectImage2 = image;
            }];
        }
        
        if ([userM.vStatus isEqualToString:kyc_success] || [userM.vStatus isEqualToString:kyc_uploaded]) {
            _picBtn1.userInteractionEnabled = NO;
            _picBtn2.userInteractionEnabled = NO;
            _submitBtn.hidden = YES;
        } else {
            _picBtn1.userInteractionEnabled = YES;
            _picBtn2.userInteractionEnabled = YES;
            _submitBtn.hidden = NO;
        }
    }
}

- (void)showPhotoAlert {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    kWeakSelf(self)
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:kLang(@"photo_album") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself selectImage:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [alertVC addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:kLang(@"camera") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself selectImage:UIImagePickerControllerSourceTypeCamera];
    }];
    [alertVC addAction:action2];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:action3];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)selectImage:(UIImagePickerControllerSourceType)type {
    kWeakSelf(self);
    [[PhotoPickerUtil getShareObject] selectSingleImage:type block:^(UIImage * _Nonnull image) {
        if (weakself.picType == VerificationPicType1) {
            weakself.selectImage1 = image;
            weakself.pic1.image = weakself.selectImage1;
        } else if (_picType == VerificationPicType2) {
            weakself.selectImage2 = image;
            weakself.pic2.image = weakself.selectImage2;
        }
    }];
}

- (void)showTip {
    TipOKView *view = [TipOKView getInstance];
    [view showWithTitle:kLang(@"verification_is_required___")];
}

- (void)showNotApproved {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kLang(@"not_approved") message:kLang(@"please_resubmit_the_required_information___") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:kLang(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:action1];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)questionAction:(id)sender {
    [self showTip];
}

- (IBAction)pic1Action:(id)sender {
    _picType = VerificationPicType1;
    [self showPhotoAlert];
}

- (IBAction)pic2Action:(id)sender {
    _picType = VerificationPicType2;
    [self showPhotoAlert];
}

- (IBAction)submitAction:(id)sender {
    if (!_selectImage1 || !_selectImage2) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_upload_the_required_information_of_your_passport")];
        return;
    }
    
    [self requestUploadIDCard];
}

#pragma mark - 上传照片
- (void)requestUploadIDCard {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [NSString stringWithFormat:@"%@",@([NSDate getTimestampFromDate:[NSDate date]])];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSDictionary *params = @{@"account":account,@"token":token};
    UIImage *img1 = _selectImage1;
    UIImage *img2 = _selectImage2;
    [kAppD.window makeToastInView:self.view text:nil];
    [RequestService postImage7:upload_id_card_Url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString *fileName1 = [NSString stringWithFormat:@"%llu",[NSDate getMillisecondTimestampFromDate:[NSDate date]]];
        NSData *data1 = [img1 compressJPGImage:img1 toMaxFileSize:Upload_ID_Image_Size];
        NSString *name1 = [NSString stringWithFormat:@"%@.jpg", fileName1];
        [formData appendPartWithFileData:data1 name:@"facePhoto" fileName:name1 mimeType:@"image/jpeg"];
        
        NSString *fileName2 = [NSString stringWithFormat:@"%llu",[NSDate getMillisecondTimestampFromDate:[NSDate date]]];
        NSData *data2 = [img2 compressJPGImage:img2 toMaxFileSize:UploadImage_Size];
        NSString *name2 = [NSString stringWithFormat:@"%@.jpg", fileName2];
        [formData appendPartWithFileData:data2 name:@"holdingPhoto" fileName:name2 mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"upload_success_wait_for_verify")];
            userM.vStatus = @"UPLOADED";
            userM.facePhoto = responseObject[@"facePhoto"];
            userM.holdingPhoto = responseObject[@"holdingPhoto"];
            [UserModel storeUserByID:userM];
            
            [UserUtil updateUserInfo];
            [weakself backAction:nil];
        }
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

@end
