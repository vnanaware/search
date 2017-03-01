#import "VNSessionLib.h"

@implementation VNSessionLib
@synthesize delegate;
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

#pragma mark Find Using NSURLSession Delegate Approach
- (NSURLSession *)createSession
{
    static NSURLSession *session = nil;
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                            delegate:self
                                       delegateQueue:[NSOperationQueue mainQueue]];
    return session;
}

//The below method used the delegate approach to get data from the same web service
#pragma mark: Send requested url to WebServer
-(void) makeConnection :(NSString*)req;
{
    self.session = [self createSession];
    req=[req stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *dataURL = [NSURL URLWithString:req];
    NSURLRequest *request = [NSURLRequest requestWithURL:dataURL];
    self.finderTask = [self.session dataTaskWithRequest:request];
    [self.finderTask resume];
}

#pragma mark: Getting Session task response here
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"%@",dataArray);
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *error=nil;
    _responseDictionary = [NSJSONSerialization
                           JSONObjectWithData:data
                           options:kNilOptions
                           error:&error];
    
    if(_responseDictionary!=nil){
        if(![_responseDictionary isKindOfClass:[NSArray class]]){
            [delegate webResponse:_responseDictionary];
            responseString=nil;
            _responseDictionary=nil;
        }
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler{
    NSLog(@"%s",__func__);
}


                /*-------       If found any error          ---------*/
#pragma mark: NSSession with error
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    NSLog(@"%s",__func__);
}
@end
