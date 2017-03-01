//
//  AKPayPal.m
//  PayPal_Demo
//
//  Created by Syneotek_Anand on 26/05/15.
//  Copyright (c) 2015 Syneotek Software Solutions. All rights reserved.
//

#import "AKPayPal.h"
#import <PayPalMobile.h>


#define kPayPalEnvironment PayPalEnvironmentNoNetwork

@implementation AKPayPal

+(id)sharedInstance
{
    static AKPayPal *selfInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        selfInstance=[[AKPayPal alloc]init];
    });
    return selfInstance;
}

-(void)akPayPalConfigWithMerchantName:(NSString *)merchantName merchantPrivacyPolicyURL:(NSURL*)merchantPrivacyPolicyURL merchantUserAgreementURL:(NSURL*)merchantUserAgreementURL delegate:(id)delegate
{
    self.delegate=delegate;
    
    // Set up payPalConfig
    #pragma mark:warning Update Merchant Details
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.rememberUser=NO;
    _payPalConfig.merchantName = merchantName;//@"Awesome Shirts, Inc.";
    _payPalConfig.merchantPrivacyPolicyURL = merchantPrivacyPolicyURL;//[NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = merchantUserAgreementURL;//[NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    // Setting the payPalShippingAddressOption property is optional.
    //
    // See PayPalConfiguration.h for details.
    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;
   
    [PayPalMobile preconnectWithEnvironment:self.environment];

    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);

    _arrCart=[[NSMutableArray alloc]init];
}

-(void)akAddItemIntoCartWithName:(NSString *)itemName quantity:(int)quantity price:(NSString*)price currencyCode:(NSString *)currencyCode sku:(NSString *)sku
{
    PayPalItem *item = [PayPalItem itemWithName:itemName withQuantity:quantity  withPrice:[NSDecimalNumber decimalNumberWithString:price] withCurrency:currencyCode  withSku:sku];
    
    [_arrCart addObject:item];
}


-(void)akMakePaymentWithDescription:(NSString*)description shippingCharges:(NSString*)shippingCharges tax:(NSString*)tax currencyCode:(NSString*)currencyCode acceptCreditCards:(BOOL)acceptCreditCards delegate:(UIViewController*)delegate
{
    if ([self isValidDescription:description shippingCharges:shippingCharges tax:tax currencyCode:currencyCode cartItems:_arrCart])
    {
        self.delegate=(id)delegate;
        
        NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:_arrCart];
        
        // Optional: include payment details
        NSDecimalNumber *intShipping = [[NSDecimalNumber alloc] initWithString:shippingCharges];
        NSDecimalNumber *intTax = [[NSDecimalNumber alloc] initWithString:tax];
        PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal withShipping:intShipping withTax:intTax];
        
        NSDecimalNumber *total = [[subtotal decimalNumberByAdding:intShipping] decimalNumberByAdding:intTax];
        
        PayPalPayment *payment = [[PayPalPayment alloc] init];
        payment.amount = total;
        payment.currencyCode =currencyCode; //@"USD";
        payment.shortDescription = description;//Some Description
        payment.items = _arrCart;  // if not including multiple items, then leave payment.items as nil
        payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
        
        if (!payment.processable) {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
        }
        
        // Update payPalConfig re accepting credit cards.
        self.payPalConfig.acceptCreditCards = acceptCreditCards;
        
        PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfig delegate:self];
        [delegate presentViewController:paymentViewController animated:YES completion:nil];
    }
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    //self.resultText = [completedPayment description];
    //[self showSuccess];
    //UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Thank you." message:@"You have successfully getting package." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //[alertview show];
    
    NSLog(@"You have successfully getting package.");
    
    NSMutableDictionary *dictResponse=[[NSMutableDictionary alloc]init];
    [dictResponse setValue:completedPayment.description forKey:@"Result"];
    [dictResponse setValue:completedPayment.confirmation forKey:@"Proof_Of_Payment"];// TODO: Send completedPayment.confirmation to server
    
    if ([self.delegate respondsToSelector:@selector(akDidFinishPaymentOperationWithResult:)])
    {
        [self.delegate akDidFinishPaymentOperationWithResult:dictResponse];
    }
    //[self.delegate dismissViewControllerAnimated:YES completion:nil];

}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    
    NSMutableDictionary *dictResponse=[[NSMutableDictionary alloc]init];
    [dictResponse setValue:@"Payment Canceled" forKey:@"Result"];
    if ([self.delegate respondsToSelector:@selector(akDidFinishPaymentOperationWithResult:)])
    {
        [self.delegate akDidFinishPaymentOperationWithResult:dictResponse];
    }

    //[self.delegate  dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- Utility Methods

-(BOOL)isValidDescription:(NSString*)description shippingCharges:(NSString*)shippingCharges tax:(NSString*)tax currencyCode:(NSString*)currencyCode cartItems:(NSMutableArray*)cartItems
{
//    if (cartItems.count>0)
//    {
//        if (description.length>0)
//        {
//            if ([shippingCharges integerValue]>=0)
//            {
//                if ([tax integerValue]>=0)
//                {
//                    if (currencyCode.length>0)
//                    {
//                        return YES;
//                    }
//                    else {[self showAlertWithTitle:@"Missing field" message:@"Please add currect currency code."];}
//                }
//                else {[self showAlertWithTitle:@"Missing field" message:@"Please add tax.(at leat zero)"];}
//            }
//            else {[self showAlertWithTitle:@"Missing field" message:@"Please add shipping charges.(at leat zero)"];}
//        }
//        else {[self showAlertWithTitle:@"Missing field" message:@"Please add description."];}
//    }
//    else {[self showAlertWithTitle:@"Missing items" message:@"Please add at least one item into cart."];}
    
    return YES;
}

-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message
{
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
}


@end
