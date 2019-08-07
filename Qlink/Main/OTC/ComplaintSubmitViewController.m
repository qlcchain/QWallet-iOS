//
//  ComplaintSubmitViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/19.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ComplaintSubmitViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "TZImagePickerController.h"
#import "ComplaintPhotoCell.h"
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageUploadOperation.h"
#import "NSDate+Category.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import "ComplaintSubmitViewController.h"

static NSInteger maxCount = 4;
static NSInteger columnNumber = 3;

@interface ComplaintSubmitViewController () <TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate> {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}

@property (weak, nonatomic) IBOutlet UITextView *textV;
@property (weak, nonatomic) IBOutlet UILabel *wordLimitLab;
@property (weak, nonatomic) IBOutlet UIView *photoBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoBackHeight;
@property (weak, nonatomic) IBOutlet UIView *bottomBack;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic) BOOL showTakePhoto;  ///< 允许拍照
@property (nonatomic) BOOL showTakeVideo;  ///< 允许拍视频
@property (nonatomic) BOOL sortAscending;     ///< 照片排列按修改时间升序
@property (nonatomic) BOOL allowPickingVideo; ///< 允许选择视频
@property (nonatomic) BOOL allowPickingImage; ///< 允许选择图片
@property (nonatomic) BOOL allowPickingGif;
@property (nonatomic) BOOL allowPickingOriginalPhoto; ///< 允许选择原图
@property (nonatomic) BOOL showSheet; ///< 显示一个sheet,把拍照/拍视频按钮放在外面
@property (nonatomic) BOOL allowCrop;
@property (nonatomic) BOOL needCircleCrop;
@property (nonatomic) BOOL allowPickingMuitlpleVideo;
@property (nonatomic) BOOL showSelectedIndex;


@end

@implementation ComplaintSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self configCollectionView];
}

#pragma mark - Operation
- (void)configInit {
    _submitBtn.layer.cornerRadius = 4.0;
    _submitBtn.layer.masksToBounds = YES;
    _textV.placeholder = kLang(@"for_example_incorrect_amount_no_payment_received_etc");
    
    [_bottomBack shadowWithColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0] offset:CGSizeMake(0,-0.5) opacity:1 radius:0];

    _showTakePhoto = YES;  ///< 允许拍照
    _showTakeVideo = NO;  ///< 允许拍视频
    _sortAscending = YES;     ///< 照片排列按修改时间升序
    _allowPickingVideo = NO; ///< 允许选择视频
    _allowPickingImage = YES; ///< 允许选择图片
    _allowPickingGif = NO;
    _allowPickingOriginalPhoto = YES; ///< 允许选择原图
    _showSheet = NO; ///< 显示一个sheet,把拍照/拍视频按钮放在外面
    _allowCrop = NO;
    _needCircleCrop = NO;
    _allowPickingMuitlpleVideo = NO;
    _showSelectedIndex = YES;
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[LxGridViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_photoBack addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:ComplaintPhotoCellReuse bundle:nil] forCellWithReuseIdentifier:ComplaintPhotoCellReuse];
    
    _margin = 4;
    CGFloat offset_margin = 16;
    _itemWH = (SCREEN_WIDTH - 3*_margin - 2*offset_margin) / 2.0;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    CGFloat collectionHeight = 3*_margin + 2*_itemWH;
    [self.collectionView setCollectionViewLayout:_layout];
    self.collectionView.frame = CGRectMake(offset_margin, 0, SCREEN_WIDTH-2*offset_margin, collectionHeight);
    [self refreshPhotoBackHeight];
}

- (void)refreshPhotoBackHeight {
    NSInteger lineNum = 1;
    if (_selectedPhotos != nil && _selectedPhotos.count > 0) {
        NSInteger count = _selectedPhotos.count;
        if (count < 4) {
            count = _selectedPhotos.count+1;
        }
        lineNum = ceil(count/2.0);
    }
    CGFloat photoBackHeight = (lineNum+1)*_margin + lineNum*_itemWH;
    _photoBackHeight.constant = photoBackHeight;
}

