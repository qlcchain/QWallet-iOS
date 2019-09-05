//
//  PhotoPickerUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/26.
//  Copyright © 2019 pan. All rights reserved.
//

#import "PhotoPickerUtil.h"
#import "ZQImageCropController.h"
#import "UINavigationController+CurrentNav.h"

#import "GlobalConstants.h"

@interface PhotoPickerUtil () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy) PhotoPickerBlock selectBlock;


@end

@implementation PhotoPickerUtil

+ (instancetype)getShareObject {
    static dispatch_once_t pred = 0;
    __strong static PhotoPickerUtil *sharedObj  = nil;
    dispatch_once(&pred, ^{
        sharedObj = [[self alloc] init];
    });
    return sharedObj;
}

//调用系统相册
- (void)selectSingleImage:(UIImagePickerControllerSourceType)type block:(PhotoPickerBlock)block {
    _selectBlock = block;
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
    pickerController.allowsEditing = NO;
    //设置相册呈现的样式
    pickerController.sourceType = type; //UIImagePickerControllerSourceTypeSavedPhotosAlbum;//图片分组列表样式
    //照片的选取样式还有以下两种
    // UIImagePickerControllerSourceTypePhotoLibrary,直接全部呈现系统相册
    //UIImagePickerControllerSourceTypeCamera//调取摄像头
    //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    pickerController.delegate = self;
    //使用模态呈现相册
    //[self showDetailViewController:pickerController sender:nil];
    [[UINavigationController currentNC] presentViewController:pickerController animated:YES completion:nil];
    //    [UIApplication sharedApplication].statusBarHidden = YES;//防止出现20px下移
    
}

#pragma UIImagePickerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
    kWeakSelf(self);
    [[UINavigationController currentNC] dismissViewControllerAnimated:YES completion:^{
        [weakself jumpToCropImage:original];
    }];
    
//    return;
//    UIImage *resultImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    if (resultImage) {
//        resultImage = [resultImage resizeImage:resultImage];
//        if (_picType == VerificationPicType1) {
//            _selectImage1 = resultImage;
//            _pic1.image = _selectImage1;
//        } else if (_picType == VerificationPicType2) {
//            _selectImage2 = resultImage;
//            _pic2.image = _selectImage2;
//        }
//    }
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if ([UIDevice currentDevice].systemVersion.floatValue < 11) {
//        return;
//    }
//    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]) {
//        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.frame.size.width < 42) {
//                [viewController.view sendSubviewToBack:obj];
//                *stop = YES;
//            }
//        }];
//    }
//}

#pragma mark - Transition
- (void)jumpToCropImage:(UIImage *)_image {
    ZQImageCropController* cropVC = [[ZQImageCropController alloc] init];
    cropVC.image = _image;
    kWeakSelf(self);
    [cropVC addFinishBlock:^(UIImage *image) {
        if (weakself.selectBlock) {
            weakself.selectBlock(image);
        }
    }];
    [[UINavigationController currentNC] presentViewController:cropVC animated:true completion:nil];
}



@end
