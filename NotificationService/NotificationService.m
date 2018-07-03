//
//  NotificationService.m
//  NotificationService
//
//  Created by Jelly Foo on 2018/5/25.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
//    self.contentHandler = contentHandler;
//    self.bestAttemptContent = [request.content mutableCopy];
//
//    // Modify the notification content here...
//    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
//
//    self.contentHandler(self.bestAttemptContent);
    
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // 下面是小米推送的url优先级高，可自行修改
    NSString *imageUrlString = [request.content.userInfo objectForKey:@"mutable_content_pic_url"]; // 小米推送image的url字段
    if (![imageUrlString isKindOfClass:[NSString class]]) {
        imageUrlString = [request.content.userInfo objectForKey:@"your_image_url_field"]; // 自己的url
        if (![imageUrlString isKindOfClass:[NSString class]]) {
            return;
        }
    }
    
    NSURL *url = [NSURL URLWithString:imageUrlString];
    if (!url)
        return;
    
    [[[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSString *tempDict = NSTemporaryDirectory();
            
            NSString *filenameSuffix = response.suggestedFilename ? response.suggestedFilename : [response.URL.absoluteString lastPathComponent];
            NSString *attachmentID = [[[NSUUID UUID] UUIDString] stringByAppendingString:filenameSuffix];
            NSString *tempFilePath = [tempDict stringByAppendingPathComponent:attachmentID];
            
            if ([[NSFileManager defaultManager] moveItemAtPath:location.path toPath:tempFilePath error:&error]) {
                UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:attachmentID URL:[NSURL fileURLWithPath:tempFilePath] options:nil error:&error];
                
                if (!attachment) {
                    NSLog(@"Create attachment error: %@", error);
                } else {
                    _bestAttemptContent.attachments = [_bestAttemptContent.attachments arrayByAddingObject:attachment];
                }
            } else {
                NSLog(@"Move file error: %@", error);
            }
        } else {
            NSLog(@"Download file error: %@", error);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.contentHandler(self.bestAttemptContent);
        });
    }] resume];
    
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
