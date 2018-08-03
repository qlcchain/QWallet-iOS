//
//  VPNRightMenuView.h
//  Qlink
//
//  Created by 旷自辉 on 2018/8/1.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickMenuBlock)(NSInteger selectIndex);

@interface VPNRightMenuView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankContraintH;
@property (weak, nonatomic) IBOutlet UIView *menuBackView;
@property (weak, nonatomic) IBOutlet UIImageView *menuImageView;
@property (nonatomic , copy) ClickMenuBlock menuBlock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuContraintV;
+ (instancetype) loadVPNRightMenuView;
- (void) showVPNRightMenuViewWithRanging:(BOOL) isShow;
@end
