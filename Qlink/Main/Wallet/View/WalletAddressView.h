//
//  ManageFundsView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/3/29.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletAddressView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
+ (WalletAddressView *)getNibView;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;

@end
