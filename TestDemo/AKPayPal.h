//
//  AKPayPal.h
//  PayPal_Demo
//
//  Created by Syneotek_Anand on 26/05/15.
//  Copyright (c) 2015 Syneotek Software Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
//#import <PayPalMobile.h>


@protocol akPayPalDelegate <NSObject>

-(void)akDidFinishPaymentOperationWithResult:(NSMutableDictionary*)result;

@end




@interface AKPayPal : NSObject
//<PayPalPaymentDelegate>

#pragma mark- Class Properties
//@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic,strong)id <akPayPalDelegate>delegate;

#pragma mark- NSMutableArray Properties
@property(strong,nonatomic)NSMutableArray *arrCart;

#pragma mark- NSString Properties
@property(nonatomic, strong, readwrite) NSString *environment;

#pragma mark- Integer Properties


@property(nonatomic)float shipping;
@property(nonatomic)float tax;


#pragma mark- Method Declarations

+(id)sharedInstance;
/**
 *  Call this method in viewWillAppear
 */
-(void)akPayPalConfigWithMerchantName:(NSString *)merchantName merchantPrivacyPolicyURL:(NSURL*)merchantPrivacyPolicyURL merchantUserAgreementURL:(NSURL*)merchantUserAgreementURL delegate:(id)delegate;

/**
 *  Add items into Cart
 */
-(void)akAddItemIntoCartWithName:(NSString*)itemName quantity:(int)quantity price:(NSString*)price currencyCode:(NSString*)currencyCode sku:(NSString*)sku;

/**
 *  Make a final payment, All field are required.
 */
-(void)akMakePaymentWithDescription:(NSString*)description shippingCharges:(NSString*)shippingCharges tax:(NSString*)tax currencyCode:(NSString*)currencyCode acceptCreditCards:(BOOL)acceptCreditCards delegate:(UIViewController*)delegate ;




@end
