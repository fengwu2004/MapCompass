//
//  IDRMapAnchor.m
//  IndoorunMap_Core
//
//  Created by ky on 16/7/19.
//  Copyright © 2016年 yellfun. All rights reserved.
//

#import "IDRMapAnchor.h"

#define FONT_WIDTH 19

#define FONT 10

#define FONT_SIZE 10

@interface IDRMapAnchor ()

@property (nonatomic, retain) UILabel *labSouth;
@property (nonatomic, retain) UILabel *labNorth;

@property (nonatomic, retain) UILabel *labEast;
@property (nonatomic, retain) UILabel *labWest;

@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, retain) UIImageView * bgBlueView;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) BOOL isAnimating;


@end

@implementation IDRMapAnchor

- (void)addLabels {
    
    CGRect rect = CGRectMake(0, 0, FONT, FONT);
    
    _labSouth = [[UILabel alloc] initWithFrame:rect];
    
    [_labSouth setCenter:CGPointMake(_width * 0.5, _height - FONT_WIDTH)];
    
    [_labSouth setText:@"南"];
    
    _labSouth.transform = CGAffineTransformRotate(_labSouth.transform, M_PI);
    
    [_labSouth setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    
    [self addSubview:_labSouth];
    
    //
    _labNorth = [[UILabel alloc] initWithFrame:rect];
    
    [_labNorth setCenter:CGPointMake(_width * 0.5, FONT_WIDTH)];
    
    [_labNorth setText:@"北"];
    
    [_labNorth setTextColor:[UIColor redColor]];
    
    [_labNorth setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    
    [self addSubview:_labNorth];
    
    //
    _labEast = [[UILabel alloc] initWithFrame:rect];
    
    [_labEast setCenter:CGPointMake(_width - FONT_WIDTH, _height * 0.5)];
    
    [_labEast setText:@"东"];
    
    [_labEast setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    
    _labEast.transform = CGAffineTransformRotate(_labSouth.transform, 0.5 * M_PI);
    
    [self addSubview:_labEast];
    
    //
    _labWest = [[UILabel alloc] initWithFrame:rect];
    
    [_labWest setCenter:CGPointMake(FONT_WIDTH, _height * 0.5)];
    
    [_labWest setText:@"西"];
    
    [_labWest setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    
    _labWest.transform = CGAffineTransformRotate(_labSouth.transform, -0.5 * M_PI);
    
    [self addSubview:_labWest];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    _showCompass = YES;
    
    _width = frame.size.width;
    
    _height = frame.size.height;
    
    _radius = 0.9 * _width * 0.5;
    
    //
    [self addLabels];
    
    _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YF_LocationIndicator.png"]];
    
    [_bgImageView setFrame:frame];
    
    [_bgImageView setCenter:CGPointMake(_width * 0.5, _height * 0.5)];
    
    [self addSubview:_bgImageView];
    
    //
    _bgBlueView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    [_bgBlueView setBackgroundColor:[UIColor colorWithRed:0 green:135.0/255.0 blue:1 alpha:0.5]];
    
    [_bgBlueView.layer setCornerRadius:_bgBlueView.frame.size.width/2];
    
    _bgBlueView.alpha = 0;
    
    [self addSubview:_bgBlueView];
    
    //
    [self setBackgroundColor:[UIColor clearColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationAnimationZoomIn) name:@"zoomIn" object:nil];
    
    return self;
}

- (void)locationAnimationZoomIn
{
    if (_isAnimating) {
        
        return;
    }
    
    _isAnimating = YES;
    
    [UIView animateWithDuration:1.0 animations:^{
        
        _bgBlueView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        
        _bgBlueView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        _isAnimating = NO;
        
        _bgBlueView.transform = CGAffineTransformMakeScale(0, 0);
        
        _bgBlueView.alpha = 1;
    }];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"zoomIn" object:nil];
}

- (void)drawLowLevel {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (_northAngle > 0) {
        
        [path addArcWithCenter:CGPointMake(_width * 0.5, _height * 0.5) radius:_radius startAngle:-M_PI * 0.5 + _northAngle endAngle:2 * M_PI - M_PI * 0.5 clockwise:YES];
    }
    else {
        
        [path addArcWithCenter:CGPointMake(_width * 0.5, _height * 0.5) radius:_radius startAngle:-M_PI * 0.5 + _northAngle endAngle:2 * M_PI - M_PI * 0.5 clockwise:NO];
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
    
    [path addArcWithCenter:CGPointMake(_width * 0.5, _height * 0.5) radius:_radius startAngle:-M_PI * 0.5 endAngle:2 * M_PI - M_PI * 0.5 clockwise:YES];
    
    path.lineWidth = 9;
    
    CGFloat length = 0.25 * M_PI * 2 * _radius;
    
    CGFloat dash[] = {4, length - 4};
    
    [path setLineDash:dash count:2 phase:2];
    
    // 设置画笔颜色
    UIColor *strokeColor = [UIColor blueColor];
    
    [strokeColor set];
    
    // 根据我们设置的各个点连线
    [path stroke];
}

- (void)setShowCompass:(BOOL)showCompass {
    
    _showCompass = showCompass;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    if (_showCompass) {
        
        [self drawLowLevel];
        
        [self drawNextLevel];
        
        [self drawArc];
        
        [self drawMiddlePoint];
    }
    
    [_labEast setHidden:!_showCompass];
    
    [_labSouth setHidden:!_showCompass];
    
    [_labNorth setHidden:!_showCompass];
    
    [_labWest setHidden:!_showCompass];
}

- (void)drawMiddlePoint {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path addArcWithCenter:CGPointMake(_width * 0.5, 6) radius:6 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    
    UIColor *color = [UIColor colorWithRed:0 green:135.0/255.0 blue:1 alpha:1];
    
    [color set];
    
    [path fill];
}

- (void)setNorthAngle:(CGFloat)northAngle {
    
    if (northAngle > M_PI) {
        
        northAngle = northAngle - 2 * M_PI;
    }
    
    _northAngle = northAngle;
    
    _bgImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, _northAngle);
    
    [self setNeedsDisplay];
}

- (UIColor*)retriveArcColor {
    
    if (ABS(_northAngle) > M_PI_4) {
        
        return [UIColor colorWithRed:0xf5/255.0 green:0x29/255.0 blue:0x01/255.0 alpha:1];;
    }
    
    if (ABS(_northAngle) > M_PI * 35.0/180.0) {
        
        return [UIColor colorWithRed:0xff/255.0 green:0x90/255.0 blue:0x37/255.0 alpha:1];
    }
    
    return [UIColor colorWithRed:0x02/255.0 green:0xec/255.0 blue:0x23/255.0 alpha:1];
}

- (void)drawArc {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (_northAngle > 0) {
        
        [path addArcWithCenter:CGPointMake(_width * 0.5, _height * 0.5) radius:_radius startAngle:-M_PI * 0.5 + _northAngle endAngle:-M_PI * 0.5 clockwise:NO];
    }
    else {
        
        [path addArcWithCenter:CGPointMake(_width * 0.5, _height * 0.5) radius:_radius startAngle:-M_PI * 0.5 + _northAngle endAngle:-M_PI * 0.5 clockwise:YES];
    }
    
    path.lineWidth = 5;
    
    // 设置画笔颜色
    UIColor *strokeColor = [self retriveArcColor];
    
    [strokeColor set];
    
    // 根据我们设置的各个点连线
    [path stroke];
}

@end
