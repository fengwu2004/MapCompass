//
//  YFBeaconManager.m
//  YFMapKit
//
//  Created by Sincere on 16/1/20.
//  Copyright © 2016年 Sincere. All rights reserved.
//

#import "IDRBaseLocationServer.h"
#import "IDRLogManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@interface IDRBaseLocationServer ()<CLLocationManagerDelegate>

@property (nonatomic, retain) NSArray *uuidStrings;

@property (nonatomic, retain) NSMutableArray<CLBeaconRegion *> *beaconRegions;

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, assign) BOOL isReceiveBeacons;

@end

@implementation IDRBaseLocationServer

+ (instancetype)sharedInstance {
    
    static IDRBaseLocationServer *_instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _instance = [[IDRBaseLocationServer alloc] init];
    });
    
    return _instance;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        _locationManager = [[CLLocationManager alloc] init];
        
        [_locationManager setDelegate:self];
        
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    
    return self;
}

- (void)setBeaconUUID:(NSArray*)uuidStrings {
    
    [self stopUpdateBeacons];
    
    self.uuidStrings = uuidStrings;
    
    _beaconRegions = [[NSMutableArray alloc] init];
    
    [self configureManagers];
}

#pragma mark - 开启服务配置

-(void)configureManagers {
    
    for (NSString *uuidString in _uuidStrings) {
        
        NSUUID * uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
        
        CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
        
        if (!beaconRegion) {
            
            continue;
        }
        
        [_beaconRegions addObject:beaconRegion];
    }
}

#pragma mark - 开始获取蓝牙信息

- (void)startUpdateBeacons {
    
    for (CLBeaconRegion *beaconRegion in _beaconRegions) {
        
        [_locationManager startRangingBeaconsInRegion:beaconRegion];
    }
}

- (void)startUpdateHeading {
    
    [_locationManager startUpdatingHeading];
}

#pragma mark - 停止获取蓝牙信息
- (void)stopUpdateBeacons {
    
    for (CLBeaconRegion *beaconRegion in _beaconRegions) {
        
        [_locationManager stopRangingBeaconsInRegion:beaconRegion];
    }
}

- (void)stopUpdateHeading {
    
    [_locationManager stopUpdatingHeading];
}

#pragma mark - 蓝牙定位实时回调
-(void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region {
    
    if (!_isReceiveBeacons) {
        
        _isReceiveBeacons = YES;
    }
    
    [self.delegate didGetRangeBeacons:[[self class]getBeaconsJSON:beacons]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    if ([self.delegate respondsToSelector:@selector(didGetDeviceHeading:)]) {
        
        [self.delegate didGetDeviceHeading:newHeading];
    }
}

#pragma mark - 定位权限变化判断
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied: {
            
            NSLog(@"定位服务未开启");
            
            _isLocationAvailable = NO;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationOff" object:nil];
        }
            break;
        default:
        {
            NSLog(@"定位服务开启");
            
            _isLocationAvailable = YES;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationOn" object:nil];
        }
            break;
    }
}

+ (NSArray*)getBeaconsJSON:(NSArray *)beacons
{
    @synchronized(beacons)
    {
        NSMutableArray * aBeacons = [NSMutableArray array];
        
        NSArray * temp = [beacons copy];
        
        for (CLBeacon * beacon in temp)
        {
            [aBeacons addObject:[[self class] createBeaconsDict:beacon]];
        }
        
        return aBeacons;
    }
}

//处理解析蓝牙数据
+ (NSDictionary*)createBeaconsDict:(CLBeacon*)beacon
{
    NSString * major = [NSString stringWithFormat:@"%d",[beacon.major  intValue]];
    
    NSString * minor = [NSString stringWithFormat:@"%d",[beacon.minor intValue]];
    
    NSString * rss = [NSString stringWithFormat:@"%ld",(long)beacon.rssi];
    
    NSString * distance = [NSString stringWithFormat:@"%.2f",(float)beacon.accuracy];
    
    NSString * mac = [NSString stringWithFormat:@"major:%@minor:%@",major,minor];
    
//    [[IDRLogManager sharedInstance] log1:[NSString stringWithFormat:@"%@,%@\n", rss, distance]];
    
    if (!mac || !rss) {
        
        NSLog(@"error");
    }
    
    NSDictionary * beaconDict = [[NSDictionary alloc] initWithObjects:@[mac,rss,distance] forKeys:@[@"mac",@"rss",@"distance"]];
    
    if (!beaconDict) {
        
        return nil;
    }
    
    return beaconDict;
}

@end
