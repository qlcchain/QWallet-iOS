//
//  ComplaintSubmitViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/19.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ComplaintInfoViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "TZImagePickerController.h"
#import "ComplaintPhotoCell.h"
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import <UIImageView+WebCache.h>
#import "TradeOrderInfoModel.h"

@interface ComplaintInfoViewController () <UICollectionViewDataSource,UICollectionViewDelegate> {
    CGFloat _itemWH;
    CGFloat _margin;
}

@property (weak, nonatomic) IBOutlet UIView *photoBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoBackHeight;
@property (weak, nonatomic) IBOutlet UILabel *reasonLab;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;

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

@property (nonatomic, strong) NSMutableArray *photoArr;

@end

@implementation ComplaintInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self configCollectionView];
}

#pragma mark - Operation
- (void)configInit {
    _reasonLab.text = _orderInfoM.reason;
    
    _photoArr = [NSMutableArray array];
    if (![_orderInfoM.photo1 isEmptyString]) {
        [_photoArr addObject:_orderInfoM.photo1];
    }
    if (![_orderInfoM.photo2 isEmptyString]) {
        [_photoArr addObject:_orderInfoM.photo2];
    }
    if (![_orderInfoM.photo3 isEmptyString]) {
        [_photoArr addObject:_orderInfoM.photo3];
    }
    if (![_orderInfoM.photo4 isEmptyString]) {
        [_photoArr addObject:_orderInfoM.photo4];
    }
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
    _photoBackHeight.constant = collectionHeight;
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

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ComplaintPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ComplaintPhotoCellReuse forIndexPath:indexPath];
    NSString *imageUrl = _photoArr[indexPath.item];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],imageUrl]];
    kWeakSelf(self);
    [cell.imgV sd_setImageWithURL:url placeholderImage:[UIImage imageWithColor:[UIColor lightGrayColor]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        cell.sizeLab.text = [NSString stringWithFormat:@"  %@",[weakself getBytesFromDataLength:imageData.length]];
    }];
    cell.imgV.contentMode = UIViewContentModeScaleAspectFill;
    cell.imgV.layer.cornerRadius = 4.0;
    cell.imgV.layer.masksToBounds = YES;
//    cell.asset = _selectedAssets[indexPath.item];
    cell.deleteBtn.hidden = YES;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _photoArr.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _photoArr.count && destinationIndexPath.item < _photoArr.count);
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
