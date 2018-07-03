//
//  ProfileViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2018/3/30.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImage+Resize.h"
//#import "UIImageView+UserHead.h"
#import "WalletUtil.h"
//#import "HYBImageCliped.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+Category.h"
#import "RequestService.h"


@interface ProfileViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImage *_selectImage;
}
@end

@implementation ProfileViewController

- (IBAction)clickSkip:(id)sender {
    
    [self leftNavBarItemPressedWithPop:YES];
}

- (IBAction)clickSave:(id)sender {
    if (_headImageView.image) {
        if (!_selectImage) {
            return;
        }
        [self uploadImg:_selectImage];
    }
}

- (IBAction)clickSelctImage:(id)sender {
    [self selectImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[UserManage getWholeHeadUrl]] placeholderImage:[UIImage imageNamed:@"img_camera"]];
    [_topHeadImgView sd_setImageWithURL:[NSURL URLWithString:[UserManage getWholeHeadUrl]] placeholderImage:User_PlaceholderImage];
    _topHeadImgView.layer.cornerRadius = 20;
    _topHeadImgView.layer.masksToBounds = YES;
    _topHeadImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    _topHeadImgView.layer.borderWidth = Photo_White_Circle_Length;
}

#pragma mark - 上传头像
- (void)uploadImg:(UIImage *)img {
    NSString *p2pId = [ToxManage getOwnP2PId]?:@"";
    if (p2pId.length <= 0) {
        return;
    }
    NSDictionary *params = @{@"p2pId":p2pId};
    @weakify_self
    [AppD.window showHudInView:self.view hint:nil];
    [RequestService postImage:uploadHeadView_Url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString *fileName = [NSString stringWithFormat:@"%ld",[NSDate getTimestampFromDate:[NSDate date]]];
        NSData *data = UIImagePNGRepresentation(img);
        if (!data || [data isKindOfClass:[NSNull class]]) { // 不为png则转成jpg
            data = [img compressJPGImage:img toMaxFileSize:UploadImage_Size];
//            DDLogDebug(@"上传图片大小=%@byte %@KB %@MB",@(data.length),@(data.length/1024.0),@(data.length/1024.0/1024.0));
            NSString *name = [NSString stringWithFormat:@"%@.jpg", fileName];
            [formData appendPartWithFileData:data name:@"head" fileName:name mimeType:@"image/jpeg"];
        } else {
            data = [img compressPNGImage:img toMaxFileSize:UploadImage_Size];
//            DDLogDebug(@"上传图片大小=%@byte %@KB %@MB",@(data.length),@(data.length/1024.0),@(data.length/1024.0/1024.0));
            NSString *name = [NSString stringWithFormat:@"%@.png", fileName];
            [formData appendPartWithFileData:data name:@"head" fileName:name mimeType:@"image/png"];
        }
    } success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [AppD.window hideHud];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
//            NSString *head = [NSString stringWithFormat:@"%@%@",[RequestService getPrefixUrl],responseObject[@"head"]];
            NSString *head = responseObject[@"head"];
            [UserManage setHeadUrl:head];
            [weakSelf leftNavBarItemPressedWithPop:YES];
        }
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [AppD.window hideHud];
//        [AppD.window showHint:error.description];
    }];
}

//调用系统相册
- (void)selectImage{
    //调用系统相册的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    //    更改titieview的字体颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [pickerController.navigationBar setTitleTextAttributes:attrs];
    pickerController.navigationBar.translucent = NO;
    pickerController.navigationBar.barTintColor = MAIN_PURPLE_COLOR;
    //设置选取的照片是否可编辑
    pickerController.allowsEditing = YES;
    //设置相册呈现的样式
    pickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary; //UIImagePickerControllerSourceTypeSavedPhotosAlbum;//图片分组列表样式
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
        _headImageView.image = resultImage;
        _topHeadImgView.image = resultImage;
        _selectImage = resultImage;
    }
    
//    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[UserManage getHeadUrl]] placeholderImage:nil];
    
//    [_topHeadImgView sd_setImageWithURL:[NSURL URLWithString:[UserManage getHeadUrl]] placeholderImage:nil];
   
//    _topHeadImgView.image = [_topHeadImgView hyb_setImage:resultImage size:CGSizeMake(100, 100) cornerRadius:50 onCliped:nil];
//    _topHeadImgView.hyb_borderColor = [UIColor whiteColor];
//    _topHeadImgView.hyb_borderWidth = 5.0f;
    //使用模态返回到软件界面
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
