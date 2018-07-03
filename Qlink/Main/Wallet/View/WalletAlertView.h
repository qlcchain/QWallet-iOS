//
//  WalletAlertView.h
//  Qlink
//
//  Created by 旷自辉 on 2018/3/30.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletAlertView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblMsg;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (nonatomic ,copy) void (^yesClickBlock)(void);
@property (nonatomic ,copy) void (^cancelClickBlock)(void);

+ (instancetype) loadWalletAlertView;
- (void) showIsTwoBtn:(BOOL) isTwo;
- (void) hidde;
@end
