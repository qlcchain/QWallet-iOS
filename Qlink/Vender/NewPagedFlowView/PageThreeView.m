//
//  PageThreeView.m
//  Qlink
//
//  Created by 旷自辉 on 2018/8/1.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "PageThreeView.h"

@implementation PageThreeView

- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds {
    
    if (CGRectEqualToRect(self.mainImageView.frame, superViewBounds)) {
        return;
    }
    
    self.mainImageView.frame = superViewBounds;
    self.coverView.frame = superViewBounds;
    //self.indexLabel.frame = CGRectMake(0, 10, superViewBounds.size.width, 20);
}

@end
