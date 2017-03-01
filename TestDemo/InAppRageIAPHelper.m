//
//  InAppRageIAPHelper.m
//  Cams
//
//  Created by Bhimashankar Vibhute on 5/2/13.
//  Copyright (c) 2013 Syneotek. All rights reserved.
//

#import "InAppRageIAPHelper.h"

@implementation InAppRageIAPHelper

static InAppRageIAPHelper * _sharedHelper;

+ (InAppRageIAPHelper *) sharedHelper {
    
    if (_sharedHelper != nil)
    {
        return _sharedHelper;
    }
    _sharedHelper = [[InAppRageIAPHelper alloc] init];
    
    return _sharedHelper;
         
}

- (id)init {
    
    NSSet *productIdentifiers = [NSSet setWithObjects:@"com.Snapbet_2",@"com.Snapbet_10",@"com.Snapbet_4",nil];
    if ((self = [super initWithProductIdentifiers:productIdentifiers]))
    {
        
    }
    return self;
    
}

@end
