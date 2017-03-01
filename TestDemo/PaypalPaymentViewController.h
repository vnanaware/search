//
//  PaypalPaymentViewController.h
//  My_Lib
//
//  Created by syneotek on 27/04/15.
//  Copyright (c) 2015 syneotek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
//#import "AccountSelectionViewController.h"

#import "AKPayPal.h"
#import "Cart_Model.h"


@interface PaypalPaymentViewController : UIViewController<akPayPalDelegate, UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    NSIndexPath *selectedIndex;
}


- (IBAction)btnPayPalPressed:(id)sender;
//- (IBAction)btnCartPressed:(id)sender;

#pragma mark- UIView
@property(nonatomic) UIView *uiViewForProfile;
@property(nonatomic) UIView *uiViewProfileDescription;
@property(nonatomic) UITableView *tblTableView;


#pragma mark- UIImageView
@property(nonatomic) UIImageView *imgLogo;
@property(nonatomic) UIImageView *imgPayPalLogo;


#pragma mark- UIButton
@property(nonatomic) UIButton *btnBack;
@property(nonatomic) UIButton *btnSearch;

@property(nonatomic) UIButton *btn10Credits;
@property(nonatomic) UIButton *btnPackage2;
@property(nonatomic) UIButton *btnPackage3;
@property(nonatomic) UIButton *btnPackage4;
@property(nonatomic) UIButton *btnPackage5;

@property(nonatomic) UIButton *btnContinue;




#pragma mark- UILabel
@property(nonatomic) UILabel *lblSettings;
@property(nonatomic) UILabel *lbl10Credits;
@property(nonatomic) UILabel *lblPackage2;
@property(nonatomic) UILabel *lblPackage3;
@property(nonatomic) UILabel *lblPackage4;
@property(nonatomic) UILabel *lblPackage5;


@property(nonatomic) UILabel *lblUGX1000;
@property(nonatomic) UILabel *lblUGXxxxxPackTwo;
@property(nonatomic) UILabel *lblUGXxxxxPackThree;
@property(nonatomic) UILabel *lblUGXxxxxPackFour;
@property(nonatomic) UILabel *lblUGXxxxxPackFive;


#pragma  mark- UIactivityIndicator
@property(nonatomic) UIActivityIndicatorView *activityIndicator;
#pragma mark- UiView For Activity Loader
@property(nonatomic) UIView *uiViewforActivityIndicator;

#pragma mark- JSON Connection Variables
@property(nonatomic) NSMutableData *data;
@property(nonatomic) NSMutableDictionary *dataDictonary;

@property(nonatomic) NSMutableArray *arrayOfButtons;

@end
