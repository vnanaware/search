//
//  SpecificThemePackgScreen.m
//  Snapbets
//
//  Created by Bhimashankar Vibhute on 10/09/16.
//  Copyright © 2016 Syneotek Software Solution. All rights reserved.
//

#import "SpecificThemePackgScreen.h"

@interface SpecificThemePackgScreen ()

@end

@implementation SpecificThemePackgScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
        
        if ([InAppRageIAPHelper sharedHelper].products == nil) {
            
            [[InAppRageIAPHelper sharedHelper] requestProducts];
            hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.labelText =@"Loading";
            [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
        }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)btnBuySinglePressed:(id)sender
{
   
}

-(IBAction)btnBuyAllPressed:(id)sender
{
    //[self viewForInvitePopUpUI];
    //[self viewForUpgradeAccountPopUpUI];
}

#pragma mark: Button buy package pressed
-(IBAction)btnBuyAllPkgValuePressed:(id)sender
{
    SKProduct *product;
    
    product=[[InAppRageIAPHelper sharedHelper].products objectAtIndex:0];
    NSLog(@"Buying %@...", product.productIdentifier);
    [[InAppRageIAPHelper sharedHelper] buyProduct:product];
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText =@"Buying...";
    [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
}

#pragma mark: Button buy single package pressed
-(IBAction)btnBuySinglePkgValuePressed:(id)sender
{
  //  NSInteger row=btn.tag;
//NSString *StrThemeID=[[_arrTblData valueForKey:@""]objectAtIndex:row];
    SKProduct *product;
    product=[[InAppRageIAPHelper sharedHelper].products objectAtIndex:1];
    NSLog(@"Buying %@...", product.productIdentifier);
    [[InAppRageIAPHelper sharedHelper] buyProduct:product];
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText =@"Buying...";
    [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
}


#pragma mark: InApp Purchases product loading methods
- (void)productsLoaded:(NSNotification *)notification
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

- (void)productPurchased:(NSNotification *)notification
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    NSString *productIdentifier = (NSString *) notification.object;
    NSLog(@"Purchased: %@", productIdentifier);
    NSDate *currDate = [NSDate date];
    NSDateFormatter *tempDateFormatter = [[NSDateFormatter alloc]init];
    [tempDateFormatter setDateFormat:@"dd-MMM-yy"];
    NSString *strMStartDate= [tempDateFormatter stringFromDate:currDate];
    NSLog(@"%@",strMStartDate);
    
    NSDate *expiryDate=[currDate dateByAddingTimeInterval:30*(60*60*24)];
    NSString *strExpireDate=[tempDateFormatter stringFromDate:expiryDate];
    NSLog(@"%@",strExpireDate);
    
    //NSString *strQuery;
    if ([notification.name isEqualToString:@"ProductPurchased"])
    {
        if ([productIdentifier isEqualToString:@"com.Snapbet_2"]) {
        
          

        }
        else if ([productIdentifier isEqualToString:@"com.Snapbet_10"])
        {
            
        }
        //_strAlertTitle=@"Theme purchased successfully";
      
    }
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:0.0];
}

- (void)productPurchaseFailed:(NSNotification *)notification
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
//        theAppDelegate.alert.title=@"Error";
//        theAppDelegate.alert.message=transaction.error.localizedDescription;
//        theAppDelegate.alert.show;
//        [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:0.0];
    }
}


- (void)timeout:(id)arg
{
    hud.labelText =@"Timeout!";
    hud.detailsLabelText =@"Please try again later.";
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
    [self performSelector:@selector(showErrorMessage) withObject:nil afterDelay:3.0];
}

- (void)dismissHUD:(id)arg
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    hud = nil;
}

- (void) showErrorMessage
{
//    theAppDelegate.alert.title=@"Error";
//    theAppDelegate.alert.message=@"Please try again later";
//    theAppDelegate.alert.show;
}
@end
