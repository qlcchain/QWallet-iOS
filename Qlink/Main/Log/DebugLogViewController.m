//
//  DebugLogViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/16.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "DebugLogViewController.h"
#import "DDLogUtil.h"

@interface DebugLogViewController ()

@property (weak, nonatomic) IBOutlet UITextView *mainTextV;

@end

@implementation DebugLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self refreshLog];
}

- (void)refreshLog {
    kWeakSelf(self);
    [DDLogUtil getDDLogStr:^(NSString *text) {
        weakself.mainTextV.text = text;
        [weakself scrollToBottom];
    }];
}

- (void)scrollToBottom {
    _mainTextV.layoutManager.allowsNonContiguousLayout = NO;
    [_mainTextV scrollRangeToVisible:NSMakeRange(_mainTextV.text.length, 1)];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backAction:(id)sender {
    [self back];
}

- (IBAction)clearAction:(id)sender {
//    [[DDLog sharedInstance] removeAllLoggers]; // 移除log
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    NSString *logDirectory = [fileLogger.logFileManager logsDirectory];
    NSArray <NSString *>*logsNameArray = [fileLogger.logFileManager sortedLogFileNames];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // log文件按时间排序
        NSArray *sortArr = [logsNameArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return NSOrderedDescending;
        }];
        
        // log文件路径
        [sortArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *logPath = [logDirectory stringByAppendingPathComponent:obj];
            BOOL removeSuccess = [[NSFileManager defaultManager] removeItemAtPath:logPath error:nil];
            NSLog(@"removeSuccess=%@",@(removeSuccess));
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshLog];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
