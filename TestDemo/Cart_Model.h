//
//  Cart_Model.h
//  PayPal_Demo
//
//  Created by Syneotek_Anand on 27/05/15.
//  Copyright (c) 2015 Syneotek Software Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cart_Model : NSObject


@property(strong,nonatomic)NSString *strItemName;
@property(strong,nonatomic)NSString *strQuantity;
@property(strong,nonatomic)NSString *strPrice;
@property(strong,nonatomic)NSString *strCurrencyCode;
@property(strong,nonatomic)NSString *strSKU;


@end