- (NSString *)getBytesFromDataLength:(NSInteger)dataLength {
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1f M",dataLength/1024/1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0f KB",dataLength/1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%zd Byte",dataLength];
    }
    return bytes;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView == _textV) {
        if (textView.text.length > 100) {
            textView.text = [textView.text substringToIndex:100];
        }
        _wordLimitLab.text = [NSString stringWithFormat:@"%lu/100",textView.text.length];
    }
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count >= maxCount) {
        return _selectedPhotos.count;
    }
    
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ComplaintPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ComplaintPhotoCellReuse forIndexPath:indexPath];
    if (indexPath.item == _selectedPhotos.count) {
        cell.imgV.image = [UIImage imageNamed:@"icon_complaint_add"];
        cell.imgV.contentMode = UIViewContentModeCenter;
        cell.sizeLab.hidden = YES;
        cell.deleteBtn.hidden = YES;
    } else {
        UIImage *image = _selectedPhotos[indexPath.item];
        cell.imgV.image = image;
        cell.imgV.contentMode = UIViewContentModeScaleAspectFill;
        cell.imgV.layer.cornerRadius = 4.0;
        cell.imgV.layer.masksToBounds = YES;
        cell.asset = _selectedAssets[indexPath.item];
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        cell.sizeLab.text = [NSString stringWithFormat:@"  %@",[self getBytesFromDataLength:imageData.length]];
        cell.sizeLab.hidden = NO;
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _selectedPhotos.count) {
        [self pushTZImagePickerController];
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}

- (void)deleteBtnClik:(UIButton *)sender {
    if ([self collectionView:self.collectionView numberOfItemsInSection:0] <= _selectedPhotos.count) {
        [_selectedPhotos removeObjectAtIndex:sender.tag];
        [_selectedAssets removeObjectAtIndex:sender.tag];
        [self.collectionView reloadData];
        return;
    }
    
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self->_collectionView reloadData];
    }];
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    if (maxCount <= 0) {
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount columnNumber:columnNumber delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    if (maxCount > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = self.showTakePhoto; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = self.showTakeVideo;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = self.allowPickingVideo;
    imagePickerVc.allowPickingImage = self.allowPickingImage;
    imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhoto;
    imagePickerVc.allowPickingGif = self.allowPickingGif;
    imagePickerVc.allowPickingMultipleVideo = self.allowPickingMuitlpleVideo; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = self.sortAscending;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = self.allowCrop;
    imagePickerVc.needCircleCrop = self.needCircleCrop;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = self.showSelectedIndex;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    [self refreshPhotoBackHeight];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    for (PHAsset *phAsset in assets) {
        NSLog(@"location:%@",phAsset.location);
    }
    
    // 3. 获取原图的示例，用队列限制最大并发为1，避免内存暴增
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    for (NSInteger i = 0; i < assets.count; i++) {
        PHAsset *asset = assets[i];
        // 图片上传operation，上传代码请写到operation内的start方法里，内有注释
        TZImageUploadOperation *operation = [[TZImageUploadOperation alloc] initWithAsset:asset completion:^(UIImage * photo, NSDictionary *info, BOOL isDegraded) {
            if (isDegraded) return;
            NSLog(@"图片获取&上传完成");
        } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
            NSLog(@"获取原图进度 %f", progress);
        }];
        [self.operationQueue addOperation:operation];
    }
}

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (PHAsset *asset in assets) {
        fileName = [asset valueForKey:@"filename"];
        // NSLog(@"图片名字:%@",fileName);
    }
}

// Decide album show or not't
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(PHFetchResult *)result {
    return YES;
}

// 决定asset显示与否
- (BOOL)isAssetCanSelect:(PHAsset *)asset {
    return YES;
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitAction:(id)sender {
    if ([_textV.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"reason_is_empty")];
        return;
    }
    
    __block BOOL photoIsBig = NO;
    [_selectedPhotos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *image = obj;
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        if (imageData.length/1024/1024.0 > 5) { // 大于5M
            photoIsBig = YES;
            *stop = YES;
        }
    }];
    if (photoIsBig) {
        [kAppD.window makeToastDisappearWithText:kLang(@"image_size_need_smaller_than_5m")];
        return;
    }
    
    [self requestTrade_appeal];
}

#pragma mark - Request
- (void)requestTrade_appeal {
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
    NSString *reason = _textV.text?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"tradeOrderId":_inputTradeOrderId?:@"",@"reason":reason};
    [kAppD.window makeToastInView:self.view text:nil];
    [RequestService postImage:trade_appeal_Url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [_selectedPhotos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImage *image = obj;
            NSString *dateStr = [NSString stringWithFormat:@"%llu",[NSDate getMillisecondTimestampFromDate:[NSDate date]]];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", dateStr];
            NSString *name = [NSString stringWithFormat:@"photo%@",@(idx+1)];
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg"];
        }];
    } success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"submit_success")];
            [weakself backAction:nil];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

@end
