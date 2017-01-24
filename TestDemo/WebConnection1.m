//
//  WebConnection.m
//  Magento
//

#import "WebConnection1.h"
#import "AppDelegate.h"

#import "HeaderAndConstants.h"
@implementation WebConnection1

@synthesize delegate;
@synthesize responseDictionary;

-(id)init
{
    if((self = [super init]))
    {
        if(!webData)
        {
            webData = [[NSMutableData alloc] init];
        }
    }
    return self;
}

-(void) makeConnection:(NSMutableURLRequest*)req
{
    NSURLConnection *con=[[NSURLConnection alloc] initWithRequest:req delegate:self];
    req.timeoutInterval=60.0;
    [con start];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;
    switch ([httpResponse statusCode])
    {
        case 400:case 401:case 403:case 404:case 500:case 408:
            
            [theAppDelegate stopSpinner];
            [[UIApplication sharedApplication]endIgnoringInteractionEvents];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            NSLog(@"Web server is not responding");
            break;
        default:
            break;
    }
    [webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [theAppDelegate stopSpinner];
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    NSString *errorMsg=error.localizedDescription;
    NSLog(@"%@",errorMsg);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSError *error=nil;
    responseDictionary = [NSJSONSerialization
                          JSONObjectWithData:webData
                          options:kNilOptions
                          error:&error];
    
    if(responseDictionary!=nil){
        if(![responseDictionary isKindOfClass:[NSArray class]]){
            [delegate webResponse:responseDictionary];
            responseString=nil;
            responseDictionary=nil;
        }
    }
}

@end
