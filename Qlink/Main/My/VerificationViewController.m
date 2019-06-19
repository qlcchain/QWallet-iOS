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

typedef enum : NSUInteger {
    VerificationPicType1,
    VerificationPicType2,
} VerificationPicType;

@interface VerificationViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *pic1;
@property (weak, nonatomic) IBOutlet UIImageView *pic2;
@property (nonatomic) VerificationPicType picType;

@end

@implementation VerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

#pragma mark - Operation
- (void)showPhotoAlert {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    kWeakSelf(self)
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Photo Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself selectImage:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [alertVC addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself selectImage:UIImagePickerControllerSourceTypeCamera];
    }];
    [alertVC addAction:action2];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:action3];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)questionAction:(id)sender {
    
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
    if (!_pic1.image || !_pic2.image) {
        [kAppD.window makeToastDisappearWithText:@"Please upload the required information of your PASSPORT."];
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
    UIImage *img1 = _pic1.image;
    UIImage *img2 = _pic2.image;
    [kAppD.window makeToastInView:self.view text:nil];
    [RequestService postImage:upload_id_card_Url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString *fileName1 = [NSString stringWithFormat:@"%llu",[NSDate getMillisecondTimestampFromDate:[NSDate date]]];
        NSData *data1 = [img1 compressJPGImage:img1 toMaxFileSize:UploadImage_Size];
        NSString *name1 = [NSString stringWithFormat:@"%@.jpg", fileName1];
        [formData appendPartWithFileData:data1 name:@"facePhoto" fileName:name1 mimeType:@"image/jpeg"];
        
        NSString *fileName2 = [NSString stringWithFormat:@"%llu",[NSDate getMillisecondTimestampFromDate:[NSDate date]]];
        NSData *data2 = [img2 compressJPGImage:img2 toMaxFileSize:UploadImage_Size];
        NSString *name2 = [NSString stringWithFormat:@"%@.jpg", fileName2];
        [formData appendPartWithFileData:data2 name:@"holdingPhoto" fileName:name2 mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:@"Upload Success."];
            [weakself backAction:nil];
        }
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

//调用系统相册
- (void)selectImage:(UIImagePickerControllerSourceType)type {
    //调用系统相册的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    //    更改titieview的字体颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [pickerController.navigationBar setTitleTextAttributes:attrs];
    pickerController.navigationBar.translucent = NO;
    //    pickerController.navigationBar.barTintColor = MAIN_BLUE_COLOR;
    pickerController.navigationBar.theme_barTintColor = globalBackgroundColorPicker;
    //设置选取的照片是否可编辑
    pickerController.allowsEditing = YES;
    //设置相册呈现的样式
    pickerController.sourceType = type; //UIImagePickerControllerSourceTypeSavedPhotosAlbum;//图片分组列表样式
    //照片的选取样式还有以下两种
    // UIImagePickerControllerSourceTypePhotoLibrary,直接全部呈现系统相册
    //UIImagePickerControllerSourceTypeCamera//调取摄像头
    //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    pickerController.delegate = self;
    //使用模态呈现相册
    //[self showDetailViewController:pickerController sender:nil];
    [self.navigationController presentViewController:pickerController animated:YES completion:nil];
    
}

#pragma UIImagePickerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //    UIImagePickerControllerEditedImage//编辑过的图片
    //    UIImagePickerControllerOriginalImage//原图
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (resultImage) {
        resultImage = [resultImage resizeImage:resultImage];
        if (_picType == VerificationPicType1) {
            _pic1.image = resultImage;
        } else if (_picType == VerificationPicType2) {
            _pic2.image = resultImage;
        }
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
