//
//  UILabel+Block.h
//  ZYPZPro
//
//  Created by SystemOuter on 15/11/7.
//  Copyright © 2015年 SystemOuter. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark- STRUCT_LINEMTHOD

/**
 *  NSAttributedString属性字符串 Attributed结构体
 */
typedef struct{
    /**
     *  待修改的Attributed的格式名称（常用：NSFontAttributeName(字体)、NSParagraphStyleAttributeName(段落格式)、NSForegroundColorAttributeName(前景色)、NSBackgroundColorAttributeName(背景色)、NSUnderlineStyleAttributeName(下划线)）
     */
    __unsafe_unretained NSString * attributeName;
    
    /**
     *  格式的值
     */
    __unsafe_unretained id value;
    
    /**
     *  需要格式的文字的范围
     */
    NSRange range;
    
}PZAttributedMode;

/**
 *  PZAttributedMode制造 内链函数
 *
 *  @param s 待修改的Attributed的格式名称
 *  @param i 格式的值
 *  @param r 需要格式的文字的范围
 *
 *  @return 赋值过的PZAttributedMode
 */
CG_INLINE PZAttributedMode PZAttributedMake(NSString * s, id i, NSRange r)
{
    PZAttributedMode mode;
    mode.attributeName = s;
    mode.value = i;
    mode.range = r;
    return mode;
}

/**
 *  PZAttributedMode转NSValue 内链函数
 *
 *  @param aMode 需要转换的PZAttributedMode结构体
 *
 *  @return 转换PZAttributedMode后的Value
 */
CG_INLINE NSValue* PZAttributedModeToValue(PZAttributedMode aMode)
{
    NSValue * value = [NSValue valueWithBytes:&aMode objCType:@encode(PZAttributedMode)];
    return value;
}

/**
 *  NSValue转PZAttributedMode 内链函数
 *
 *  @param value 需要转换的PZAttributedMode的NSValue
 *
 *  @return 转换Value后的PZAttributedMode
 */
CG_INLINE PZAttributedMode ValueToPZAttributedMode(NSValue * value)
{
    PZAttributedMode aMode;
    [value getValue:&aMode];
    return aMode;
}

#pragma mark- TYPEDEF_BLOCK
/**
 *  label基本设置Block
 *
 *  @param lab 当前要设置的Label
 */
typedef void (^ZYLabelBasicSetBlock)(UILabel * lab);

/**
 *  label动画执行后的Block
 *
 *  @param lab 当前要设置的Label
 */
typedef void (^ZYLabelAfterHandleBlock)(UILabel * lab,NSTimeInterval time);

#pragma mark-

@interface UILabel (Block)

#pragma mark- NEW_METHOD

/**
 *  创建一个Label标签
 *
 *  @param basicSet 包含基本设置（参数为当前创建的label）
 *
 *  @return 返回创建的label
 */
+(UILabel *)label_Alloc:(ZYLabelBasicSetBlock)basicSet;

/**
 *  创建一个Label标签
 *
 *  @param basicSet     包含基本设置（参数为当前创建的label）
 *  @param superView    要添加到的SuperView
 *
 *  @return 返回创建的label
 */
+(UILabel *)label_Alloc:(ZYLabelBasicSetBlock)basicSet addView:(UIView *)superView;

/**
 *  label标签，基本设置
 *
 *  @param basicSet basicSet 包含基本设置（参数为当前创建的label）
 */
-(void)label_basicSet:(ZYLabelBasicSetBlock)basicSet;

/**
 *  创建一个Label标签，其中文字按指定方向自适应，并自动修改label尺寸
 *
 *  @param basicSet      basicSet 包含基本设置（参数为当前创建的label）
 *  @param text          文字内容
 *  @param lineBreakMode label换行格式
 *  @param font          label字体
 *  @param frame         label位置
 *  @param heightMask    是否是高度根据文字自适应
 *
 *  @return 返回创建的label
 */
+(UILabel *)label_AllocAutoMask:(ZYLabelBasicSetBlock)basicSet withText:(NSString *)text lineBreakMode:(NSLineBreakMode)lineBreakMode font:(UIFont *)font withLabelFrame:(CGRect)frame heightMask:(BOOL)heightMask;

