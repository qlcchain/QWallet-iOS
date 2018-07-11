//
//  VPNFileInputView.h
//  Qlink
//
//  Created by 旷自辉 on 2018/4/23.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnderlineView.h"

@interface VPNFileInputView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblMsg;
@property (weak, nonatomic) IBOutlet UnderlineView *lineView;
@property (weak, nonatomic) IBOutlet UITextField *txtFileName;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic , copy) NSURL *vpnURL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintCenterX;
+ (instancetype) loadVPNFileInputView;
- (void) showVPNFileInputView:(UIView *) view;

@end
