//
//  MyView.m
//  MapCompass
//
//  Created by ky on 16/7/18.
//  Copyright © 2016年 yellfun. All rights reserved.
//

#import "MyView.h"

#define KScreenWidth       [UIScreen mainScreen].bounds.size.width

#define KScreenHeight      [UIScreen mainScreen].bounds.size.height

#define Radius 100

#define Width 210
#define Height 210

@interface MyView()

@property (nonatomic, retain) UILabel *labSouth;
@property (nonatomic, retain) UILabel *labNorth;

@property (nonatomic, retain) UILabel *labEast;
@property (nonatomic, retain) UILabel *labWest;

@property (nonatomic, retain) UIImageView *bgImageView;

@end

@implementation MyView

- (void)addLabels {
    
    CGRect rect = CGRectMake(0, 0, 20, 20);
    
    _labSouth = [[UILabel alloc] initWithFrame:rect];
    
    [_labSouth setCenter:CGPointMake(Width * 0.5, 20)];
    
    [_labSouth setText:@"南"];
    
    [self addSubview:_labSouth];
    
    //
    _labNorth = [[UILabel alloc] initWithFrame:rect];
    
    [_labNorth setCenter:CGPointMake(Width * 0.5, Height - 20)];
    
    [_labNorth setText:@"北"];
    
    [_labNorth setTextColor:[UIColor redColor]];
    
    _labNorth.transform = CGAffineTransformRotate(_labSouth.transform, M_PI);
    
    [self addSubview:_labNorth];
    
    //
    _labEast = [[UILabel alloc] initWithFrame:rect];
    
    [_labEast setCenter:CGPointMake(20, Height * 0.5)];
    
    [_labEast setText:@"东"];
    
    [self addSubview:_labEast];
    
    //
    _labWest = [[UILabel alloc] initWithFrame:rect];
    
    [_labWest setCenter:CGPointMake(Width - 20, Height * 0.5)];
    
    [_labWest setText:@"西"];
    
    [self addSubview:_labWest];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    //
    [self addLabels];
    
    _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YF_LocationIndicator.png"]];
    
    [_bgImageView setFrame:CGRectMake(0, 0, 100, 100)];
    
    [_bgImageView setCenter:CGPointMake(Width * 0.5, Height * 0.5)];
    
    [self addSubview:_bgImageView];
    
    //
    [self setBackgroundColor:[UIColor clearColor]];
    
    return self;
}

- (void)drawLowLevel {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (_magneticHeading > 0) {
        
            [path addArcWithCenter:CGPointMake(Width * 0.5, Height * 0.5) radius:Radius startAngle:-M_PI * 0.5 + _magneticHeading endAngle:2 * M_PI - M_PI * 0.5 clockwise:YES];
    }
    else {
        
            [path addArcWithCenter:CGPointMake(Width * 0.5, Height * 0.5) radius:Radius startAngle:-M_PI * 0.5 + _magneticHeading endAngle:-M_PI * 0.5 clockwise:NO];
    }
    
    path.lineWidth = 2;
    
    CGFloat dash[] = {1,10};
    
    [path setLineDash:dash count:2 phase:1];
    
    // 设置画笔颜色
    UIColor *strokeColor = [UIColor blueColor];
    
    [strokeColor set];
    
    // 根据我们设置的各个点连线
    [path stroke];
}

- (void)drawNextLevel {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path addArcWithCenter:CGPointMake(Width * 0.5, Height * 0.5) radius:Radius startAngle:-M_PI * 0.5 endAngle:2 * M_PI - M_PI * 0.5 clockwise:YES];
    
    path.lineWidth = 9;
    
    CGFloat length = 0.25 * M_PI * 2 * Radius;
    
    CGFloat dash[] = {4, length - 4};
    
    [path setLineDash:dash count:2 phase:2];
    
    // 设置画笔颜色
    UIColor *strokeColor = [UIColor blueColor];
    
    [strokeColor set];
    
    // 根据我们设置的各个点连线
    [path stroke];
}

- (void)drawRect:(CGRect)rect {
    
    [self drawLowLevel];

    [self drawNextLevel];
    
    [self drawArc];
    
    [self drawWestPoint];
}

- (void)drawWestPoint {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path addArcWithCenter:CGPointMake(Width * 0.5, 6) radius:6 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    
    UIColor *color = [UIColor blueColor];
    
    [color set];
    
    [path fill];
}

- (void)setMagneticHeading:(CGFloat)magneticHeading {
    
    _magneticHeading = magneticHeading;
    
    _bgImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, _magneticHeading);
    
    [self setNeedsDisplay];
}

- (UIColor*)retriveArcColor {
    
    if (ABS(_magneticHeading) > M_PI_4) {
        
        return [UIColor colorWithRed:0xf5/255.0 green:0x29/255.0 blue:0x01/255.0 alpha:1];;
    }
    
    if (ABS(_magneticHeading) > M_PI * 35.0/180.0) {
        
        return [UIColor colorWithRed:0xff/255.0 green:0x90/255.0 blue:0x37/255.0 alpha:1];
    }
    
    return [UIColor colorWithRed:0x02/255.0 green:0xec/255.0 blue:0x23/255.0 alpha:1];
}

- (void)drawArc {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (_magneticHeading > 0) {
        
        [path addArcWithCenter:CGPointMake(Width * 0.5, Height * 0.5) radius:Radius startAngle:-M_PI * 0.5 + _magneticHeading endAngle:-M_PI * 0.5 clockwise:NO];
    }
    else {
        
        [path addArcWithCenter:CGPointMake(Width * 0.5, Height * 0.5) radius:Radius startAngle:-M_PI * 0.5 + _magneticHeading endAngle:-M_PI * 0.5 clockwise:YES];
    }
    
    path.lineWidth = 10;
    
    // 设置画笔颜色
    UIColor *strokeColor = [self retriveArcColor];
    
    [strokeColor set];
    
    // 根据我们设置的各个点连线
    [path stroke];
}


@end
