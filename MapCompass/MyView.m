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

@end

@implementation MyView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    //
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
    
    //
    [self setBackgroundColor:[UIColor clearColor]];
    
    return self;
}

- (void)drawLowLevel {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path addArcWithCenter:CGPointMake(Width * 0.5, Height * 0.5) radius:Radius startAngle:0 endAngle:M_PI * 2 clockwise:NO];
    
    path.lineWidth = 2;
    
    CGFloat dash[] = {1,10};
    
    [path setLineDash:dash count:2 phase:0];
    
    // 设置画笔颜色
    UIColor *strokeColor = [UIColor blueColor];
    
    [strokeColor set];
    
    // 根据我们设置的各个点连线
    [path stroke];
}

- (void)drawNextLevel {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path addArcWithCenter:CGPointMake(Width * 0.5, Height * 0.5) radius:Radius startAngle:0 endAngle:M_PI * 2 clockwise:NO];
    
    path.lineWidth = 9;
    
    CGFloat length = 0.25 * M_PI * 2 * Radius;
    
    CGFloat dash[] = {4, length - 4};
    
    [path setLineDash:dash count:2 phase:0];
    
    // 设置画笔颜色
    UIColor *strokeColor = [UIColor blueColor];
    
    [strokeColor set];
    
    // 根据我们设置的各个点连线
    [path stroke];
}

- (void)drawRect:(CGRect)rect {
    
    [self drawLowLevel];

    [self drawNextLevel];
}


@end
