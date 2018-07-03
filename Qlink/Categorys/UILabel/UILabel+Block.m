//
//  UILabel+Block.m
//  ZYPZPro
//
//  Created by SystemOuter on 15/11/7.
//  Copyright © 2015年 SystemOuter. All rights reserved.
//

#import "UILabel+Block.h"

@implementation UILabel (Block)

#pragma mark- 公共方法区
/**
 *  创建一个Label标签
 *
 *  @param basicSet 包含基本设置（参数为当前创建的label）
 *
 *  @return 返回创建的label
 */
+(UILabel *)label_Alloc:(ZYLabelBasicSetBlock)basicSet
{
    UILabel * lab_Temp = [[UILabel alloc] init];
    if (basicSet) {
        basicSet(lab_Temp);
    }
    return lab_Temp;
}

/**
 *  创建一个Label标签
 *
 *  @param basicSet     包含基本设置（参数为当前创建的label）
 *  @param superView    要添加到的SuperView
 *
 *  @return 返回创建的label
 */
+(UILabel *)label_Alloc:(ZYLabelBasicSetBlock)basicSet addView:(UIView *)superView
{
    UILabel * lab_Temp = [[UILabel alloc] init];
    if (basicSet) {
        basicSet(lab_Temp);
    }
    [superView addSubview:lab_Temp];
    return lab_Temp;
}

/**
 *  label标签，基本设置
 *
 *  @param basicSet basicSet 包含基本设置（参数为当前创建的label）
 */
-(void)label_basicSet:(ZYLabelBasicSetBlock)basicSet
{
    if (basicSet) {
        basicSet(self);
    }
}

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
+(UILabel *)label_AllocAutoMask:(ZYLabelBasicSetBlock)basicSet withText:(NSString *)text lineBreakMode:(NSLineBreakMode)lineBreakMode font:(UIFont *)font withLabelFrame:(CGRect)frame heightMask:(BOOL)heightMask
{
    //基础设置
    UILabel * lab_Temp = [[UILabel alloc] init];
    //额外属性设置
    //判断Block是否实现
    if (basicSet) {
        //调用以完成额外属性设置
        basicSet(lab_Temp);
    }
    //设置Label尺寸
    lab_Temp.frame = frame;
    //设置内容
    lab_Temp.text = text;
    //设置字体
    lab_Temp.font = font;
    //记录自适应后的高度
    float flt_Auto = .0f;
    //当前要适应的尺寸高度
    CGSize size_Content = CGSizeMake(heightMask?CGRectGetWidth(frame):MAXFLOAT, heightMask?MAXFLOAT:CGRectGetHeight(frame));
    //系统适配
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        //IOS7.0以上计算文字高度
        CGSize size = [text boundingRectWithSize:size_Content options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        //记录计算后的变化的尺寸
        flt_Auto = heightMask?size.height:size.width;
    }else{
        //IOS7.0以下计算文字高度
        CGSize size = [text sizeWithFont:font constrainedToSize:size_Content lineBreakMode:lineBreakMode];
        //记录计算后的变化尺寸
        flt_Auto = heightMask?size.height:size.width;
    }
    //设置行数为自适应行数0
    lab_Temp.numberOfLines = 0;
    //重设label尺寸
    lab_Temp.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), heightMask?CGRectGetWidth(frame):flt_Auto, heightMask?flt_Auto:CGRectGetHeight(frame));
    //返回自适应的Label
    return lab_Temp;
}

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
+(UILabel *)label_AllocAutoMask:(ZYLabelBasicSetBlock)basicSet withText:(NSString *)text lineBreakMode:(NSLineBreakMode)lineBreakMode font:(UIFont *)font withLabelFrame:(CGRect)frame heightMask:(BOOL)heightMask addView:(UIView *)superView
{
    //基础设置
    UILabel * lab_Temp = [[UILabel alloc] init];
    //额外属性设置
    //判断Block是否实现
    if (basicSet) {
        //调用以完成额外属性设置
        basicSet(lab_Temp);
    }
    //设置Label尺寸
    lab_Temp.frame = frame;
    //设置内容
    lab_Temp.text = text;
    //设置字体
    lab_Temp.font = font;
    //记录自适应后的高度
    float flt_Auto = .0f;
    //当前要适应的尺寸高度
    CGSize size_Content = CGSizeMake(heightMask?CGRectGetWidth(frame):MAXFLOAT, heightMask?MAXFLOAT:CGRectGetHeight(frame));
    //系统适配
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        //IOS7.0以上计算文字高度
        CGSize size = [text boundingRectWithSize:size_Content options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        //记录计算后的变化的尺寸
        flt_Auto = heightMask?size.height:size.width;
    }else{
        //IOS7.0以下计算文字高度
        CGSize size = [text sizeWithFont:font constrainedToSize:size_Content lineBreakMode:lineBreakMode];
        //记录计算后的变化尺寸
        flt_Auto = heightMask?size.height:size.width;
    }
    //设置行数为自适应行数0
    lab_Temp.numberOfLines = 0;
    //重设label尺寸
    lab_Temp.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), heightMask?CGRectGetWidth(frame):flt_Auto, heightMask?flt_Auto:CGRectGetHeight(frame));
    //添加到父视图
    [superView addSubview:lab_Temp];
    //返回自适应的Label
    return lab_Temp;
}

