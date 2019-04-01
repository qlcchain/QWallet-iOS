//
//  UnderlineView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/4/10.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UnderlineView : UIView

//@property(nonatomic, assign) IBInspectable UIImage *normalImage;
//@property(nonatomic, assign) IBInspectable UIImage *editingImage;
@property(nonatomic, assign) IBInspectable CGFloat leftOffset;
@property(nonatomic, assign) IBInspectable CGFloat rightOffset;
@property(nonatomic, weak) UITextField *textField;

//- (void)beginEdit;
//- (void)endEdit;

@end
