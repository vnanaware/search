//
//  PaypalPaymentViewController.m
//  My_Lib
//
//  Created by syneotek on 27/04/15.
//  Copyright (c) 2015 syneotek. All rights reserved.
//

#import "PaypalPaymentViewController.h"
#import "AppDelegate.h"
@interface PaypalPaymentViewController ()<UIAlertViewDelegate>


@property(nonatomic)AppDelegate *appDelegate;

@property(strong,nonatomic)AKPayPal *akPayPal;

@property(strong,nonatomic)Cart_Model *cart_model;


@end

@implementation PaypalPaymentViewController
int selectedButtonIndex=-1;
- (void)viewDidLoad
{
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:(242/255.00) green:(242/255.00) blue:(242/255.00) alpha:1];
    
        [self LoadContains];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    selectedButtonIndex=-1;
    _akPayPal=[AKPayPal sharedInstance];
    [_akPayPal akPayPalConfigWithMerchantName:@"Custom Merchant" merchantPrivacyPolicyURL: [NSURL URLWithString:@"https://www.google.com"]merchantUserAgreementURL:[NSURL URLWithString:@"https://www.google.com"] delegate:self];
    
    [_tblTableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark- LoadContains
-(void)LoadContains
{
    
}

- (IBAction)buttonPressed:(UIButton *)sender
{
    
    //_dataDictonary = [_appDelegate.aryofPaypalPackages objectAtIndex:[sender.accessibilityLabel intValue]];
   // _appDelegate.strPaymentAmount =[_dataDictonary valueForKey:@"price"];
   // isSelectedorNot = YES;
    selectedButtonIndex=[sender.accessibilityLabel intValue];

}
- (IBAction)btnPayPalPressed:(id)sender
{
    //if(isSelectedorNot == YES)
    //{
      //  _dataDictonary = [_appDelegate.aryofPaypalPackages objectAtIndex:selectedButtonIndex];
      //  [_akPayPal akAddItemIntoCartWithName:[_dataDictonary valueForKey:@"name"] quantity:[@"1" intValue] price:_appDelegate.strPaymentAmount currencyCode:@"USD" sku:@"SKU"];
    
        [_akPayPal akMakePaymentWithDescription:@"My Grand Total :" shippingCharges:@"0" tax:@"0" currencyCode:@"USD" acceptCreditCards:YES delegate:self];
   // }
  //  else{
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select any package" /delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      //  [alert show];
}

#pragma mark- AKPayPal Delegate Method
-(void)akDidFinishPaymentOperationWithResult:(NSMutableDictionary *)result
{
    NSLog(@"Result :%@",result);
//    _appDelegate.strPaymentAmount = @"0";
//    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Thank you." message:@"You have successfully getting package." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alertview show];
    
    //_dataDictonary = [_appDelegate.aryofPaypalPackages objectAtIndex:selectedButtonIndex];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Thank you" message:[NSString stringWithFormat:@"You have purchase %@ credits",[_dataDictonary valueForKey:@"credit"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag=401;
    
    NSString *responseState=[[[result valueForKey:@"Proof_Of_Payment"] valueForKey:@"response"] valueForKey:@"state"];
    if ([responseState isEqualToString:@"approved"])
    {
        //NSString *strCredit=[_dataDictonary valueForKey:@"credit"];
        //NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mobile.mylib.ug/wsaddcredit.php?uid=%@&credit=%@",_appDelegate.strUserUid,strCredit]];
        //NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
        //NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:600];
      //  NSURLResponse *response;
       // NSError *error;
        //NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
      //  if ([[[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy] isEqualToString:@"sus"])
       // {
            
      //  }
               [self dismissViewControllerAnimated:YES completion:^{}];
    }
    else if([[result valueForKey:@"Result"] isEqualToString:@"Payment Canceled"])
    {
        {
            alert.message=@"Payment Canceled";
            //[alert show];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
