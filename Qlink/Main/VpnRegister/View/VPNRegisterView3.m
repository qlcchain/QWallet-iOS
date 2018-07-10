//
//  VPNRegisterView3.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/8.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VPNRegisterView3.h"
#import "VPNRegisterViewController.h"

#define FeeMin 0.1
#define FeeMax 3
#define ConnectionMin 1
#define ConnectionMax 20

@interface VPNRegisterView3 ()

@end

@interface VPNRegisterView3 ()

@property (weak, nonatomic) IBOutlet UILabel *hourlyLab;
@property (weak, nonatomic) IBOutlet UISlider *hourlyFeeSlider;
@property (weak, nonatomic) IBOutlet UILabel *connectionLab;
@property (weak, nonatomic) IBOutlet UISlider *connectionSlider;

@end

@implementation VPNRegisterView3

+ (VPNRegisterView3 *)getNibView {
    VPNRegisterView3 *nibView = [[[NSBundle mainBundle] loadNibNamed:@"VPNRegisterView3" owner:self options:nil] firstObject];
    [nibView config];
    return nibView;
}

#pragma mark - Operation
- (void) setVPNInfo:(VPNInfo *) mode
{
    [_hourlyFeeSlider setValue:[mode.connectCost floatValue] animated:YES];
    [_connectionSlider setValue:[mode.connectNum floatValue] animated:YES];
    [self updateLab];
}
- (void)config {
    _hourlyLab.adjustsFontSizeToFitWidth = YES;
    
    UIImage *img = [UIImage imageNamed:@"icon_the_selected"];
    [_hourlyFeeSlider setThumbImage:img forState:UIControlStateNormal];
    [_connectionSlider setThumbImage:img forState:UIControlStateNormal];
    
    [self layoutIfNeeded];
    [self updateLab];
}

- (void)updateLab {
    [self updateHourlyLab];
    [self updateConnectionLab];
}

- (void)updateHourlyLab {
    CGFloat thumbWidth = 20;
    CGFloat startX = _hourlyFeeSlider.left + thumbWidth/2.0;
    CGFloat endX = _hourlyFeeSlider.right - thumbWidth/2.0;
    CGFloat moveWidth = endX - startX;
    CGFloat labWidth = 50;
    CGFloat labHeight = 20;
    _hourlyLab.text = [NSString stringWithFormat:@"%.1f",_hourlyFeeSlider.value];
    CGFloat offsetX = moveWidth*((_hourlyFeeSlider.value - _hourlyFeeSlider.minimumValue)/(_hourlyFeeSlider.maximumValue - _hourlyFeeSlider.minimumValue));
    _hourlyLab.frame = CGRectMake(startX - labWidth/2.0 + offsetX, _hourlyFeeSlider.top - labHeight, labWidth, labHeight);
}

- (void)updateConnectionLab {
    CGFloat thumbWidth = 20;
    CGFloat startX = _connectionSlider.left + thumbWidth/2.0;
    CGFloat endX = _connectionSlider.right - thumbWidth/2.0;
    CGFloat moveWidth = endX - startX;
    CGFloat labWidth = 50;
    CGFloat labHeight = 20;
    _connectionLab.text = [NSString stringWithFormat:@"%.0f",_connectionSlider.value];
    CGFloat offsetX = moveWidth*((_connectionSlider.value - _connectionSlider.minimumValue)/(_connectionSlider.maximumValue - _connectionSlider.minimumValue));
    _connectionLab.frame = CGRectMake(startX - labWidth/2.0 + offsetX, _connectionSlider.top - labHeight, labWidth, labHeight);
}

#pragma mark - Action

- (IBAction)feeSubtractAction:(id)sender {
    if (_hourlyFeeSlider.value > FeeMin) {
        _hourlyFeeSlider.value -= 0.1;
        [self updateHourlyLab];
    }
}

- (IBAction)feeAddAction:(id)sender {
    if (_hourlyFeeSlider.value < FeeMax) {
        _hourlyFeeSlider.value += 0.1;
        [self updateHourlyLab];
    }
}

- (IBAction)connectSubtractAction:(id)sender {
    if (_connectionSlider.value > ConnectionMin) {
        _connectionSlider.value -= 1;
        [self updateConnectionLab];
    }
}

- (IBAction)connectAddAction:(id)sender {
    if (_connectionSlider.value < ConnectionMax) {
        _connectionSlider.value += 1;
        [self updateConnectionLab];
    }
}

- (IBAction)hourlySliderAction:(id)sender {
    [self updateHourlyLab];
}

- (IBAction)connectionSliderAction:(id)sender {
    [self updateConnectionLab];
}

- (IBAction)scheduleStartAction:(id)sender {
    
}

- (IBAction)scheduleEndAction:(id)sender {
    
}

#pragma mark - Lazy
- (NSString *)hourlyFee {
    _hourlyFee = [NSString stringWithFormat:@"%.1f",_hourlyFeeSlider.value];
    return _hourlyFee;
}

- (NSString *)connectNum {
    _connectNum = [NSString stringWithFormat:@"%.0f",_connectionSlider.value];
    return _connectNum;
}

@end
