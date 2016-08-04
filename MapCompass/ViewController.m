//
//  ViewController.m
//  MapCompass
//
//  Created by ky on 16/7/18.
//  Copyright © 2016年 yellfun. All rights reserved.
//

#import "ViewController.h"
#import "IDRMapAnchor.h"
#import "IDRBaseLocationServer.h"
#import <CoreLocation/CoreLocation.h>
#import "MyView.h"

#define KScreenWidth       [UIScreen mainScreen].bounds.size.width

#define KScreenHeight      [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<IDRBaseLocationServerDelegate>

//@property (nonatomic, retain) IDRMapAnchor *myView;

@property (nonatomic, retain) MyView *myView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    MyView *view = [[MyView alloc] initWithFrame:CGRectMake(100, 100, 300, 300)];
    
    [self.view addSubview:view];
    
//    _myView = [[IDRMapAnchor alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    
//    [_myView setCenter:CGPointMake(0.5 * KScreenWidth, 0.5 * KScreenHeight)];
//    
//    [_myView setNorthAngle:0.001];
//    
//    [self.view addSubview:_myView];
//    
//    [[IDRBaseLocationServer sharedInstance] setDelegate:self];
//    
//    [[IDRBaseLocationServer sharedInstance] startUpdateHeading];
//    
//    CGPoint p = CGPointMake(1, -1);
//    
//    CGFloat value = [self retriveNorthAngle:p];
//    
//    value = value * 180/M_PI;
//    
//    NSLog(@"%.2f", value);
}

- (void)didGetRangeBeacons:(NSArray*)beacons {
    
    
}

//- (void)didGetDeviceHeading:(CLHeading*)heading {
//    
//    CGFloat value = heading.magneticHeading * M_PI/180.0;
//    
//    NSLog(@"%.2f", value);
//    
//    if (value > M_PI) {
//        
//        value = value - 2 * M_PI;
//    }
//    
//    [_myView setNorthAngle:value];
//}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
