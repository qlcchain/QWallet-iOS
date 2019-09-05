//
//  CQScrollMenuView.h
//  UITableViewDemo
//
//  Created by 蔡强 on 2017/5/26.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CQScrollMenuView;
@protocol CQScrollMenuViewDelegate <NSObject>

/**
 菜单按钮点击时回调

 @param scrollMenuView 带单view
 @param index 所点按钮的index
 */
- (void)scrollMenuView:(CQScrollMenuView *)scrollMenuView clickedButtonAtIndex:(NSInteger)index;

@end

@interface CQScrollMenuView : UIScrollView

@property (nonatomic,weak) id <CQScrollMenuViewDelegate> menuButtonClickedDelegate;
/** 菜单标题数组 */
@property (nonatomic,strong) NSArray *titleArray;
/** 当前选择的按钮的index */
@property (nonatomic,assign) NSInteger currentButtonIndex;

@end
