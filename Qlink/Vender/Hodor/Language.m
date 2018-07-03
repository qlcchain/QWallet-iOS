//
//  Language.h
//
//  Created by Aufree on 12/5/15.
//  Copyright (c) 2015 The EST Group. All rights reserved.
//

#import "Language.h"

@implementation Language

static NSBundle *bundle = nil;

NSString *const LanguageCodeIdIndentifier = @"LanguageCodeIdIndentifier";

+ (void)initialize {
     NSString *current = @"zh-Hant";
    [self setLanguage:current];
}

+ (void)setLanguage:(NSString *)language {
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
}

+ (NSString *)currentLanguageCode {
    NSString *userSelectedLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:LanguageCodeIdIndentifier];
    if (userSelectedLanguage) {
        // Store selected language in local
        
        return userSelectedLanguage;
    } else {
        // 初始化本地语言  默认繁体
        [Language userSelectedLanguage:LanguageCode[1]];
        return [Language currentLanguageCode];
    }
    
    NSString *systemLanguage = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    if ([systemLanguage isEqualToString:@"en"] || [systemLanguage isEqualToString:@"zh-Hant"]) {
        // Update selected language in local
    } else {
        // Update selected language in local
    }
    
    return systemLanguage;
}

+ (void)userSelectedLanguage:(NSString *)selectedLanguage {
    // Store the data
    // Store selected language in local
    
    [[NSUserDefaults standardUserDefaults] setObject:selectedLanguage forKey:LanguageCodeIdIndentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // Set global language
    [Language setLanguage:selectedLanguage];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLanguageChangeNoti object:nil];
}

+ (NSString *)get:(NSString *)key alter:(NSString *)alternate {
    NSString *_currentLanguage = [Language currentLanguageCode];
    NSString *path = [[NSBundle mainBundle] pathForResource:_currentLanguage ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
    NSString *valStr = [bundle localizedStringForKey:key value:alternate table:nil];
    return valStr;
}

// 用于各个vc中，要监听通知
+ (void)changeLanguage {
    NSString *_currentLanguage = [[Language currentLanguageCode] mutableCopy];
    if ([_currentLanguage isEqualToString:LanguageCode[0]]) {
        _currentLanguage = LanguageCode[1];
    } else if ([_currentLanguage isEqualToString:LanguageCode[1]]) {
        _currentLanguage = LanguageCode[0];
    }
    
    [Language userSelectedLanguage:_currentLanguage];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshText) name:kLanguageChangeNoti object:nil];
//    _helloWorldLabel.text = kLang(@"Hello World");
}

@end
