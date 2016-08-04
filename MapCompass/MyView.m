//
//  MyView.m
//  MapCompass
//
//  Created by ky on 16/7/22.
//  Copyright © 2016年 yellfun. All rights reserved.
//

#import "MyView.h"

@interface MyView()

@property (nonatomic, assign) CGPoint start;
@property (nonatomic, assign) CGPoint end;

@end

@implementation MyView

CGPoint pointAddPoint(CGPoint a, CGPoint b) {
    
    return CGPointMake(a.x + b.x, a.y + b.y);
}

CGPoint pointMinusPoint(CGPoint a, CGPoint b) {
    
    return CGPointMake(a.x - b.x, a.y - b.y);
}

CGPoint operator+(const CGPoint& lhs, const CGPoint& rhs) {
    
    return pointAddPoint(lhs, rhs);
}

CGPoint operator-(const CGPoint& lhs, const CGPoint& rhs) {
    
    return pointMinusPoint(lhs, rhs);
}

CGPoint operator*(const CGPoint& lhs, CGFloat scale) {
    
    return CGPointMake(lhs.x * scale, lhs.y * scale);
}

CGPoint operator*(const CGPoint& lhs, const CGAffineTransform& tm) {
    
    return CGPointApplyAffineTransform(lhs, tm);
}

CGFloat lengthOfPoint(const CGPoint& parm) {
    
    return sqrt(parm.x * parm.x + parm.y * parm.y);
}

CGPoint normalOfPoint(const CGPoint& p) {
    
    CGFloat length = lengthOfPoint(p);
    
    return p * (1/length);
}

CGFloat retriveNorthAngle(CGPoint p) {
    
    if (p.y == 0) {
        
        if (p.x > 0) {
            
            return M_PI_2 * -1;
        }
        
        return M_PI_2;
    }
    
    CGPoint normal = normalOfPoint(p);
    
    CGFloat yAxisOffset = acos(normal.y * -1);
    
    if (normal.x > 0) {
        
        yAxisOffset = -1 * yAxisOffset;
    }
    
    return yAxisOffset;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [self drawLine];
    
    [self drawStartPos];
    
    [self drawArrow];
}

- (void)drawLine {
    
    UIColor *color = [UIColor redColor];
    
    [color set];
    
    _start = CGPointMake(100, 100);
    
    _end = CGPointMake(200, 200);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    bezierPath.lineWidth = 2;
    
    [bezierPath moveToPoint:_start];
    
    [bezierPath addLineToPoint:_end];
    
    [bezierPath closePath];
    
    // 根据我们设置的各个点连线
    [bezierPath stroke];
}

- (void)drawArrow {
    
    UIColor *color = [UIColor greenColor];
    
    [color set];
    
    CGPoint p = _end - _start;
    
    CGPoint A = _start + p * 0.5;
    
    CGPoint M = _start + CGPointMake(-p.y, p.x) * 0.2;
    
    CGPoint B = A + (M - A) * 0.1;
    
    CGPoint N = _start + CGPointMake(p.y, -p.x) * 0.2;
    
    CGPoint C = A + (N - A) * 0.1;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    bezierPath.lineWidth = 5;
    
    [bezierPath moveToPoint:A];
    
    [bezierPath addLineToPoint:B];
    
    [bezierPath addLineToPoint:C];
    
    [bezierPath addLineToPoint:A];
    
    [bezierPath closePath];
    
    [bezierPath stroke];
    
    [bezierPath fill];
}

- (void)drawStartPos {
    
    UIColor * color = [UIColor greenColor];
    
    CGPoint p = CGPointMake(100, 100);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillEllipseInRect(context, CGRectMake(p.x-2, p.y-2, 4, 4));
    
    CGContextRestoreGState(context);
}

@end
