//
//  DefiLineView.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/15.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DefiLineView.h"
#import "GlobalConstants.h"

@implementation DefiLineView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (!_inputArr || _inputArr.count == 0) {
        return;
    }
    
    CGFloat totalPointCount = self.bounds.size.width;
    CGFloat inputPointCount = _inputArr.count;
    CGFloat divideLength = totalPointCount/inputPointCount;
    
    double maxVal = [[_inputArr valueForKeyPath:@"@max.doubleValue"] doubleValue];
    double minVal = [[_inputArr valueForKeyPath:@"@min.doubleValue"] doubleValue];
    double lengthVal = maxVal-minVal;

    NSMutableArray *muArr = [NSMutableArray array];
    CGFloat height = self.bounds.size.height-2;
    [_inputArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        double valD = height-height/lengthVal*([obj doubleValue]-minVal);
        NSValue *val = [NSValue valueWithCGPoint:CGPointMake(idx*divideLength, valD)];
        [muArr addObject:val];
    }];
    
    NSString *firstInput = _inputArr.firstObject;
    NSString *lastInput = _inputArr.lastObject;
    UIColor *lineColor = [firstInput doubleValue] > [lastInput doubleValue]?UIColorFromRGB(0xFF3669):UIColorFromRGB(0x7ED321);
    
    [self smoothedPathWithPoints:muArr andGranularity:6 lineColor:lineColor];
}

#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]
- (void)smoothedPathWithPoints:(NSArray *) pointsArray andGranularity:(NSInteger)granularity lineColor:(UIColor *)lineColor {
    
    NSMutableArray *points = [pointsArray mutableCopy];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    UIBezierPath *smoothedPath = [UIBezierPath bezierPath];
    
//    [smoothedPath moveToPoint:POINT(0)];
//    for (NSUInteger index = 1; index < points.count; index++) {
//        [smoothedPath addLineToPoint:POINT(index)];
//    }
    
    // Add control points to make the math make sense
    [points insertObject:[points objectAtIndex:0] atIndex:0];
    [points addObject:[points lastObject]];
    [smoothedPath moveToPoint:POINT(0)];

    for (NSUInteger index = 1; index < points.count - 2; index++) {
        CGPoint p0 = POINT(index - 1);
        CGPoint p1 = POINT(index);
        CGPoint p2 = POINT(index + 1);
        CGPoint p3 = POINT(index + 2);

        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < granularity; i++) {

            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;

            CGPoint pi; // intermediate point
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            [smoothedPath addLineToPoint:pi];
        }

        // Now add p2
        [smoothedPath addLineToPoint:p2];
    }

    // finish by adding the last point
    [smoothedPath addLineToPoint:POINT(points.count - 1)];
    
    CGContextAddPath(context, smoothedPath.CGPath);
    CGContextDrawPath(context, kCGPathStroke);
}

@end
