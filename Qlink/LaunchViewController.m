//
//  ViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "LaunchViewController.h"
#import <SDWebImage/UIImage+GIF.h>
#import "OLImage.h"
#import "OLImageView.h"

@interface LaunchViewController ()

@property (weak, nonatomic) IBOutlet OLImageView *gifImgV;

@end

@implementation LaunchViewController

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _gifImgV.image = [LaunchViewController gifImage];
}

+ (void)showLog {
    DDLogDebug(@"oc log");
}

+ (NSTimeInterval)getGifDuration {
    NSTimeInterval timeI = ((OLImage *)[LaunchViewController gifImage]).totalDuration;
    return timeI;
}

+ (UIImage *)gifImage {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"launchAnimate" ofType:@"gif"];
    UIImage *img = [OLImage imageWithData:[NSData dataWithContentsOfFile:path]];
    return img;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
