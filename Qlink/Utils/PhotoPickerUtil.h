//
//  PhotoPickerUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/26.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PhotoPickerBlock)(UIImage *image);

@interface PhotoPickerUtil : NSObject

+ (instancetype)getShareObject;
- (void)selectSingleImage:(UIImagePickerControllerSourceType)type block:(PhotoPickerBlock)block;

@end

NS_ASSUME_NONNULL_END
