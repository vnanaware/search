
//
//  AppDelegate.h
//  Snapbets
//
//  Created by Bhimashankar Vibhute on 06/09/16.
//  Copyright © 2016 Syneotek Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Reachability.h"
#import "HeaderAndConstants.h"
#import "DBManager.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property(nonatomic)Reachability *reachbility;
@property (nonatomic)DBManager *objDBManager;

#pragma mark: BOOL Properties declarations here
@property(nonatomic)BOOL isConnected;


#pragma mark- Activitity Indicator Properties
@property (nonatomic)UIView *viewForSpinner,*viewForSilentAlert;
@property (nonatomic)UIActivityIndicatorView *activityIndicator;
@property (nonatomic)NSTimer *timerForSpinnerInterval;
@property(nonatomic)NSInteger intCounterValue;

#pragma mark: Methods Declarations Here
-(void)showSpinnerInView:(UIView*)view;
-(void)stopSpinner;
@end

