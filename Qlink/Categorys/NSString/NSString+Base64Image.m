//
//  NSString+Base64Image.m
//  humao
//
//  Created by Jelly Foo on 16/1/9.
//
//

#import "NSString+Base64Image.h"
#import "NSData+Base64.h"

@implementation NSString (Base64Image)

+ (UIImage *)getImgFromBase64Data:(NSString *)string {
    UIImage *getImage = [UIImage imageNamed:@""];
    if (string && [string isKindOfClass:[NSString class]] && string.length > 0) { // 不是默认头像
        NSString *base64Str1 = @"data:image/jpeg;base64,";
        NSString *base64Str2 = @"data:image/png;base64,";
        NSString *tempStr = [string stringByReplacingOccurrencesOfString:base64Str1 withString:@""];
        tempStr = [string stringByReplacingOccurrencesOfString:base64Str2 withString:@""];
        NSData *decodedImageData = [NSData dataWithBase64EncodedString:tempStr];
        getImage = [UIImage imageWithData:decodedImageData];
    }
    
    return getImage;
}

@end
