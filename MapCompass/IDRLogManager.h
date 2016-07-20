//
//  StoreMgr.h
//  Lottery
//
//  Created by user on 16/2/16.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDRLogManager : NSObject

@property (nonatomic, assign) BOOL stopSave;

+ (IDRLogManager*)sharedInstance;

- (void)log1:(NSString*)text;

- (void)log2:(NSString*)text;

- (void)clear;

- (void)flush;

- (void)clearLog2;

@end
