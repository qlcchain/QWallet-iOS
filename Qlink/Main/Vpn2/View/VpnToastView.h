//
//  VpnToastView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/7/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VpnToastView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic ,copy) void (^yesClickBlock)(void);

+ (instancetype) loadVPN2ToastView;
- (void) showToastView;
@end
