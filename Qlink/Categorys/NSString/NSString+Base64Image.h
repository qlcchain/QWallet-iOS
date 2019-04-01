//
//  NSString+Base64Image.h
//  humao
//
//  Created by Jelly Foo on 16/1/9.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Base64Image)

+ (UIImage *)getImgFromBase64Data:(NSString *)string;

@end
