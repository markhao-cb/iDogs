//
//  AppDelegate.h
//  NBA Fun Facts
//
//  Created by Yu Qi Hao on 11/8/14.
//  Copyright (c) 2014 Yu Qi Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBAPI.h"


#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 \
green:((c>>16)&0xFF)/255.0 \
blue:((c>>8)&0xFF)/255.0 \
alpha:((c)&0xFF)/255.0]
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) DBAPI *db;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIActivityIndicatorView *activity;

- (void) showActivity:(UIView *)superview aiStyle:(UIActivityIndicatorViewStyle)style;
- (void) hideActivity;
@end

