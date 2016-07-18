//
//  ViewController.m
//  MapCompass
//
//  Created by ky on 16/7/18.
//  Copyright © 2016年 yellfun. All rights reserved.
//

#import "ViewController.h"
#import "MyView.h"

#define KScreenWidth       [UIScreen mainScreen].bounds.size.width

#define KScreenHeight      [UIScreen mainScreen].bounds.size.height


@interface ViewController ()

@property (nonatomic, retain) MyView *myView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _myView = [[MyView alloc] initWithFrame:CGRectMake(0, 0, 210, 210)];
    
    [_myView setCenter:CGPointMake(0.5 * KScreenWidth, 0.5 * KScreenHeight)];
    
    [_myView setBackgroundColor:[UIColor grayColor]];
    
    [self.view addSubview:_myView];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
