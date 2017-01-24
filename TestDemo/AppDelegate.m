//
//  AppDelegate.m
//  Snapbets
//
//  Created by Bhimashankar Vibhute on 06/09/16.
//  Copyright © 2016 Syneotek Software Solution. All rights reserved.
//https://we.tl/XmQayqSNyc

#import "AppDelegate.h"

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%f",screenWidth);
    NSLog(@"%f",screenHeight);
    
    NetworkStatus remoteHostStatus = [_reachbility currentReachabilityStatus];
    
    if(remoteHostStatus==NotReachable)
    { NSLog(@"not Connected");
        _isConnected=NO;
    }
    else    {
        NSLog(@"Connected");
        _isConnected=YES;
    }
      return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark: Network Changed checking function
-(void)networkChanged:(NSNotification *)notification
{
    NetworkStatus remoteHostStatus=[_reachbility currentReachabilityStatus];
    if (remoteHostStatus==NotReachable)
    {
        NSLog(@"Not Connected");
        _isConnected=NO;
    }
    
    else
    {
        NSLog(@"Connected");
        _isConnected=YES;
    }
}


#pragma mark- Activity Indicator Methods
-(void)showSpinnerInView:(UIView*)view
{
    [_viewForSpinner removeFromSuperview];
    _viewForSpinner=[[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-35, screenHeight/2-30, 70, 70)];
    _viewForSpinner.layer.cornerRadius=35.0;
    _viewForSpinner.layer.borderWidth=2;
    _viewForSpinner.layer.masksToBounds=YES;
    _viewForSpinner.layer.borderColor=[UIColor whiteColor].CGColor;
    _viewForSpinner.backgroundColor=[UIColor blackColor];
    
    [view addSubview:_viewForSpinner];
    
    _activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.frame=CGRectMake(_viewForSpinner.frame.size.width/2-15,_viewForSpinner.frame.size.height/2-15, 30, 30);
    [_viewForSpinner addSubview:_activityIndicator];
    
    [_activityIndicator startAnimating];
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
}

#pragma mark: Stop Spinner
-(void)stopSpinner
{
    [_viewForSpinner removeFromSuperview];
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
}
-(void)showSilentAlertWithTitle:(NSString*)title description:(NSString*)description inView:(UIView*)inView
{
    [_viewForSilentAlert removeFromSuperview];
    _viewForSilentAlert=[[UIView alloc]initWithFrame:CGRectMake(10,screenHeight/2-75, screenWidth-20, 150)];
}

#pragma mark: show Spinner in view
-(void)showSpinnerInView:(UIView*)view withMsg:(NSString*)msg
{
    [_viewForSpinner removeFromSuperview];
    _viewForSpinner=[[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-100, screenHeight/2-100,200,150)];
    _viewForSpinner.layer.cornerRadius=35.0;
    _viewForSpinner.layer.borderWidth=2;
    _viewForSpinner.layer.masksToBounds=YES;
    _viewForSpinner.layer.borderColor=[UIColor blackColor].CGColor;
    _viewForSpinner.backgroundColor=[UIColor orangeColor];
    [view addSubview:_viewForSpinner];
    
    _activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicator.frame=CGRectMake(_viewForSpinner.frame.size.width/2-15,20, 30, 30);
    [_viewForSpinner addSubview:_activityIndicator];
    UITextView *lblMsg=[[UITextView alloc]initWithFrame:CGRectMake(10,60,_viewForSpinner.frame.size.width-20,80)];
    lblMsg.textAlignment=NSTextAlignmentCenter;
    lblMsg.textColor=[UIColor colorWithRed:125.0/255.0 green:177.0/255.0 blue:97.0/255.0 alpha:1];
    lblMsg.text=msg;
    lblMsg.backgroundColor=[UIColor whiteColor];
    lblMsg.font=[UIFont fontWithName:@"Avenir-Light" size:15];
    lblMsg.editable=NO;
    lblMsg.selectable=NO;
    [_viewForSpinner addSubview:lblMsg];
    
    [_activityIndicator startAnimating];
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    
    _timerForSpinnerInterval=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(stopSpinnerAfterWaiting:) userInfo:nil repeats:YES];
    _intCounterValue=0;
}

-(void)stopSpinnerAfterWaiting:(NSTimer*)timer
{
    if (_intCounterValue>=20)
    {
        [self stopSpinner];
        [_timerForSpinnerInterval invalidate];
        _timerForSpinnerInterval=nil;
        _intCounterValue=0;
    }
    _intCounterValue++;
    // NSLog(@"Counter :%ld ",_intCounterValue);
}

#pragma mark create all table's
-(void)createAllTablesIfNotExist
{
    //--------------------------DataBase handling Coding-------------------//
    _objDBManager=[DBManager getSharedInstance];
    NSString *sql_stmt;
    
    sql_stmt=@"create table if not exists tblUser(UID TEXT primary key,EMAIL text,FNAME text,LNAME text,CONTACT text,IMAGE text,DID text,ISFBLOGIN text)";
    
    if (![_objDBManager createTableWithQuery:sql_stmt])
    {
        //  NSLog(@"error while creating table User");
    }
}
@end
