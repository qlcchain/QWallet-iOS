//
//  LandScapePicker.m
//  PickView
//
//  Created by A$CE on 2018/1/25.
//  Copyright © 2018年 A$CE. All rights reserved.
//

#import "LandScapePicker.h"

@interface LandScapePicker()<UIPickerViewDelegate,UIPickerViewDataSource> {
    BOOL _isTransform;
}
@property (nonatomic ,strong) UIPickerView *pickerView;
@property (nonatomic) NSInteger currentSelectRow;

@end


@implementation LandScapePicker

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.backgroundColor = [UIColor clearColor];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.currentSelectRow = 0;
        [self addSubview:self.pickerView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (_isTransform) {
        return;
    }
    CGFloat w = rect.size.height;
    CGFloat h = rect.size.width;
    CGFloat centerX = w * 0.5;
    CGFloat centerY = h * 0.5;
    CGFloat y = centerX - h * 0.5;
    CGFloat x = centerY - w * 0.5;
    self.pickerView.frame = CGRectMake(x, y,w,h);
    self.pickerView.transform = CGAffineTransformMakeRotation(M_PI*3/2);
    _isTransform = YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    if (self.lspkTitles) {
        return self.lspkTitles().count;
    }
    return self.pTitles.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    for(UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = [UIColor clearColor];}}
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:60 weight:UIFontWeightBold];
    if (self.lspkTitles) {
        label.text = self.lspkTitles()[row];
    }else {
        label.text = self.pTitles[row];
    }
    label.textColor = self.titleColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.transform = CGAffineTransformMakeRotation(M_PI_2);
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component {
    return 77;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView
rowHeightForComponent:(NSInteger)component {
    return 100;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    _currentSelectRow = row;
    if (self.lspSelected) {
        NSString *title;
        if (self.lspkTitles) {
            title = self.lspkTitles()[row];
        }else {
            title = self.pTitles[row];
        }
        self.lspSelected(row,title);
    }
}

- (NSInteger)getCurrentSelectRow {
    return _currentSelectRow;
}

- (void)selectRow:(NSInteger)row {
    _currentSelectRow = row;
    [self.pickerView selectRow:row inComponent:0 animated:YES];
}

- (void)reload {
    [self.pickerView reloadAllComponents];
}

@end
