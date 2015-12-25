//
//  AppDelegate.m
//  NBA Fun Facts
//
//  Created by Yu Qi Hao on 11/8/14.
//  Copyright (c) 2014 Yu Qi Hao. All rights reserved.
//

#import "AppDelegate.h"
#import "OnboardingViewController.h"
#import "OnboardingContentViewController.h"

static NSString * const kUserHasOnboardedKey = @"user_has_onboarded";
@interface AppDelegate ()

@end

#define ACTIVITY_WIDTH 40

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
   
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                            [UIColor blackColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:19], NSFontAttributeName, nil]];
    [UIBarButtonItem appearance];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    BOOL userHasOnboarded = [[NSUserDefaults standardUserDefaults] boolForKey:kUserHasOnboardedKey];
    
    if (userHasOnboarded) {
        [self setupNormalRootViewControllerAnimated:NO];
    }
    else {
        self.window.rootViewController = [self generateFirstDemoVC];
    }
        _db = [[DBAPI alloc] init];
    return YES;
}

- (void)setupNormalRootViewControllerAnimated:(BOOL)animated {
    // create whatever your root view controller is going to be, in this case just a simple view controller
    // wrapped in a navigation controller
    UITabBarController *mainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"main"];
   
    
    
    // if we want to animate the transition, do it
    //if (animated) {
        [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.window.rootViewController = mainVC;        } completion:nil];
    //}
    
    // otherwise just set the root view controller normally without animation
//    else {
//        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:mainVC];
//    }
}

- (OnboardingViewController *)generateFirstDemoVC {
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"A dog is the only thing on the earth" body:@"that loves you more than he loves himself." image:[UIImage imageNamed:@""] buttonText:@"- Josh Billings" action:nil];
    
    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"One of the most enduring friendships in history - " body:@"dogs and their people, people and their dogs." image:[UIImage imageNamed:@"red"] buttonText:@"- Terry Kay" action:nil];
    secondPage.movesToNextViewController = YES;
    
    
    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"Life is better with a dog" body:@"and iDogs..." image:[UIImage imageNamed:@"yellow"] buttonText:@"Get Started" action:^{
        [self handleOnboardingCompletion];
    }];
    
    OnboardingViewController *onboardingVC = [OnboardingViewController onboardWithBackgroundImage:[UIImage imageNamed:@"dogbg"] contents:@[firstPage, secondPage, thirdPage]];
    onboardingVC.shouldFadeTransitions = YES;
    onboardingVC.fadePageControlOnLastPage = YES;
    
    // If you want to allow skipping the onboarding process, enable skipping and set a block to be executed
    // when the user hits the skip button.
    onboardingVC.allowSkipping = YES;
    onboardingVC.skipHandler = ^{
        [self handleOnboardingCompletion];
    };
    
    return onboardingVC;
}

- (void)handleOnboardingCompletion {
    // set that we have completed onboarding so we only do it once... for demo
    // purposes we don't want to have to set this every time so I'll just leave
    // this here...
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserHasOnboardedKey];
    
    // animate the transition to the main application
    [self setupNormalRootViewControllerAnimated:YES];
}


- (void) showActivity:(UIView *)superview aiStyle:(UIActivityIndicatorViewStyle)style
{
    if (_bgView != nil) return;
    CGRect appRect = superview.bounds;
    _bgView = [[UILabel alloc] initWithFrame:CGRectMake(appRect.size.width/2-ACTIVITY_WIDTH/2, appRect.size.height/3+10, ACTIVITY_WIDTH, ACTIVITY_WIDTH)];
    _bgView.backgroundColor = HEXCOLOR(0x669AF6FF);//[UIColor darkGrayColor];
    _bgView.layer.cornerRadius = 10.0;
    _bgView.layer.masksToBounds = YES;
    [superview addSubview:_bgView];
    
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(ACTIVITY_WIDTH/4, ACTIVITY_WIDTH/4, ACTIVITY_WIDTH/2, ACTIVITY_WIDTH/2)];
    _activity = ai;
    _activity.activityIndicatorViewStyle = style;
    _activity.hidesWhenStopped = YES;
    _activity.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                  UIViewAutoresizingFlexibleRightMargin |
                                  UIViewAutoresizingFlexibleTopMargin |
                                  UIViewAutoresizingFlexibleBottomMargin);
    [_activity startAnimating];
    [_bgView addSubview:_activity];
}

- (void) hideActivity
{
    if (_bgView == nil) return;
    [_activity stopAnimating];
    [_activity removeFromSuperview];
    [_bgView removeFromSuperview];
    _bgView = nil;
    _activity = nil;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