/**
 *  label标签，文字按指定方向自适应，并自动修改label尺寸
 *
 *  @param heightMask 是否是高度根据文字自适应
 */
-(void)label_AutoMaskWithHeightMask:(BOOL)heightMask
{
    //记录自适应后的高度
    float flt_Auto = .0f;
    //当前要适应的尺寸高度
    CGSize size_Content = CGSizeMake(heightMask?CGRectGetWidth(self.frame):MAXFLOAT, heightMask?MAXFLOAT:CGRectGetHeight(self.frame));
    //系统适配
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        //IOS7.0以上计算文字高度
        CGSize size = [self.text boundingRectWithSize:size_Content options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
        //记录计算后的变化的尺寸
        flt_Auto = heightMask?size.height:size.width;
    }else{
        //IOS7.0以下计算文字高度
        CGSize size = [self.text sizeWithFont:self.font constrainedToSize:size_Content lineBreakMode:self.lineBreakMode];
        //记录计算后的变化尺寸
        flt_Auto = heightMask?size.height:size.width;
    }
    //设置行数为自适应行数0
    self.numberOfLines = 0;
    //重设label尺寸
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), heightMask?CGRectGetWidth(self.frame):flt_Auto, heightMask?flt_Auto:CGRectGetHeight(self.frame));
}

/**
 *  创建一个Label标签，其中文字颜色按照指定图片渐变
 *
 *  @param basicSet    basicSet 包含基本设置（参数为当前创建的label）
 *  @param image       文字渐变图片
 *
 *  @return 返回创建的label
 */
+(UILabel *)label_AllocColorAdverb:(ZYLabelBasicSetBlock)basicSet withColor:(UIImage *)image
{
    UILabel * lab_Temp = [[UILabel alloc] init];
    if (basicSet) {
        basicSet(lab_Temp);
    }
    //设置图层背景色
    lab_Temp.textColor = (__bridge UIColor * _Nullable)([UIColor colorWithPatternImage:image].CGColor);
    return lab_Temp;
}

/**
 *  创建一个Label标签，其中文字颜色按照指定图片渐变
 *
 *  @param basicSet    basicSet 包含基本设置（参数为当前创建的label）
 *  @param image       文字渐变图片
 *  @param superView   要添加到的SuperView
 *
 *  @return 返回创建的label
 */
+(UILabel *)label_AllocColorAdverb:(ZYLabelBasicSetBlock)basicSet withColor:(UIImage *)image addView:(UIView *)superView
{
    UILabel * lab_Temp = [[UILabel alloc] init];
    if (basicSet) {
        basicSet(lab_Temp);
    }
    //设置图层背景色
    lab_Temp.textColor = (__bridge UIColor * _Nullable)([UIColor colorWithPatternImage:image].CGColor);
    //添加到父视图
    [superView addSubview:lab_Temp];
    return lab_Temp;
}

/**
 *  label标签，文字颜色按照指定图片渐变
 *
 *  @param image 文字渐变图片
 */
-(void)label_ColorAdverb:(UIImage *)image
{
    //设置图层背景色
    self.textColor = (__bridge UIColor * _Nullable)([UIColor colorWithPatternImage:image].CGColor);
}

/**
 *  创建一个Label标签，其中文字格式按照给定格式进行编码显示
 *
 *  @param basicSet        basicSet 包含基本设置（参数为当前创建的label）
 *  @param text            文字内容
 *  @param attributedArray 格式数组，包含PZAttributedMode的NSValue数组，存的时候将结构体转换为NSValue
 *
 *  @return 返回对应Label
 */
