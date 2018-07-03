//
//  UnderlineView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/10.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "UnderlineView.h"

#define Underline_Image_Edit [UIImage imageNamed:@"bg_shape"]
#define Underline_Image_Normal [UIImage imageNamed:@"bg_shape_two"]

//static char normalImageKey, editingImageKey;

@interface UnderlineView ()

@property (nonatomic, strong) UIImageView *underlineV;
@property (nonatomic, strong) MASConstraint *heightConstraint;
@property (nonatomic, strong) MASConstraint *leftConstraint;
@property (nonatomic, strong) MASConstraint *rightConstraint;

@end

@implementation UnderlineView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self addSubview:self.underlineV];
        [self.underlineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).offset(0);
            self.leftConstraint = make.left.mas_equalTo(self).offset(0);
            self.rightConstraint = make.right.mas_equalTo(self).offset(0);
            self.heightConstraint = make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    
//    _underlineV.frame = CGRectMake(0, self.height - 0.5 - 0.2, self.width, 0.5);
}

- (void)beginEdit {
    _heightConstraint.offset = 1;
//    _underlineV.frame = CGRectMake(_underlineV.left, self.height - 1 - 0.2, _underlineV.width, 1);
    _underlineV.image = Underline_Image_Edit;
}

- (void)endEdit {
    _heightConstraint.offset = 0.5;
//    _underlineV.frame = CGRectMake(_underlineV.left, self.height - 0.5 - 0.2, _underlineV.width, 0.5);
    _underlineV.image = Underline_Image_Normal;
}

- (void)setLeftOffset:(CGFloat)leftOffset {
    _leftConstraint.offset = leftOffset;
//    _underlineV.frame = CGRectMake(leftOffset, _underlineV.top, _underlineV.width, _underlineV.height);
}

- (void)setRightOffset:(CGFloat)rightOffset {
    _rightConstraint.offset = -rightOffset;
//    _underlineV.frame = CGRectMake(_underlineV.left, _underlineV.top, self.width - _underlineV.left - rightOffset, _underlineV.height);
}

- (void)setTextField:(UITextField *)textField {
    [textField addTarget:self action:@selector(beginEdit) forControlEvents:UIControlEventEditingDidBegin];
    [textField addTarget:self action:@selector(endEdit) forControlEvents:UIControlEventEditingDidEnd];
}

- (UIImageView *)underlineV {
    if (!_underlineV) {
        _underlineV = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height - 0.5, self.width, 0.5)];
        _underlineV.image = Underline_Image_Normal;
        _underlineV.contentMode = UIViewContentModeScaleToFill;
    }
    
    return _underlineV;
}


@end
