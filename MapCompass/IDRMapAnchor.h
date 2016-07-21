//
//  MyView.h
//  MapCompass
//
//  Created by ky on 16/7/18.
//  Copyright © 2016年 yellfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDRMapAnchor : UIView

@property (nonatomic, assign) CGFloat middleAngle;

@property (nonatomic, assign) CGFloat northAngle;

@property (nonatomic, assign, getter = isShowCompass) BOOL showCompass;

@end
