//
//  DefiNewsListModel.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/12.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DefiNewsListModel.h"
#import "NSDate+Category.h"
#import "GlobalConstants.h"

@implementation DefiNewsListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

- (NSString *)formattedDefiNewsTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *theDay = [dateFormatter stringFromDate:self];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    
//    NSInteger timeInterval = -[self timeIntervalSinceNow];
    NSInteger timeInterval = [[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:_createDate]];
    if (timeInterval < 3600) {//1小时内
        int val = (int)(timeInterval / 60);
        return [NSString stringWithFormat:@"%d%@", val,val<=1?kLang(@"defi_minute_ago"):kLang(@"defi_minutes_ago")];
    } else if (timeInterval < (21600*4)) {//24小时内
        int val = (int)(timeInterval / 3600);
        return [NSString stringWithFormat:@"%d%@", val,val<=1?kLang(@"defi_hour_age"):kLang(@"defi_hours_age")];
    } else {
//        timeInterval = [[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]];
        if (timeInterval<=86400*7) {
            int val = (int)(timeInterval / 86400);
            return [NSString stringWithFormat:@"%d%@", val,val<=1?kLang(@"defi_day_age"):kLang(@"defi_days_age")];
        } else {
            int val = (int)(timeInterval / (86400*7));
            return [NSString stringWithFormat:@"%d%@", val,val<=1?kLang(@"defi_week_age"):kLang(@"defi_weeks_ago")];
        }
    }
}

- (NSAttributedString *)showContent {
    NSString *result = _isShowDetail?(_content!=nil&&_content.length>0)?_content:_leadText:_leadText;
    
    NSAttributedString *contentAttr = nil;
//    if (_content!=nil&&_content.length>0) {
        NSMutableAttributedString *contentMuAtt =  [[NSMutableAttributedString alloc] initWithData:[result dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [contentMuAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, contentMuAtt.length)];
        [contentMuAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x555555) range:NSMakeRange(0, contentMuAtt.length)];
        contentAttr = contentMuAtt;
//    }
    
    return contentAttr;
}

@end