+(UILabel *)label_AllocAttributedString:(ZYLabelBasicSetBlock)basicSet withText:(NSString *)text attributedMode:(NSArray<NSValue *> *)attributedArray
{
    //常规创建
    UILabel * lab_Temp = [[UILabel alloc] init];
    if (basicSet) {
        basicSet(lab_Temp);
    }
    //清空原始文字
    lab_Temp.text = @"";
    
    //设置格式字符串
    NSMutableAttributedString * strAtt_Temp = [[NSMutableAttributedString alloc] initWithString:text];
    //取出对应数据
    for (NSValue * value_Temp in attributedArray) {
        //取出NSValue中结构体
        PZAttributedMode attriM_Temp = ValueToPZAttributedMode(value_Temp);
        //赋值给格式字符串
        [strAtt_Temp addAttribute:attriM_Temp.attributeName value:attriM_Temp.value range:attriM_Temp.range];
    }
    
    //赋值给Label
    lab_Temp.attributedText = strAtt_Temp;
    
    //返回给格式Label
    return lab_Temp;
}

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
+(UILabel *)label_AllocAttributedString:(ZYLabelBasicSetBlock)basicSet withText:(NSString *)text attributedMode:(NSArray<NSValue *> *)attributedArray addView:(UIView *)superView
{
    //常规创建
    UILabel * lab_Temp = [[UILabel alloc] init];
    if (basicSet) {
        basicSet(lab_Temp);
    }
    //清空原始文字
    lab_Temp.text = @"";
    //设置格式字符串
    NSMutableAttributedString * strAtt_Temp = [[NSMutableAttributedString alloc] initWithString:text];
    //取出对应数据
    for (NSValue * value_Temp in attributedArray) {
        //取出NSValue中结构体
        PZAttributedMode attriM_Temp = ValueToPZAttributedMode(value_Temp);
        //赋值给格式字符串
        [strAtt_Temp addAttribute:attriM_Temp.attributeName value:attriM_Temp.value range:attriM_Temp.range];
    }
    
    //赋值给Label
    lab_Temp.attributedText = strAtt_Temp;
    
    //添加到父视图
    [superView addSubview:lab_Temp];
    
    //返回给格式Label
    return lab_Temp;
}

/**
 *  label标签，其中文字格式按照给定格式进行编码显示
 *
 *  @param text            文字内容
 *  @param attributedArray 格式数组，包含PZAttributedMode的NSValue数组，存的时候将结构体转换为NSValue
 */
-(void)label_AttributedString:(NSString *)text attributedMode:(NSArray<NSValue *> *)attributedArray
{
    //先清空原始文字
    self.text = @"";
    //设置格式字符串
    NSMutableAttributedString * strAtt_Temp = [[NSMutableAttributedString alloc] initWithString:text];
    //取出对应数据
    for (NSValue * value_Temp in attributedArray) {
        //取出NSValue中结构体
        PZAttributedMode attriM_Temp = ValueToPZAttributedMode(value_Temp);
        //赋值给格式字符串
        [strAtt_Temp addAttribute:attriM_Temp.attributeName value:attriM_Temp.value range:attriM_Temp.range];
    }
    //赋值给Label
    self.attributedText = strAtt_Temp;
}


/**
 *  显示下划线
 */
-(void)showUnderLine
{
    NSMutableAttributedString * strAtt_Temp = [[NSMutableAttributedString alloc] initWithString:self.text];
    [strAtt_Temp addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, self.text.length)];
    self.attributedText = strAtt_Temp;
}

/**
 *  显示删除线
 *
 *  @param color 删除线颜色
 */
-(void)showDeleteLine:(UIColor *)color
{
    NSMutableAttributedString * strAtt_Temp = [[NSMutableAttributedString alloc] initWithString:self.text];
    [strAtt_Temp addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid) range:NSMakeRange(0, self.text.length)];
    [strAtt_Temp addAttribute:NSStrikethroughColorAttributeName value:color range:NSMakeRange(0, self.text.length)];
    self.attributedText = strAtt_Temp;
}

/**
 *  自动横移
 *
 *  @param handleBlock      横移一次之后的动画
 *  @param bol_NeedRepead   是否要重复
 *
 */
-(void)lab_AutoRowMove:(ZYLabelAfterHandleBlock)handleBlock withReqeat:(BOOL)bol_NeedRepead
{
    //超出了
    if (CGRectGetWidth(self.frame) > CGRectGetWidth(self.superview.bounds)) {
        //让父视图剪切当前可见区域
        self.superview.clipsToBounds = YES;
        int width = (int)(CGRectGetWidth(self.frame) - CGRectGetWidth(self.superview.bounds));
        //动画时间
        NSTimeInterval time = (width/CGRectGetWidth(self.superview.bounds))*3;
        //循环引用
        __block typeof(self) self_Temp = self;
        __block typeof(time) time_Temp = time;
        
        //设置动画重复模式
        UIViewAnimationOptions animationOption = bol_NeedRepead?(UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat):UIViewAnimationOptionCurveLinear;
        
        //开启动画
        [UIView animateWithDuration:time delay:1 options:animationOption animations:^{
            CGRect rect_Temp = self_Temp.frame;
            rect_Temp.origin.x = CGRectGetWidth(self_Temp.superview.frame) - CGRectGetWidth(self_Temp.frame);
            self_Temp.frame = rect_Temp;
        } completion:^(BOOL finished) {
            if (handleBlock) {
                handleBlock(self_Temp,time_Temp);
            }
        }];
    }
}



@end
