//
//  PersonalInfoViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/11.
//  Copyright © 2019 pan. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "PersonalInfoCell.h"
#import "UserModel.h"
#import "EditTextViewController.h"
#import "NSDate+Category.h"
#import "UIImage+Resize.h"
#import "RSAUtil.h"
#import "ForgetPWViewController.h"
#import "VerificationViewController.h"
#import "UserUtil.h"
#import <SwiftTheme/SwiftTheme-Swift.h>

//#import "GlobalConstants.h"

@interface PersonalInfoViewController () <UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation PersonalInfoViewController

//NSString *person_title0 = @"Profile Photo";
//NSString *person_title1 = @"Username";
//NSString *person_title2 = @"My Invitation Code";
//NSString *person_title3 = @"Email";
//NSString *person_title4 = @"Mobile";
////NSString *person_title5 = @"Reset Password";
//NSString *person_title5 = @"Verification";

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfoNot:) name:User_UpdateInfo_Noti object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;

    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:PersonalInfoCellReuse bundle:nil] forCellReuseIdentifier:PersonalInfoCellReuse];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self configInit];
    [UserUtil updateUserInfo];
}

#pragma mark - Operation
- (void)configInit {
    [_sourceArr removeAllObjects];
    UserModel *userM = [UserModel fetchUserOfLogin];
    PersonalInfoShowModel *model = [PersonalInfoShowModel new];
    model.key = kLang(@"profile_photo");
    model.val = userM.head;
    model.showCopy = NO;
    model.showArrow = YES;
    model.showHead = YES;
    [_sourceArr addObject:model];
    model = [PersonalInfoShowModel new];
    model.key = kLang(@"username");
    model.val = userM.nickname;
    model.showCopy = NO;
    model.showArrow = YES;
    model.showHead = NO;
    [_sourceArr addObject:model];
    model = [PersonalInfoShowModel new];
    model.key = kLang(@"my_invitation_code");
    model.val = [NSString stringWithFormat:@"%@",userM.number];
    model.showCopy = YES;
    model.showArrow = NO;
    model.showHead = NO;
    [_sourceArr addObject:model];
    model = [PersonalInfoShowModel new];
    model.key = kLang(@"email");
    model.val = userM.email;
    model.showCopy = NO;
    model.showArrow = YES;
    model.showHead = NO;
    [_sourceArr addObject:model];
    model = [PersonalInfoShowModel new];
    model.key = kLang(@"mobile");
    model.val = userM.phone;
    model.showCopy = NO;
    model.showArrow = YES;
    model.showHead = NO;
    [_sourceArr addObject:model];
    model = [PersonalInfoShowModel new];
    model.key = kLang(@"verification");
//    model.val = person_title5;
    NSString *vStatusStr = @"";
    if ([userM.vStatus isEqualToString:kyc_not_upload]) {
        vStatusStr = @"Unverified";
    } else if ([userM.vStatus isEqualToString:kyc_uploaded]) {
        vStatusStr = @"Under review";
    } else if ([userM.vStatus isEqualToString:kyc_success]) {
        vStatusStr = @"Verified";
    } else if ([userM.vStatus isEqualToString:kyc_fail]) {
        vStatusStr = @"Not approved";
    }
    model.val = vStatusStr;
    model.showCopy = NO;
    model.showArrow = YES;
    model.showHead = NO;
    [_sourceArr addObject:model];
    
    [_mainTable reloadData];
}

- (void)handleCopy:(NSString *)str {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:str];
    [kAppD.window makeToastDisappearWithText:kLang(@"copied")];
}

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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PersonalInfoCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PersonalInfoShowModel *model = _sourceArr[indexPath.row];
    if ([model.key isEqualToString:kLang(@"profile_photo")]) {
        [self showPhotoAlert];
    } else if ([model.key isEqualToString:kLang(@"username")]) {
        [self jumpToEditText:EditUsername];
    } else if ([model.key isEqualToString:kLang(@"my_invitation_code")]) {
        [self handleCopy:model.val];
    } else if ([model.key isEqualToString:kLang(@"email")]) {
        [self jumpToEditText:EditEmail];
    } else if ([model.key isEqualToString:kLang(@"mobile")]) {
        [self jumpToEditText:EditPhone];
    } else if ([model.key isEqualToString:kLang(@"verification")]) {
//        [self jumpToForgetPW];
        [self jumpToVerification];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalInfoCellReuse];
    
    PersonalInfoShowModel *model = _sourceArr[indexPath.row];
    [cell configCell:model];
    
    return cell;
}

#pragma mark - Transition
- (void)jumpToEditText:(EditType)type {
    EditTextViewController *vc = [[EditTextViewController alloc] initWithType:type];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToForgetPW {
    ForgetPWViewController *vc = [ForgetPWViewController new];
    vc.inputTitle = kLang(@"verification");
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToVerification {
    VerificationViewController *vc = [VerificationViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 上传头像
- (void)uploadImg:(UIImage *)img {
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
    [kAppD.window makeToastInView:self.view text:nil];
    [RequestService postImage7:user_upload_headview_Url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
        [kAppD.window hideToast];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            //            NSString *head = [NSString stringWithFormat:@"%@%@",[RequestService getPrefixUrl],responseObject[@"head"]];
            NSString *head = responseObject[@"head"];
            userM.head = head;
            [UserModel storeUserByID:userM];
            
            [weakself configInit];
//            [UserManage setHeadUrl:head];
//            [weakself leftNavBarItemPressedWithPop:YES];
        }
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
        //        [kAppD.window showHint:error.description];
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
        [self uploadImg:resultImage];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Noti
- (void)updateUserInfoNot:(NSNotification *)noti {
    [self configInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
