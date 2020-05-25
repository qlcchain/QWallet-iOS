//
//  LandScapePicker.h
//  PickView
//
//  Created by A$CE on 2018/1/25.
//  Copyright © 2018年 A$CE. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  type(NSInteger) ===> Selected row in picker
    type(NSString *) ===> Title show in pikcer
 */
typedef void(^LandScapePickerSelected)(NSInteger ,NSString *);
typedef NSArray<NSString *>* (^LandScapePickerTitles)(void);

@interface LandScapePicker : UIView

@property (nonatomic ,strong) NSArray<NSString *> *pTitles;/*Deprecated, USE LandScapePickerTitles Replaced*/

@property (nonatomic ,strong) UIColor *titleColor;

@property (nonatomic ,copy) LandScapePickerTitles lspkTitles;

@property (nonatomic ,copy) LandScapePickerSelected lspSelected;
/*跳转到指定行*/
- (void)selectRow:(NSInteger)row;
/*刷新*/
- (void)reload;
- (NSInteger)getCurrentSelectRow;

@end
