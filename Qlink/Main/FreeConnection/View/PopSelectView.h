//
//  PopSelectView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/7/18.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickTabCellBlock)(NSString *cellValue,NSInteger row);

@interface PopSelectView : UIView
@property (nonatomic , copy) ClickTabCellBlock clickCellBlock;

+ (instancetype)getInstance;
- (void) showSelectView;
- (void) hideSelectView;
@end
