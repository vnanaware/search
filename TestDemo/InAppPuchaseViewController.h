//
//  InAppPuchaseViewController.h
//  Image Fun
//
//  Created by Santosh Bayas on 7/2/12.
//  Copyright 2012 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"



@interface InAppPuchaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource >
{
	
	UITableView *inAppTableView;
	
	NSMutableArray *inAppArray;
	
	AppDelegate *appDelegate;

	MBProgressHUD *_hud;
        
     //  GADBannerViewDelegate *addview1;
}

@property (nonatomic, retain) UITableView *inAppTableView;

@property (nonatomic, retain) NSMutableArray *inAppArray;

@property (retain) MBProgressHUD *hud;


- (void)productsLoaded:(NSNotification *)notification;

- (void)productPurchased:(NSNotification *)notification;

- (void)productPurchaseFailed:(NSNotification *)notification;


-(BOOL)writeToFile:(NSString *)fileName andProductString:(NSString *)productName;

@end
