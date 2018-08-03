//
//  PageOneView.h
//  Qlink
//
//  Created by 旷自辉 on 2018/8/1.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGIndexBannerSubiew.h"

@interface PageOneView : PGIndexBannerSubiew
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblHour;
@property (weak, nonatomic) IBOutlet UILabel *lblMin;
@property (weak, nonatomic) IBOutlet UILabel *lblSecon;
@property (weak, nonatomic) IBOutlet UIImageView *winQImgView;

@property(nonatomic, strong)NSTimer *timer ; //定时器
@property(nonatomic, assign)double timeSecons;
@property(nonatomic, assign)double subSecons;

- (void) statrtTimeCountdownWithSecons:(double) secons;
@end
