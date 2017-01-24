//
//  WebConnection.h
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@protocol WebRequestResult1
-(void) webResponse:(NSDictionary*)responseDictionary;
@end

@interface WebConnection1 : NSObject
{

    __weak id<WebRequestResult1> delegate;

    NSMutableData *webData;
    NSString *xmlData;
}

@property(weak,nonatomic)	id<WebRequestResult1> delegate;
@property(strong,nonatomic) NSDictionary *responseDictionary;
-(void) makeConnection :(NSMutableURLRequest*)req;

@end
