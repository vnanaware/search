//
//  AppDelegate.h
//  PCrew
//
//  Created by Bhimashankar Vibhute on 06/01/17.
//  Copyright © 2017 Syneotek Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

#pragma mark- Activitity Indicator Properties
@property (nonatomic)UIView *viewForSpinner,*viewForSilentAlert;
@property (nonatomic)UIActivityIndicatorView *activityIndicator;
@property (nonatomic)NSTimer *timerForSpinnerInterval;
@property(nonatomic)NSInteger intCounterValue;


#pragma mark: Methods Declarations Here
-(void)showSpinnerInView:(UIView*)view;
-(void)stopSpinner;

@property (strong, nonatomic) UIWindow *window;
@end