/**
 *  创建一个Label标签，其中文字按指定方向自适应，并自动修改label尺寸
 *
 *  @param basicSet      basicSet 包含基本设置（参数为当前创建的label）
 *  @param text          文字内容
 *  @param lineBreakMode label换行格式
 *  @param font          label字体
 *  @param frame         label位置
 *  @param heightMask    是否是高度根据文字自适应
 *  @param superView     要添加到的SuperView
 *
 *  @return 返回创建的label
 */
+(UILabel *)label_AllocAutoMask:(ZYLabelBasicSetBlock)basicSet withText:(NSString *)text lineBreakMode:(NSLineBreakMode)lineBreakMode font:(UIFont *)font withLabelFrame:(CGRect)frame heightMask:(BOOL)heightMask addView:(UIView *)superView;

/**
 *  label标签，文字按指定方向自适应，并自动修改label尺寸
 *
 *  @param heightMask 是否是高度根据文字自适应
 */
-(void)label_AutoMaskWithHeightMask:(BOOL)heightMask;

/**
 *  创建一个Label标签，其中文字颜色按照指定图片渐变
 *
 *  @param basicSet    basicSet 包含基本设置（参数为当前创建的label）
 *  @param image       文字渐变图片
 *
 *  @return 返回创建的label
 */
+(UILabel *)label_AllocColorAdverb:(ZYLabelBasicSetBlock)basicSet withColor:(UIImage *)image;

/**
 *  创建一个Label标签，其中文字颜色按照指定图片渐变
 *
 *  @param basicSet    basicSet 包含基本设置（参数为当前创建的label）
 *  @param image       文字渐变图片
 *  @param superView   要添加到的SuperView
 *
 *  @return 返回创建的label
 */
+(UILabel *)label_AllocColorAdverb:(ZYLabelBasicSetBlock)basicSet withColor:(UIImage *)image addView:(UIView *)superView;

/**
 *  label标签，文字颜色按照指定图片渐变
 *
 *  @param image 文字渐变图片
 */
-(void)label_ColorAdverb:(UIImage *)image;

/**
 *  创建一个Label标签，其中文字格式按照给定格式进行编码显示
 *
 *  @param basicSet        basicSet 包含基本设置（参数为当前创建的label）
 *  @param text            文字内容
 *  @param attributedArray 格式数组，包含PZAttributedMode的NSValue数组，存的时候将结构体转换为NSValue
 *
 *  @return 返回对应Label
 */
+(UILabel *)label_AllocAttributedString:(ZYLabelBasicSetBlock)basicSet withText:(NSString *)text attributedMode:(NSArray<NSValue *> *)attributedArray;

/**
 *  创建一个Label标签，其中文字格式按照给定格式进行编码显示
 *
 *  @param basicSet        basicSet 包含基本设置（参数为当前创建的label）
 *  @param text            文字内容
 *  @param attributedArray 格式数组，包含PZAttributedMode的NSValue数组，存的时候将结构体转换为NSValue
 *  @param superView       要添加到的SuperView
 *
 *  @return 返回对应Label
 */
+(UILabel *)label_AllocAttributedString:(ZYLabelBasicSetBlock)basicSet withText:(NSString *)text attributedMode:(NSArray<NSValue *> *)attributedArray addView:(UIView *)superView;

/**
 *  label标签，其中文字格式按照给定格式进行编码显示
 *
 *  @param text            文字内容
 *  @param attributedArray 格式数组，包含PZAttributedMode的NSValue数组，存的时候将结构体转换为NSValue
 */
-(void)label_AttributedString:(NSString *)text attributedMode:(NSArray<NSValue *> *)attributedArray;

/**
 *  显示下划线
 */
-(void)showUnderLine;

/**
 *  显示删除线
 *
 *  @param color 删除线颜色
 */
-(void)showDeleteLine:(UIColor *)color;

/**
 *  自动横移<注意设置一直重复动画后 不会回调“handleBlock”操作>
 *
 *  @param handleBlock      横移一次之后的动画
 *  @param bol_NeedRepead   是否要重复
 *
 */
-(void)lab_AutoRowMove:(ZYLabelAfterHandleBlock)handleBlock withReqeat:(BOOL)bol_NeedRepead;


#pragma mark-

@end
