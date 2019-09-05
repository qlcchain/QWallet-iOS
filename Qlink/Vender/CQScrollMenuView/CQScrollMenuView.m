//
//  CQScrollMenuView.m
//  UITableViewDemo
//
//  Created by 蔡强 on 2017/5/26.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import "CQScrollMenuView.h"
#import "UIView+frameAdjust.h"

@interface CQScrollMenuView ()

@end

@implementation CQScrollMenuView{
    /** 用于记录最后创建的控件 */
    UIView *_lastView;
    /** 按钮下面的横线 */
    UIView *_lineView;
}

#pragma mark - 重写构造方法
/** 重写构造方法 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        _currentButtonIndex = 0; // 默认当前选择的按钮是第一个
    }
    return self;
}

#pragma mark - 赋值标题数组
/** 赋值标题数组 */
- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    
    // 先将所有子控件移除
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    // 将lastView置空
    _lastView = nil;
    
    // 遍历标题数组
    [_titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *menuButton = [[UIButton alloc]init];
        [self addSubview:menuButton];
        if (_lastView) {
            menuButton.frame = CGRectMake(_lastView.maxX + 10, 0, 100, self.height);
        }else{
            menuButton.frame = CGRectMake(0, 0, 100, self.height);
        }
        
        menuButton.tag = 100 + idx;
        [menuButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [menuButton setTitle:obj forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // 宽度自适应
        [menuButton sizeToFit];
        menuButton.height = self.height;
        
        // 这句不能少，不然初始化时button的label的宽度为0
        [menuButton layoutIfNeeded];
        
        // 默认第一个按钮时选中状态
        if (idx == 0) {
            menuButton.selected = YES;
            _lineView = [[UIView alloc]init];
            [self addSubview:_lineView];
            _lineView.bounds = CGRectMake(0, 0, menuButton.titleLabel.width, 2);
            _lineView.center = CGPointMake(menuButton.centerX, self.height-2);
            _lineView.backgroundColor = [UIColor whiteColor];
        }
        
        _lastView = menuButton;
    }];
    
    self.contentSize = CGSizeMake(CGRectGetMaxX(_lastView.frame), CGRectGetHeight(self.frame));
    
    // 如果内容总宽度不超过本身，平分各个模块
    if (_lastView.maxX < self.width) {
        int i = 0;
        for (UIButton *button in self.subviews) {
            if ([button isMemberOfClass:[UIButton class]]) {
                button.width = self.width / _titleArray.count;
                button.x = i * button.width;
                button.titleLabel.adjustsFontSizeToFitWidth = YES; // 开启，防极端情况
                if (i == 0) {
                    _lineView.width = button.titleLabel.width;
                    _lineView.centerX = button.centerX;
                    _lineView.maxY = self.height-2;
                }
                i ++;
            }
        }
    }
}

#pragma mark - 菜单按钮点击
/** 菜单按钮点击 */
- (void)menuButtonClicked:(UIButton *)sender{
    // 改变按钮的选中状态
    for (UIButton *button in self.subviews) {
        if ([button isMemberOfClass:[UIButton class]]) {
            button.selected = NO;
        }
    }
    sender.selected = YES;
    
    // 将所点击的button移到中间
    if (_lastView.maxX > self.width) {
        if (sender.x >= self.width / 2 && sender.centerX <= self.contentSize.width - self.width/2) {
            [UIView animateWithDuration:0.3 animations:^{
                self.contentOffset = CGPointMake(sender.centerX - self.width / 2, 0);
            }];
        }else if (sender.frame.origin.x < self.width / 2){
            [UIView animateWithDuration:0.3 animations:^{
                self.contentOffset = CGPointMake(0, 0);
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                self.contentOffset = CGPointMake(self.contentSize.width - self.width, 0);
            }];
        }
    }
    
    // 改变下横线的位置和宽度
    [UIView animateWithDuration:0.3 animations:^{
        _lineView.width = sender.titleLabel.width;
        _lineView.centerX = sender.centerX;
    }];
    
    // 代理方执行方法
    if ([self.menuButtonClickedDelegate respondsToSelector:@selector(scrollMenuView:clickedButtonAtIndex:)]) {
        [self.menuButtonClickedDelegate scrollMenuView:self clickedButtonAtIndex:(sender.tag - 100)];
    }
}

#pragma mark - 赋值当前选择的按钮
/** 赋值当前选择的按钮 */
- (void)setCurrentButtonIndex:(NSInteger)currentButtonIndex{
    _currentButtonIndex = currentButtonIndex;
    
    // 改变按钮的选中状态
    UIButton *currentButton = [self viewWithTag:(100 + currentButtonIndex)];
    for (UIButton *button in self.subviews) {
        if ([button isMemberOfClass:[UIButton class]]) {
            button.selected = NO;
        }
    }
    currentButton.selected = YES;
    
    // 将所点击的button移到中间
    if (_lastView.maxX > self.width) {
        if (currentButton.x >= self.width / 2 && currentButton.centerX <= self.contentSize.width - self.width/2) {
            [UIView animateWithDuration:0.3 animations:^{
                self.contentOffset = CGPointMake(currentButton.centerX - self.width / 2, 0);
            }];
        }else if (currentButton.x < self.width / 2){
            [UIView animateWithDuration:0.3 animations:^{
                self.contentOffset = CGPointMake(0, 0);
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                self.contentOffset = CGPointMake(self.contentSize.width - self.width, 0);
            }];
        }
    }
    
    // 改变下横线的宽度和位置
    [UIView animateWithDuration:0.3 animations:^{
        _lineView.width = currentButton.titleLabel.width;
        _lineView.centerX = currentButton.centerX;
    }];
}

@end
